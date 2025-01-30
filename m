Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEBB1E8855;
	Thu, 30 Jan 2025 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247142; cv=none; b=oPyzjxiEx8mlSLxu3I8msgFsSeAznyd6Ujl3NZMHs+2CIfvfBA4YGVdDz1RBSMUwPRa6Yva5yfbivJz5RKOpJI4hKVHK4yTGynyljpRsUWzjeO8b4mNyjYUYN13LYDtSO8KjcM9lU1coDgPw6uGEHqbwJthWe6zHpgvTe2yTwRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247142; c=relaxed/simple;
	bh=0dwb1vwzYNNWfiTuCMs+EhaWEz+Q02v0YA97IBSUTpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/4tKPURbIbwmVLjCA+q4w1ojPU/P1kVjUTXh5eP9wWAlfcjcSu7dQgJuV/bApaUT8G9EJ08j1jey+qQ1xhlCG2pIcGlxAxggenDnCXYKIki66E5Nr50ge0PtgHO3YupYjtVRy9gy+lvTLZAzFKzoBf+NQBbuE7cz9aPumNqIUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eni489q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eni489q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4152C4CED2;
	Thu, 30 Jan 2025 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247142;
	bh=0dwb1vwzYNNWfiTuCMs+EhaWEz+Q02v0YA97IBSUTpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eni489q85N0LI07KF+X4Z4nwvvFhhycECew28DJ1h2966kE5TszOHiR7CKbWTm32E
	 YS+nylzpLsn2KMOrWw9CN2bm5md3ZueW/iguAA3MCHklZaU9/gbf6l9a+o+rVMrWBl
	 Wx+IePL/9w12a1hfzmR8EfCuhmXwk9qmuJWy8+YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/133] drm: adv7511: Fix use-after-free in adv7533_attach_dsi()
Date: Thu, 30 Jan 2025 15:00:56 +0100
Message-ID: <20250130140145.214783446@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 81adbd3ff21c1182e06aa02c6be0bfd9ea02d8e8 ]

The host_node pointer was assigned and freed in adv7533_parse_dt(), and
later, adv7533_attach_dsi() uses the same. Fix this use-after-free issue
by dropping of_node_put() in adv7533_parse_dt() and calling of_node_put()
in error path of probe() and also in the remove().

Fixes: 1e4d58cd7f88 ("drm/bridge: adv7533: Create a MIPI DSI device")
Cc: stable@vger.kernel.org
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241119192040.152657-2-biju.das.jz@bp.renesas.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 10 ++++++++--
 drivers/gpu/drm/bridge/adv7511/adv7533.c     |  2 --
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index 9255bce51753..46782f72564b 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1220,8 +1220,10 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 		return ret;
 
 	ret = adv7511_init_regulators(adv7511);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to init regulators\n");
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to init regulators\n");
+		goto err_of_node_put;
+	}
 
 	/*
 	 * The power down GPIO is optional. If present, toggle it from active to
@@ -1329,6 +1331,8 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	i2c_unregister_device(adv7511->i2c_edid);
 uninit_regulators:
 	adv7511_uninit_regulators(adv7511);
+err_of_node_put:
+	of_node_put(adv7511->host_node);
 
 	return ret;
 }
@@ -1337,6 +1341,8 @@ static int adv7511_remove(struct i2c_client *i2c)
 {
 	struct adv7511 *adv7511 = i2c_get_clientdata(i2c);
 
+	of_node_put(adv7511->host_node);
+
 	adv7511_uninit_regulators(adv7511);
 
 	drm_bridge_remove(&adv7511->bridge);
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7533.c b/drivers/gpu/drm/bridge/adv7511/adv7533.c
index f8d5fa6652af..ee33e7a033ef 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7533.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7533.c
@@ -184,8 +184,6 @@ int adv7533_parse_dt(struct device_node *np, struct adv7511 *adv)
 	if (!adv->host_node)
 		return -ENODEV;
 
-	of_node_put(adv->host_node);
-
 	adv->use_timing_gen = !of_property_read_bool(np,
 						"adi,disable-timing-generator");
 
-- 
2.39.5



