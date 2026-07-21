Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B500471246;
	Tue, 21 Jul 2026 19:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660715; cv=none; b=PFeOJyrRjBA3pQHfJvWaYNT+BgiofdL2lvTadqB4KDQUku3jBdaoIpT1SD/6GVrwcH/cCFAvMlGuzIz1ON/B+03YoDdko3uyIszZ4AyDwflmZpaqsIUoVwpuYwDW23U7+6xj1a7DGjMcdcjkjuMTOLFUjwdJjsr3BD9JVRhfmMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660715; c=relaxed/simple;
	bh=vRsq6749X9AL8QI1L1p3v687Zy3nWKxyqAmhHXPZhC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5xO/DEY9Q7j70Mb4xo1J1V8Fwsl04d7QBGDa1ykrslWZajwGDNTHJKMcp7pvDJbGyoh6l2kqHV9pS0YmVXVLUoV0nyPal+gLyQz8/JpQBaPaKNDSVZkmynj35+MWDvhB+FK7Op0P7F8Lmx78SsARauKtRuq3Wgj2eszplHDkUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOnBp3Ru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOnBp3Ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C7E1F000E9;
	Tue, 21 Jul 2026 19:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660714;
	bh=cEUatnxa6Ad8+jUrKip4fZFhCSnW0mTZM0GqM+rIkOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOnBp3RuaabB18DYYgmLHRCeILK+nNQPWMiYURFqTWZbQIfy1/MLtA8RwQVILQziu
	 j8O+tDJ0Np24SHo9J7fJwI+huZw7fsZ28JWi7YwS2scCbfr8zbN3/X4F3LA/dlxBai
	 0alyDCJSHMMrpU6V4EE/31WLx2q1/A/Gs1howfGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1084/2077] drm/i915: clear CRTC color blob pointers after dropping refs
Date: Tue, 21 Jul 2026 17:12:37 +0200
Message-ID: <20260721152618.390810915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 71b7325917b6e6..a16e1cb7d41e51 100644
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



