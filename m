Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A15A171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B35C433D2;
	Mon, 22 May 2023 19:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784134;
	bh=MajvwgqHTq6Y4B0Iz5buZZwYZUI8FH1JP57RXewqY50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0CXL/O4tNbV1z8Hcfd4ZNk0L5ySRonLi2tQr3yOgoO3tdHakRVimnxZ3OP+iI5DR
	 q1JgidrrkAlN7/r6OlBVPZIHMGiz9WzS/UjjXSITmjiw0Dawudi4rlgZvc1imrDjhH
	 pTs4a+EeaqIBwpGjOa0wvNgMyrnWCbHPdCAnhTRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 275/292] drm/amdgpu/gfx11: update gpu_clock_counter logic
Date: Mon, 22 May 2023 20:10:32 +0100
Message-Id: <20230522190412.814879514@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit d5aa417808cf14c052ca042920b3c6b9f1dc6aa4 upstream.

This code was written prior to previous updates to this
logic for other chips.  The RSC registers are part of
SMUIO which is an always on block so there is no need
to disable gfxoff.  Additionally add the carryover and
preemption checks.

v2: rebase

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.y: 5591a051b86b: drm/amdgpu: refine get gpu clock counter method
Cc: stable@vger.kernel.org # 6.2.y: 5591a051b86b: drm/amdgpu: refine get gpu clock counter method
Cc: stable@vger.kernel.org # 6.3.y: 5591a051b86b: drm/amdgpu: refine get gpu clock counter method
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4643,24 +4643,27 @@ static uint64_t gfx_v11_0_get_gpu_clock_
 	uint64_t clock;
 	uint64_t clock_counter_lo, clock_counter_hi_pre, clock_counter_hi_after;
 
-	amdgpu_gfx_off_ctrl(adev, false);
-	mutex_lock(&adev->gfx.gpu_clock_mutex);
 	if (amdgpu_sriov_vf(adev)) {
+		amdgpu_gfx_off_ctrl(adev, false);
+		mutex_lock(&adev->gfx.gpu_clock_mutex);
 		clock_counter_hi_pre = (uint64_t)RREG32_SOC15(GC, 0, regCP_MES_MTIME_HI);
 		clock_counter_lo = (uint64_t)RREG32_SOC15(GC, 0, regCP_MES_MTIME_LO);
 		clock_counter_hi_after = (uint64_t)RREG32_SOC15(GC, 0, regCP_MES_MTIME_HI);
 		if (clock_counter_hi_pre != clock_counter_hi_after)
 			clock_counter_lo = (uint64_t)RREG32_SOC15(GC, 0, regCP_MES_MTIME_LO);
+		mutex_unlock(&adev->gfx.gpu_clock_mutex);
+		amdgpu_gfx_off_ctrl(adev, true);
 	} else {
+		preempt_disable();
 		clock_counter_hi_pre = (uint64_t)RREG32_SOC15(SMUIO, 0, regGOLDEN_TSC_COUNT_UPPER);
 		clock_counter_lo = (uint64_t)RREG32_SOC15(SMUIO, 0, regGOLDEN_TSC_COUNT_LOWER);
 		clock_counter_hi_after = (uint64_t)RREG32_SOC15(SMUIO, 0, regGOLDEN_TSC_COUNT_UPPER);
 		if (clock_counter_hi_pre != clock_counter_hi_after)
 			clock_counter_lo = (uint64_t)RREG32_SOC15(SMUIO, 0, regGOLDEN_TSC_COUNT_LOWER);
+		preempt_enable();
 	}
 	clock = clock_counter_lo | (clock_counter_hi_after << 32ULL);
-	mutex_unlock(&adev->gfx.gpu_clock_mutex);
-	amdgpu_gfx_off_ctrl(adev, true);
+
 	return clock;
 }
 


