Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED795C8F7;
	Tue,  3 Dec 2024 15:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240626; cv=none; b=D7aEHK4A2J/UZKewfB9ILLdKvntqKj4C2/DoiWUbD5JEdzagFSS98zAeLE1OpDsB3hTBAicy7skh3chXpbxWzO6MDPNIYyY/LyFVvzDODZNgnUaiP6jHPAsSSVuf+4T+dyWmoNb5xALGaWKg44yLKN28+u1PeTjG1RlikqJQ0lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240626; c=relaxed/simple;
	bh=Hb8jCLFxhqTw7OOik9h76VcQGMLM8Nu17psGFPiYHH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHJ5AJ+ncOXEQ9uLyR+seplFiG+SJS06qA9Bj/ekfe2gjXGUycBifAqwTEtkiuSaVIi2SP7zGOCTH0/zL6iRKNRWIGtxI7CYpSvNmv9cPzinxF+c451Z3srfiRzus4/YpViy3iMZNm6Ilj4uyIgxFpY4a512N03i27/UAXua1OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DipFlUH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DipFlUH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D84C4CECF;
	Tue,  3 Dec 2024 15:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240626;
	bh=Hb8jCLFxhqTw7OOik9h76VcQGMLM8Nu17psGFPiYHH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DipFlUH+Ra73QcpqFEEBcGG2NfgC0eWdIitjA/Iv2EjfbSDbX1wdMwb8w+RmCQ5Hi
	 H3/MlbeEJ6lA7svTfdLeo5DyULMLOON+V6o2BzuJuOvHW9rtjn2IssDZRBmtx4wf0r
	 Ppyi0m7SWbbPU4RBA9PILljRE7vmyzdRG4OwphoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 190/826] drm/omap: Fix possible NULL dereference
Date: Tue,  3 Dec 2024 15:38:37 +0100
Message-ID: <20241203144751.152699033@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit a88fee2d67d9b78c24630a987a88ccf886b2498b ]

smatch reports:

drivers/gpu/drm/omapdrm/dss/base.c:176 omapdss_device_disconnect() error: we previously assumed 'src' could be null (see line 169)

This code is mostly from a time when omapdrm had its own display device
model. I can't honestly remember the details, and I don't think it's
worth digging in deeply into that for a legacy driver.

However, it looks like we only call omapdss_device_disconnect() and
omapdss_device_connect() with NULL as the src parameter. We can thus
drop the src parameter from both functions, and fix the smatch warning.

I don't think omapdss_device_disconnect() ever gets NULL for the dst
parameter (if it did, we'd crash soon after returning from the
function), but I have kept the !dst check, just in case, but I added a
WARN_ON() there.

Also, if the dst parameter can be NULL, we can't always get the struct
dss_device pointer from dst->dss (which is only used for a debug print).
To make sure we can't hit that issue, do it similarly to the
omapdss_device_connect() function: add 'struct dss_device *dss' as the
first parameter, so that we always have it regardless of the dst.

Fixes: 79107f274b2f ("drm/omap: Add support for drm_bridge")
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240806-omapdrm-misc-fixes-v1-1-15d31aea0831@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/base.c    | 25 ++++++-------------------
 drivers/gpu/drm/omapdrm/dss/omapdss.h |  3 +--
 drivers/gpu/drm/omapdrm/omap_drv.c    |  4 ++--
 3 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/base.c b/drivers/gpu/drm/omapdrm/dss/base.c
