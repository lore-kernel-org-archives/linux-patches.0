Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5283618454A;
	Tue, 30 Jul 2024 17:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359385; cv=none; b=OQoUIl5rlFpVgUkegXyrUTsPoHWZuedrWx2SwHmFZFVKvcFWsZH+amQz8Orb9fA9GW2CUOI7qA6G9S7uZMofOc2ezmjJZVeJHoSis8B/F7Jmd4oOWIwME6Gk1sy9BHJPp11YCqkDcgYBUvJ6CvAwBTwdxJ3XdCm12og7j88OJK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359385; c=relaxed/simple;
	bh=FaS5drBGMDCFVrMu31Cbpxuy1sr0xUCLj3jj6XeSHYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fyr33R4eH3uL/FGurlcM1dvl9zCuRTtZTjkIZfUpFi7PFYMg+kdKn7qlgm/3TFjN9MtSbxFLO94ps02YI3yKshqFDyBez+HeR5Q2AVQQXKrlD0z+tvBH8t9mO2R8dmbC3oYakWOrH2hJ48D4E25EzsOFvbSDFzQzS6s9hMkEI7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPXEzZCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPXEzZCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D69C32782;
	Tue, 30 Jul 2024 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359384;
	bh=FaS5drBGMDCFVrMu31Cbpxuy1sr0xUCLj3jj6XeSHYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPXEzZCgaFESnEwI+RSqzfTnPQaeob8k375CngL+WSD5os3ymKjDgKULbT0rKexVs
	 5ZNzDVB9ST22ARpsOREhV14dUb+6R/QcU8O9DX1EHc6znOSUwIUlPUyxY+uattWnA6
	 eDJYn+xDxnSVWLGGNV3EXdT7tCaMKJqP02n3R8ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 475/568] drm/amdgpu/sdma5.2: Update wptr registers as well as doorbell
Date: Tue, 30 Jul 2024 17:49:42 +0200
Message-ID: <20240730151658.592504111@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit a03ebf116303e5d13ba9a2b65726b106cb1e96f6 upstream.

We seem to have a case where SDMA will sometimes miss a doorbell
if GFX is entering the powergating state when the doorbell comes in.
To workaround this, we can update the wptr via MMIO, however,
this is only safe because we disallow gfxoff in begin_ring() for
SDMA 5.2 and then allow it again in end_ring().

Enable this workaround while we are root causing the issue with
the HW team.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/3440
Tested-by: Friedrich Vock <friedrich.vock@gmx.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit f2ac52634963fc38e4935e11077b6f7854e5d700)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -188,6 +188,14 @@ static void sdma_v5_2_ring_set_wptr(stru
 		DRM_DEBUG("calling WDOORBELL64(0x%08x, 0x%016llx)\n",
 				ring->doorbell_index, ring->wptr << 2);
 		WDOORBELL64(ring->doorbell_index, ring->wptr << 2);
+		/* SDMA seems to miss doorbells sometimes when powergating kicks in.
+		 * Updating the wptr directly will wake it. This is only safe because
+		 * we disallow gfxoff in begin_use() and then allow it again in end_use().
+		 */
+		WREG32(sdma_v5_2_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR),
+		       lower_32_bits(ring->wptr << 2));
+		WREG32(sdma_v5_2_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR_HI),
+		       upper_32_bits(ring->wptr << 2));
 	} else {
 		DRM_DEBUG("Not using doorbell -- "
 				"mmSDMA%i_GFX_RB_WPTR == 0x%08x "
@@ -1666,6 +1674,10 @@ static void sdma_v5_2_ring_begin_use(str
 	 * but it shouldn't hurt for other parts since
 	 * this GFXOFF will be disallowed anyway when SDMA is
 	 * active, this just makes it explicit.
+	 * sdma_v5_2_ring_set_wptr() takes advantage of this
+	 * to update the wptr because sometimes SDMA seems to miss
+	 * doorbells when entering PG.  If you remove this, update
+	 * sdma_v5_2_ring_set_wptr() as well!
 	 */
 	amdgpu_gfx_off_ctrl(adev, false);
 }


