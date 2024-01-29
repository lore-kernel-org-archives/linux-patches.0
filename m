Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA48415703F;
	Mon, 29 Jan 2024 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548333; cv=none; b=hxl/Az6UyfwEfZ2z/czhRrk175KLQEAATSMHjAfhNbIW5KEcZqvYG8VRYm/dr8An//AF/XuadEaJIRPimQDoz2SweUJcUYecfPZmeMCsNUbdfT/it/kIPg+2kQky+IN8Z6ysfMvFf3Y4uHrdI1lwW6xRn1FlGFqymdPbl1FG0ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548333; c=relaxed/simple;
	bh=Mb+iXT4E05LUFeryHqlBK3UI18IVpPDDE+QFZVl+DIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6pXLtN7T3Hezq19BAHkFSl5/fc6kd+r2hLr+nWWTlr/x8+UhbUPpoPt8G7+K2KqvjtsN2Mc0vZpfst43naW8alAOybQa6CpHUeUj8w3sqIolulL237N9tZ/yPnJmi+HBntUItsq1L4yXogAndrCjtoN5oiQEOjJ/arz2mHkIk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQbl5LZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQbl5LZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15DBC433F1;
	Mon, 29 Jan 2024 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548332;
	bh=Mb+iXT4E05LUFeryHqlBK3UI18IVpPDDE+QFZVl+DIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQbl5LZPSToCsXj6W5idsDcsPyqj6MUsCEYn6tS+vxrs0NwXxITopstaAcHDQd4YI
	 ve70EvIo8S2PmNJsm34LRO6eLdx+wZP6E4VRysfpdRMSLqgRMpHO7A9WPI5CJri5dy
	 CO2Pdwf0KUoxpxURFYsRTXLEB6xpNhCDnZQM3gU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Xuxin Xiong <xuxinxiong@huaqin.corp-partner.google.com>,
	Pin-yen Lin <treapking@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 330/346] drm/bridge: anx7625: Ensure bridge is suspended in disable()
Date: Mon, 29 Jan 2024 09:06:01 -0800
Message-ID: <20240129170026.185206809@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



