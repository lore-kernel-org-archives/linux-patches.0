Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C60A43BDCB;
	Thu, 30 Jul 2026 14:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422276; cv=none; b=lvcEriCG5SMNGFbHAxIABIvczuAnv3dQk7ikSFb6KTM3WJvXQ19n6NM2TPKWDfUbaXf+BMKfowm7JPj5mwt6IYTsG/elbkxPHKYDX1i7a4fvzhAw/Bfgl9IJkeX1HGb28YzNMu7BDUUQr6gLRhZycBeMFTiCBF/bNDmHnQOw0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422276; c=relaxed/simple;
	bh=YRT1xhrmfYNxLr0U7+Y/CN+7UcuR8ZZY0QbGjcv+AH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfiTml4oxQpkTqKX7jWGYAYDOaEDHtbrndp0TfTCReX7Lwj7ZREevMYTDcsVzt3bMDycmv1cPBvVTAcDqfet7nLwlaTUFSw//T1FCxIZV/lB5xuV8TqfjHTAPa4bs4VBZncTS9vYC7XxLCRB1Bsr2cuG0PN3yCbFtnBZkpT5Dew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpO515q/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpO515q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85001F000E9;
	Thu, 30 Jul 2026 14:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422275;
	bh=lgThdOJKXLV6x3uHfU/kG7QiOehKCNZha/opz2z68Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpO515q/kfV0pg/4xVifvrOMDLS+uJRQjWB8AwbQvKz56pkWHEQW0VWoqDZY2C1Lh
	 ptocuBKiOTdepETZpk7a8cRf/HkuFhOa81zeh7O6mV3litirFjL1CwSEHHEPUJ44e/
	 C3TDAuYFiDtQHUaAQ7sAjllNRkQsz89tWLaGonLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiqian Chen <Jiqian.Chen@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 383/744] drm/amdgpu/gfx9: Fix Ring and IB test fail after mode2
Date: Thu, 30 Jul 2026 16:10:56 +0200
Message-ID: <20260730141452.425390336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiqian Chen <Jiqian.Chen@amd.com>

commit 85ed06d990ff73212b5a91a406671cabd962e521 upstream.

For Renior APU with gfx9, in some test scenarios with disabling
ring_reset, like accessing an unmapped invalid address, it can
trigger a gpu job timeout event, then driver uses Mode2 reset
to reset GPU, but after Mode2 compute Ring test and IB test fail
randomly. It because the HQDs of MECs are always active before or
after Mode2, that causes MECs use stale HQDs when MECs are unhalted
before driver restore MQDs, and causes CPC and CPF are still stuck
after Mode2, then causes compute Ring and IB tests fail.

So, add sequences to deactivate HQDs of MECs in suspend IP function
of the resetting process.

v2: Move all sequences into a new function gfx_v9_0_cp_mode2_clear_state (Ray Huang)
    To check reset Mode2 method in the if condition (Ray Huang)
v3: Move all sequences before Mode2 instead of after Mode2 (Timur Kristóf)
v4: Call amdgpu_gfx_rlc_enter/exit_safe_mode int the begin and end of
    gfx_v9_0_deactivate_kcq_hqd (Alex Deucher)

Signed-off-by: Jiqian Chen <Jiqian.Chen@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c3988a7ad4799514447294f04f063b422e0551df)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -4049,6 +4049,41 @@ static int gfx_v9_0_hw_init(struct amdgp
 	return r;
 }
 
+static void gfx_v9_0_deactivate_kcq_hqd(struct amdgpu_device *adev)
+{
+	amdgpu_gfx_rlc_enter_safe_mode(adev, 0);
+	for (int i = 0; i < adev->gfx.num_compute_rings; i++) {
+		u32 tmp;
+		struct amdgpu_ring *ring = &adev->gfx.compute_ring[i];
+
+		mutex_lock(&adev->srbm_mutex);
+		soc15_grbm_select(adev, ring->me, ring->pipe, ring->queue, 0, 0);
+		tmp = RREG32_SOC15(GC, 0, mmCP_HQD_ACTIVE);
+		/* disable the queue if it's active */
+		if (tmp & CP_HQD_ACTIVE__ACTIVE_MASK) {
+			int j;
+
+			WREG32_SOC15(GC, 0, mmCP_HQD_DEQUEUE_REQUEST, 1);
+			for (j = 0; j < adev->usec_timeout; j++) {
+				tmp = RREG32_SOC15(GC, 0, mmCP_HQD_ACTIVE);
+				if (!(tmp & CP_HQD_ACTIVE__ACTIVE_MASK))
+					break;
+				udelay(1);
+			}
+			if (j == AMDGPU_MAX_USEC_TIMEOUT) {
+				DRM_DEBUG("comp_%u_%u_%u dequeue request failed.\n",
+							ring->me, ring->pipe, ring->queue);
+				/* Manual disable if dequeue request times out */
+				WREG32_SOC15(GC, 0, mmCP_HQD_ACTIVE, 0);
+			}
+			WREG32_SOC15(GC, 0, mmCP_HQD_DEQUEUE_REQUEST, 0);
+		}
+		soc15_grbm_select(adev, 0, 0, 0, 0, 0);
+		mutex_unlock(&adev->srbm_mutex);
+	}
+	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
+}
+
 static int gfx_v9_0_hw_fini(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
@@ -4075,6 +4110,10 @@ static int gfx_v9_0_hw_fini(struct amdgp
 		return 0;
 	}
 
+	if ((adev->flags & AMD_IS_APU) && amdgpu_in_reset(adev) &&
+		amdgpu_asic_reset_method(adev) == AMD_RESET_METHOD_MODE2)
+		gfx_v9_0_deactivate_kcq_hqd(adev);
+
 	/* Use deinitialize sequence from CAIL when unbinding device from driver,
 	 * otherwise KIQ is hanging when binding back
 	 */


