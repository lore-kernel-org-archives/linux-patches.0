Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D18313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301037; cv=none; b=JKSLmJUgMN8clku74MGrAl6nusE61YOqtOcSYmS4TwU7BF5PrLGV3kMo96oSZozYCD2UYnjYW424DC03M/A/Sjm+cCkf4aY7T1NcA/q/KPZaQjKXPKMLNehqiNNDTs5mDY6KWM8Xi9roK1qpQUU/Z9f2QWp/U1wth6vjMdfKQ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301037; c=relaxed/simple;
	bh=q8eiRDRkU9tqoi5U5Yofpk5B6AYUFTFvenjgfRVD4Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iW5RMod86gL6SGoxcyrJlqTnd3k+on8U+eJaUrVHP9bY5yNmECz8+6gqaj44RYYBGj9YO4cxSAxgjyMR3uDE1fdKmofr9/T5sInbwP6dfcNYDUthnxrIBjWZm+DoIj17ynHotDMcdaOtRyJDmVhhGGlKFL5Jn6CKvkSC8yHlX8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTQ9KhjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTQ9KhjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063ECC19424;
	Sat, 28 Feb 2026 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301037;
	bh=q8eiRDRkU9tqoi5U5Yofpk5B6AYUFTFvenjgfRVD4Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTQ9KhjVG/tiGac1qaCyQkw17NV96kR9yXw0nwvsKMif3QScfSuzqcbOiy3ORLorS
	 EVFLHqgOQXIxTXrmszOy/KyHlhfBm5d3S4xywvXd1rWRGp1bM4WHaqT3EBSC/wtNSx
	 Ls3xlvhmQSzL36isfsXEbAK1vfMbRkW4VCxLfWgZuYPks1bL/PySoPOeT0Gwcj/3pr
	 sDY5JCUQckuvcEYafpbwcxdsz9VwTacO7DdECe6rKXqzrBF/Q1MgJOn2ob0LMoVTDK
	 TkXKlBWpNqX8UO7BOIUTqE2OAYiuLs3P15OMxYCh+7PaKQdepNC0e6HxdgO3yuhPT8
	 F1KdIk/zt3fzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Karen Chen <karen.chen@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/752] drm/amd/display: Disable FEC when powering down encoders
Date: Sat, 28 Feb 2026 12:38:06 -0500
Message-ID: <20260228174750.1542406-175-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ovidiu Bunea <ovidiu.bunea@amd.com>

[ Upstream commit 8cee62904caf95e5698fa0f2d420f5f22b4dea15 ]

[why & how]
VBIOS DMCUB FW can enable FEC for capable eDPs, but S/W DC state is
only updated for link0 when transitioning into OS with driver loaded.
This causes issues when the eDP is immediately hidden and DIG0 is
assigned to another link that does not support FEC. Driver will
attempt to disable FEC but FEC enablement occurs based on the link
state, which does not have fec_state updated since it is a different
link. Thus, FEC disablement on DIG0 will get skipped and cause no
light up.

Reviewed-by: Karen Chen <karen.chen@amd.com>
Signed-off-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dce110/dce110_hwseq.c | 24 ++++++++++++-------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 7e36c063f0da5..65e66bfc4161c 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -59,6 +59,7 @@
 #include "dc_state_priv.h"
 #include "dpcd_defs.h"
 #include "dsc.h"
+#include "dc_dp_types.h"
 /* include DCE11 register header files */
 #include "dce/dce_11_0_d.h"
 #include "dce/dce_11_0_sh_mask.h"
@@ -1729,20 +1730,25 @@ static void power_down_encoders(struct dc *dc)
 	int i;
 
 	for (i = 0; i < dc->link_count; i++) {
-		enum signal_type signal = dc->links[i]->connector_signal;
-
-		dc->link_srv->blank_dp_stream(dc->links[i], false);
+		struct dc_link *link = dc->links[i];
+		struct link_encoder *link_enc = link->link_enc;
+		enum signal_type signal = link->connector_signal;
 
+		dc->link_srv->blank_dp_stream(link, false);
 		if (signal != SIGNAL_TYPE_EDP)
 			signal = SIGNAL_TYPE_NONE;
 
-		if (dc->links[i]->ep_type == DISPLAY_ENDPOINT_PHY)
-			dc->links[i]->link_enc->funcs->disable_output(
-					dc->links[i]->link_enc, signal);
+		if (link->ep_type == DISPLAY_ENDPOINT_PHY)
+			link_enc->funcs->disable_output(link_enc, signal);
+
+		if (link->fec_state == dc_link_fec_enabled) {
+			link_enc->funcs->fec_set_enable(link_enc, false);
+			link_enc->funcs->fec_set_ready(link_enc, false);
+			link->fec_state = dc_link_fec_not_ready;
+		}
 
-		dc->links[i]->link_status.link_active = false;
-		memset(&dc->links[i]->cur_link_settings, 0,
-				sizeof(dc->links[i]->cur_link_settings));
+		link->link_status.link_active = false;
+		memset(&link->cur_link_settings, 0, sizeof(link->cur_link_settings));
 	}
 }
 
-- 
2.51.0

