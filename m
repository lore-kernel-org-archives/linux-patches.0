Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA07B4ADDAA;
	Sat, 28 Feb 2026 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301324; cv=none; b=Vvdxbppnr8B7grtcsCSnyPfj1kjqeOpD4jgprPBmSt6aVQ6w+ehlKiXffKA1m1Ro2OuANaRFGv6GcG4a+BDcqcxXCB6WiNENa63nZkwtkwt581QPpKqVGvtpiy1Reewcir4rSG4HvE5rubgovVW71bE9iVerLuB/ShrLVi6o7z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301324; c=relaxed/simple;
	bh=9FODK//6TYtej7KC85PiWDTKQdHlQO51usadGvKRXD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4QXopxiaLtQa4qJzSWtkE+PlvMr+FOtKJ2i39vAwl//iPf+/V2EIYVTE0kGrqZ8ssuzo1ahM9n3YJxRlW9ny4t+3CEWKrP+sxXp+pLd2XlsM8k3MCvMvgJqIvmlofVj5llfpYpe0/Qeq0cbmu1keZIivkkSIKUHK5cmIh0U86M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbuAnjju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbuAnjju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E30FC19424;
	Sat, 28 Feb 2026 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301323;
	bh=9FODK//6TYtej7KC85PiWDTKQdHlQO51usadGvKRXD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbuAnjjurI+OlQpht9VD2Cu/VfZCrVELjIQRi0bOdX9SiqgQRxayNiNDPSDvwAReY
	 EPzlqez9VURAVuLsG2P4QThxApHCUM2aFTQbvvDCyV/iIwR1Gy68nEwM+laJtQdqp5
	 5/8AVBMOODSf9hxe2gMFHonR+QYeiuCThIhebOVnMpaHatBRPsECGn4daN4BpE4buV
	 vviK6HUtBkSptEx5XSbhBjfs7LG3Tuw7AByk7EgLbYkATQY8+pShDUzUK75jMaNwL1
	 bFc4XRdIB2j6tR69jssbyWS48Ti0oAyToJsveAy0s6SxfpylmPgk1TVvOzb1nzGQ6q
	 o7RELYA5de55w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	syzbot+a41b73dce23962a74c72@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 510/752] media: radio-keene: fix memory leak in error path
Date: Sat, 28 Feb 2026 12:43:41 -0500
Message-ID: <20260228174750.1542406-510-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

[ Upstream commit b8bf939d77c0cd01118e953bbf554e0fa15e9006 ]

Fix a memory leak in usb_keene_probe(). The v4l2 control handler is
initialized and controls are added, but if v4l2_device_register() or
video_register_device() fails afterward, the handler was never freed,
leaking memory.

Add v4l2_ctrl_handler_free() call in the err_v4l2 error path to ensure
the control handler is properly freed for all error paths after it is
initialized.

Reported-by: syzbot+a41b73dce23962a74c72@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a41b73dce23962a74c72
Fixes: 1bf20c3a0c61 ("[media] radio-keene: add a driver for the Keene FM Transmitter")
Cc: stable@vger.kernel.org
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/radio-keene.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index f3b57f0cb1ec4..c133305fd0194 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -338,7 +338,6 @@ static int usb_keene_probe(struct usb_interface *intf,
 	if (hdl->error) {
 		retval = hdl->error;
 
-		v4l2_ctrl_handler_free(hdl);
 		goto err_v4l2;
 	}
 	retval = v4l2_device_register(&intf->dev, &radio->v4l2_dev);
@@ -384,6 +383,7 @@ static int usb_keene_probe(struct usb_interface *intf,
 err_vdev:
 	v4l2_device_unregister(&radio->v4l2_dev);
 err_v4l2:
+	v4l2_ctrl_handler_free(&radio->hdl);
 	kfree(radio->buffer);
 	kfree(radio);
 err:
-- 
2.51.0

