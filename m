Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A562EF9AA;
	Thu,  3 Jul 2025 15:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555697; cv=none; b=DosXgvTzCZ9HqMGuISPwPcjSE9+r79oTFzj6foskdQqQmB/U0AlTUiYFC2/DzQiba+WGr/YGen/P2mRgolgmI/vp8fhF8+neROGq2vXI/ajypYRIWorJF+BrEhPtomG7jMD8Qymti4loVS1bx/RCs2sznHckdx12OsgVkKa7PHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555697; c=relaxed/simple;
	bh=3VAAnH6MmpURasXteT2wdGCU6ibu6CBJRKW7J5vD+cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyXPQFmJ+2sT6DmArg9yM2qS04q+shj0VCHzLkc9zufLMRUuDZ6Ogd7uU6kyP086Ek2CgG5CJcwv3mbhckvPLeQFbeJ/Qky9GyW9CgH49uWfhYLDEKS1tmLM96gYwo6ZYpDHaynesrmbGm+P1jWlfnaqYzp7AKFDsXhFKwssf00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CelxzZ1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CelxzZ1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B040C4CEED;
	Thu,  3 Jul 2025 15:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555696;
	bh=3VAAnH6MmpURasXteT2wdGCU6ibu6CBJRKW7J5vD+cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CelxzZ1U8t4ExIqT47jxbA/6CDbfbHKW6b1X8JmUQVtRSOQ+ueGAOwusuhtGEJYIm
	 FUS1TO2P5XFWcCRXrnlVrnEtN2FGlZgERURItDYazXXTTpIkGQBxnKYPkslhamoyut
	 C14Lb9jOOKkiOI2rIu47SPlebBsUNld1ktlm9J8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/139] drm/bridge: ti-sn65dsi86: make use of debugfs_init callback
Date: Thu,  3 Jul 2025 16:42:35 +0200
Message-ID: <20250703143944.755809000@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 1d1f7b15cb9c11974cebfd39da51dc69b8cb31ff ]

Do not create a custom directory in debugfs-root, but use the
debugfs_init callback to create a custom directory at the given place
for the bridge. The new directory layout looks like this on a Renesas
GrayHawk-Single with a R-Car V4M SoC:

	/sys/kernel/debug/dri/feb00000.display/DP-1/1-002c

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250315201651.7339-2-wsa+renesas@sang-engineering.com
Stable-dep-of: 55e8ff842051 ("drm/bridge: ti-sn65dsi86: Add HPD for DisplayPort connector type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 40 +++++++--------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index bfbd3fee12567..3e31a0c5a6d25 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -424,36 +424,8 @@ static int status_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
 DEFINE_SHOW_ATTRIBUTE(status);
 
-static void ti_sn65dsi86_debugfs_remove(void *data)
-{
-	debugfs_remove_recursive(data);
-}
-
-static void ti_sn65dsi86_debugfs_init(struct ti_sn65dsi86 *pdata)
-{
-	struct device *dev = pdata->dev;
-	struct dentry *debugfs;
-	int ret;
-
-	debugfs = debugfs_create_dir(dev_name(dev), NULL);
-
-	/*
-	 * We might get an error back if debugfs wasn't enabled in the kernel
-	 * so let's just silently return upon failure.
-	 */
-	if (IS_ERR_OR_NULL(debugfs))
-		return;
-
-	ret = devm_add_action_or_reset(dev, ti_sn65dsi86_debugfs_remove, debugfs);
-	if (ret)
-		return;
-
-	debugfs_create_file("status", 0600, debugfs, pdata, &status_fops);
-}
-
 /* -----------------------------------------------------------------------------
  * Auxiliary Devices (*not* AUX)
  */
@@ -1217,6 +1189,15 @@ static struct edid *ti_sn_bridge_get_edid(struct drm_bridge *bridge,
 	return drm_get_edid(connector, &pdata->aux.ddc);
 }
 
+static void ti_sn65dsi86_debugfs_init(struct drm_bridge *bridge, struct dentry *root)
+{
+	struct ti_sn65dsi86 *pdata = bridge_to_ti_sn65dsi86(bridge);
+	struct dentry *debugfs;
+
+	debugfs = debugfs_create_dir(dev_name(pdata->dev), root);
+	debugfs_create_file("status", 0600, debugfs, pdata, &status_fops);
+}
+
 static const struct drm_bridge_funcs ti_sn_bridge_funcs = {
 	.attach = ti_sn_bridge_attach,
 	.detach = ti_sn_bridge_detach,
@@ -1230,6 +1211,7 @@ static const struct drm_bridge_funcs ti_sn_bridge_funcs = {
 	.atomic_reset = drm_atomic_helper_bridge_reset,
 	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
+	.debugfs_init = ti_sn65dsi86_debugfs_init,
 };
 
 static void ti_sn_bridge_parse_lanes(struct ti_sn65dsi86 *pdata,
@@ -1935,8 +1917,6 @@ static int ti_sn65dsi86_probe(struct i2c_client *client)
 	if (ret)
 		return ret;
 
-	ti_sn65dsi86_debugfs_init(pdata);
-
 	/*
 	 * Break ourselves up into a collection of aux devices. The only real
 	 * motiviation here is to solve the chicken-and-egg problem of probe
-- 
2.39.5



