Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463081E0DCA;
	Wed, 19 Feb 2025 09:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955667; cv=none; b=P0UEneqSb82nfuN4b3C8OCjhqMt6ZF8HbSBGINZBlZtwzO69U0ssi4WITPqimNnPArNkRJTCgZI6Ry6Eqyp8mL6gErRNWEtSJETztG9PA/KDMgD3Z/bo1463JE/3tX5qeM9viHWiMNBkXaO7dSuROxpTHRqCaFFKogDVCgLQhqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955667; c=relaxed/simple;
	bh=/J10Zu47SESrOIen0m455H17N+ZFupOEmirlXFiC++4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCF3xHkOhAqzQOUeysXFMuu8f/DVlMnBCiQRpjS4/GMFPXaQrOpHlXrPtiFeJz46IhAPeTIXmFTxWS1e1yuLe1mIy/JCv6MwpTY1YaU1VMJV99IJ5j3NSHAf7UlpmLcPz9E+dhGRfQPkrhSpHuWXyd/tnSFTxoHP197eN+79lbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtJ+6nhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtJ+6nhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE63DC4CED1;
	Wed, 19 Feb 2025 09:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955667;
	bh=/J10Zu47SESrOIen0m455H17N+ZFupOEmirlXFiC++4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtJ+6nhBkwNwh6TdO+svEiaLjDfaBRBtFhkOyyuSR9pRwWYDkAIT2D2qOsIaNgile
	 0l7F4hwLPT5PihDhxXbhiV1ZSgiYWxEeOVRgdzXHpZFFYiRwlmC//+Tmi4CLE9Trft
	 57L6221Dh4nnazvVJh+2sCzr8bRJ2hvPnhP0r1n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yan kang <kangyan91@outlook.com>,
	yue sun <samsun1006219@gmail.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 077/152] can: etas_es58x: fix potential NULL pointer dereference on udev->serial
Date: Wed, 19 Feb 2025 09:28:10 +0100
Message-ID: <20250219082553.093821020@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

commit a1ad2109ce41c9e3912dadd07ad8a9c640064ffb upstream.

The driver assumed that es58x_dev->udev->serial could never be NULL.
While this is true on commercially available devices, an attacker
could spoof the device identity providing a NULL USB serial number.
That would trigger a NULL pointer dereference.

Add a check on es58x_dev->udev->serial before accessing it.

Reported-by: yan kang <kangyan91@outlook.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/linux-can/SY8P300MB0421E0013C0EBD2AA46BA709A1F42@SY8P300MB0421.AUSP300.PROD.OUTLOOK.COM/
Fixes: 9f06631c3f1f ("can: etas_es58x: export product information through devlink_ops::info_get()")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250204154859.9797-2-mailhol.vincent@wanadoo.fr
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/etas_es58x/es58x_devlink.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/etas_es58x/es58x_devlink.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_devlink.c
@@ -248,7 +248,11 @@ static int es58x_devlink_info_get(struct
 			return ret;
 	}
 
-	return devlink_info_serial_number_put(req, es58x_dev->udev->serial);
+	if (es58x_dev->udev->serial)
+		ret = devlink_info_serial_number_put(req,
+						     es58x_dev->udev->serial);
+
+	return ret;
 }
 
 const struct devlink_ops es58x_dl_ops = {


