Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868EF349CF3;
	Sat, 12 Sep 2026 14:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223470; cv=none; b=jcT5k42hqbsjrUDwJ4OPdI/7BTveJ+lhv3iH6Z+zseIDUv/Fea/rtZh8D1YQbM64mxP0mKEV+2OmQGMyFmWw1o14RfzD12SUJQLvvWFkM5EPokOmpy/WBKTo7cXTakCAcBt9D9BximS/4zXlf0NfuCN0Zsotp60StCeXk+L8XZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223470; c=relaxed/simple;
	bh=b9+z0vMnVrgu6QDhJ564MUoa29wpwPQUjbqJ4gKc6FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g26/yBMQuxYDc3ol4n2BHNE2YplRSQUgibRRIIWJvM9YyIveWdpKfLmghaHM07iYpt25eynDeUQUt41NPTE9US2odZZ2uIi0Ow3UjSKdefbMGGAmjhUqa+x3gXvYR4cluzVv7dSx6LZrmqJcRpaGtyLTML7222TDk/ZMRI+j7Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDcbkjfQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDcbkjfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063211F000FF;
	Sat, 12 Sep 2026 14:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223468;
	bh=ia+uYOI9nMlG0hgx8GTbKrIorqfT1UsgVQhcksBbizo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDcbkjfQzBKLLoLrYw2bhlVXFfJrqwZbbYT9sHE8kzv9/aK7zgbgW9HvwA0LKbIPp
	 P4KG+g2j5secI/3VKy+WikWS7Rcz3+VI7VOM3CuQhE5JBstxwb/5hvz77/8E27nfrM
	 ip/5vuaEzx4SZTgWw/+Zx3ouuCRU4ytw+CRBam7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0769/1424] media: i2c: rdacm21: Fix missing media_entity_cleanup()
Date: Sat, 12 Sep 2026 08:53:21 +0200
Message-ID: <20260912065624.517751967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



