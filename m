Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6045553816;
	Wed, 21 Feb 2024 13:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521783; cv=none; b=KrQojflilFmjHuvGwaq2cdDAidFfKGIM3ECtYj3mkk7+om3ETZlOBxcv+QUgdESlRTSxwRf/v/1VGqC6nfOwGEVUU0AWn/L6wmGRmvrtxyH07sCkfj2TUB12JGSrqZhwClZ4l8lRRQorJdZzZ5yBS6VoWgWyg+OlomJjH9Xj4qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521783; c=relaxed/simple;
	bh=Vr3X6NjHOJyQG8gyfZ6fclXz234ulAqlXDGc5wyhkqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZVJk/AyLnfycKEWvDSk0jW7YCVPBLP8ApfjDo2YcFHyqqvNXJjJS1LTmb1pB1/13zoZQW/GIzrQxFZbY62ES0+xn0YhAhQPwmvzEFiDGIsI8yeF+nIaUl8HWopx38bBbVJw4axudhCpiyxnjJeZspSov86y4fQU86greEePYH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEQgzpM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEQgzpM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F70C433C7;
	Wed, 21 Feb 2024 13:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521783;
	bh=Vr3X6NjHOJyQG8gyfZ6fclXz234ulAqlXDGc5wyhkqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEQgzpM3ug/w7HQN8yj01yN1+j7/R7A+qxwRMBt5QzdscKyBpQ49dijnYxqb5vF3y
	 PR1Vc98Tp4qpAJ6F53Btd1KoOKBF6uLmu+WJ2WRyRkO6Q8dkCOq73TuZOZNqp0l69+
	 5LHd3ivPBNHMBREiK2vfyhIA/qRHfk9cjXoBRQpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 4.19 177/202] USB: hub: check for alternate port before enabling A_ALT_HNP_SUPPORT
Date: Wed, 21 Feb 2024 14:07:58 +0100
Message-ID: <20240221125937.555742158@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2331,17 +2331,25 @@ static int usb_enumerate_device_otg(stru
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


