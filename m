Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511B5154BF
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2E2C433CA;
	Wed, 20 Sep 2023 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211404;
	bh=qDAqrhYA9YnE9+z6M4KE9i6idbTkBTLKFfziP46sxBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W62sIUbc/FPZA81qnnDGx8fQVkhPWn0guetVt/CoG/Ht8adgGsRUftkNV+/U8UFoy
	 IY9g2xvpiePM3bStRSuBdcR819dayL/LbvAQZSgYl+6KCs0NvhVwBQsq89GW3VWmPq
	 8YLT9jjFdF9MGtfieXlHol3SU/pkJxDgIZB2OsaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 073/186] drivers: usb: smsusb: fix error handling code in smsusb_init_device
Date: Wed, 20 Sep 2023 13:29:36 +0200
Message-ID: <20230920112839.507302871@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongliang Mu <dzm91@hust.edu.cn>

[ Upstream commit b9c7141f384097fa4fa67d2f72e5731d628aef7c ]

The previous commit 4b208f8b561f ("[media] siano: register media controller
earlier")moves siano_media_device_register before smscore_register_device,
and adds corresponding error handling code if smscore_register_device
fails. However, it misses the following error handling code of
smsusb_init_device.

Fix this by moving error handling code at the end of smsusb_init_device
and adding a goto statement in the following error handling parts.

Fixes: 4b208f8b561f ("[media] siano: register media controller earlier")
Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/siano/smsusb.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 92a6192f9ab2b..1d67b4c1a020c 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -467,12 +467,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	rc = smscore_register_device(&params, &dev->coredev, mdev);
 	if (rc < 0) {
 		pr_err("smscore_register_device(...) failed, rc %d\n", rc);
-		smsusb_term_device(intf);
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-		media_device_unregister(mdev);
-#endif
-		kfree(mdev);
-		return rc;
+		goto err_unregister_device;
 	}
 
 	smscore_set_board_id(dev->coredev, board_id);
@@ -489,8 +484,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	rc = smsusb_start_streaming(dev);
 	if (rc < 0) {
 		pr_err("smsusb_start_streaming(...) failed\n");
-		smsusb_term_device(intf);
-		return rc;
+		goto err_unregister_device;
 	}
 
 	dev->state = SMSUSB_ACTIVE;
@@ -498,13 +492,20 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	rc = smscore_start_device(dev->coredev);
 	if (rc < 0) {
 		pr_err("smscore_start_device(...) failed\n");
-		smsusb_term_device(intf);
-		return rc;
+		goto err_unregister_device;
 	}
 
 	pr_debug("device 0x%p created\n", dev);
 
 	return rc;
+
+err_unregister_device:
+	smsusb_term_device(intf);
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	media_device_unregister(mdev);
+#endif
+	kfree(mdev);
+	return rc;
 }
 
 static int smsusb_probe(struct usb_interface *intf,
-- 
2.40.1



