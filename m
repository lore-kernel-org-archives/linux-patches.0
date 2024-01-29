Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAC115A493;
	Mon, 29 Jan 2024 17:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548640; cv=none; b=VAWHBdH4TsEpOXIStFVaseUQDDgjFJY+D/y5B1/O+OVnZz/FHrfoK0I5n5xH6TMi6fTTCoWoGgM1tw+NO5MMhDjIw8DiZwoUwOVaKaJU8MJP09vjelhylVzhK5uxpWz2uMzqCkStm+XCFS+8/TqGR3lC5b3QFD+8IMq+Lb8sWVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548640; c=relaxed/simple;
	bh=dseahJJlHRqxTydhXbihIB0tXmiFhUUS3NJ6/5NMLCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeyKQk3qxjMPht6NEie7x5kvZoTHMekotVveHqMTw2AtyaY+jvxPNYulwbwzB660jZXZtzp5tiKlukjK3IEevRxS+8ny3bKlZ8ilYKnKW3aEzd4uVHQWrHJqr957Cvc6cUgA5cFHsJJ79eYs8zXXVFsbNpDMl9wMAOgbsyyrkZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oT4mD5h3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oT4mD5h3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CC8C43390;
	Mon, 29 Jan 2024 17:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548639;
	bh=dseahJJlHRqxTydhXbihIB0tXmiFhUUS3NJ6/5NMLCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oT4mD5h3Mu8dNhJ3qhVffl9JEuhjH9qeFohb2+Y0dopM4WcM0DNNfdnpOKyq0Be/x
	 wYPxz/jNz5f/eoxpOWa8ezWUI24BUe7ejG4t5Z/T5aT+HU+YrOIKXiKKnMFluVEF8M
	 eFEGdUq314g3yE9jy3e9mKSMMnsm1ibVMqbpMie4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Xuxin Xiong <xuxinxiong@huaqin.corp-partner.google.com>,
	Pin-yen Lin <treapking@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 316/331] drm/bridge: anx7625: Ensure bridge is suspended in disable()
Date: Mon, 29 Jan 2024 09:06:20 -0800
Message-ID: <20240129170024.131303443@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 4d5b7daa3c610af3f322ad1e91fc0c752ff32f0e ]

Similar to commit 26db46bc9c67 ("drm/bridge: parade-ps8640: Ensure bridge
is suspended in .post_disable()"). Add a mutex to ensure that aux transfer
won't race with atomic_disable by holding the PM reference and prevent
the bridge from suspend.

Also we need to use pm_runtime_put_sync_suspend() to suspend the bridge
instead of idle with pm_runtime_put_sync().

Fixes: 3203e497eb76 ("drm/bridge: anx7625: Synchronously run runtime suspend.")
Fixes: adca62ec370c ("drm/bridge: anx7625: Support reading edid through aux channel")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Xuxin Xiong <xuxinxiong@huaqin.corp-partner.google.com>
Reviewed-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240118015916.2296741-1-hsinyi@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 7 ++++++-
 drivers/gpu/drm/bridge/analogix/anx7625.h | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 51abe42c639e..5168628f11cf 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1741,6 +1741,7 @@ static ssize_t anx7625_aux_transfer(struct drm_dp_aux *aux,
 	u8 request = msg->request & ~DP_AUX_I2C_MOT;
 	int ret = 0;
 
+	mutex_lock(&ctx->aux_lock);
 	pm_runtime_get_sync(dev);
 	msg->reply = 0;
 	switch (request) {
@@ -1757,6 +1758,7 @@ static ssize_t anx7625_aux_transfer(struct drm_dp_aux *aux,
 					msg->size, msg->buffer);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
+	mutex_unlock(&ctx->aux_lock);
 
 	return ret;
 }
@@ -2453,7 +2455,9 @@ static void anx7625_bridge_atomic_disable(struct drm_bridge *bridge,
 	ctx->connector = NULL;
 	anx7625_dp_stop(ctx);
 
-	pm_runtime_put_sync(dev);
+	mutex_lock(&ctx->aux_lock);
+	pm_runtime_put_sync_suspend(dev);
+	mutex_unlock(&ctx->aux_lock);
 }
 
 static enum drm_connector_status
@@ -2647,6 +2651,7 @@ static int anx7625_i2c_probe(struct i2c_client *client)
 
 	mutex_init(&platform->lock);
 	mutex_init(&platform->hdcp_wq_lock);
+	mutex_init(&platform->aux_lock);
 
 	INIT_DELAYED_WORK(&platform->hdcp_work, hdcp_check_work_func);
 	platform->hdcp_workqueue = create_workqueue("hdcp workqueue");
diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.h b/drivers/gpu/drm/bridge/analogix/anx7625.h
index 5af819611ebc..80d3fb4e985f 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.h
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.h
@@ -471,6 +471,8 @@ struct anx7625_data {
 	struct workqueue_struct *hdcp_workqueue;
 	/* Lock for hdcp work queue */
 	struct mutex hdcp_wq_lock;
+	/* Lock for aux transfer and disable */
+	struct mutex aux_lock;
 	char edid_block;
 	struct display_timing dt;
 	u8 display_timing_valid;
-- 
2.43.0



