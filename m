Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556AC159574;
	Mon, 29 Jan 2024 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548399; cv=none; b=FP2KqLyHNagSGB32Gao+9X0JWhPerLeXT2YjUWvrZi//vPiHfgQ0rPq9wqE0+MNdn2J0M1K04qOeNZ/x1ERtLajoXne1G3BImyavrtwP2FPc5PlpfKoSrIauJbDTkU2Lh3ZFy8bM8Y6hpSPnMKA31HFfUofGSa5QnA6+FQ9ATHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548399; c=relaxed/simple;
	bh=il6BlhkL3Qlx65BBHT/I8dH3imDJMflk9cCAz8GXe/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMyObhwNYRdbBM+lVgPzUdxamlZk/j661n5OWWH2zjl2Tx82TVLzr58HvukoFfiQ4MFPqbc+2SGwc8uNPy3/KjhlJf3s3mMTxbriUm5hlrOl3JVzPewYls1XCLu7aULdGKrUcrui9GLGry09FOp3cctpvUHMBSF2RqrWU5YpjD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaugyyfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaugyyfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB4AC43390;
	Mon, 29 Jan 2024 17:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548399;
	bh=il6BlhkL3Qlx65BBHT/I8dH3imDJMflk9cCAz8GXe/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaugyyfljfT/4XKMU+VuoEcGPMJFsVC/YykWm/vr/kL97QED5LH1+JZDyh4Q/pOjB
	 ETVzPxunP38G7H4MOcs15hr9iqQ+gTvFS1qgQmf6GAoujQZ6MWWMdGoy4yb6JI93Dr
	 /t2Wxqim9UgWOyU43dOeP4E81lRK0pPOdZu//I8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Xuxin Xiong <xuxinxiong@huaqin.corp-partner.google.com>,
	Pin-yen Lin <treapking@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/185] drm/bridge: anx7625: Ensure bridge is suspended in disable()
Date: Mon, 29 Jan 2024 09:06:17 -0800
Message-ID: <20240129170004.282164428@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cf86cc05b7fc..5f8137e9cfd7 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1742,6 +1742,7 @@ static ssize_t anx7625_aux_transfer(struct drm_dp_aux *aux,
 	u8 request = msg->request & ~DP_AUX_I2C_MOT;
 	int ret = 0;
 
+	mutex_lock(&ctx->aux_lock);
 	pm_runtime_get_sync(dev);
 	msg->reply = 0;
 	switch (request) {
@@ -1758,6 +1759,7 @@ static ssize_t anx7625_aux_transfer(struct drm_dp_aux *aux,
 					msg->size, msg->buffer);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
+	mutex_unlock(&ctx->aux_lock);
 
 	return ret;
 }
@@ -2454,7 +2456,9 @@ static void anx7625_bridge_atomic_disable(struct drm_bridge *bridge,
 	ctx->connector = NULL;
 	anx7625_dp_stop(ctx);
 
-	pm_runtime_put_sync(dev);
+	mutex_lock(&ctx->aux_lock);
+	pm_runtime_put_sync_suspend(dev);
+	mutex_unlock(&ctx->aux_lock);
 }
 
 static enum drm_connector_status
@@ -2648,6 +2652,7 @@ static int anx7625_i2c_probe(struct i2c_client *client)
 
 	mutex_init(&platform->lock);
 	mutex_init(&platform->hdcp_wq_lock);
+	mutex_init(&platform->aux_lock);
 
 	INIT_DELAYED_WORK(&platform->hdcp_work, hdcp_check_work_func);
 	platform->hdcp_workqueue = create_workqueue("hdcp workqueue");
diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.h b/drivers/gpu/drm/bridge/analogix/anx7625.h
index 14f33d6be289..239956199e1b 100644
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



