Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8F934252D;
	Sat, 12 Sep 2026 07:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198673; cv=none; b=JG2oF/scrBsp/BIe2p1oXB1ID5YVgHvsT+vSP4QbQOwJcD9KXjqowg2hmphComHFkdoZkIKp4L2tQjP9S0hLVoRHBFNHK+nr0WKY4vnOrZkk1XZB7KkbbONC3gkdyoBdbuUzLhmdhB0kkM1xz5x6E9mgwyN6bsyjLIJWJwDqoTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198673; c=relaxed/simple;
	bh=LpvQaAtqoOph6DWGfXnYKcJjQqE5y10+vsXGr2zXsl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUOPB3gl0UHULuDb5Lp62tsoov5hehY6si5qYEnwY8WoBkuL2/x0/kWNcku255QfG2L0Cy+BFceC2m7Lj/BuUqJdVfPNyPaJp94Q14lP8kdQmriCwpIW2D8aKbWfv5Pquw3X3s91+XTtTpl2rnO5EPEKMVymuDVPdgOGfcX940g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViOQXYo7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViOQXYo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8571A1F000FF;
	Sat, 12 Sep 2026 07:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198672;
	bh=vInmgxpzn6RGOMUv3R20Iyisgjr59sNJJ+8kO2929C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViOQXYo7fDTSrDTabu7cJRzMqWjMHPS700FYd/kRUUj0wr9RrQZ0g7ebRUmP6+b/q
	 f78S94C6zVZcKXqTDGspsQU7Wv080tK+xptEuAPg9eCISoouwEbvoR2by7TCSkNA5B
	 59tcUGWBNj6JjyLlQ5NHkN3Fjfj/VInwQlyZprso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0429/1815] media: i2c: rdacm21: Fix missing media_entity_cleanup()
Date: Sat, 12 Sep 2026 08:36:19 +0200
Message-ID: <20260912065658.966689126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



