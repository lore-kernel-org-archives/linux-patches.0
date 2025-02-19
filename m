Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE971DED71;
	Wed, 19 Feb 2025 08:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955093; cv=none; b=lVcDMRoFIuGPpwqTlaNb+hMl5rasXJ304VAjdlEXCHbm4AlUjtEpC3zoiL0HXwA8BIwNKBnXZ0XLC5MT0Q/CDrIcTD37qLvqYTgDwXn3CCnEszQC1PugtoKObkpWDhkr4oSDjZVPs3apmH/ZNRrCTT365OOAdMMAma9Fi8Y530w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955093; c=relaxed/simple;
	bh=SoSQDWTJiboABlD8nykJrMmT2bmuGltKjJLGxDGT9wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jo0Cp7oN03xnwXKU/LtFUjwVHx2/tnwVkwgMkCJ3zE+x14GwXPbi251LF13iTUGHW1ECMB6CHo+R2K8Pf/EERSBFqNxr6+Ij8nvtgtT9ug+19U8r3fGIj2kMCd2UulH18AWJd7y57assanqdhkLYG/ZsQSNtGPcgjh5oBdERmKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxJsG+5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxJsG+5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EF9C4CED1;
	Wed, 19 Feb 2025 08:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955092;
	bh=SoSQDWTJiboABlD8nykJrMmT2bmuGltKjJLGxDGT9wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxJsG+5WelYAVe8eqC6x12UH+R2/bLliiY8Gm31LTnLAakO8eNIB4ki3jpG7iltge
	 A5jZ7mS0hRadep+Kc8dUG78JimB3RfMMLnnpGOY5uvQ680CV4Qe7x2SGzAji19lG5z
	 AdH8LG+8O3ZKCDiyTejQe5ylMfFqQi2GMXGI/a2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?B=C5=82a=C5=BCej=20Szczygie=C5=82?= <mumei6102@gmail.com>,
	Sergey Kovalenko <seryoga.engineering@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 097/230] drm/amdgpu/gfx9: manually control gfxoff for CS on RV
Date: Wed, 19 Feb 2025 09:26:54 +0100
Message-ID: <20250219082605.490351110@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   36 ++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -7415,6 +7415,38 @@ static void gfx_v9_0_ring_emit_cleaner_s
 	amdgpu_ring_write(ring, 0);  /* RESERVED field, programmed to zero */
 }
 
+static void gfx_v9_0_ring_begin_use_compute(struct amdgpu_ring *ring)
+{
+	struct amdgpu_device *adev = ring->adev;
+	struct amdgpu_ip_block *gfx_block =
+		amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_GFX);
+
+	amdgpu_gfx_enforce_isolation_ring_begin_use(ring);
+
+	/* Raven and PCO APUs seem to have stability issues
+	 * with compute and gfxoff and gfx pg.  Disable gfx pg during
+	 * submission and allow again afterwards.
+	 */
+	if (gfx_block && amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 1, 0))
+		gfx_v9_0_set_powergating_state(gfx_block, AMD_PG_STATE_UNGATE);
+}
+
+static void gfx_v9_0_ring_end_use_compute(struct amdgpu_ring *ring)
+{
+	struct amdgpu_device *adev = ring->adev;
+	struct amdgpu_ip_block *gfx_block =
+		amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_GFX);
+
+	/* Raven and PCO APUs seem to have stability issues
+	 * with compute and gfxoff and gfx pg.  Disable gfx pg during
+	 * submission and allow again afterwards.
+	 */
+	if (gfx_block && amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 1, 0))
+		gfx_v9_0_set_powergating_state(gfx_block, AMD_PG_STATE_GATE);
+
+	amdgpu_gfx_enforce_isolation_ring_end_use(ring);
+}
+
 static const struct amd_ip_funcs gfx_v9_0_ip_funcs = {
 	.name = "gfx_v9_0",
 	.early_init = gfx_v9_0_early_init,
@@ -7591,8 +7623,8 @@ static const struct amdgpu_ring_funcs gf
 	.emit_wave_limit = gfx_v9_0_emit_wave_limit,
 	.reset = gfx_v9_0_reset_kcq,
 	.emit_cleaner_shader = gfx_v9_0_ring_emit_cleaner_shader,
-	.begin_use = amdgpu_gfx_enforce_isolation_ring_begin_use,
-	.end_use = amdgpu_gfx_enforce_isolation_ring_end_use,
+	.begin_use = gfx_v9_0_ring_begin_use_compute,
+	.end_use = gfx_v9_0_ring_end_use_compute,
 };
 
 static const struct amdgpu_ring_funcs gfx_v9_0_ring_funcs_kiq = {


