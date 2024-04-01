Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D75C129;
	Mon,  1 Apr 2024 16:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988675; cv=none; b=af06JETD0Io4oTIXOLGxJT5+W6rWcIait1aPugdrOfBoyr40foeVf1YnANTSKxO2xIlira5tlDt4/8lH1elI1W1yip+jPeWbVuYKmVNHG20FfNFAqE+OMqxAhSoQGsvkbkq7ayzcl2yR79NU+WPWwkgOYmwI0GO1R20h0yTbOz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988675; c=relaxed/simple;
	bh=VSZ8MgFI5jBAvTzeZJwwrOVVOwObhj/E2Nsy3CdDOi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuThmWQ7BWynd3kpUtxjUTSY4697/yh+RFmULjvPLsb3zWtHpiQzVODZTTY++5yUC+JQf/GONIAp74Lu+XdWc19a8uhp4cuK4b42VRBqK9PwSowF0EsBCC9I9Ah5Mos7RdAjiyvLDsfN8ckPUQvTwgk90KLlyJOJur3Wc9Iy3Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vj13XQ7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vj13XQ7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EB5C433C7;
	Mon,  1 Apr 2024 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988675;
	bh=VSZ8MgFI5jBAvTzeZJwwrOVVOwObhj/E2Nsy3CdDOi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vj13XQ7YmEDb3ctVl8KPV57VGxGP1CstcsovuEEAmMYUZ7ZnCFKM5sWzkOU76k2DD
	 MrVtgTJF1NPsmTk8p88poRoeU4omTctry/X+QjlprtEunPnMkcEjc4jrJ3buWh8rMG
	 OyWp+/gxTr+85mpwurYq+W8JsuYxR1sz9UeWzSR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 228/432] drm/bridge: add ->edid_read hook and drm_bridge_edid_read()
Date: Mon,  1 Apr 2024 17:43:35 +0200
Message-ID: <20240401152559.935916864@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit d807ad80d811ba0c22adfd871e2a46491f80d6e2 ]

Add new struct drm_edid based ->edid_read hook and
drm_bridge_edid_read() function to call the hook.

v2: Include drm/drm_edid.h

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/9d08d22eaffcb9c59a2b677e45d7e61fc689bc2f.1706038510.git.jani.nikula@intel.com
Stable-dep-of: 171b711b26cc ("drm/bridge: lt8912b: do not return negative values from .get_modes()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bridge.c | 46 +++++++++++++++++++++++++++++++++++-
 include/drm/drm_bridge.h     | 33 ++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index 30d66bee0ec6a..e1cfba2ff583b 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -27,8 +27,9 @@
 #include <linux/mutex.h>
 
 #include <drm/drm_atomic_state_helper.h>
-#include <drm/drm_debugfs.h>
 #include <drm/drm_bridge.h>
+#include <drm/drm_debugfs.h>
+#include <drm/drm_edid.h>
 #include <drm/drm_encoder.h>
 #include <drm/drm_file.h>
 #include <drm/drm_of.h>
@@ -1206,6 +1207,47 @@ int drm_bridge_get_modes(struct drm_bridge *bridge,
 }
 EXPORT_SYMBOL_GPL(drm_bridge_get_modes);
 
+/**
+ * drm_bridge_edid_read - read the EDID data of the connected display
+ * @bridge: bridge control structure
+ * @connector: the connector to read EDID for
+ *
+ * If the bridge supports output EDID retrieval, as reported by the
+ * DRM_BRIDGE_OP_EDID bridge ops flag, call &drm_bridge_funcs.edid_read to get
+ * the EDID and return it. Otherwise return NULL.
+ *
+ * If &drm_bridge_funcs.edid_read is not set, fall back to using
+ * drm_bridge_get_edid() and wrapping it in struct drm_edid.
+ *
+ * RETURNS:
+ * The retrieved EDID on success, or NULL otherwise.
+ */
+const struct drm_edid *drm_bridge_edid_read(struct drm_bridge *bridge,
+					    struct drm_connector *connector)
+{
+	if (!(bridge->ops & DRM_BRIDGE_OP_EDID))
+		return NULL;
+
+	/* Transitional: Fall back to ->get_edid. */
+	if (!bridge->funcs->edid_read) {
+		const struct drm_edid *drm_edid;
+		struct edid *edid;
+
+		edid = drm_bridge_get_edid(bridge, connector);
+		if (!edid)
+			return NULL;
+
+		drm_edid = drm_edid_alloc(edid, (edid->extensions + 1) * EDID_LENGTH);
+
+		kfree(edid);
+
+		return drm_edid;
+	}
+
+	return bridge->funcs->edid_read(bridge, connector);
+}
+EXPORT_SYMBOL_GPL(drm_bridge_edid_read);
+
 /**
  * drm_bridge_get_edid - get the EDID data of the connected display
  * @bridge: bridge control structure
@@ -1215,6 +1257,8 @@ EXPORT_SYMBOL_GPL(drm_bridge_get_modes);
  * DRM_BRIDGE_OP_EDID bridge ops flag, call &drm_bridge_funcs.get_edid to
  * get the EDID and return it. Otherwise return NULL.
  *
+ * Deprecated. Prefer using drm_bridge_edid_read().
+ *
  * RETURNS:
  * The retrieved EDID on success, or NULL otherwise.
  */
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 9ef461aa9b9e2..99aea536013ef 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -557,6 +557,37 @@ struct drm_bridge_funcs {
 	int (*get_modes)(struct drm_bridge *bridge,
 			 struct drm_connector *connector);
 
+	/**
+	 * @edid_read:
+	 *
+	 * Read the EDID data of the connected display.
+	 *
+	 * The @edid_read callback is the preferred way of reporting mode
+	 * information for a display connected to the bridge output. Bridges
+	 * that support reading EDID shall implement this callback and leave
+	 * the @get_modes callback unimplemented.
+	 *
+	 * The caller of this operation shall first verify the output
+	 * connection status and refrain from reading EDID from a disconnected
+	 * output.
+	 *
+	 * This callback is optional. Bridges that implement it shall set the
+	 * DRM_BRIDGE_OP_EDID flag in their &drm_bridge->ops.
+	 *
+	 * The connector parameter shall be used for the sole purpose of EDID
+	 * retrieval, and shall not be stored internally by bridge drivers for
+	 * future usage.
+	 *
+	 * RETURNS:
+	 *
+	 * An edid structure newly allocated with drm_edid_alloc() or returned
+	 * from drm_edid_read() family of functions on success, or NULL
+	 * otherwise. The caller is responsible for freeing the returned edid
+	 * structure with drm_edid_free().
+	 */
+	const struct drm_edid *(*edid_read)(struct drm_bridge *bridge,
+					    struct drm_connector *connector);
+
 	/**
 	 * @get_edid:
 	 *
@@ -888,6 +919,8 @@ drm_atomic_helper_bridge_propagate_bus_fmt(struct drm_bridge *bridge,
 enum drm_connector_status drm_bridge_detect(struct drm_bridge *bridge);
 int drm_bridge_get_modes(struct drm_bridge *bridge,
 			 struct drm_connector *connector);
+const struct drm_edid *drm_bridge_edid_read(struct drm_bridge *bridge,
+					    struct drm_connector *connector);
 struct edid *drm_bridge_get_edid(struct drm_bridge *bridge,
 				 struct drm_connector *connector);
 void drm_bridge_hpd_enable(struct drm_bridge *bridge,
-- 
2.43.0



