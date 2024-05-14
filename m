Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C7F4F88C;
	Tue, 14 May 2024 10:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683827; cv=none; b=IzDH3wDX67QIbNYT9HBQzH7rLQtwxS3ebNqSRZez2nzOSEiJWfoC4ePfJUSn+XcFJ/DVvbQtYmjsAJ2xc1dIv3+4MT0Ocs8UEG3c7bycyVEysM0VJa+UeQRjl42aEMrQilHE2owgFVx/sgukPZ5yXcA3J/uae5g8U4hw3pNjdFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683827; c=relaxed/simple;
	bh=vrR2Yr7hT0YRNEwdDnpjHLbZUG9c2ZmwACrxhOSiJfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptSutDhQSuoMhH1t0SCFBzw34qcmznh20fC4Ipcts3VZJeM/oknZ2KdxVOoTCfHbhT3xsp223BSNd9Ytc9tG80Ph3yZSE1rZlPU9yyALoX4hvTPZ3RQ+5xI1uw6ZUzd6AZ6uNVlUnOlfif8TZQjzVLEj4+5zkMTTcntBXbeadcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UiAUpoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UiAUpoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A3AC2BD10;
	Tue, 14 May 2024 10:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683827;
	bh=vrR2Yr7hT0YRNEwdDnpjHLbZUG9c2ZmwACrxhOSiJfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UiAUpoyoFTOVru+2sCUvxqyNEpj3jPEBFT4tMRjh5VZQvUtRPv0gmhjqaIXXCAfE
	 NaDcIgcUwqLuxAQoSkX2ZjjbbiWaF7cOurA/FR32LVJ7aKHumQ6iN9bJF9fBnfLK0l
	 tnKqYfB7hDf+eSW5nS0usxeFbOVEmJyH+M5DGVeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Korsgaard <peter@korsgaard.com>
Subject: [PATCH 6.8 250/336] usb: gadget: composite: fix OS descriptors w_value logic
Date: Tue, 14 May 2024 12:17:34 +0200
Message-ID: <20240514101048.057497447@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2112,7 +2112,7 @@ unknown:
 			buf[5] = 0x01;
 			switch (ctrl->bRequestType & USB_RECIP_MASK) {
 			case USB_RECIP_DEVICE:
-				if (w_index != 0x4 || (w_value >> 8))
+				if (w_index != 0x4 || (w_value & 0xff))
 					break;
 				buf[6] = w_index;
 				/* Number of ext compat interfaces */
@@ -2128,9 +2128,9 @@ unknown:
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


