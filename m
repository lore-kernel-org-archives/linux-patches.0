Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756BE3A9629;
	Fri,  4 Sep 2026 05:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500313; cv=none; b=KMtEyVrB2/7CMNazItPOMWc+5pfIKbe2w4m1SicTMziKlv5o75Bhw6UOb9QeQlUjFWOxNjleYVywJK4io6AR/8EFmQLZ4uwZyr8q/3v564ZqCZlxs0Qqe8YIaQpOiGeVbDBmtl/isKw5MWppoOPcz8ql1IZC3z9F/4uAJRO/LaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500313; c=relaxed/simple;
	bh=0IFpKXt7DPvF66LiKyDP1dfLUEMnPfdOLMlQob+IlPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxVm4zri1LavEpyXDjVw//1mwYw1O6xFv03FyMTGchEJiWUzE341HVJTLOXofceD2AH2N+HQUk+SuTGdNUKQ7Kcn2ApfixMmD/SnBJE2OB3G3H4eyOKjGOqPUQB7nOdewYuWzTlpeV8XpyGFS4eiknhthtWMlej8Et6mbRg6GSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHtJAIo1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHtJAIo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64021F00A3D;
	Fri,  4 Sep 2026 05:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500312;
	bh=OVvqHpYaGOrMMDNDMh4akhFalpFoB+AldbJHshzhQvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHtJAIo1sFMQQVfhIxV13s0TZBfPZK4T/8eTLl+xHcsVbgDFb2lcbNeG86chGWX12
	 EnJHK8SWLKNufVYVkyFRLqagWswCGrg/w9sMHsM/+SnB2ndIW8ZwI+V31D3tzFU9wn
	 c5PkbdKic2byO0m8+VxrMCL67l6DUJhNUUT+qCL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sun peng Li <sunpeng.li@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/552] drm/amd/display: hide Apple Studio Display secondary tile
Date: Fri,  4 Sep 2026 06:52:50 +0200
Message-ID: <20260904045748.127189035@linuxfoundation.org>
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

From: Jerry Zuo <jerry.zuo@amd.com>

[ Upstream commit 49521be4809d63fe3efb6bc68ee11cb1e1ef3d63 ]

The Apple Studio Display exposes a 2x1 tiled panel over two SST DP
links. The primary tile advertises the full 5120x2880 mode (with DSC on
the bandwidth-sufficient link) while the secondary carries a per-tile
2560x2880 timing on a link without sufficient bandwidth. Report the
non-primary tile connector as disconnected during detect so compositors
only see the primary DP link and configure a single 5K mode instead of
driving both tiled streams independently.

Drive the behaviour from an EDID quirk: add a disable_second_tile panel
patch that apply_edid_quirks() sets for the affected Apple Studio
Display panel IDs (0xAE3A, 0xAE42, 0xAE46), and have detect() hide the
secondary tile when the sink carries that quirk.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Adjust for lack of movement from amdgpu_dm.c to amdgpu_dm_connector.c
Adjust for lack of analog connector support.
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 36 +++++++++++++++++++
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 11 ++++++
 drivers/gpu/drm/amd/display/dc/dc_types.h     |  1 +
 3 files changed, 48 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d70b94c688c3a..1f6663090c25c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7327,6 +7327,39 @@ create_stream_for_sink(struct drm_connector *connector,
 	return stream;
 }
 
+/*
+ * Apple Studio Display exposes two SST DP links for a 2x1 tiled panel.
+ * The primary tile advertises the full 5120x2880 mode (with DSC on the
+ * bandwidth-sufficient link) while the secondary carries a per-tile
+ * 2560x2880 timing on a insufficient bandwidth link. Hide the secondary
+ * connector from userspace so compositors configure a single 5K stream
+ * on the primary link only.
+ */
+static bool amdgpu_dm_hide_secondary_tile_from_userspace(struct drm_connector *connector)
+{
+	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
+
+	if (!aconnector->dc_sink)
+		return false;
+
+	if (!aconnector->dc_sink->edid_caps.panel_patch.disable_second_tile)
+		return false;
+
+	drm_edid_connector_update(connector, aconnector->drm_edid);
+
+	if (!connector->has_tile)
+		return false;
+
+	if (!connector->tile_h_loc && !connector->tile_v_loc)
+		return false;
+
+	drm_dbg_kms(connector->dev,
+		    "[CONNECTOR:%d:%s] hiding secondary Apple Studio Display tile from userspace\n",
+		    connector->base.id, connector->name);
+
+	return true;
+}
+
 /**
  * amdgpu_dm_connector_detect() - Detect whether a DRM connector is connected to a display
  *
@@ -7352,6 +7385,9 @@ amdgpu_dm_connector_detect(struct drm_connector *connector, bool force)
 	else if (aconnector->base.force == DRM_FORCE_OFF)
 		return connector_status_disconnected;
 
+	if (amdgpu_dm_hide_secondary_tile_from_userspace(connector))
+		return connector_status_disconnected;
+
 	return (aconnector->dc_sink ? connector_status_connected :
 			connector_status_disconnected);
 }
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 21f391e01ca7c..25923b00667a0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -95,6 +95,17 @@ static void apply_edid_quirks(struct dc_link *link, struct edid *edid,
 		drm_dbg_driver(dev, "Skip PHY SSC reduction on panel id %X\n", panel_id);
 		link->wa_flags.skip_phy_ssc_reduction = true;
 		break;
+	/*
+	 * Workaround for Apple Studio Display which exposes a 2x1 tiled panel
+	 * over two SST DP links. Hide the secondary tile from userspace so
+	 * compositors drive a single 5K stream on the primary link only.
+	 */
+	case drm_edid_encode_panel_id('A', 'P', 'P', 0xAE3A):
+	case drm_edid_encode_panel_id('A', 'P', 'P', 0xAE42):
+	case drm_edid_encode_panel_id('A', 'P', 'P', 0xAE46):
+		drm_dbg_driver(dev, "Hiding secondary tile on panel id %X\n", panel_id);
+		edid_caps->panel_patch.disable_second_tile = true;
+		break;
 	default:
 		return;
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/dc_types.h b/drivers/gpu/drm/amd/display/dc/dc_types.h
index b5aa03a3e39cf..ff06a1dae5c61 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -178,6 +178,7 @@ struct dc_panel_patch {
 	unsigned int skip_audio_sab_check;
 	unsigned int mst_start_top_delay;
 	unsigned int remove_sink_ext_caps;
+	bool disable_second_tile;
 	unsigned int disable_colorimetry;
 	uint8_t blankstream_before_otg_off;
 	bool oled_optimize_display_on;
-- 
2.53.0



