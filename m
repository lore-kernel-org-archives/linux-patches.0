Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5773D15D5D4;
	Mon, 29 Jan 2024 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548411; cv=none; b=XqKrgwKlNkIB2sbrjG7SPk4Su7jT4cOZrL3kJ+NVgKFwS3rTMwmbCuIH22CHTNNGrV6FhrKMRVYWA38fAoibnlLVQMrsFw6n4ew23PNk7Wbk2N81hTweghZetQBsiWYle3z+T4gXRuRn18I38TEgyicttb09fr8xKwlvfKWvT/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548411; c=relaxed/simple;
	bh=Z8y4nVte10pppE1r4qylNmoneCdgoglB9ECtGi7rPuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt1TJAxu4cvLCKYFHoWkONwYpEk1zuv8mI/VB/KqoZVBHTvhlKmIr9PM2uTacfhg/U3AEG+HdNa8PJ8M7iC1VEGc5e8BXPFAppTTLtnwGuI2pSSD0wNL9x4IOILEzbZksvp4LLXHtZqx5EuB5qZtFfk2vXUbxZDy86Q8c15T7xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZIMjWXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZIMjWXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D26C43394;
	Mon, 29 Jan 2024 17:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548410;
	bh=Z8y4nVte10pppE1r4qylNmoneCdgoglB9ECtGi7rPuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZIMjWXdfi8iF3mHGzS09OQ9iimiNWADVtJdZux1a4iFUppPcDn/92hXHe4qb9z1v
	 6+cDeViUNwLd+j3lhv4A0pBZHVBcZSSNzVLxt7AKd8l/kh4PhInWJLZbKspIW1ynLP
	 MGyfWtZoQ9KnPZNwkAl85kIftWYU7QlIYT+gPw8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/185] drm/bridge: parade-ps8640: Ensure bridge is suspended in .post_disable()
Date: Mon, 29 Jan 2024 09:06:11 -0800
Message-ID: <20240129170004.082020155@linuxfoundation.org>
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

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 26db46bc9c675e43230cc6accd110110a7654299 ]

The ps8640 bridge seems to expect everything to be power cycled at the
disable process, but sometimes ps8640_aux_transfer() holds the runtime
PM reference and prevents the bridge from suspend.

Prevent that by introducing a mutex lock between ps8640_aux_transfer()
and .post_disable() to make sure the bridge is really powered off.

Fixes: 826cff3f7ebb ("drm/bridge: parade-ps8640: Enable runtime power management")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240109120528.1292601-1-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/parade-ps8640.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/bridge/parade-ps8640.c b/drivers/gpu/drm/bridge/parade-ps8640.c
index 146e1ad76223..3982568bd093 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -106,6 +106,7 @@ struct ps8640 {
 	struct device_link *link;
 	bool pre_enabled;
 	bool need_post_hpd_delay;
+	struct mutex aux_lock;
 };
 
 static const struct regmap_config ps8640_regmap_config[] = {
@@ -353,6 +354,7 @@ static ssize_t ps8640_aux_transfer(struct drm_dp_aux *aux,
 	struct device *dev = &ps_bridge->page[PAGE0_DP_CNTL]->dev;
 	int ret;
 
+	mutex_lock(&ps_bridge->aux_lock);
 	pm_runtime_get_sync(dev);
 	ret = _ps8640_wait_hpd_asserted(ps_bridge, 200 * 1000);
 	if (ret) {
@@ -362,6 +364,7 @@ static ssize_t ps8640_aux_transfer(struct drm_dp_aux *aux,
 	ret = ps8640_aux_transfer_msg(aux, msg);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
+	mutex_unlock(&ps_bridge->aux_lock);
 
 	return ret;
 }
@@ -481,7 +484,18 @@ static void ps8640_post_disable(struct drm_bridge *bridge)
 	ps_bridge->pre_enabled = false;
 
 	ps8640_bridge_vdo_control(ps_bridge, DISABLE);
+
+	/*
+	 * The bridge seems to expect everything to be power cycled at the
+	 * disable process, so grab a lock here to make sure
+	 * ps8640_aux_transfer() is not holding a runtime PM reference and
+	 * preventing the bridge from suspend.
+	 */
+	mutex_lock(&ps_bridge->aux_lock);
+
 	pm_runtime_put_sync_suspend(&ps_bridge->page[PAGE0_DP_CNTL]->dev);
+
+	mutex_unlock(&ps_bridge->aux_lock);
 }
 
 static int ps8640_bridge_attach(struct drm_bridge *bridge,
@@ -662,6 +676,8 @@ static int ps8640_probe(struct i2c_client *client)
 	if (!ps_bridge)
 		return -ENOMEM;
 
+	mutex_init(&ps_bridge->aux_lock);
+
 	ps_bridge->supplies[0].supply = "vdd12";
 	ps_bridge->supplies[1].supply = "vdd33";
 	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(ps_bridge->supplies),
-- 
2.43.0



