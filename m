Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DF9471252;
	Tue, 21 Jul 2026 19:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660815; cv=none; b=U+V/ad/IQ7kuRYa3aMboHR7VkQVLYemvV1qrVjzlhr5KboKDBQj6yut7aQFbbyfCckHdAf/oZi2tDUsnqUTTLpHZMVzD60VPk5RkNknqqgkGRcpDKxLg3euAyq9pdnXcn7GVpnj3tTfAB4G5+KeImaevpA9+cptUbFLMv3wDEBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660815; c=relaxed/simple;
	bh=fraWOnReV6vcq/g82L9VqcClYQUQoudC1XK2YGpA6ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT1wuidBkgQ44oZZGhjell3SDtgsah4wSNHEduj+AsAjtXz1x0ijsDYao0QUmHtbpiZZOXOkkgKNMlqD7M4d4h20pJkXWrlEMy3AN4IpdSoeDUl5VOvr/2owiwcvNinjGnrTFN40ZFMKg4+/Um0jvXsKGpD/PBd5/4NzNEYtPZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hS6ru3tx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hS6ru3tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67881F000E9;
	Tue, 21 Jul 2026 19:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660814;
	bh=SxNCHUWQjsLxfykaVxaNSPn9nQtZS//bYKBLB0EBViM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hS6ru3txxPh2cYsUg0TZRPLAynsP71zAlZCFEHGNIVS+QWDNOLBwWAhVPtjw1KEzv
	 atecKYMnIgWq/L6WTadjqrFOPPw3XKZjxsYEkLEnhCujn0QeDSq8rNjBKEKZKZTG4i
	 8bFhBCMBeSyM2Chs6cZRMehyUMpK+Xqh8gDH2OBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1105/2077] drm/amd/display: Skip PHY SSC reduction on some 8K panels
Date: Tue, 21 Jul 2026 17:12:58 +0200
Message-ID: <20260721152618.883339005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit fe7945d092a1d3c340febc2ab176cee50d0f6c80 ]

[Why]
Some 8K displays cannot tolerate the reduced phy ssc value
at high link utilization and show corruption or black screen.

[How]
Add an EDID panel-id quirk to utilize existing skip_phy_ssc_reduction flag.

To pass the link into the quirk handler, change the signature of
apply_edid_quirks() to take link as an argument. The dev local in
dm_helpers_parse_edid_caps() becomes unused and is removed.

Fixes: 5fa62c87cffd ("drm/amd/display: Add option to disable PHY SSC reduction on transmitter enable")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 144169e7be0831e09958a906d08d1856751aa6c6)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c   | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index a3cb05490dc916..ee214f7592e50b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -95,8 +95,11 @@ static u32 edid_extract_panel_id(struct edid *edid)
 	       (u32)EDID_PRODUCT_ID(edid);
 }
 
-static void apply_edid_quirks(struct drm_device *dev, struct edid *edid, struct dc_edid_caps *edid_caps)
+static void apply_edid_quirks(struct dc_link *link, struct edid *edid,
+			      struct dc_edid_caps *edid_caps)
 {
+	struct amdgpu_dm_connector *aconnector = link->priv;
+	struct drm_device *dev = aconnector->base.dev;
 	uint32_t panel_id = edid_extract_panel_id(edid);
 
 	switch (panel_id) {
@@ -126,6 +129,11 @@ static void apply_edid_quirks(struct drm_device *dev, struct edid *edid, struct
 		drm_dbg_driver(dev, "Disabling VSC on monitor with panel id %X\n", panel_id);
 		edid_caps->panel_patch.disable_colorimetry = true;
 		break;
+	/* Workaround for monitors that get corrupted by the PHY SSC reduction */
+	case drm_edid_encode_panel_id('D', 'E', 'L', 0x4147):
+		drm_dbg_driver(dev, "Skip PHY SSC reduction on panel id %X\n", panel_id);
+		link->wa_flags.skip_phy_ssc_reduction = true;
+		break;
 	default:
 		return;
 	}
@@ -147,7 +155,6 @@ enum dc_edid_status dm_helpers_parse_edid_caps(
 {
 	struct amdgpu_dm_connector *aconnector = link->priv;
 	struct drm_connector *connector = &aconnector->base;
-	struct drm_device *dev = connector->dev;
 	struct edid *edid_buf = edid ? (struct edid *) edid->raw_edid : NULL;
 	struct cea_sad *sads;
 	int sad_count = -1;
@@ -181,7 +188,7 @@ enum dc_edid_status dm_helpers_parse_edid_caps(
 	if (edid_caps->edid_hdmi)
 		populate_hdmi_info_from_connector(&connector->display_info.hdmi, edid_caps);
 
-	apply_edid_quirks(dev, edid_buf, edid_caps);
+	apply_edid_quirks(link, edid_buf, edid_caps);
 
 	sad_count = drm_edid_to_sad((struct edid *) edid->raw_edid, &sads);
 	if (sad_count <= 0)
-- 
2.53.0



