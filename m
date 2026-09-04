Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FB43D9521;
	Fri,  4 Sep 2026 05:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498291; cv=none; b=XjwmMjjunSzbugPmO48aLhCgOeDdlo+rKh21PnXzEFwPO/oOYBCFqoibFRzaRsZp2NqM0+lx+4Zr9fmv8bBSdoUviG1oMyN9JHN8cR/TPmkaNdi7jrkhngcz9Nl5YMPThQaPJAg+fObeQdn5Kpqu/B8JF0qqIqXJBgi2VJPbtlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498291; c=relaxed/simple;
	bh=a2zuwKBg9qtXL2aZZuIGfIg4wZue26hsAg6wSKwTThk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoOsLeARazWQV8IUtqckx957RpJV1cePAFt7zTmqfjTFHnYKkiKQguR78Ce+eVW3EtW4bjLR6fpjl6zGCNvNjDkJRHOZ1ul9TDAcwIt6mcBO+Dc/gTG67AzF6G4bhCJnbi4Jwq7Oc9VDymcflRvd/2VBmRH6cjfUGzqyrqYGNSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cReVjQZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cReVjQZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32741F00A3E;
	Fri,  4 Sep 2026 05:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498290;
	bh=uYcUBuveRq4JfajyVSLg5tNS4hBA+Qu24/cWLOFGXV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cReVjQZEwubHIs0IzWfBSQVN7PkJT4ZKfv/Z5qWOxnZ21zTyk7y9n10vb2LX4TYzV
	 3CGUE7+xZ9PzMIXowDgBar+3dYs60t1mF5/v2J6qKVzm/E59J64oaqobiEY3zz/A0D
	 b/Namc0IOLCaoCQ3BcP7/mcKZsadHQVCDt/Wx/BQ=
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
Subject: [PATCH 7.2 011/713] drm/amd/display: hide Apple Studio Display secondary tile
Date: Fri,  4 Sep 2026 06:49:39 +0200
Message-ID: <20260904045804.074479291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 36 +++++++++++++++++++
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 11 ++++++
 drivers/gpu/drm/amd/display/dc/dc_types.h     |  1 +
 3 files changed, 48 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 941c1a3128249..6604ce25255d8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7846,6 +7846,39 @@ amdgpu_dm_connector_poll(struct amdgpu_dm_connector *aconnector, bool force)
 	return status;
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
@@ -7889,6 +7922,9 @@ amdgpu_dm_connector_detect(struct drm_connector *connector, bool force)
 		(!aconnector->dc_sink || aconnector->dc_sink->edid_caps.analog))
 		return amdgpu_dm_connector_poll(aconnector, force);
 
+	if (amdgpu_dm_hide_secondary_tile_from_userspace(connector))
+		return connector_status_disconnected;
+
 	return (aconnector->dc_sink ? connector_status_connected :
 			connector_status_disconnected);
 }
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 6be7f6edd0b29..41aa8f9bb152b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -134,6 +134,17 @@ static void apply_edid_quirks(struct dc_link *link, struct edid *edid,
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
index 4ed1efa172709..6482e275e63bf 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -187,6 +187,7 @@ struct dc_panel_patch {
 	unsigned int skip_audio_sab_check;
 	unsigned int mst_start_top_delay;
 	unsigned int remove_sink_ext_caps;
+	bool disable_second_tile;
 	unsigned int disable_colorimetry;
 	uint8_t blankstream_before_otg_off;
 	bool oled_optimize_display_on;
-- 
2.53.0



