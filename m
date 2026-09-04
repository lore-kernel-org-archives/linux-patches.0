Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC8241A4F8;
	Fri,  4 Sep 2026 05:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500308; cv=none; b=q13gC8qCg3CqK4qf8N5tXsFPkXp2yORDKfJMLxh29VjlBzD2R3dyAdIIaKO5yajhoQfR7XV7tvXWTHB/ttYnsTbPCRkpKXoIPCZWMBLKF0CGEEUr7RKm3IZ9QffSZIUUATT/FOUztJ7Kv7pUQWEDBQmYyhT8WT4anNnzAsxJ1K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500308; c=relaxed/simple;
	bh=SVEYuAG6veSAwhZIauJWilS1yLlm13SHIDrsGZkVNfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IalBrQkh5lyrX22JfOuE7gC8z2jvR0BosWmpKZMkrVZtvI5n6neU87r4JmskWBeGSGTuL3c2RlYWrMt8J0TmQ4ruHB+JDsI6P2UEkmjzMa3RVNwi/fdVQtd3yVH7BC19UMIdHNjjBQLlLKhAjmkW8KcQh91k/sdhFRSUCz/mtKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2W0Rwv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2W0Rwv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9A81F00AC4;
	Fri,  4 Sep 2026 05:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500306;
	bh=xHuUr2V/auxmLRhc+Cc7jCb8mWxesZvc+CyG3w0bgKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2W0Rwv6QeW/TvnOddMnArt8vcVYmsa0hlHxB6GN9sDHlL6S3Hh6DF8KbxLTfOOg/
	 51viEFMCvDFqhu8EdEZEY5LwhUfbnp89s7WOCDdiV2xGKuk1YCnuEaFnfhcLbAMU5O
	 UahNTCQ0Rf0nPeBSkjRPz7RX48M82NLsAP43bxA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/552] drm/amd/display: Skip PHY SSC reduction on some 8K panels
Date: Fri,  4 Sep 2026 06:52:48 +0200
Message-ID: <20260904045748.082035520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 144169e7be0831e09958a906d08d1856751aa6c6 ]

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
Adjust for lack of HDMI 2.1 FRL in 6.18.y
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c   | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index d0f770dd0a956..21f391e01ca7c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -56,8 +56,11 @@ static u32 edid_extract_panel_id(struct edid *edid)
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
@@ -87,6 +90,11 @@ static void apply_edid_quirks(struct drm_device *dev, struct edid *edid, struct
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
@@ -108,7 +116,6 @@ enum dc_edid_status dm_helpers_parse_edid_caps(
 {
 	struct amdgpu_dm_connector *aconnector = link->priv;
 	struct drm_connector *connector = &aconnector->base;
-	struct drm_device *dev = connector->dev;
 	struct edid *edid_buf = edid ? (struct edid *) edid->raw_edid : NULL;
 	struct cea_sad *sads;
 	int sad_count = -1;
@@ -138,7 +145,7 @@ enum dc_edid_status dm_helpers_parse_edid_caps(
 
 	edid_caps->edid_hdmi = connector->display_info.is_hdmi;
 
-	apply_edid_quirks(dev, edid_buf, edid_caps);
+	apply_edid_quirks(link, edid_buf, edid_caps);
 
 	sad_count = drm_edid_to_sad((struct edid *) edid->raw_edid, &sads);
 	if (sad_count <= 0)
-- 
2.53.0



