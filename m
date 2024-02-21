Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43FA7D401;
	Wed, 21 Feb 2024 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524640; cv=none; b=jBhGbDS/TLvIL2GPYyxvlG0dcdn6CSDs5CFj1KE+D1jTtuu/mIfl62AKHrkk1sXRdpoGmSgL7T3E8CPr1/vnwxsbNaxGxlKBzqi69tw5AXWCjAEnIR3aIQ8ylnPFDS5FJTsKGP/mI2LmyDlhR48JHvldgSCSeK4fgdpEwrnl/uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524640; c=relaxed/simple;
	bh=aTIhFFw+Rf+BvmIxGC49BzMlKJFI4u1YZJSK0bh0peU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PUBSFGPb+myy96V0jrQyerTaY6GxTC/K6jqRs5ZeRaiGtUbU9YZQ3TDKVZA6x7tNRZB20lT2qmzQxNbbnhenpuyr8AClyNIO1ikDmzd5msRoh35V49TFGnPRn4rj7Q60xw7oiYZPWUvQxaITl2Q/uweqP5C2MCcxJXIlbnNsCcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqucCaHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqucCaHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAE8C433C7;
	Wed, 21 Feb 2024 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524640;
	bh=aTIhFFw+Rf+BvmIxGC49BzMlKJFI4u1YZJSK0bh0peU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqucCaHyuIIuylZSG4oX2Zjl/MJsmFgofCyyPUp75MXFLOAQvplFT39xogERSgGKb
	 l/rH/g9E1IXc9lYkZNMS/1zWyO3IGGXaF8DXliPXCL7+qILXXAII3WCpo/72L1ZWf+
	 /kPdLsxWB6gPwI1OHBWEGVkyxvw8jGv1a7w0SniU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 304/379] USB: hub: check for alternate port before enabling A_ALT_HNP_SUPPORT
Date: Wed, 21 Feb 2024 14:08:03 +0100
Message-ID: <20240221130003.914617155@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit f17c34ffc792bbb520e4b61baa16b6cfc7d44b13 upstream.

The OTG 1.3 spec has the feature A_ALT_HNP_SUPPORT, which tells
a device that it is connected to the wrong port. Some devices
refuse to operate if you enable that feature, because it indicates
to them that they ought to request to be connected to another port.

According to the spec this feature may be used based only the following
three conditions:

6.5.3 a_alt_hnp_support
Setting this feature indicates to the B-device that it is connected to
an A-device port that is not capable of HNP, but that the A-device does
have an alternate port that is capable of HNP.
The A-device is required to set this feature under the following conditions:
• the A-device has multiple receptacles
• the A-device port that connects to the B-device does not support HNP
• the A-device has another port that does support HNP

A check for the third and first condition is missing. Add it.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Fixes: 7d2d641c44269 ("usb: otg: don't set a_alt_hnp_support feature for OTG 2.0 device")
Link: https://lore.kernel.org/r/20240122153545.12284-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2367,17 +2367,25 @@ static int usb_enumerate_device_otg(stru
 			}
 		} else if (desc->bLength == sizeof
 				(struct usb_otg_descriptor)) {
-			/* Set a_alt_hnp_support for legacy otg device */
-			err = usb_control_msg(udev,
-				usb_sndctrlpipe(udev, 0),
-				USB_REQ_SET_FEATURE, 0,
-				USB_DEVICE_A_ALT_HNP_SUPPORT,
-				0, NULL, 0,
-				USB_CTRL_SET_TIMEOUT);
-			if (err < 0)
-				dev_err(&udev->dev,
-					"set a_alt_hnp_support failed: %d\n",
-					err);
+			/*
+			 * We are operating on a legacy OTP device
+			 * These should be told that they are operating
+			 * on the wrong port if we have another port that does
+			 * support HNP
+			 */
+			if (bus->otg_port != 0) {
+				/* Set a_alt_hnp_support for legacy otg device */
+				err = usb_control_msg(udev,
+					usb_sndctrlpipe(udev, 0),
+					USB_REQ_SET_FEATURE, 0,
+					USB_DEVICE_A_ALT_HNP_SUPPORT,
+					0, NULL, 0,
+					USB_CTRL_SET_TIMEOUT);
+				if (err < 0)
+					dev_err(&udev->dev,
+						"set a_alt_hnp_support failed: %d\n",
+						err);
+			}
 		}
 	}
 #endif


