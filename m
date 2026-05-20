Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BA517A2FC;
	Wed, 20 May 2026 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302002; cv=none; b=rfM21MQqrP0Kov1vYVzuo5Lu9zO993XzZYGW6kPxQFWLCvM9aJSystuU4q1KKolPoMWb9MDDlxZe4pPQXJVbDudrILzf+cMjPp/f9++DQDnf5yrJRmuktYCfgiU1EArbYG5fHW8EZuJPVOxm/5NkqkUgPibhHNAAnNTOG2rNafk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302002; c=relaxed/simple;
	bh=UQgV+X2MaO8jwIIHlJlVMSMow+WcGmGuYUh6auZ93cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqCdVuly6hmcKIsEF9nuCc9Q18Cg3sfDfbnE/SQBxU+Gv2eMczBDKDiLDIevEMazFRdM1Xz5a5bX4k9LAxBB0WKUWzc9o3FbC7qHqFTuGcipVQ1Al82SWTTdHCaaSGwtemkzc2gPysvoPWfWAVzbadOlvwK585ZBDuFU81SeUMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQjXGYBO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQjXGYBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72BA1F000E9;
	Wed, 20 May 2026 18:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302001;
	bh=9cURUseNy8ECw2Ip1r12KqH/xCcxPY51soUDO4J4rYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQjXGYBOHAahZmRNLdRsIhWBuhZPkKzs0oEp6qb+oFbhbHydEuKZEKl3R40h0IENx
	 2UDotJXxNxZtYQBn2GxsF/oaul7jT98+6OiXD9dXufndhoC6Q7odPlZZcLd1VEuWWH
	 Mt50Hf7BUuH0yXvXgWU6+yb0tZJmpJS1PIFaf5aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Harikrishna Shenoy <h-shenoy@ti.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/508] drm/bridge: cadence: cdns-mhdp8546-core: Set the mhdp connector earlier in atomic_enable()
Date: Wed, 20 May 2026 18:18:44 +0200
Message-ID: <20260520162100.806231606@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit 43d6508ddbf9fb974fbc359a033154f78c9d4c8b ]

In case if we get errors in cdns_mhdp_link_up() or cdns_mhdp_reg_read()
in atomic_enable, we will go to cdns_mhdp_modeset_retry_fn() and will hit
NULL pointer while trying to access the mutex. We need the connector to
be set before that. Unlike in legacy cases with flag
!DRM_BRIDGE_ATTACH_NO_CONNECTOR, we do not have connector initialised
in bridge_attach(), so add the mhdp->connector_ptr in device structure
to handle both cases with DRM_BRIDGE_ATTACH_NO_CONNECTOR and
!DRM_BRIDGE_ATTACH_NO_CONNECTOR, set it in atomic_enable() earlier to
avoid possible NULL pointer dereference in recovery paths like
modeset_retry_fn() with the DRM_BRIDGE_ATTACH_NO_CONNECTOR flag set.

Fixes: c932ced6b585 ("drm/tidss: Update encoder/bridge chain connect model")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Harikrishna Shenoy <h-shenoy@ti.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patch.msgid.link/20251209120332.3559893-2-h-shenoy@ti.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/bridge/cadence/cdns-mhdp8546-core.c   | 29 ++++++++++---------
 .../drm/bridge/cadence/cdns-mhdp8546-core.h   |  1 +
 .../drm/bridge/cadence/cdns-mhdp8546-hdcp.c   | 18 +++++++++---
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index bdb9fc00c776b..8037a41f9afd2 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -810,7 +810,7 @@ static void cdns_mhdp_fw_cb(const struct firmware *fw, void *context)
 	bridge_attached = mhdp->bridge_attached;
 	spin_unlock(&mhdp->start_lock);
 	if (bridge_attached) {
-		if (mhdp->connector.dev)
+		if (mhdp->connector_ptr)
 			drm_kms_helper_hotplug_event(mhdp->bridge.dev);
 		else
 			drm_bridge_hpd_notify(&mhdp->bridge, cdns_mhdp_detect(mhdp));
@@ -1709,6 +1709,7 @@ static int cdns_mhdp_connector_init(struct cdns_mhdp_device *mhdp)
 		return ret;
 	}
 
