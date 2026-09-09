Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E3C530DE5;
	Wed,  9 Sep 2026 14:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963016; cv=none; b=aHSaipKeRzgEThee3M0sxG9eHNZBUbwYJkHa3s06F1J0td3QHVuDIdOXkALoKKMC1BIo71eey8NnFUU9p7TzRQBG4HlMd3dHdfqxTH0bHkdZIuQC7ZISRezmjht1wLXkXqLwIGAwTZ6L/MLcgFPQD4olKy3nRDRYDecqiPTBS+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963016; c=relaxed/simple;
	bh=mlmKUkkONquRipXuOZSQlfLHpvNzda13w0ltmaH1Mjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFQWk+jXabGMJp7N2DYqWNgfL881Ndhu7fSKdsJlTn7r0q5M23EOIEYKvYUHlK8YO6F/LEhagZ1BUWuSmm5m1kILDAChN9/WR3tiwvFFiKnM7j0pKRYGhjTp6ehyBPt+94KlpMBV/XnjHNYUmSRHqz7RWCqNvaMHpzMiv77MMJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxGqwBak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxGqwBak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE9F1F00A3D;
	Wed,  9 Sep 2026 14:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963014;
	bh=HA4t1FYq1KiysfsFVAsc29JI0vve+MiHu6pQ5Q794e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxGqwBakUP6+pDmeuYZf9ZdAEUIOMSp5Y/F+JAmtXBSyUY+71CB59joetTA4WZV7p
	 ImDLDDWg/zxMDbLowcGSvjOFC48BXmbMiI33c83A+UQPlvgJ8I/jyrMWo0H8sPRzHZ
	 O3Guw5E9F/JO85FYSWc1CDvWEW0J2h2OZB12L9XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 491/556] drm/amd/display: validate plane degamma LUT size for private color prop
Date: Wed,  9 Sep 2026 15:42:51 +0200
Message-ID: <20260909134247.761465310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit e4c3ab59021e7c146a84b6671f0d530972bd58b4 upstream.

Unlike the CRTC degamma path, which is guarded by
amdgpu_dm_verify_lut_sizes(), the per-plane degamma LUT size was never
validated before use. __set_dm_plane_degamma() passed the user-supplied
size straight into __is_lut_linear() and, for a non-linear LUT, into
__set_input_tf() -> __drm_lut_to_dc_gamma(), the latter always iterating
MAX_COLOR_LUT_ENTRIES entries regardless of the actual LUT size.

A malformed AMD_PLANE_DEGAMMA_LUT blob (e.g. a single entry) could thus
trigger a divide-by-zero in __is_lut_linear() or an out-of-bounds read in
__drm_lut_to_dc_gamma(). Reject any plane degamma LUT whose size does not
match MAX_COLOR_LUT_ENTRIES, mirroring the invariant the code already
asserts a few lines below (and which the CRTC path enforces).

The AMD_PLANE_DEGAMMA_LUT property is only exposed on builds with
AMD_PRIVATE_COLOR defined.

Fixes: 980f8710075a ("drm/amd/display: add plane degamma TF and LUT support")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
@@ -1473,6 +1473,13 @@ __set_dm_plane_degamma(struct drm_plane_
 	degamma_lut = __extract_blob_lut(dm_plane_state->degamma_lut,
 					 &degamma_size);
 
+	if (degamma_lut && degamma_size != MAX_COLOR_LUT_ENTRIES) {
+		drm_dbg(plane_state->state->dev,
+			"Invalid Plane Degamma LUT size. Should be %u but got %u.\n",
+			MAX_COLOR_LUT_ENTRIES, degamma_size);
+		return -EINVAL;
+	}
+
 	has_degamma_lut = degamma_lut &&
 			  !__is_lut_linear(degamma_lut, degamma_size);
 


