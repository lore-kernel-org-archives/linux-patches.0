Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA911F2381;
	Thu, 12 Dec 2024 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022103; cv=none; b=p9vARmQefO228FhN+GLiFvGsxErZtY9Brcm5hwoOXrdNQ8P2YawZe+CKLcAun1vQ94w925hf0/SvY6eNQze5FAeH8yAnyVjwiDnQO7m38lhyGD0o36aFnxnm01eRAZFHakr1LfGufhyS5+Mld/XyvQj4i8Rd83l+jqjGwy9WU8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022103; c=relaxed/simple;
	bh=Y8gdgW3LhOEc8t3QmBLTAOgTD+iNdmyt769P37I/lh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSaO4ZEgGAKHnRqX9zynRWY89nBenZ4rd29ByE/egGaYNwxABWUT8oFHp3abl28rlKJ/7bqUcO8p8YhMowzKB6BOyptXQX8n3LPXlppoLHaBig6VvkVdCYZ3nvsnoszXY9wZ7BQpANSV2XjCcdTu+IuR2f1v9PcdowZIScdQ0Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMRMPzzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMRMPzzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89D7C4CECE;
	Thu, 12 Dec 2024 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022103;
	bh=Y8gdgW3LhOEc8t3QmBLTAOgTD+iNdmyt769P37I/lh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMRMPzzOWAAotvS07hbVadRZvAg1B6UUr0UWx37uCifHqGbWfSrldzULPFpt/+pSb
	 pZbN9g9zeFLi6+Fcl+yWA1DzOZxJqjfLsCozW5Mke3n9DJav0D3D860zu7L1FM8LNk
	 Z6VKwDGFyRo/Xo68GSnuK204cYcJt/UvQegK001k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/565] drm/omap: Fix possible NULL dereference
Date: Thu, 12 Dec 2024 15:55:43 +0100
Message-ID: <20241212144317.337245910@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 050ca7eafac58..556e0f9026bed 100644
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
index 939597ab5b76d..05b7481f977ab 100644
--- a/drivers/gpu/drm/omapdrm/omap_drv.c
+++ b/drivers/gpu/drm/omapdrm/omap_drv.c
@@ -135,7 +135,7 @@ static void omap_disconnect_pipelines(struct drm_device *ddev)
 	for (i = 0; i < priv->num_pipes; i++) {
 		struct omap_drm_pipeline *pipe = &priv->pipes[i];
 
-		omapdss_device_disconnect(NULL, pipe->output);
+		omapdss_device_disconnect(priv->dss, pipe->output);
 
 		omapdss_device_put(pipe->output);
 		pipe->output = NULL;
@@ -153,7 +153,7 @@ static int omap_connect_pipelines(struct drm_device *ddev)
 	int r;
 
 	for_each_dss_output(output) {
-		r = omapdss_device_connect(priv->dss, NULL, output);
+		r = omapdss_device_connect(priv->dss, output);
 		if (r == -EPROBE_DEFER) {
 			omapdss_device_put(output);
 			return r;
-- 
2.43.0



