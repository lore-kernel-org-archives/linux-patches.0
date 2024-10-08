Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433D51DED48;
	Tue,  8 Oct 2024 13:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392807; cv=none; b=Q/SbZmlPzEpyM3ytjQRyzjXa/oSSg+yvZhrT6f30yURIpbD+RbQCSMeKJDxcGJRu53FDVY4SCPDPEP/tK7Sr1iS00fN0np/53JLaFIjHkfZ1FD7BbJ2R0ropbLxKu7hoxseU7IoItmSOVTU+S+Hw/wfBz4mLy84I8gGSsM7l9vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392807; c=relaxed/simple;
	bh=5mcPfSvJVPVXx/O++QHp4TgWueXeofm33GaeH6k+4nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpAGRje4UBzxr24el2Z9NJI5UAHbci0qvjtcfq66AKbb472AcCLqtyY/j4x5sic5WHM8FJv7I2mzefV3bCN10F1wq5pjcCT2fN4km4V8kB+3OrdG8uZtB6cxJEaM3yWdCuk1lnddm/suqr1rDsRSXEmKH79Z6kH5+nsvpWLhkPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0/vQdFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0/vQdFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D04C4CECC;
	Tue,  8 Oct 2024 13:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392807;
	bh=5mcPfSvJVPVXx/O++QHp4TgWueXeofm33GaeH6k+4nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0/vQdFP33Zz5hX0SxsJccSGG1VludSHliDut5COGnaoKmw4OCRE2essiklVPYcF+
	 ibe2OdqdXVWH5yJUn9IKLpdJB25vSwPxHrswliPBZ4CCZP2LZyCdnwOSJrrUbBIImk
	 6k/sKBqJtU6+CcMJwxKG8ycGAHoJJ3+QlQWnqH7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 525/558] drm/amd/display: Add HDR workaround for specific eDP
Date: Tue,  8 Oct 2024 14:09:15 +0200
Message-ID: <20241008115722.889795587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit 05af800704ee7187d9edd461ec90f3679b1c4aba upstream.

[WHY & HOW]
Some eDP panels suffer from flicking when HDR is enabled in KDE. This
quirk works around it by skipping VSC that is incompatible with eDP
panels.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3151
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d4257280d7957727998ef90ccc7b69c7cca8376)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c         |   11 ++++++++++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    4 ++++
 drivers/gpu/drm/amd/display/dc/dc_types.h                 |    1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6713,12 +6713,21 @@ create_stream_for_sink(struct drm_connec
 	if (stream->signal == SIGNAL_TYPE_DISPLAY_PORT ||
 	    stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST ||
 	    stream->signal == SIGNAL_TYPE_EDP) {
+		const struct dc_edid_caps *edid_caps;
+		unsigned int disable_colorimetry = 0;
+
+		if (aconnector->dc_sink) {
+			edid_caps = &aconnector->dc_sink->edid_caps;
+			disable_colorimetry = edid_caps->panel_patch.disable_colorimetry;
+		}
+
 		//
 		// should decide stream support vsc sdp colorimetry capability
 		// before building vsc info packet
 		//
 		stream->use_vsc_sdp_for_colorimetry = stream->link->dpcd_caps.dpcd_rev.raw >= 0x14 &&
-						      stream->link->dpcd_caps.dprx_feature.bits.VSC_SDP_COLORIMETRY_SUPPORTED;
+						      stream->link->dpcd_caps.dprx_feature.bits.VSC_SDP_COLORIMETRY_SUPPORTED &&
+						      !disable_colorimetry;
 
 		if (stream->out_transfer_func.tf == TRANSFER_FUNCTION_GAMMA22)
 			tf = TRANSFER_FUNC_GAMMA_22;
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -73,6 +73,10 @@ static void apply_edid_quirks(struct edi
 		DRM_DEBUG_DRIVER("Clearing DPCD 0x317 on monitor with panel id %X\n", panel_id);
 		edid_caps->panel_patch.remove_sink_ext_caps = true;
 		break;
+	case drm_edid_encode_panel_id('S', 'D', 'C', 0x4154):
+		DRM_DEBUG_DRIVER("Disabling VSC on monitor with panel id %X\n", panel_id);
+		edid_caps->panel_patch.disable_colorimetry = true;
+		break;
 	default:
 		return;
 	}
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -178,6 +178,7 @@ struct dc_panel_patch {
 	unsigned int skip_avmute;
 	unsigned int mst_start_top_delay;
 	unsigned int remove_sink_ext_caps;
+	unsigned int disable_colorimetry;
 };
 
 struct dc_edid_caps {


