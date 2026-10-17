Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCF22D73A6;
	Sat, 17 Oct 2026 17:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257055; cv=none; b=kIeHNJ/et/pOeBZ/n9gb5qKaXlvbbycZOQa9rTGVsax4bDugqLOGCD21sIFTws8Qy0kC3xkoYXDhvlIoW0Kpy0FuIJRwHCCOpKslSPzuXakNOc+OrSj0hl3dgFaVOVfirQ/Bn/Td8tLAa55D/EOHGGHyTFVim3wY2flxjdc6Mck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257055; c=relaxed/simple;
	bh=8HKs9D513Nh5F3G14ypYfbeSl0t0pgcKLPytZu4PTZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y72VUxxpgsrgG/jRQQ3MJyhTeedWlLbjKfmuFsFLt6p/13WXkSyk3SMODfY51Ms9ADDg4PwFdRjuIG+s0Z2L13fJfZ/xQrdlBCMwzLnsT/dzufPlvgt+RC2OQOzJMiB9MTZ9dUWdHfq4ffdSUJnj5lfecrcS2grkRF3z+eqLioA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIVz0Ksa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIVz0Ksa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27491F000C4;
	Sat, 17 Oct 2026 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257054;
	bh=AsvhGIQtRmJSo2g+vkWh/ve4teUPVOsHcf4xJSFS9N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIVz0Ksa9HbvBYFgHGtKaA1d36VZrhtRqAbJtXNYt2WYzY1tZ+/Xf9/yISL9OZlQA
	 5Hm7iFxjxWG5nBw8CqOhUeF4QkrfoL0d3l7RTTEkoyEpkQCqfijjvDjOPAZv8YOgVB
	 htygGVOAbSSj1i5hOCW/uZpTdeF4wJ4lVh8tZ3k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Arthur Heymans <arthur@aheymans.xyz>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0394/1674] drm/amd/display: Preserve eDP mode on initial ASSR failure
Date: Sat, 17 Oct 2026 17:44:26 +0200
Message-ID: <20261017160441.222449050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arthur Heymans <arthur@aheymans.xyz>

[ Upstream commit 5e08102d1d336593160d1434261d50b0c0f6cbe6 ]

Commit 56d8ce9d8c17 ("drm/amd/display: Apply correct panel mode when
reinitializing hardware") made ASSR failure fall back to the default panel
mode unless eDP mode had previously been applied.

However, dc_link is zero-initialized and DP_PANEL_MODE_DEFAULT is zero.
Before the first call to dp_set_panel_mode(), panel_mode therefore looks
like a previously applied default mode. If ASSR setup fails during the
first link training attempt, the driver incorrectly trains the eDP link
using the default scrambling mode.

On a Google Vilboz Chromebook running self-built coreboot firmware and
PSP verstage, this leaves the panel mostly black with corrupted output
along the top edge.

Track whether panel_mode has actually been initialized, and only consult
the saved mode after it has been applied. This retains the recovery
behavior while preserving eDP mode during initial link training.

Fixes: 56d8ce9d8c17 ("drm/amd/display: Apply correct panel mode when reinitializing hardware")
Assisted-by: Pi:gpt-5.6-sol
Reviewed-by: George Zhang <george.zhang@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Arthur Heymans <arthur@aheymans.xyz>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ccb6c2702033f1002b45807fb3cc938760f26f78)
Cc: stable@vger.kernel.org # 6.4.x
[ sashal: Applied the ASSR guard in perform_link_training_with_retries() instead of the absent edp_set_panel_assr() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                            | 1 +
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_training.c   | 3 ++-
 .../drm/amd/display/dc/link/protocols/link_edp_panel_control.c | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 88e64b280c90f..1f4292336692e 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1512,6 +1512,7 @@ struct dc_link {
 	struct ddc_service *ddc;
 
 	enum dp_panel_mode panel_mode;
+	bool panel_mode_initialized;
 	bool aux_mode;
 
 	/* Private to DC core */
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
index 539f57858dfec..aa46e0e84ce4f 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -1608,7 +1608,8 @@ bool perform_link_training_with_retries(
 				 */
 				bool result;
 				result = cp_psp->funcs.enable_assr(cp_psp->handle, link);
-				if (!result && link->panel_mode != DP_PANEL_MODE_EDP)
+				if (!result && link->panel_mode_initialized &&
+				    link->panel_mode != DP_PANEL_MODE_EDP)
 					panel_mode = DP_PANEL_MODE_DEFAULT;
 			}
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
index d4d92da153ece..9f7ace40092ba 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
@@ -88,6 +88,7 @@ void dp_set_panel_mode(struct dc_link *link, enum dp_panel_mode panel_mode)
 	}
 
 	link->panel_mode = panel_mode;
+	link->panel_mode_initialized = true;
 	DC_LOG_DETECTION_DP_CAPS("Link: %d eDP panel mode supported: %d "
 		 "eDP panel mode enabled: %d \n",
 		 link->link_index,
-- 
2.53.0



