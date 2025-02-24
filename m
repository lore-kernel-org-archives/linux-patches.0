Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5523A18BC26;
	Mon, 24 Feb 2025 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409236; cv=none; b=jshsLFWiwcwCnynlqw1rMUz+aiHx6fuPk/xYG/7OBv70gdtHDV+L+k2oR8Nb+p0sSxBrjKE5scu/pQ9GLH2bVq8SYlBPg/lYfGOtH2foxz1Jfz/j4UVyk7v3XRRnII8/nOLWA0dVu+xgdbl6QwX6nMKrm8gGqsyXYAwO73SeCAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409236; c=relaxed/simple;
	bh=xQOxQupCziuKhG9ndDH0rIA58TUQN85q+5vPLiZgExE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LpMq1GY0HSr16mgjHDGYVecMLOGgdHsFZTYciqkbNJRfBoTs9NefZ2pP9fX2frpZ8YO8URcnwPn1r5AQj2tXdHBD7/xOMAz01sEfpD8EJSF09aqzvz2uzWKNEB9w2mgwBVmodlVjK1ZOLvolCVlwCkmx1BScVzITDMqLzEZbrdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSTk9KZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSTk9KZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3F8C4CED6;
	Mon, 24 Feb 2025 15:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409235;
	bh=xQOxQupCziuKhG9ndDH0rIA58TUQN85q+5vPLiZgExE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSTk9KZjh7hCdXn5yccUDLzyumvqT4PW75kMlu2EOy/oCQwf2yfeROqeQwPhvYrmt
	 jsOkBIP2JO8yhCQcyGEg33zUUbO7ZIG1Y1es5eEQRvV0MUwPdM3iZxbnDMvpB7RKcK
	 N88ZObKM6DAoWjHKcbC8CyD0jqyl5OINtPlCzRuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?B=C5=82a=C5=BCej=20Szczygie=C5=82?= <mumei6102@gmail.com>,
	Sergey Kovalenko <seryoga.engineering@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 137/138] drm/amdgpu/gfx9: manually control gfxoff for CS on RV
Date: Mon, 24 Feb 2025 15:36:07 +0100
Message-ID: <20250224142609.854335353@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b35eb9128ebeec534eed1cefd6b9b1b7282cf5ba upstream.

When mesa started using compute queues more often
we started seeing additional hangs with compute queues.
Disabling gfxoff seems to mitigate that.  Manually
control gfxoff and gfx pg with command submissions to avoid
any issues related to gfxoff.  KFD already does the same
thing for these chips.

v2: limit to compute
v3: limit to APUs
v4: limit to Raven/PCO
v5: only update the compute ring_funcs
v6: Disable GFX PG
v7: adjust order

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Suggested-by: Błażej Szczygieł <mumei6102@gmail.com>
Suggested-by: Sergey Kovalenko <seryoga.engineering@gmail.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3861
Link: https://lists.freedesktop.org/archives/amd-gfx/2025-January/119116.html
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -7439,6 +7439,34 @@ static void gfx_v9_0_ring_emit_cleaner_s
 	amdgpu_ring_write(ring, 0);  /* RESERVED field, programmed to zero */
 }
 
+static void gfx_v9_0_ring_begin_use_compute(struct amdgpu_ring *ring)
+{
+	struct amdgpu_device *adev = ring->adev;
+
+	amdgpu_gfx_enforce_isolation_ring_begin_use(ring);
+
+	/* Raven and PCO APUs seem to have stability issues
+	 * with compute and gfxoff and gfx pg.  Disable gfx pg during
+	 * submission and allow again afterwards.
+	 */
+	if (amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 1, 0))
+		gfx_v9_0_set_powergating_state(adev, AMD_PG_STATE_UNGATE);
+}
+
+static void gfx_v9_0_ring_end_use_compute(struct amdgpu_ring *ring)
+{
+	struct amdgpu_device *adev = ring->adev;
+
+	/* Raven and PCO APUs seem to have stability issues
+	 * with compute and gfxoff and gfx pg.  Disable gfx pg during
+	 * submission and allow again afterwards.
+	 */
+	if (amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 1, 0))
+		gfx_v9_0_set_powergating_state(adev, AMD_PG_STATE_GATE);
+
+	amdgpu_gfx_enforce_isolation_ring_end_use(ring);
+}
+
 static const struct amd_ip_funcs gfx_v9_0_ip_funcs = {
 	.name = "gfx_v9_0",
 	.early_init = gfx_v9_0_early_init,
@@ -7615,8 +7643,8 @@ static const struct amdgpu_ring_funcs gf
 	.emit_wave_limit = gfx_v9_0_emit_wave_limit,
 	.reset = gfx_v9_0_reset_kcq,
 	.emit_cleaner_shader = gfx_v9_0_ring_emit_cleaner_shader,
-	.begin_use = amdgpu_gfx_enforce_isolation_ring_begin_use,
-	.end_use = amdgpu_gfx_enforce_isolation_ring_end_use,
+	.begin_use = gfx_v9_0_ring_begin_use_compute,
+	.end_use = gfx_v9_0_ring_end_use_compute,
 };
 
 static const struct amdgpu_ring_funcs gfx_v9_0_ring_funcs_kiq = {


