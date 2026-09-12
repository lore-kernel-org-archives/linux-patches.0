Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEAC2F531B;
	Sat, 12 Sep 2026 12:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215537; cv=none; b=YfKigiy/znSpPkC8RZ3RGKebZIzWGBJno1BFIqh2sa5w42t9pbXsS3Upg5+3idry6HTCKfJtTgW4ZH9QOzaD0YnBRrONXPAmq9n1mwNXfMO9AQv1ZTu+1omcumaurcqfeVjwQvI6atf/MU0WytLE5+Ajk2uAQLQaDHNnt7YvkWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215537; c=relaxed/simple;
	bh=zg6m5ZE1wUAPecNGk2I2fIDxfxLNrVQoncS74Mv43Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNZCgyZqsz2razlCAO90drTf7qgOWUAImxh0z+F9PGtzah40q+2Yp7G0vRqoInBehjLdXTz/i7GFmFda4r17IVOEu+763b1KD6aH/l8dPY67F1qoc3iMZMvbHEMHQxJZfkXzeUbB756vnuRstMiL843IAtuZCuMJ1VRZoSdywaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0Aeo1qY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0Aeo1qY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2321F000FF;
	Sat, 12 Sep 2026 12:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215536;
	bh=yv7fhkALCqV8Wd1g+RLbHlmyZJ37Z5A52LKeQ20MKoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0Aeo1qY7YQB1WeI3EtnvlK2YQstyqk6fpgaHLlKQy9SfP6AVy4crTX9AdtbPqM/X
	 L5/gDi8ND3P5HzqmHpOKNzbAMlAbBxIdEz4INnPhzHKTgQ2huW7UO9BJJU07hGM13w
	 N5XXBABqy1v1pAozqbip16C/ia9ZnjavOlhxm7EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0551/1376] media: i2c: rdacm21: Fix missing media_entity_cleanup()
Date: Sat, 12 Sep 2026 08:49:37 +0200
Message-ID: <20260912065619.818852818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

[ Upstream commit 04c053379c3a33460b581953c4f5b36de39439ac ]

The driver misses calling media_entity_cleanup() on the probe error path
and during remove, leaking resources if probe fails after entity
initialization or when the driver is unloaded.

Fix this by adding media_entity_cleanup() to the rdacm21_probe() error
handling path and to rdacm21_remove().

Fixes: a59f853b3b4b ("media: i2c: Add driver for RDACM21 camera module")
Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/rdacm21.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/rdacm21.c b/drivers/media/i2c/rdacm21.c
index 3e22df36354fd..e8196ea737393 100644
--- a/drivers/media/i2c/rdacm21.c
+++ b/drivers/media/i2c/rdacm21.c
@@ -589,10 +589,12 @@ static int rdacm21_probe(struct i2c_client *client)
 
 	ret = v4l2_async_register_subdev(&dev->sd);
 	if (ret)
-		goto error_free_ctrls;
+		goto error_entity_cleanup;
 
 	return 0;
 
+error_entity_cleanup:
+	media_entity_cleanup(&dev->sd.entity);
 error_free_ctrls:
 	v4l2_ctrl_handler_free(&dev->ctrls);
 error:
@@ -607,6 +609,7 @@ static void rdacm21_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(&dev->sd);
 	v4l2_ctrl_handler_free(&dev->ctrls);
+	media_entity_cleanup(&dev->sd.entity);
 	i2c_unregister_device(dev->isp);
 }
 
-- 
2.53.0



