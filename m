Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D0520F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960FEC433C7;
	Fri, 21 Jul 2023 19:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967409;
	bh=YRIYtT+4ORyc2g1Z7ZBtk1TOy85sC+64nOpEjdKDULY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6CtYhqSA7m+c0tRiudtYmjswgSNJ29pXn+cGpZFuqFBnPRrV7LFqIS5qVwohaDl+
	 5Buzmx10GxF1Yl9RPt0gXo3YZ2Cz/RgC9a5BOiWruw1LhPo0kaohE45CEM2QNp9hp+
	 QZhfgGR89Sr+MMoYyLPif8G7bFYw8BtekwvI/RhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 153/223] drm/amd/display: Add monitor specific edid quirk
Date: Fri, 21 Jul 2023 18:06:46 +0200
Message-ID: <20230721160527.394579997@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit 613a7956deb3b1ffa2810c6d4c90ee9c3d743dbb upstream.

Disable FAMS on a Samsung Odyssey G9 monitor. Experiments show that this
monitor does not work well under some use cases, and is likely
implementation specific bug on the monitor's firmware.

Cc: stable@vger.kernel.org
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |   26 ++++++++++++++
 1 file changed, 26 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -42,6 +42,30 @@
 #include "dm_helpers.h"
 #include "ddc_service_types.h"
 
+static u32 edid_extract_panel_id(struct edid *edid)
+{
+	return (u32)edid->mfg_id[0] << 24   |
+	       (u32)edid->mfg_id[1] << 16   |
+	       (u32)EDID_PRODUCT_ID(edid);
+}
+
+static void apply_edid_quirks(struct edid *edid, struct dc_edid_caps *edid_caps)
+{
+	uint32_t panel_id = edid_extract_panel_id(edid);
+
+	switch (panel_id) {
+	/* Workaround for some monitors which does not work well with FAMS */
+	case drm_edid_encode_panel_id('S', 'A', 'M', 0x0E5E):
+	case drm_edid_encode_panel_id('S', 'A', 'M', 0x7053):
+	case drm_edid_encode_panel_id('S', 'A', 'M', 0x71AC):
+		DRM_DEBUG_DRIVER("Disabling FAMS on monitor with panel id %X\n", panel_id);
+		edid_caps->panel_patch.disable_fams = true;
+		break;
+	default:
+		return;
+	}
+}
+
 /* dm_helpers_parse_edid_caps
  *
  * Parse edid caps
@@ -113,6 +137,8 @@ enum dc_edid_status dm_helpers_parse_edi
 	else
 		edid_caps->speaker_flags = DEFAULT_SPEAKER_LOCATION;
 
+	apply_edid_quirks(edid_buf, edid_caps);
+
 	kfree(sads);
 	kfree(sadb);
 


