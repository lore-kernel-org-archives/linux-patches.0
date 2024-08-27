Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051291BC9E3;
	Tue, 27 Aug 2024 15:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771571; cv=none; b=imRtF5sJeQXXr4K+h89dj5OHKajIMh++O6R2nRh62nSU1NIrV60ZLpmPQX86PHW0eTMwamPdYWIGcQSyjYGNqPeM82pK4eD9kR6HEBhhrYb5qc/ZShelYLzlhskWJ8txSK1UdxyZlLWk1zineWGbPKZrhg+h7sbMhj2RfeboEpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771571; c=relaxed/simple;
	bh=xDS/JsDo8NzZRw7Fv/ZadosCPYa3c+H/aU2kIv/eULo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkHILx/9qzwCwV471raApaHb01hlpmp4HCtPPq3MNM+PFe/ab5muVYa3Qfn4XqJ35KqLnssQJNU+OSXH7AKTCVXb6fx0yJLGQAlubc8GQaxstjukxckgFXIm5gBBj0c0p0phZ3wsRCfVGynXjlLvnIvgoho45doA3ROYX4PTfrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcxsN30M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcxsN30M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ADDC61043;
	Tue, 27 Aug 2024 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771570;
	bh=xDS/JsDo8NzZRw7Fv/ZadosCPYa3c+H/aU2kIv/eULo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcxsN30MHMkTMZaN4HJylGd2970H4MbS/1LCj33LpV44h1zSCPoJpaZWG29+g5e1x
	 yiN7+xGskrOoqHkXpE2FWn6pa2aNfGTu01pnMRap5rnaHnCCUwpmwjPJxjMbl9BxJE
	 wbyN3fFcpbO61os4izpevI8UvR+pfRRR97EPJKWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 227/273] drm/amdgpu/sdma5.2: limit wptr workaround to sdma 5.2.1
Date: Tue, 27 Aug 2024 16:39:11 +0200
Message-ID: <20240827143842.045645458@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

commit e3e4bf58bad1576ac732a1429f53e3d4bfb82b4b upstream.

The workaround seems to cause stability issues on other
SDMA 5.2.x IPs.

Fixes: a03ebf116303 ("drm/amdgpu/sdma5.2: Update wptr registers as well as doorbell")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3556
Acked-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2dc3851ef7d9c5439ea8e9623fc36878f3b40649)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -176,14 +176,16 @@ static void sdma_v5_2_ring_set_wptr(stru
 		DRM_DEBUG("calling WDOORBELL64(0x%08x, 0x%016llx)\n",
 				ring->doorbell_index, ring->wptr << 2);
 		WDOORBELL64(ring->doorbell_index, ring->wptr << 2);
-		/* SDMA seems to miss doorbells sometimes when powergating kicks in.
-		 * Updating the wptr directly will wake it. This is only safe because
-		 * we disallow gfxoff in begin_use() and then allow it again in end_use().
-		 */
-		WREG32(sdma_v5_2_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR),
-		       lower_32_bits(ring->wptr << 2));
-		WREG32(sdma_v5_2_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR_HI),
-		       upper_32_bits(ring->wptr << 2));
+		if (amdgpu_ip_version(adev, SDMA0_HWIP, 0) == IP_VERSION(5, 2, 1)) {
+			/* SDMA seems to miss doorbells sometimes when powergating kicks in.
+			 * Updating the wptr directly will wake it. This is only safe because
+			 * we disallow gfxoff in begin_use() and then allow it again in end_use().
+			 */
+			WREG32(sdma_v5_2_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR),
+			       lower_32_bits(ring->wptr << 2));
+			WREG32(sdma_v5_2_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR_HI),
+			       upper_32_bits(ring->wptr << 2));
+		}
 	} else {
 		DRM_DEBUG("Not using doorbell -- "
 				"mmSDMA%i_GFX_RB_WPTR == 0x%08x "


