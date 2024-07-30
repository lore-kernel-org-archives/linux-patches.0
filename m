Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342B11A76BF;
	Tue, 30 Jul 2024 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360537; cv=none; b=Xsdp8m9uEhet0J/FC9Or8EYmYDwEz4Zb/X1yQRDHbF5/wJuq2cktOCwleaI8Chpylqfj8F2EK/s0Z0SzexAtP3XrrRoSqojk2lEDH6HUC0gQ6PFQBJ9GMuTCun14kdfv8qpIewe5P7gD8fGPUb99R07LMty+vrYM/wWzPKx+21c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360537; c=relaxed/simple;
	bh=7/qWEjG4Arfkp1HIit0ZzmrywJbT5okgWwK/BnFzl1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RloGPckOydAwXTDYkVLCQ5nii9H/kyiz+gETNIi/rfSolyO+613qzyM+bUgInhe3r200st7TskUB+h740R4ZTDMRns6Dp4RT6wQT27q2vi+AEO1z5luqYKiHp0s2mtfMfpjuzRNGwurYZ0z8Ghf0kikNje/RIT0uAW2u0uELaSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBaZEm6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBaZEm6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11CBC32782;
	Tue, 30 Jul 2024 17:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360537;
	bh=7/qWEjG4Arfkp1HIit0ZzmrywJbT5okgWwK/BnFzl1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBaZEm6sJ8kcxwNm0h0vRjqbtsxYLk50pR0Gtp3Ip3zDJClMbo54zI7Btau0LVxmF
	 0Cr9wOQI+cvhACeC9/lMyGHT/du64LL5qXAnRxqYlrUXrhaVMvZWV+KSXPz5HvZH1e
	 reqOBd4rNIM/75JEa8O/9YJGg7glyUjKjAiEqIvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 699/809] drm/amdgpu/sdma5.2: Update wptr registers as well as doorbell
Date: Tue, 30 Jul 2024 17:49:35 +0200
Message-ID: <20240730151752.531990093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -176,6 +176,14 @@ static void sdma_v5_2_ring_set_wptr(stru
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
@@ -1647,6 +1655,10 @@ static void sdma_v5_2_ring_begin_use(str
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


