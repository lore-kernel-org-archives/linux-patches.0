Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032D91A9B5A;
	Wed, 20 Nov 2024 12:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107558; cv=none; b=hKjES3CW2vGqM8RQRCXdJ4EbAz33e22UMl9DO+vY0JCZJ2PPayQHSspAAegkIjbQ29D+BTjbcVh+m4R0/ItXpZbKodLoXjtVjoG2I2vNSoipBBDyRdfew3qJDHwsOSUn6nfQ8xLyqNxUFiunfy7Y2QqwVhwM4HSQqo6LzFNRWQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107558; c=relaxed/simple;
	bh=X6zsUkBjza/5jP+kfz1gX3zQIaZSH8I6qfwhYbrlwSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k54HdU8Uq48JzPBd1LIC1tkZ6A/Qsg2DDW8o1ENjaZb+k2b0G+0pR7bhKb+Klb7er+TquqIvQljsKsrmJsb6jqdMhlf0dRjgWL9VOUQdNzEZF9UGGP3Aw6B3L2vMJr3bRfGIPqVz2WY0tW3FX7nJu/m4qCI86E0B3YQf3FLFZUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPq/44OA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPq/44OA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B7EC4CED2;
	Wed, 20 Nov 2024 12:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107557;
	bh=X6zsUkBjza/5jP+kfz1gX3zQIaZSH8I6qfwhYbrlwSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPq/44OAg2mit3kgc15Ias/czXKInllQXKu4svL7vpz9A9b6m/TFGQVzQTjn8b38r
	 0oWVzM/k3FiCssGy11tKlYnEoQnE35L72CG4tqFHusWMjXUPqLxZL4cgPvBLYndTRo
	 kWFP0mi2sXc+lKh5M96bIWInSQ1dnrGeMz5Iom5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austin Zheng <austin.zheng@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 099/107] drm/amd/display: Require minimum VBlank size for stutter optimization
Date: Wed, 20 Nov 2024 13:57:14 +0100
Message-ID: <20241120125631.962881432@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Dillon Varone <dillon.varone@amd.com>

commit 9fc0cbcb6e45d6fc96ffd3bb7b6d6d28d693ff4d upstream.

If the nominal VBlank is too small, optimizing for stutter can cause
the prefetch bandwidth to increase drasticaly, resulting in higher
clock and power requirements. Only optimize if it is >3x the stutter
latency.

Reviewed-by: Austin Zheng <austin.zheng@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 003215f962cdf2265f126a3f4c9ad20917f87fca)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c |   11 ++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c
@@ -30,6 +30,7 @@
 #include "dml2_pmo_dcn4_fams2.h"
 
 static const double MIN_VACTIVE_MARGIN_PCT = 0.25; // We need more than non-zero margin because DET buffer granularity can alter vactive latency hiding
+static const double MIN_BLANK_STUTTER_FACTOR = 3.0;
 
 static const enum dml2_pmo_pstate_strategy base_strategy_list_1_display[][PMO_DCN4_MAX_DISPLAYS] = {
 	// VActive Preferred
@@ -2004,6 +2005,7 @@ bool pmo_dcn4_fams2_init_for_stutter(str
 	struct dml2_pmo_instance *pmo = in_out->instance;
 	bool stutter_period_meets_z8_eco = true;
 	bool z8_stutter_optimization_too_expensive = false;
+	bool stutter_optimization_too_expensive = false;
 	double line_time_us, vblank_nom_time_us;
 
 	unsigned int i;
@@ -2025,10 +2027,15 @@ bool pmo_dcn4_fams2_init_for_stutter(str
 		line_time_us = (double)in_out->base_display_config->display_config.stream_descriptors[i].timing.h_total / (in_out->base_display_config->display_config.stream_descriptors[i].timing.pixel_clock_khz * 1000) * 1000000;
 		vblank_nom_time_us = line_time_us * in_out->base_display_config->display_config.stream_descriptors[i].timing.vblank_nom;
 
-		if (vblank_nom_time_us < pmo->soc_bb->power_management_parameters.z8_stutter_exit_latency_us) {
+		if (vblank_nom_time_us < pmo->soc_bb->power_management_parameters.z8_stutter_exit_latency_us * MIN_BLANK_STUTTER_FACTOR) {
 			z8_stutter_optimization_too_expensive = true;
 			break;
 		}
+
+		if (vblank_nom_time_us < pmo->soc_bb->power_management_parameters.stutter_enter_plus_exit_latency_us * MIN_BLANK_STUTTER_FACTOR) {
+			stutter_optimization_too_expensive = true;
+			break;
+		}
 	}
 
 	pmo->scratch.pmo_dcn4.num_stutter_candidates = 0;
@@ -2044,7 +2051,7 @@ bool pmo_dcn4_fams2_init_for_stutter(str
 		pmo->scratch.pmo_dcn4.z8_vblank_optimizable = false;
 	}
 
-	if (pmo->soc_bb->power_management_parameters.stutter_enter_plus_exit_latency_us > 0) {
+	if (!stutter_optimization_too_expensive && pmo->soc_bb->power_management_parameters.stutter_enter_plus_exit_latency_us > 0) {
 		pmo->scratch.pmo_dcn4.optimal_vblank_reserved_time_for_stutter_us[pmo->scratch.pmo_dcn4.num_stutter_candidates] = (unsigned int)pmo->soc_bb->power_management_parameters.stutter_enter_plus_exit_latency_us;
 		pmo->scratch.pmo_dcn4.num_stutter_candidates++;
 	}


