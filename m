Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0746C47125E;
	Tue, 21 Jul 2026 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657501; cv=none; b=g51fn/fJoygQ9WLYb8GmVYVMoIjNmknRN3ZTy0laPRPwv6igFMRkh/aHvsY0Rb3tixekCOI7Sr7tMkfgMJOsWtjwoH3iYNTiO/85ZhiN1ZnFE0l0hxeyfDq4gij9WHLNHoVVEWoH0hJ7uHaAgtLfPBewn0I3ckAOppPg6RTJFbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657501; c=relaxed/simple;
	bh=fUYsTp38VplYGVR0WGLcpik23Zc8a78iMCnShIgmpO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu02IpNFqn5ErzGHdedR6Ik54sAc6up4ao3/bGPuWDuFs/XSG6yxTTGEuZs/C1abYFuZ98CqOORKfO9f9aL3jIjELCPt2seAvMZ/uAyhomsV6Lu0rG7u78RL6fdQ9oWbxIDLUqGNoHo14moszKOz11JeFulO98CJrX71QFants4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbeuRNdj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbeuRNdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5871F000E9;
	Tue, 21 Jul 2026 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657499;
	bh=+WNGL756+6TtdHyb/Nr1gqSyNfXgy/6qjqQZoeLHpZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbeuRNdjlcWIQejaJadW9xMAMuyBYCOZZhOGdWZujmt5tJXwNbV8SfdOWXdXN0oIs
	 PrlYLjIw9uOsbby1mTJfEx4SoyeUBE7nPlOdAMWogRjFIheGJ36gEiYh25vPEX+rGi
	 +dvlGmHqZ1zEyEMC38wPE2U/oYvpLUfP1PwOjL3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0786/1611] drm/i915: clear CRTC color blob pointers after dropping refs
Date: Tue, 21 Jul 2026 17:15:02 +0200
Message-ID: <20260721152533.066273336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 348b1655435e1c..5b6e3605732e1d 100644
--- a/drivers/gpu/drm/i915/display/intel_atomic.c
+++ b/drivers/gpu/drm/i915/display/intel_atomic.c
@@ -289,6 +289,12 @@ static void intel_crtc_put_color_blobs(struct intel_crtc_state *crtc_state)
 
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



