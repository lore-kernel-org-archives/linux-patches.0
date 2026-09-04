Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD2830C160;
	Fri,  4 Sep 2026 05:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500316; cv=none; b=EUYs6ru3bbjdvO5AlXHxTQcB+k1w53eqL/NPAwW0j73vVyUUH+f4qY8I0CgI6ljCHWLUeLPH08GUCY8NHp0rw7aBNy/ZbCpvGDldrbXIpkAjhXNkTtsiot7g1rGSvpDFo1obSydCjAhTmOfBwmD5p2Qam6ZAZMAieOXlMPZaUjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500316; c=relaxed/simple;
	bh=AkGHtbJZ114cFNMrLxANjYDMiqhwYLeuTpTfLFWlE8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1D7lmQr5aIY8lPB9W7ro9hHpb19qykUcilO0uHkrzx/C3oAjqvzUDK7049Io2ODRQubs/nmx5Lznf65UfbbUd/cmdWs0OXK40W/jkkFE9kQM09+/LD++TBep7auF30uov0haI62my7aeSnvO1LWOrqInJV3E6c14FHykKy8ga4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li6Gm0od; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li6Gm0od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADE41F00A3D;
	Fri,  4 Sep 2026 05:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500315;
	bh=Aov0Rva8Xe3suB/0i/q5iJgf9geHrG2Rj1Bq/lKlvYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li6Gm0odwFoARCgnhEVHXIdAooqNo5p+KnLx+0eNCOapU7ulK+42dxiIphTxchsLH
	 HIwhyF0mjyB7b4sO0FpvAd51Vi/ou05bADwEFCyQfS9/nxT8A97ZjnfwHiYsOchJ7k
	 kBe8fi8GpKMCaYB3m787CRqlyCSxvAlSTzfXDrSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/552] drm/amd/display: Prune per-tile Timing from Apple Studio Display Primary Tile
Date: Fri,  4 Sep 2026 06:52:51 +0200
Message-ID: <20260904045748.148698941@linuxfoundation.org>
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

From: Fangzhi Zuo <jerry.zuo@amd.com>

[ Upstream commit 7a4dd08c3f921576c6a7524f60e4f0e4601835d2 ]

[why]
The Apple Studio Display primary tile advertises both the full 5120x2880
mode and the per-tile 2560x2880 timing. With the secondary tile already
hidden from userspace, the stray 2560x2880 mode on the primary connector
can still be picked by compositors, defeating the single 5K stream goal.

[how]
Prune the per-tile timing from the primary connector during get_modes:
when the sink carries the disable_second_tile quirk and the connector is
the primary tile (tile_h_loc == 0 && tile_v_loc == 0), drop any probed
mode matching the advertised tile size (tile_h_size x tile_v_size) so
userspace only sees the full 5120x2880 mode.

Fixes: 49521be4809d ("drm/amd/display: hide Apple Studio Display secondary tile")
Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Adjust for lack of movement from amdgpu_dm.c to amdgpu_dm_connector.c
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 1f6663090c25c..deac90c49d638 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8540,6 +8540,47 @@ static void amdgpu_dm_connector_add_common_modes(struct drm_encoder *encoder,
 	}
 }
 
+/*
+ * The Apple Studio Display primary tile advertises both the full 5120x2880
+ * mode and the per-tile 2560x2880 timing. As the secondary tile is hidden from
+ * userspace (see amdgpu_dm_hide_secondary_tile_from_userspace()), drop the
+ * per-tile timing from the primary connector so compositors only pick the full
+ * 5K mode.
+ */
+static void amdgpu_dm_prune_primary_tile_modes(struct drm_connector *connector)
+{
+	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
+	struct drm_display_mode *mode, *t;
+
+	if (!aconnector->dc_sink)
+		return;
+
+	if (!aconnector->dc_sink->edid_caps.panel_patch.disable_second_tile)
+		return;
+
+	if (!connector->has_tile)
+		return;
+
+	/* Only prune the per-tile timing from the primary tile. */
+	if (connector->tile_h_loc || connector->tile_v_loc)
+		return;
+
+	list_for_each_entry_safe(mode, t, &connector->probed_modes, head) {
+		if (mode->hdisplay != connector->tile_h_size ||
+		    mode->vdisplay != connector->tile_v_size)
+			continue;
+
+		drm_dbg_kms(connector->dev,
+			    "[CONNECTOR:%d:%s] pruning per-tile %dx%d timing from primary Apple Studio Display tile\n",
+			    connector->base.id, connector->name,
+			    mode->hdisplay, mode->vdisplay);
+
+		list_del(&mode->head);
+		drm_mode_destroy(connector->dev, mode);
+		aconnector->num_modes--;
+	}
+}
+
 static void amdgpu_set_panel_orientation(struct drm_connector *connector)
 {
 	struct drm_encoder *encoder;
@@ -8582,6 +8623,8 @@ static void amdgpu_dm_connector_ddc_get_modes(struct drm_connector *connector,
 		amdgpu_dm_connector->num_modes =
 				drm_edid_connector_add_modes(connector);
 
+		amdgpu_dm_prune_primary_tile_modes(connector);
+
 		/* sorting the probed modes before calling function
 		 * amdgpu_dm_get_native_mode() since EDID can have
 		 * more than one preferred mode. The modes that are
-- 
2.53.0



