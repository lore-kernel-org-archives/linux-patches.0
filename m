Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C94D2D60A;
	Tue, 14 May 2024 11:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687126; cv=none; b=dPjP3xZ4Fedf69u1KMpjznxrtQIOJ0BY+W0Dtxvte7RJ5SJ/Lts5s+86ZUGEP6KSmdqFyqJVKj2OesM5bdEj33Gi0meeeu+DPL+toBBCenyOS94pQOA4lPWdFEs7OpD8CEbhElRTQIeU0tfqZfF5Lsw01DOgm1iBAla20NP8WHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687126; c=relaxed/simple;
	bh=ddOKMgkKBrR18H5NapTuMt0xEj1E7K8ii3t0Ek3CXVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFZq980vHtJQQMWMKfX5vsWjKViy7DPR1XUykANDNwPpNLq3I4dRGme77WLm+aD92VCY27OHHkL6dpaj/Z0hQYihHZvTK+BMBbBlBuXHqctTrRnqnOnmp5IwwrUa2UqLyoXHO8h3n5sShvJprz+DZfow3WKWt/Hz9joFqnWDXUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMZqQext; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMZqQext"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE5CC32781;
	Tue, 14 May 2024 11:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687126;
	bh=ddOKMgkKBrR18H5NapTuMt0xEj1E7K8ii3t0Ek3CXVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMZqQextExj4meQmEKVeGOilRJ/mi/hCIU8p/uk/aUCEKZO5NwMy9a1Y+8a+2BTDY
	 zuC5CYZXrRukm/2qsDZPEbCo58YHMayG0g3JW5d+xI28Lmb3PtrRKf3ULxkoJd9N+h
	 pg9ffBn6iZ9q6WsXQUOLMUPf027IAxOiSczMUAVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Korsgaard <peter@korsgaard.com>
Subject: [PATCH 5.4 74/84] usb: gadget: composite: fix OS descriptors w_value logic
Date: Tue, 14 May 2024 12:20:25 +0200
Message-ID: <20240514100954.464653369@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1925,7 +1925,7 @@ unknown:
 			buf[5] = 0x01;
 			switch (ctrl->bRequestType & USB_RECIP_MASK) {
 			case USB_RECIP_DEVICE:
-				if (w_index != 0x4 || (w_value >> 8))
+				if (w_index != 0x4 || (w_value & 0xff))
 					break;
 				buf[6] = w_index;
 				/* Number of ext compat interfaces */
@@ -1941,9 +1941,9 @@ unknown:
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