+	mhdp->connector_ptr = conn;
 	drm_connector_helper_add(conn, &cdns_mhdp_conn_helper_funcs);
 
 	ret = drm_display_info_set_bus_formats(&conn->display_info,
@@ -1988,17 +1989,25 @@ static void cdns_mhdp_atomic_enable(struct drm_bridge *bridge,
 	struct drm_atomic_state *state = bridge_state->base.state;
 	struct cdns_mhdp_bridge_state *mhdp_state;
 	struct drm_crtc_state *crtc_state;
-	struct drm_connector *connector;
 	struct drm_connector_state *conn_state;
 	struct drm_bridge_state *new_state;
 	const struct drm_display_mode *mode;
 	u32 resp;
-	int ret;
+	int ret = 0;
 
 	dev_dbg(mhdp->dev, "bridge enable\n");
 
 	mutex_lock(&mhdp->link_mutex);
 
+	mhdp->connector_ptr = drm_atomic_get_new_connector_for_encoder(state,
+								       bridge->encoder);
+	if (WARN_ON(!mhdp->connector_ptr))
+		goto out;
+
+	conn_state = drm_atomic_get_new_connector_state(state, mhdp->connector_ptr);
+	if (WARN_ON(!conn_state))
+		goto out;
+
 	if (mhdp->plugged && !mhdp->link_up) {
 		ret = cdns_mhdp_link_up(mhdp);
 		if (ret < 0)
@@ -2018,15 +2027,6 @@ static void cdns_mhdp_atomic_enable(struct drm_bridge *bridge,
 	cdns_mhdp_reg_write(mhdp, CDNS_DPTX_CAR,
 			    resp | CDNS_VIF_CLK_EN | CDNS_VIF_CLK_RSTN);
 
-	connector = drm_atomic_get_new_connector_for_encoder(state,
-							     bridge->encoder);
-	if (WARN_ON(!connector))
-		goto out;
-
-	conn_state = drm_atomic_get_new_connector_state(state, connector);
-	if (WARN_ON(!conn_state))
-		goto out;
-
 	if (mhdp->hdcp_supported &&
 	    mhdp->hw_state == MHDP_HW_READY &&
 	    conn_state->content_protection ==
@@ -2103,6 +2103,7 @@ static void cdns_mhdp_atomic_disable(struct drm_bridge *bridge,
 	if (mhdp->info && mhdp->info->ops && mhdp->info->ops->disable)
 		mhdp->info->ops->disable(mhdp);
 
+	mhdp->connector_ptr = NULL;
 	mutex_unlock(&mhdp->link_mutex);
 }
 
@@ -2368,7 +2369,7 @@ static void cdns_mhdp_modeset_retry_fn(struct work_struct *work)
 
 	mhdp = container_of(work, typeof(*mhdp), modeset_retry_work);
 
-	conn = &mhdp->connector;
+	conn = mhdp->connector_ptr;
 
 	/* Grab the locks before changing connector property */
 	mutex_lock(&conn->dev->mode_config.mutex);
@@ -2445,7 +2446,7 @@ static void cdns_mhdp_hpd_work(struct work_struct *work)
 	int ret;
 
 	ret = cdns_mhdp_update_link_status(mhdp);
-	if (mhdp->connector.dev) {
+	if (mhdp->connector_ptr) {
 		if (ret < 0)
 			schedule_work(&mhdp->modeset_retry_work);
 		else
diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.h b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.h
index bad2fc0c73066..a76775c768956 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.h
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.h
@@ -376,6 +376,7 @@ struct cdns_mhdp_device {
 	struct mutex link_mutex;
 
 	struct drm_connector connector;
+	struct drm_connector *connector_ptr;
 	struct drm_bridge bridge;
 
 	struct cdns_mhdp_link link;
diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c
index 5e3b8edcf7948..2866069805524 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c
@@ -394,7 +394,7 @@ static int _cdns_mhdp_hdcp_disable(struct cdns_mhdp_device *mhdp)
 	int ret;
 
 	dev_dbg(mhdp->dev, "[%s:%d] HDCP is being disabled...\n",
-		mhdp->connector.name, mhdp->connector.base.id);
+		mhdp->connector_ptr->name, mhdp->connector_ptr->base.id);
 
 	ret = cdns_mhdp_hdcp_set_config(mhdp, 0, false);
 
@@ -436,6 +436,10 @@ static int cdns_mhdp_hdcp_check_link(struct cdns_mhdp_device *mhdp)
 	int ret = 0;
 
 	mutex_lock(&mhdp->hdcp.mutex);
+
+	if (!mhdp->connector_ptr)
+		goto out;
+
 	if (mhdp->hdcp.value == DRM_MODE_CONTENT_PROTECTION_UNDESIRED)
 		goto out;
 
@@ -445,7 +449,7 @@ static int cdns_mhdp_hdcp_check_link(struct cdns_mhdp_device *mhdp)
 
 	dev_err(mhdp->dev,
 		"[%s:%d] HDCP link failed, retrying authentication\n",
-		mhdp->connector.name, mhdp->connector.base.id);
+		mhdp->connector_ptr->name, mhdp->connector_ptr->base.id);
 
 	ret = _cdns_mhdp_hdcp_disable(mhdp);
 	if (ret) {
@@ -487,13 +491,19 @@ static void cdns_mhdp_hdcp_prop_work(struct work_struct *work)
 	struct cdns_mhdp_device *mhdp = container_of(hdcp,
 						     struct cdns_mhdp_device,
 						     hdcp);
-	struct drm_device *dev = mhdp->connector.dev;
+	struct drm_device *dev = NULL;
 	struct drm_connector_state *state;
 
+	if (mhdp->connector_ptr)
+		dev = mhdp->connector_ptr->dev;
+
+	if (!dev)
+		return;
+
 	drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
 	mutex_lock(&mhdp->hdcp.mutex);
 	if (mhdp->hdcp.value != DRM_MODE_CONTENT_PROTECTION_UNDESIRED) {
-		state = mhdp->connector.state;
+		state = mhdp->connector_ptr->state;
 		state->content_protection = mhdp->hdcp.value;
 	}
 	mutex_unlock(&mhdp->hdcp.mutex);
-- 
2.53.0