index 5f8002f6bb7a5..a4ac113e16904 100644
--- a/drivers/gpu/drm/omapdrm/dss/base.c
+++ b/drivers/gpu/drm/omapdrm/dss/base.c
@@ -139,21 +139,13 @@ static bool omapdss_device_is_connected(struct omap_dss_device *dssdev)
 }
 
 int omapdss_device_connect(struct dss_device *dss,
-			   struct omap_dss_device *src,
 			   struct omap_dss_device *dst)
 {
-	dev_dbg(&dss->pdev->dev, "connect(%s, %s)\n",
-		src ? dev_name(src->dev) : "NULL",
+	dev_dbg(&dss->pdev->dev, "connect(%s)\n",
 		dst ? dev_name(dst->dev) : "NULL");
 
-	if (!dst) {
-		/*
-		 * The destination is NULL when the source is connected to a
-		 * bridge instead of a DSS device. Stop here, we will attach
-		 * the bridge later when we will have a DRM encoder.
-		 */
-		return src && src->bridge ? 0 : -EINVAL;
-	}
+	if (!dst)
+		return -EINVAL;
 
 	if (omapdss_device_is_connected(dst))
 		return -EBUSY;
@@ -163,19 +155,14 @@ int omapdss_device_connect(struct dss_device *dss,
 	return 0;
 }
 
-void omapdss_device_disconnect(struct omap_dss_device *src,
+void omapdss_device_disconnect(struct dss_device *dss,
 			       struct omap_dss_device *dst)
 {
-	struct dss_device *dss = src ? src->dss : dst->dss;
-
-	dev_dbg(&dss->pdev->dev, "disconnect(%s, %s)\n",
-		src ? dev_name(src->dev) : "NULL",
+	dev_dbg(&dss->pdev->dev, "disconnect(%s)\n",
 		dst ? dev_name(dst->dev) : "NULL");
 
-	if (!dst) {
-		WARN_ON(!src->bridge);
+	if (WARN_ON(!dst))
 		return;
-	}
 
 	if (!dst->id && !omapdss_device_is_connected(dst)) {
 		WARN_ON(1);
diff --git a/drivers/gpu/drm/omapdrm/dss/omapdss.h b/drivers/gpu/drm/omapdrm/dss/omapdss.h
index 040d5a3e33d68..4c22c09c93d52 100644
--- a/drivers/gpu/drm/omapdrm/dss/omapdss.h
+++ b/drivers/gpu/drm/omapdrm/dss/omapdss.h
@@ -242,9 +242,8 @@ struct omap_dss_device *omapdss_device_get(struct omap_dss_device *dssdev);
 void omapdss_device_put(struct omap_dss_device *dssdev);
 struct omap_dss_device *omapdss_find_device_by_node(struct device_node *node);
 int omapdss_device_connect(struct dss_device *dss,
-			   struct omap_dss_device *src,
 			   struct omap_dss_device *dst);
-void omapdss_device_disconnect(struct omap_dss_device *src,
+void omapdss_device_disconnect(struct dss_device *dss,
 			       struct omap_dss_device *dst);
 
 int omap_dss_get_num_overlay_managers(void);
diff --git a/drivers/gpu/drm/omapdrm/omap_drv.c b/drivers/gpu/drm/omapdrm/omap_drv.c
index d3eac4817d768..a982378aa1411 100644
--- a/drivers/gpu/drm/omapdrm/omap_drv.c
+++ b/drivers/gpu/drm/omapdrm/omap_drv.c
@@ -307,7 +307,7 @@ static void omap_disconnect_pipelines(struct drm_device *ddev)
 	for (i = 0; i < priv->num_pipes; i++) {
 		struct omap_drm_pipeline *pipe = &priv->pipes[i];
 
-		omapdss_device_disconnect(NULL, pipe->output);
+		omapdss_device_disconnect(priv->dss, pipe->output);
 
 		omapdss_device_put(pipe->output);
 		pipe->output = NULL;
@@ -325,7 +325,7 @@ static int omap_connect_pipelines(struct drm_device *ddev)
 	int r;
 
 	for_each_dss_output(output) {
-		r = omapdss_device_connect(priv->dss, NULL, output);
+		r = omapdss_device_connect(priv->dss, output);
 		if (r == -EPROBE_DEFER) {
 			omapdss_device_put(output);
 			return r;
-- 
2.43.0



