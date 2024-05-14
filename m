Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5360F9D4;
	Tue, 14 May 2024 11:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687973; cv=none; b=JtDt2V2FmqOAvyPcN19kFKcC45f8IxS1q8/P0k3Qpvd9UZr7VHburiDfNu2Qfn0i9G59cWj9vkLF2WWpp7a+1X9EYURh4Iwea2TYebTn4z+yfANsEyvK/PxKs9DyC1JsyqKfbJc64ur8jFOa4dp8M37BvINsPVFBhZ2qxjbRzHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687973; c=relaxed/simple;
	bh=KOx7K9zwnRWRNsjR+uq1wpvlR81h12lHtGk7ZkPSfIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKizQjrjIgfRKwbLU1OwAVOqdNWF6VyNiZ28QHi+HX7l0dcryZjq5cHhIl/NsauD0G6UAHk5pvINYkG+oEl96QkwoPqzlNq6CVIzLcTJUwo5I0cDeidbwQZSZqK/VucMbDGEX6rOiFiXsPijsdByYpRfRsOfDL0/f28ndr+lNwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3HG/6Gw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3HG/6Gw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B382C2BD10;
	Tue, 14 May 2024 11:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687973;
	bh=KOx7K9zwnRWRNsjR+uq1wpvlR81h12lHtGk7ZkPSfIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3HG/6Gw2qrQjL/i9YfA8vH/hgthK0osdoKSDFlCFm7WaHkSt6ieDMS3Y5js5rEeb
	 2BpQoX2w9/WO0A2ilLofmvmYqEGM5PkzCRKE7LPhs/1/8gjHqek5rokagERg47+lZH
	 tidEGIPNED3sSxJKMgvo6Cd0mpLY8VKqiDp8vbZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Korsgaard <peter@korsgaard.com>
Subject: [PATCH 5.15 145/168] usb: gadget: composite: fix OS descriptors w_value logic
Date: Tue, 14 May 2024 12:20:43 +0200
Message-ID: <20240514101012.238789330@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <peter@korsgaard.com>

commit ec6ce7075ef879b91a8710829016005dc8170f17 upstream.

The OS descriptors logic had the high/low byte of w_value inverted, causing
the extended properties to not be accessible for interface != 0.

>From the Microsoft documentation:
https://learn.microsoft.com/en-us/windows-hardware/drivers/usbcon/microsoft-os-1-0-descriptors-specification

OS_Desc_CompatID.doc (w_index = 0x4):

- wValue:

  High Byte = InterfaceNumber.  InterfaceNumber is set to the number of the
  interface or function that is associated with the descriptor, typically
  0x00.  Because a device can have only one extended compat ID descriptor,
  it should ignore InterfaceNumber, regardless of the value, and simply
  return the descriptor.

  Low Byte = 0.  PageNumber is used to retrieve descriptors that are larger
  than 64 KB.  The header section is 16 bytes, so PageNumber is set to 0 for
  this request.

We currently do not support >64KB compat ID descriptors, so verify that the
low byte is 0.

OS_Desc_Ext_Prop.doc (w_index = 0x5):

- wValue:

  High byte = InterfaceNumber.  The high byte of wValue is set to the number
  of the interface or function that is associated with the descriptor.

  Low byte = PageNumber.  The low byte of wValue is used to retrieve
  descriptors that are larger than 64 KB.  The header section is 10 bytes, so
  PageNumber is set to 0 for this request.

We also don't support >64KB extended properties, so verify that the low byte
is 0 and use the high byte for the interface number.

Fixes: 37a3a533429e ("usb: gadget: OS Feature Descriptors support")
Cc: stable <stable@kernel.org>
Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Link: https://lore.kernel.org/r/20240404100635.3215340-1-peter@korsgaard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1978,7 +1978,7 @@ unknown:
 			buf[5] = 0x01;
 			switch (ctrl->bRequestType & USB_RECIP_MASK) {
 			case USB_RECIP_DEVICE:
-				if (w_index != 0x4 || (w_value >> 8))
+				if (w_index != 0x4 || (w_value & 0xff))
 					break;
 				buf[6] = w_index;
 				/* Number of ext compat interfaces */
@@ -1994,9 +1994,9 @@ unknown:
 				}
 				break;
 			case USB_RECIP_INTERFACE:
-				if (w_index != 0x5 || (w_value >> 8))
+				if (w_index != 0x5 || (w_value & 0xff))
 					break;
-				interface = w_value & 0xFF;
+				interface = w_value >> 8;
 				if (interface >= MAX_CONFIG_INTERFACES ||
 				    !os_desc_cfg->interface[interface])
 					break;


