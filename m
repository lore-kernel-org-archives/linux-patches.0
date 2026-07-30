Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDCB43C04D;
	Thu, 30 Jul 2026 15:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424377; cv=none; b=uLVH6ddgOGndLekaGjn/kJV3/snqKGts6d3DcAAxVLmoLJ0pl6rjeqiLOVRm+oSx3Kp1uFcMYOBnZ8q30GZyhsszBtBxVtLIrqJ3mNprJD0a8IpGUypAZ33ysMwQD/b8Pe3MxZXlFAQacbgsvR7BKkaMzPzv4DQcoQUO4aL44JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424377; c=relaxed/simple;
	bh=tDPyBgO2oyNkTfSYBtGFrLxaW5HyPUmf1t8Hnx4nYmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrcvOxctm76+5jKVBEiNlFWHsdw6nKDWxEKhyZbNOr2iDnVEOhWy2xRGj3cVPORQfGXnJwiTOkcE6c+QFXH3LrxncuesxDzDI4Osoov0vvxrZNDun2oKvIq426AgPjqRUx4W39HvhAIS+yQLPmOn4jOecXsiKOLXSMlwDsCgiz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuESssSA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuESssSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B611F000E9;
	Thu, 30 Jul 2026 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424376;
	bh=7Q0VTZEIu0RdiirOVhIcr1/g4bXGMJ9kNcCPCnGopro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuESssSAnr8RVeWk8mVg4Xi2y9+VTlWXkH4svGGx5dhJWKZqm/e1a2vQRml8HZ6Dz
	 ngDOTY4XbYzg1qCZuckJCCVh+iASIvlJt93sWZmeYCch3/ux0gLIMOsNUNMf/koEbN
	 H5jbVAN2wDW8A2ie0x/jEUysUrl5noqSkMnZR42s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 373/675] drm/gfx10: Program DB_RING_CONTROL
Date: Thu, 30 Jul 2026 16:11:43 +0200
Message-ID: <20260730141453.062920706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit f0262c3a3f14d60140f6b826d40d44edf62c36d6 upstream.

This is needed to allocate occlusion counters across
both gfx pipes.

Fixes: b7a1a0ef12b8 ("drm/amd/amdgpu: add pipe1 hardware support")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6807352cbabb74b61ba42888769283af72191f66)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -5349,6 +5349,15 @@ static void gfx_v10_0_constants_init(str
 	gfx_v10_0_get_tcc_info(adev);
 	adev->gfx.config.pa_sc_tile_steering_override =
 		gfx_v10_0_init_pa_sc_tile_steering_override(adev);
+	/* Program DB_RING_CONTROL for multiple GFX pipes
+	 * Default power up value is 1.
+	 * Possible values:
+	 * 0 - split occlusion counters between gfx pipes
+	 * 1 - all occlusion counters to pipe 0
+	 * 2 - all occlusion counters to pipe 1
+	 */
+	WREG32_FIELD15(GC, 0, DB_RING_CONTROL, COUNTER_CONTROL,
+		       (adev->gfx.me.num_pipe_per_me > 1) ? 0 : 1);
 
 	/* XXX SH_MEM regs */
 	/* where to put LDS, scratch, GPUVM in FSA64 space */


