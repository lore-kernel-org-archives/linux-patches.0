Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8748A1BE846;
	Tue,  2 Jul 2024 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940642; cv=none; b=D/nv3aLryJ1hOkyDFnjIXeF4I8Xk8EwSX82RZ2N41L5wc5YgRrGC7vN3j18ZohZP9JW9YaHw6QE9L67XvrBsKfxwnq5DrzAZunSpsEIlXy3RncHNxDihXP+6OTiiF2G/CidzNLNEMH65gh8Me8bsqwzTA7oTWdBWMK9ef4jT7PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940642; c=relaxed/simple;
	bh=IiEqP1J6dk/eYn83NAUGFXa4Pgr7Ls9S1breN+C44xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dh3htcWpz/ahsxBMvf3thE3dagSvbGaEN+0AY58XJ/A9fos9WWQ6P4/MtEhIXhxKEO0CY5CHbubou4F3TubxmFRenYWxZiOl9FcohvfmzzQ7tOlFudcpCjZK8RCs8HzjdWI7I64Dgc4tEl8SVj5DljlGuw6xKEZMSCQczNLfRu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llDPVIfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llDPVIfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB010C116B1;
	Tue,  2 Jul 2024 17:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940642;
	bh=IiEqP1J6dk/eYn83NAUGFXa4Pgr7Ls9S1breN+C44xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llDPVIfyRfZXb6LGMwiG8ypWzhCdbVdtXcFpVVxdkVx6D5CEIikBYubL0sEKaZIpG
	 1WnnkK7qvnW7a1DOklseYHJNJpLzKAm81k1LaWe5UB9nrpCHFiLGZEV2KIeNgdlRkR
	 FaSSA25AM41h1oqCgvy8nzzCb2Lcb4EiK/gyoGhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.9 185/222] drm/amd/display: Send DP_TOTAL_LTTPR_CNT during detection if LTTPR is present
Date: Tue,  2 Jul 2024 19:03:43 +0200
Message-ID: <20240702170251.057435123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Strauss <michael.strauss@amd.com>

commit 2ec6c7f802332d1eff16f03e7c757f1543ee1183 upstream.

[WHY]
New register field added in DP2.1 SCR, needed for auxless ALPM

[HOW]
Echo value read from 0xF0007 back to sink

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c |   10 +++++++++-
 drivers/gpu/drm/amd/display/include/dpcd_defs.h                    |    5 +++++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -1590,9 +1590,17 @@ static bool retrieve_link_cap(struct dc_
 			return false;
 	}
 
-	if (dp_is_lttpr_present(link))
+	if (dp_is_lttpr_present(link)) {
 		configure_lttpr_mode_transparent(link);
 
+		// Echo TOTAL_LTTPR_CNT back downstream
+		core_link_write_dpcd(
+				link,
+				DP_TOTAL_LTTPR_CNT,
+				&link->dpcd_caps.lttpr_caps.phy_repeater_cnt,
+				sizeof(link->dpcd_caps.lttpr_caps.phy_repeater_cnt));
+	}
+
 	/* Read DP tunneling information. */
 	status = dpcd_get_tunneling_device_data(link);
 
--- a/drivers/gpu/drm/amd/display/include/dpcd_defs.h
+++ b/drivers/gpu/drm/amd/display/include/dpcd_defs.h
@@ -177,4 +177,9 @@ enum dpcd_psr_sink_states {
 #define DP_SINK_PR_PIXEL_DEVIATION_PER_LINE     0x379
 #define DP_SINK_PR_MAX_NUMBER_OF_DEVIATION_LINE 0x37A
 
+/* Remove once drm_dp_helper.h is updated upstream */
+#ifndef DP_TOTAL_LTTPR_CNT
+#define DP_TOTAL_LTTPR_CNT                                  0xF000A /* 2.1 */
+#endif
+
 #endif /* __DAL_DPCD_DEFS_H__ */


