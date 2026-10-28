Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215774;
	b=x7L/yluVCXJYac4sWNJ924UzDO2I5LXbOkjmtJNKb9dRnJUCvNmCHtDc2oOz7EVQoe+0
	 dZjtcwhV05wT3K4YsBLu3u56NLdVuzqW5vNeygpfbMaRrfqhulf3uQVyXZUP3uZW/vJqd
	 cIogirwBw1/0E1nM+cwTxqp2x0V5CCouqby9dZ/0KIE/+boLDPaKzQR/WBJHqIIMhy7N1
	 X/qmMbSxvQHhGenE5kcJWiJQZbX1BvoJb1/EUNrEASKXaVhSurS/47d8r6fCuCKRWz9mA
	 jBzGqtxAgsiKcL+Zxz4iXaSOArJhfFQgvAmqaIIkqR4iiGhff9Vj1qLNza+e3gV99YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CKGWkc7VIGEabykoGgjB7Mi20n20ma49JRiwy9CxZy4=;
	b=bhCwflTsXIoejwgN9c3kUVT2cIZO6Vxm4DJBoydWYt3/43PH+YhzR+dYSWRus10hyK5W
	 bOs8mTdIWgOu8t5yqLwFOcodfdkso8b7BSJMOviYw6ozBvRBuf8CkMjTQstfRpIHjThVj
	 +jUVy739c7KjdQeUdo5NTzmxAQjSspr/aHQDqlblpYYdN4VTLBMuW58J0wi7Y/db7MD6F
	 kOMWHPZj5GlfMYbWOkmi+TRWyEc2z0TdLYLAC5ktoPEO50HIna4DzNMwB6zz+eWkLnaGS
	 EzHdtVbqomkCPTbKIzcsWzpgOSyI1lrBjka8T/08HHJWeqiSWJtdUqDj1eN9ZiA8xMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+rv1m6y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C5E606A31A;
	Wed, 28 Oct 2026 19:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+rv1m6y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36A61F01828;
	Wed, 28 Oct 2026 19:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215774;
	bh=CKGWkc7VIGEabykoGgjB7Mi20n20ma49JRiwy9CxZy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+rv1m6ynk/dg55Cmt16VRvMXtpedB/tesPhmppb6JJA7s7p5coLTG46Ca9VKF20e
	 b2k4UVbtkA8ZYR2ZBtVhpF7quroroHsawbxYYhIR/tcZqIWJNBiKhcYUyb7JmNYrWo
	 k0WR7Saz8qSaypTdAeE70ZNFFzfE7NRN6FVddtcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1329/1887] media: atomisp: gc2235: fix UAF and memory leak
Date: Wed, 28 Oct 2026 17:57:05 +0100
Message-ID: <20261028170529.673091298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4d5a7e335f85f..5b8c7eafbf45c 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
@@ -989,7 +989,7 @@ static int gc2235_probe(struct i2c_client *client)
 
 	ret = gc2235_s_config(&dev->sd, client->irq, gcpdev);
 	if (ret)
-		goto out_free;
+		goto err_unregister_subdev;
 
 	dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	dev->pad.flags = MEDIA_PAD_FL_SOURCE;
@@ -998,18 +998,16 @@ static int gc2235_probe(struct i2c_client *client)
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
@@ -1018,14 +1016,23 @@ static int gc2235_probe(struct i2c_client *client)
 
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



