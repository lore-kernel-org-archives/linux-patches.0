Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F75527466A;
	Fri,  7 Aug 2026 15:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116511; cv=none; b=eLNVr3vJzH9EV5QAUg2s/IPoCjdrC1FG+NZN4iA36fTZjjd6l8UgFd+1z5pwZyipCO4GOkCVaIBdfdhsni8bWGop4rd9A0CHLNzL4B1MTStXkFWDh6F77wjv5XTYT5M9Cap+C7/qy5w5mfOEeyuPMJuJ+aP7/2g4V+U0FsuHLto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116511; c=relaxed/simple;
	bh=k66pGLWwBJhPYXNqRMCR4uNkjKuLd+Ssl4Qr2+nxAaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ll3ndpfqOz+lqZp0yizaQy8TwyNvOSOxP0djwUVi11xdexE8x4d07Fi4tvV++b2YC9vfZqM8XV1pFN7bcnPxwk2EZ3cNillOydS6epTjFP2wzDp9nMZk8C3KOcQ9V2UdEe7mZ/KhuFP79Hxl1sbYvcdyHyfOO22sJN3ZdDIExIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTLeKxvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTLeKxvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FE11F000E9;
	Fri,  7 Aug 2026 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116510;
	bh=oxT0DyeiHo9BQyvHbRgFV6G35QJSr7nGcodCGjN84TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTLeKxvNVwwn2HSP5xCOihXIZjLP2rzm4gqeFdlrr7kwDaAWCQ9doud9bFSaf0NG0
	 RrZ5DQiCEGycYiqxoKxMrtWJtIt+F3ZOevhjPXj9Vfr4b9iNAZooejQJRk7Kigab2T
	 ZjvmqHHfDeIqVlvCZPbFOAZ2V39fUxQlqy0m4yWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/261] drm/i915/fbc: Extract intel_fbc_has_fences()
Date: Fri,  7 Aug 2026 16:40:11 +0200
Message-ID: <20260807143420.896802999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit bc34d310b578952d37b5200a7fa7475ab2a2bd5e ]

Pull the "do we have fences?" check into a single helper in the FBC
code. Avoids having to call to outside the display code in multiple
places for this.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240705145254.3355-2-ville.syrjala@linux.intel.com
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: db9e64c983dc ("drm/i915/hdcp: require monotonically increasing seq_num_v")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_fbc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -223,6 +223,11 @@ static u16 intel_fbc_override_cfb_stride
 	return 0;
 }
 
+static bool intel_fbc_has_fences(struct drm_i915_private *i915)
+{
+	return intel_gt_support_legacy_fencing(to_gt(i915));
+}
+
 static u32 i8xx_fbc_ctl(struct intel_fbc *fbc)
 {
 	const struct intel_fbc_state *fbc_state = &fbc->state;
@@ -608,7 +613,7 @@ static void ivb_fbc_activate(struct inte
 	else if (DISPLAY_VER(i915) == 9)
 		skl_fbc_program_cfb_stride(fbc);
 
-	if (intel_gt_support_legacy_fencing(to_gt(i915)))
+	if (intel_fbc_has_fences(i915))
 		snb_fbc_program_fence(fbc);
 
 	intel_de_write(i915, ILK_DPFC_CONTROL(fbc->id),
@@ -992,7 +997,7 @@ static void intel_fbc_update_state(struc
 	fbc_state->fence_y_offset = intel_plane_fence_y_offset(plane_state);
 
 	drm_WARN_ON(&i915->drm, plane_state->flags & PLANE_HAS_FENCE &&
-		    !intel_gt_support_legacy_fencing(to_gt(i915)));
+		    !intel_fbc_has_fences(i915));
 
 	if (plane_state->flags & PLANE_HAS_FENCE)
 		fbc_state->fence_id =  i915_vma_fence_id(plane_state->ggtt_vma);


