Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFE2299920;
	Sat, 12 Sep 2026 10:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207381; cv=none; b=C/0rMO6nWOV6sa+X0tYPV9y6dbLEqXAUslkrlKuW0umFo1nle9PgpAS0wNy0mAMw13mlr+itRZiMwCYMpIDQpbWyocBjCAXfrHEd0EylFdfG5QASIb/oI2+cSuMHndDyGY9VOIwI42DRHsBgbkiJSfFmHeAGxTmXsJySzlVmMO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207381; c=relaxed/simple;
	bh=H9KqQnZkj8/Jczm0uhW4Hp6Hl9eg/z1NmgIW5E5L9EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMaQwJIunJQ89W5XVTlwrWf1SXa886ktrPKrqBRbRj9D5BW8556e894vgOXgprAvy8Dev6bZj2aWSh+LZJOYvuKbAeoEJDwi5YKL0rBANagWKGYKXESpLizHVdh9RoAenCy10huR/QGJ+4rOqtO/C/tpww+kugtd7yfbw7WlJjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9Kh2YpS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9Kh2YpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A721F000FF;
	Sat, 12 Sep 2026 10:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207379;
	bh=um5CpGLIrQ/x28h1s0f0QZ4s1VlCf2xoNdCd0DAu7Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9Kh2YpSz1WFAevU8MMn8e2CHOaWvzLiaeRQi291gU/O6Ovo9a0GTMtNCPi9CE2sM
	 rXBviWv2jEiU+LN9H0ZsGTHKjWBY9R+jJyigtvoRkgVF1BWBoWNnqrMw/wZ6ZyUIOX
	 qwfXe52c+q28yBYuUPZWP2Xj0jIYwlcDDSRLOLwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0400/1518] media: i2c: rdacm21: Fix missing media_entity_cleanup()
Date: Sat, 12 Sep 2026 08:42:49 +0200
Message-ID: <20260912065632.505082636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index bcab462708c70..ece8a410e7ced 100644
--- a/drivers/media/i2c/rdacm21.c
+++ b/drivers/media/i2c/rdacm21.c
@@ -588,10 +588,12 @@ static int rdacm21_probe(struct i2c_client *client)
 
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
@@ -606,6 +608,7 @@ static void rdacm21_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(&dev->sd);
 	v4l2_ctrl_handler_free(&dev->ctrls);
+	media_entity_cleanup(&dev->sd.entity);
 	i2c_unregister_device(dev->isp);
 }
 
-- 
2.53.0



