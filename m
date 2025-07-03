Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5D5126BFF;
	Thu,  3 Jul 2025 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554208; cv=none; b=orF4cHVAyKxf2pQJZkEsBLPAd/IVUTj6nnIbK2L378arIaHj0Di48upnN6LvWFs1UXZLiPOZwCZJP/9b3ApylnQWO/ma1ELsn5aJj/TQ65b7+Ot+LqgoyNSxOEGeokljRbKTixsw3H548wxH7dBq7fPmV6a8x6T5JfJX51oZlJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554208; c=relaxed/simple;
	bh=UhAv6IQex3+vBgwUcA4ZtttQ5T82f6nWY0ZcV5JjUPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLkCPJEX4enbcBXfCyzsLX0UNx6ecqi6gyoGA7IObl24IbNWGkE/P+HR3bH3sGH8QUAGiEvGWW8Rxc2v18BSPoXe93oANQiF8gDmY8q17Fb7gE/P5Mn9/3wkz3pdCBM8nti6W0ZMfQUGX8oel0kuldLB/u8xoDD4Pox1IDfni0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVDxrISb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVDxrISb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8039C4CEE3;
	Thu,  3 Jul 2025 14:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554208;
	bh=UhAv6IQex3+vBgwUcA4ZtttQ5T82f6nWY0ZcV5JjUPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVDxrISbqWDrXdgjjyKXEEZLFtXRHhUhj0vY5t3eF/GKUXGVHCTLMBk2TazdYA3Ua
	 XAScqvJEYxGj1+ok6qzR/bNOHuXI0AURhEN/ZN6/FFOUnU26QlG50X+bEsEgq0jcru
	 nBusf2+LTlitsY/+pZeKxJ+u3eA5Ez/WKgzN06i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/218] drm/bridge: ti-sn65dsi86: make use of debugfs_init callback
Date: Thu,  3 Jul 2025 16:41:02 +0200
Message-ID: <20250703144000.495914731@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 95ce50ed53acf..ca7597805e30f 100644
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
@@ -1217,6 +1189,15 @@ static const struct drm_edid *ti_sn_bridge_edid_read(struct drm_bridge *bridge,
 	return drm_edid_read_ddc(connector, &pdata->aux.ddc);
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
@@ -1938,8 +1920,6 @@ static int ti_sn65dsi86_probe(struct i2c_client *client)
 	if (ret)
 		return ret;
 
-	ti_sn65dsi86_debugfs_init(pdata);
-
 	/*
 	 * Break ourselves up into a collection of aux devices. The only real
 	 * motiviation here is to solve the chicken-and-egg problem of probe
-- 
2.39.5



