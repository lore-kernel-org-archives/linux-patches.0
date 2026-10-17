Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135D93B2FCA;
	Sat, 17 Oct 2026 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259478; cv=none; b=oCewE874rUwN98iqYt233co5NyBVOiPudvmhXYxq1HxCS68EnTUgi8tVJYkCckAGnznIGnJz+3clLl7gu/9ftpnemcmKDVddbYBk6qWl6dLAFeh+FEBViPjQAofz6TTqspZF6w6s9HTMuwFZ/43pRor3Lh2+N4fCC4/yiR5Gopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259478; c=relaxed/simple;
	bh=eZy69FkP00abrBqIvTYU42NiEY7O/U3MO5ZjTEDbHHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3m/VOsD85+6dTs+PKk2+xah6Qyyji42o2oiMn2+krt46zWrK/f9GoOfj+QypymiylEVkBk8vpzJIs4E78gNMvKrNyAN5uQNnLtjrTqSpvoIVnT0ImtqRcAXcp/QAyzWniWu9uB2T3O5+UzzEbXAN4un1IeRRda+PYEVRZsdW7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFSBhe29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFSBhe29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627021F000C4;
	Sat, 17 Oct 2026 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259477;
	bh=qHZT8cAGVO7+psJ7aqtqkROc2AuojeHSPYqnCjmvU1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFSBhe29NHGkU+1zTyHiPU/5bmpywcfFzpUZ+rgNauVjUgEtiDh1IjItRAiRgEqQA
	 +Gdi7eWVhjV2BexUTaiAOp8hoMRI9Yv34LLgfbUtkbxTyspaPZH8snFRqph00gxjIv
	 n+AzE+qqHKyDGzCzDVohvJG8ejrBXrX2P0+GnpwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1226/1674] media: atomisp: gc2235: fix UAF and memory leak
Date: Sat, 17 Oct 2026 17:58:18 +0200
Message-ID: <20261017160502.609375503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9fa390fbc5f31..1130d514891f7 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
@@ -813,7 +813,7 @@ static int gc2235_probe(struct i2c_client *client)
 
 	ret = gc2235_s_config(&dev->sd, client->irq, gcpdev);
 	if (ret)
-		goto out_free;
+		goto err_unregister_subdev;
 
 	dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	dev->pad.flags = MEDIA_PAD_FL_SOURCE;
@@ -822,18 +822,16 @@ static int gc2235_probe(struct i2c_client *client)
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
@@ -842,14 +840,23 @@ static int gc2235_probe(struct i2c_client *client)
 
 	ret = media_entity_pads_init(&dev->sd.entity, 1, &dev->pad);
 	if (ret)
-		gc2235_remove(client);
+		goto err_ctrl_handler;
+
+	ret = atomisp_register_i2c_module(&dev->sd, gcpdev, RAW_CAMERA);
+	if (ret)
+		goto err_media_cleanup;
 
-	return atomisp_register_i2c_module(&dev->sd, gcpdev, RAW_CAMERA);
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



