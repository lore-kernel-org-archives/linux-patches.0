Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EE3395DB5;
	Mon, 23 Mar 2026 14:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277427; cv=none; b=Z6hYotJ4hAPVLW8jRA3GwCQDAxgxjvDGfieYCffw8Q4UL1RVf2NrjKDxEZNlgkoUAOT6zu0+V8I1Uj69jxlbbzo4mcD9Ftg3dezbTmdGByQyQ6MFba0lOQ2RLNoK0IfvEr3vV6tB7myDx9T4BYLQ+Fx5o2gBNh7TAyDBf4HXtDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277427; c=relaxed/simple;
	bh=RiZOT8H9TDFGZF6kqXx7qxXv0ZcP4ROfS065EP6RGJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Affvsyxg/Qz75vWolBpHIVN9lSIrkk/vCbS6XpRePXYY6kea9GxISLAHi8X3QHc3hSDEiN5SVExqG9Y6aZ0wo5bDNoLJrVPyDT9xy62hrSOOqrhl+YiFNoU6xctJocYUfp2VAVn52blZ5WrivQ1E9XP7onuCjGH2Zp+nbviqlmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1v4q20I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1v4q20I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1201C4CEF7;
	Mon, 23 Mar 2026 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277427;
	bh=RiZOT8H9TDFGZF6kqXx7qxXv0ZcP4ROfS065EP6RGJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1v4q20I2jgt8FsYxyzipeX3AwsjAK0fCuE/WzsJulk3i6ZFyr5kNSyiNBQ3xtXMq
	 nlpswDoMw10CxQkilZIPjZFZQZ5hIOBED6XgLwnHKhb254fwG9Yd3fR5C/QsoTCI61
	 dXVV05iJ0raXgCfFPDhYJVOfFup4A6Vc9jKcrbPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Kahola <mika.kahola@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 436/460] drm/i915/psr: Compute PSR entry_setup_frames into intel_crtc_state
Date: Mon, 23 Mar 2026 14:47:12 +0100
Message-ID: <20260323134537.275639618@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit 7caac659a837af9fd4cad85be851982b88859484 upstream.

PSR entry_setup_frames is currently computed directly into struct
intel_dp:intel_psr:entry_setup_frames. This causes a problem if mode change
gets rejected after PSR compute config: Psr_entry_setup_frames computed for
this rejected state is in intel_dp:intel_psr:entry_setup_frame. Fix this by
computing it into intel_crtc_state and copy the value into
intel_dp:intel_psr:entry_setup_frames on PSR enable.

Fixes: 2b981d57e480 ("drm/i915/display: Support PSR entry VSC packet to be transmitted one frame earlier")
Cc: Mika Kahola <mika.kahola@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260312083710.1593781-3-jouni.hogander@intel.com
(cherry picked from commit 8c229b4aa00262c13787982e998c61c0783285e0)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
[ dropped intel_psr_needs_wa_18037818876 hunk and adjusted surrounding context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_types.h |    1 +
 drivers/gpu/drm/i915/display/intel_psr.c           |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1218,6 +1218,7 @@ struct intel_crtc_state {
 	bool wm_level_disabled;
 	u32 dc3co_exitline;
 	u16 su_y_granularity;
+	u8 entry_setup_frames;
 
 	/*
 	 * Frequence the dpll for the port should run at. Differs from the
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1571,7 +1571,7 @@ static bool _psr_compute_config(struct i
 	entry_setup_frames = intel_psr_entry_setup_frames(intel_dp, adjusted_mode);
 
 	if (entry_setup_frames >= 0) {
-		intel_dp->psr.entry_setup_frames = entry_setup_frames;
+		crtc_state->entry_setup_frames = entry_setup_frames;
 	} else {
 		drm_dbg_kms(display->drm,
 			    "PSR condition failed: PSR setup timing not met\n");
@@ -1979,6 +1979,7 @@ static void intel_psr_enable_locked(stru
 	intel_dp->psr.psr2_sel_fetch_cff_enabled = false;
 	intel_dp->psr.req_psr2_sdp_prior_scanline =
 		crtc_state->req_psr2_sdp_prior_scanline;
+	intel_dp->psr.entry_setup_frames = crtc_state->entry_setup_frames;
 
 	if (!psr_interrupt_error_check(intel_dp))
 		return;


