Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7768757CBC;
	Tue, 14 May 2024 11:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686926; cv=none; b=mlV7AnJUtNMaNB8GvSS+DQufJWuA8pLA1XvMja6Vuq6ingfHWpjDICr/ydH5/lIwXbnDGKvSFv4MgQNV4w3COoLClnD6nhTJQRjFLjiTHyaGK+U2tYEgMLfUwLHcrqZKffH4ZnhPIHk9iHWJuSX9vG2jIZXOdO9+wOTv1BorxLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686926; c=relaxed/simple;
	bh=cC9OoMiK+JmpiMGofXSFmxl9/9lCc+lxbeQLnmauolw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kjh17BRF5YjhE5rxMSohUZ9/RELHoWqO05yn6a3Clfimljh/Ml+CWaKV8IvbgI0FTXkyixvkQPGcqXrfUzoBXsIwzdNQHEEU0wFUOvrfD11UTVxd1MgF/XdaC3PUN0yCrPMXhR9OtZ+CepEMtUHbBAr7LnHjA3gi9KqOATtycpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isfdLyGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isfdLyGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005E5C2BD10;
	Tue, 14 May 2024 11:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686926;
	bh=cC9OoMiK+JmpiMGofXSFmxl9/9lCc+lxbeQLnmauolw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isfdLyGiiMbylxIr7copug2bQre90G5L90luxdAmZq6GYP0dnur0lkMEIaO0SPPwo
	 bgV4oY5+HrQB7NZqZtz39u2gY42nolp5eFDYQOYsLs6y8nZBTvoO55mIs+xqjxekDu
	 Ucf+F55UEjIwPp4/EH1frXku93njjxkYrJGsFJfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Korsgaard <peter@korsgaard.com>
Subject: [PATCH 4.19 57/63] usb: gadget: composite: fix OS descriptors w_value logic
Date: Tue, 14 May 2024 12:20:18 +0200
Message-ID: <20240514100950.163833304@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1911,7 +1911,7 @@ unknown:
 			buf[5] = 0x01;
 			switch (ctrl->bRequestType & USB_RECIP_MASK) {
 			case USB_RECIP_DEVICE:
-				if (w_index != 0x4 || (w_value >> 8))
+				if (w_index != 0x4 || (w_value & 0xff))
 					break;
 				buf[6] = w_index;
 				/* Number of ext compat interfaces */
@@ -1927,9 +1927,9 @@ unknown:
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


