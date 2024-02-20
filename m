Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85531509BF;
	Tue, 20 Feb 2024 21:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463558; cv=none; b=BmPJhUXcyjFRkDlz6Zz43devLvG/2UUkfitVIWgbcRDGfeSkEpWqyrOdTCPVWczi4gdmJPktaxi/VMQtr8qekkZ0Uf/UYJJCSCSSau7mnCgrW+Cmoe39KVshwRLHmZk27foFd4THERyNIBpduXhkrhHG1MJbvSA2QvTCJwYjzhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463558; c=relaxed/simple;
	bh=aBsT9P4feVs1arXo6SeWMiVponHw47sx8W0IQjWTjVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JzjAnZEU+I41i3EDki4tF9jeO+m91puPuWkknDy96peirbE5B9Uetis+5T/Z8PYg7HCbZzzJBhHypKyOTLVefDdrSYL3U/ucNBw9dLUhtQj2iXiO23LTpB1jWvfPjtQgfAiia9et9LXghhUQ6/7bW0tp61LzBiI9l0Gj43eoWRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkeTSJZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkeTSJZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD514C433C7;
	Tue, 20 Feb 2024 21:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463558;
	bh=aBsT9P4feVs1arXo6SeWMiVponHw47sx8W0IQjWTjVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkeTSJZbdvkG62ErcK3T7XmWmmVr78N4U4qPEFpVjuk7MW+2niZngVlLKFIOs+hbz
	 xU0OH3v5vregdQxDE+rYiTsIzmr9DZ6GfS0VDXfLeyEtXP9SKnfSuskxEmy30DE/jo
	 E62c7JWhYzOiruSpUgf4o9eCqxahm5Go/wZ776Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 080/331] USB: hub: check for alternate port before enabling A_ALT_HNP_SUPPORT
Date: Tue, 20 Feb 2024 21:53:16 +0100
Message-ID: <20240220205640.095006484@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2380,17 +2380,25 @@ static int usb_enumerate_device_otg(stru
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


