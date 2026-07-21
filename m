Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA073403AFB;
	Tue, 21 Jul 2026 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655865; cv=none; b=M0rML1mXaA72/x8RWIxBvzEdgsPD0tXS3oF64WAP8Z00IjQmO1lIEJVLyKKx+/ELr2bWTJrFL3P9jnubmO40AT7kuRdwxAm0bNELQPYs7qXemf/Dae9cezQ7rYbDZDNyw9cZMY0xnpbQIqbLGCkOb0o0HlkmRBm284x4/qvSbPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655865; c=relaxed/simple;
	bh=ujx6UUifUkxO8F5bwi/brkotL792gKaW4NkDQX+Fci8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0e8vxep8KvoY9qNRL1ZzXunTKHMs0RpIxL1pm9cQ9rv+9gwYx+0zRKekCgIimPSjdZyCZY9Q2CiScLo/dUqa3S70qVc3dzTCQ03j+Xj26gflHFRQVI04znE8VIUTl916zkbVSDUWFUCSX6SKOGDuL+DvO38rC94ODpToCuiHGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zNGt7P3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zNGt7P3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FF51F000E9;
	Tue, 21 Jul 2026 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655863;
	bh=CmAf31xzHZ89FuA9QQvS3TJzZpBU1l5Ep0qyjzJkiK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zNGt7P3ym1I0QIUQv48RT6Go6B8DLpHbehGErvpXRF3lH01+V35ax19rg7o5fAgF
	 6kiZtSiPcxuJw0u8JKmrmeLUlOk50L2p5qoR2ec4/WheJP89vzwQOSYVD1exTvS3NY
	 HARHpiVtsvfR66g6KL2tROTtcXUEOV+/46100Br0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0170/1611] media: atomisp: gc2235: fix UAF and memory leak
Date: Tue, 21 Jul 2026 17:04:46 +0200
Message-ID: <20260721152518.720055836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 628f763aee0047ff44974388d6f70f75a763026b ]

gc2235_probe() handles its error paths incorrectly.

If media_entity_pads_init() fails, gc2235_remove() is called, which
tears down the subdev and frees dev, but then still falls through to
atomisp_register_i2c_module(). This results in use-after-free.

If atomisp_register_i2c_module() fails, the media entity and control
handler are left initialized and dev is leaked.

gc2235_remove() unconditionally calls media_entity_cleanup() and
v4l2_ctrl_handler_free(), but these are not initialized at every
error path in gc2235_probe().

Replace gc2235_remove() calls in the probe error paths with explicit
unwind labels that free only the resources initialized at each point
of failure, in reverse order of initialization.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/atomisp/i2c/atomisp-gc2235.c        | 29 ++++++++++++-------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
index 6fc39ab95e46fa..4b11a20c2ba19d 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
@@ -809,7 +809,7 @@ static int gc2235_probe(struct i2c_client *client)
 
 	ret = gc2235_s_config(&dev->sd, client->irq, gcpdev);
 	if (ret)
-		goto out_free;
+		goto err_unregister_subdev;
 
 	dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	dev->pad.flags = MEDIA_PAD_FL_SOURCE;
@@ -818,18 +818,16 @@ static int gc2235_probe(struct i2c_client *client)
 	ret =
 	    v4l2_ctrl_handler_init(&dev->ctrl_handler,
 				   ARRAY_SIZE(gc2235_controls));
-	if (ret) {
-		gc2235_remove(client);
-		return ret;
-	}
+	if (ret)
+		goto err_csi_cfg;
 
 	for (i = 0; i < ARRAY_SIZE(gc2235_controls); i++)
 		v4l2_ctrl_new_custom(&dev->ctrl_handler, &gc2235_controls[i],
 				     NULL);
 
 	if (dev->ctrl_handler.error) {
-		gc2235_remove(client);
-		return dev->ctrl_handler.error;
+		ret = dev->ctrl_handler.error;
+		goto err_ctrl_handler;
 	}
 
 	/* Use same lock for controls as for everything else. */
@@ -838,14 +836,23 @@ static int gc2235_probe(struct i2c_client *client)
 
 	ret = media_entity_pads_init(&dev->sd.entity, 1, &dev->pad);
 	if (ret)
-		gc2235_remove(client);
+		goto err_ctrl_handler;
+
+	ret = atomisp_register_i2c_module(&dev->sd, gcpdev);
+	if (ret)
+		goto err_media_cleanup;
 
-	return atomisp_register_i2c_module(&dev->sd, gcpdev);
+	return 0;
 
-out_free:
+err_media_cleanup:
+	media_entity_cleanup(&dev->sd.entity);
+err_ctrl_handler:
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+err_csi_cfg:
+	dev->platform_data->csi_cfg(&dev->sd, 0);
+err_unregister_subdev:
 	v4l2_device_unregister_subdev(&dev->sd);
 	kfree(dev);
-
 	return ret;
 }
 
-- 
2.53.0



