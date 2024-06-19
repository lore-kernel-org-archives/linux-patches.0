Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C684D14387E;
	Wed, 19 Jun 2024 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803932; cv=none; b=Mw7kQkCWgpTxj32xbrC6dnMenDJLOdzSpSBG8fntbYcnumbzjD4jnRFwUDX2/lAJMqxrUSJyRwuQB8EqX4hFHZR4tBV+rlInB3xEhyjsbT+72/kMXIlsCvfEn0ScBorcVz0kBrSQbkjcJ44c2ZfJSZyGpD4bANt6wX7Er/sjGj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803932; c=relaxed/simple;
	bh=ZUfagm6xbeCanYB+nEN7Vgy54cgwxhkhekEABUfgAdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo0WoX6J6D2y/vyQ3tiwhLkB4kLHwpQCPuBb/dUF0zSmIphmx9thVJMrhi5xcDFgNOp6dC+Zm7BoSXSoZqgPWk4FGoRK5Gg0dyAMITn2gV89XqHb2YxsTTzKODDT+zHPnAkSWitoaJqoSeYT7mCkVD/ytKx5/u2IyLfqm+plXk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCsXuSAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCsXuSAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBD0C2BBFC;
	Wed, 19 Jun 2024 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803932;
	bh=ZUfagm6xbeCanYB+nEN7Vgy54cgwxhkhekEABUfgAdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCsXuSAkntlef8Q3JKAHGZU9dwOezDWy44CVoe/Qxj0WP4rgYN+4uKriy0+rF46hT
	 ZEn6oORamOFpZvChbYyxBn61lxC/pZHvAYSadzI7qv+H7KlQbJhGF09WCr9drIIT4O
	 s+3ts2y8Fg4IUevYoQpIJQHO7fHpHEThW5V4MCMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/217] drm/vmwgfx: Filter modes which exceed graphics memory
Date: Wed, 19 Jun 2024 14:56:18 +0200
Message-ID: <20240619125601.899858187@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 426826933109093503e7ef15d49348fc5ab505fe ]

SVGA requires individual surfaces to fit within graphics memory
(max_mob_pages) which means that modes with a final buffer size that would
exceed graphics memory must be pruned otherwise creation will fail.

Additionally llvmpipe requires its buffer height and width to be a multiple
of its tile size which is 64. As a result we have to anticipate that
llvmpipe will round up the mode size passed to it by the compositor when
it creates buffers and filter modes where this rounding exceeds graphics
memory.

This fixes an issue where VMs with low graphics memory (< 64MiB) configured
with high resolution mode boot to a black screen because surface creation
fails.

Fixes: d947d1b71deb ("drm/vmwgfx: Add and connect connector helper function")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240521184720.767-2-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c | 45 ++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
index b3e70ace6d9b0..6dd33d1258d11 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
@@ -40,7 +40,14 @@
 #define vmw_connector_to_stdu(x) \
 	container_of(x, struct vmw_screen_target_display_unit, base.connector)
 
-
+/*
+ * Some renderers such as llvmpipe will align the width and height of their
+ * buffers to match their tile size. We need to keep this in mind when exposing
+ * modes to userspace so that this possible over-allocation will not exceed
+ * graphics memory. 64x64 pixels seems to be a reasonable upper bound for the
+ * tile size of current renderers.
+ */
+#define GPU_TILE_SIZE 64
 
 enum stdu_content_type {
 	SAME_AS_DISPLAY = 0,
@@ -972,7 +979,41 @@ static void vmw_stdu_connector_destroy(struct drm_connector *connector)
 	vmw_stdu_destroy(vmw_connector_to_stdu(connector));
 }
 
+static enum drm_mode_status
+vmw_stdu_connector_mode_valid(struct drm_connector *connector,
+			      struct drm_display_mode *mode)
+{
+	enum drm_mode_status ret;
+	struct drm_device *dev = connector->dev;
+	struct vmw_private *dev_priv = vmw_priv(dev);
+	u64 assumed_cpp = dev_priv->assume_16bpp ? 2 : 4;
+	/* Align width and height to account for GPU tile over-alignment */
+	u64 required_mem = ALIGN(mode->hdisplay, GPU_TILE_SIZE) *
+			   ALIGN(mode->vdisplay, GPU_TILE_SIZE) *
+			   assumed_cpp;
+	required_mem = ALIGN(required_mem, PAGE_SIZE);
+
+	ret = drm_mode_validate_size(mode, dev_priv->stdu_max_width,
+				     dev_priv->stdu_max_height);
+	if (ret != MODE_OK)
+		return ret;
 
+	ret = drm_mode_validate_size(mode, dev_priv->texture_max_width,
+				     dev_priv->texture_max_height);
+	if (ret != MODE_OK)
+		return ret;
+
+	if (required_mem > dev_priv->max_primary_mem)
+		return MODE_MEM;
+
+	if (required_mem > dev_priv->max_mob_pages * PAGE_SIZE)
+		return MODE_MEM;
+
+	if (required_mem > dev_priv->max_mob_size)
+		return MODE_MEM;
+
+	return MODE_OK;
+}
 
 static const struct drm_connector_funcs vmw_stdu_connector_funcs = {
 	.dpms = vmw_du_connector_dpms,
@@ -988,7 +1029,7 @@ static const struct drm_connector_funcs vmw_stdu_connector_funcs = {
 static const struct
 drm_connector_helper_funcs vmw_stdu_connector_helper_funcs = {
 	.get_modes = vmw_connector_get_modes,
-	.mode_valid = vmw_connector_mode_valid
+	.mode_valid = vmw_stdu_connector_mode_valid
 };
 
 
-- 
2.43.0



