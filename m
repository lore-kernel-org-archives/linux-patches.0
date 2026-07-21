Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A246471257;
	Tue, 21 Jul 2026 19:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662744; cv=none; b=rlPKe7jydPBEYSQwWQSJu34gZW9p72r5gMK2a8mMRqjf3z9b1lwY/f6dVVgDHHsiJ3rz/SjuZ/UtsgCt6/uoA1X66lRxFiqwGCRdEYNcdo2f6s205jOYkpimzyWGeOwgyeeJFznCl+QAABm6k944eMmSyP0LmDrGszP5scHJiyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662744; c=relaxed/simple;
	bh=lbomb85HucHIYc9iDT9g57gPI8aMZKk+ZL/uxLsH3VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrHguX2E4zQOjmOjdxQZxAh99rZjjZluYvnK/Kcuz3/K/r/29q9lNOTD2zucUYV+J6Q+IakWFeb6D0LVcjs7PMtIe/fh2+ZRHzUCwNfkQQyfO0OAgu7g6L15FHhi7vYfdIH+P1fDPCBHrW6LB4E3eLu5bR/nOtydLtgtMRuiJzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVBB48yG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVBB48yG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADA81F000E9;
	Tue, 21 Jul 2026 19:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662743;
	bh=zzVSGlLJzoqS7WTegvsWyjV1pE2aH2IDSUtVe83OY1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVBB48yGpMa+A57eojuY6WIzoNUx3DNOj4XtE+3ugVDPlsczNWXuxN2QGFJmz5ojf
	 H8TPYj21Y0Be1ABKwwrcK0MlHzd0UTqHyf69FIu7Pl0hTk7tUYTTGJToETbr83KOeo
	 2AhDGrIjcWm0+11gZCwaRnmWFx9phuWAanVnvmUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0561/1276] drm/i915: clear CRTC color blob pointers after dropping refs
Date: Tue, 21 Jul 2026 17:16:44 +0200
Message-ID: <20260721152458.673978261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 31f077088e0faae6be8377741f356dea1b94ba46 ]

intel_crtc_put_color_blobs() drops the CRTC color blob references, but
leaves the corresponding pointers unchanged.

This can matter in intel_crtc_prepare_cleared_state(), which frees the
old CRTC hw state before calling intel_dp_tunnel_atomic_clear_stream_bw().
The latter can fail while looking up the DP tunnel group state, for
example with -EDEADLK.

If that happens, the function returns without completing the cleared
state preparation. The failed atomic state will then be cleared by the
atomic core and intel_crtc_free_hw_state() can be called again for the
same state, dropping the same blob references again.

Clear the blob pointers after dropping the references so repeated cleanup
of the same CRTC hw state is safe.

Fixes: 77fcf58df15e ("drm/i915/dp_tunnel: Fix error handling when clearing stream BW in atomic state")
Suggested-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260612035310.3013066-1-lgs201920130244@gmail.com
(cherry picked from commit d5005addb5f68e8a0edce249506757bdc9e3d8c8)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_atomic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_atomic.c b/drivers/gpu/drm/i915/display/intel_atomic.c
index 12d6ed94075142..c1da487e88957d 100644
--- a/drivers/gpu/drm/i915/display/intel_atomic.c
+++ b/drivers/gpu/drm/i915/display/intel_atomic.c
@@ -290,6 +290,12 @@ static void intel_crtc_put_color_blobs(struct intel_crtc_state *crtc_state)
 
 	drm_property_blob_put(crtc_state->pre_csc_lut);
 	drm_property_blob_put(crtc_state->post_csc_lut);
+
+	crtc_state->hw.degamma_lut = NULL;
+	crtc_state->hw.gamma_lut = NULL;
+	crtc_state->hw.ctm = NULL;
+	crtc_state->pre_csc_lut = NULL;
+	crtc_state->post_csc_lut = NULL;
 }
 
 void intel_crtc_free_hw_state(struct intel_crtc_state *crtc_state)
-- 
2.53.0



