Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6053AEF22;
	Mon, 23 Mar 2026 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274755; cv=none; b=amIW1eqPkb5Jk7DkKrhAm5xcrtI0QKkavTFTXDNkQ0GzBqF7OfWxtGSSWCfKD6t3/8Tm3Wrn48dswpQUxnhdjlw9LM5+1j0HMRhUZb3QGFNfIVK543EAAHXK4e6K5SiOR8uA8u5CLC+Be72AMxUxmhyhxOFXbzXWURvGjSIkPRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274755; c=relaxed/simple;
	bh=7Kt2vcMJl8cf6UNVI9u59V2x3K3Lu1gboOj9tD15qR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=as9AVyHch5MLvHO9YfiZ9HUnTuIyaL181xqqJ5vK96Os5j6/tCjm4YPjBSjsJktAM6NmLU4TUUloldm9G6p4HZs+psVkl7fZi+UQ07ix08f/0i+EKygI584xaq2PKYmLToj3JeQ30c6RLA6F/vJ99JLEtc7oB+NYlP8xDy5rdVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W56RFDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W56RFDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E33C2BCB1;
	Mon, 23 Mar 2026 14:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274754;
	bh=7Kt2vcMJl8cf6UNVI9u59V2x3K3Lu1gboOj9tD15qR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W56RFDDyacvKQcqrrE1XSSGrv+By2+PU0petNHXhvuyTwCdNBdr/HLBBJ4SVAQxX
	 VDTKlSsGOr6DM6Wi4+k8tgQfxQQL8WRjCGSVye04KhIpTCXinnIzN5FBLjWhblX7bf
	 bslQVFtKiuBxO2ikvVhd4w6/SVs5wyUVuZ9pgNds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Kahola <mika.kahola@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/212] drm/i915/psr: Compute PSR entry_setup_frames into intel_crtc_state
Date: Mon, 23 Mar 2026 14:45:19 +0100
Message-ID: <20260323134506.873285514@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted context lines to account for missing `no_psr_reason` field and `alpm_state` struct. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_types.h |    1 +
 drivers/gpu/drm/i915/display/intel_psr.c           |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1127,6 +1127,7 @@ struct intel_crtc_state {
 	u32 dc3co_exitline;
 	u16 su_y_granularity;
 	u8 active_non_psr_pipes;
+	u8 entry_setup_frames;
 
 	/*
 	 * Frequency the dpll for the port should run at. Differs from the
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1585,7 +1585,7 @@ static bool _psr_compute_config(struct i
 	entry_setup_frames = intel_psr_entry_setup_frames(intel_dp, adjusted_mode);
 
 	if (entry_setup_frames >= 0) {
-		intel_dp->psr.entry_setup_frames = entry_setup_frames;
+		crtc_state->entry_setup_frames = entry_setup_frames;
 	} else {
 		drm_dbg_kms(display->drm,
 			    "PSR condition failed: PSR setup timing not met\n");
@@ -1657,7 +1657,7 @@ static bool intel_psr_needs_wa_180378188
 {
 	struct intel_display *display = to_intel_display(intel_dp);
 
-	return (DISPLAY_VER(display) == 20 && intel_dp->psr.entry_setup_frames > 0 &&
+	return (DISPLAY_VER(display) == 20 && crtc_state->entry_setup_frames > 0 &&
 		!crtc_state->has_sel_update);
 }
 
@@ -2027,6 +2027,7 @@ static void intel_psr_enable_locked(stru
 		crtc_state->req_psr2_sdp_prior_scanline;
 	intel_dp->psr.active_non_psr_pipes = crtc_state->active_non_psr_pipes;
 	intel_dp->psr.pkg_c_latency_used = crtc_state->pkg_c_latency_used;
+	intel_dp->psr.entry_setup_frames = crtc_state->entry_setup_frames;
 
 	if (!psr_interrupt_error_check(intel_dp))
 		return;


