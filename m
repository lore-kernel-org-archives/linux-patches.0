Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58D6258EE9;
	Thu, 20 Aug 2026 15:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238116; cv=none; b=fjw/0ZKPnxHX5dVMhaiKj5vQ2IzksAB9qANsJGoOUlMhLMVaiDhYqmbRiHbTmBVi0nKtOSkxI58tkodny0fsY3XWFMFk7yLsThNGdzWbvW0aTTYiXOwGjQZDA6O5fiayF5tzO2RR8xY9ddk9JOGtozPhSpkr3mNzsunh1RKm97w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238116; c=relaxed/simple;
	bh=skETKm9mzjgZUXBnrqiiOAHKbmtMM14zmGADuy8d1qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXMobuh9VPPs+lo7q1tNbLEn9fkFgPOvhUyleU2MyWOR0ATP2upqhgAQoMcpjjAMxKMWaYAv4cataA+AXErxWDpW4Js279JvR/RLxl8VCDZJdvYensCtIccAy0Pq7cs8h+zEhqDnENt2yHIbTLMGsJTrjCSB8WeAFPL9x0kE0vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9iFPdab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9iFPdab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA901F000E9;
	Thu, 20 Aug 2026 15:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238115;
	bh=J4whMfUChGyNswWzEsI/iyXnUcNpXMDWN7SzOUKGRak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9iFPdabmSoC7/1ClCssWUdJBWYDllYk0w3jcUdUYuwtrHxK72egLXzsOUUpYnSOV
	 JZKg9RJMDDkgjalVi1LQkrIT/te8PB0bvtUPsQTJcjKiJt5jNJGSjlpmeQFnOiINpo
	 Y6PFeB0oaj/Jt1XN9QngNQsL1oHgCzGY6HODDJno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonny Jiang <sonny.jiang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 037/228] drm/amdgpu/gmc12.1: implement tlb inv semaphore
Date: Thu, 20 Aug 2026 16:52:59 +0200
Message-ID: <20260820145245.597743773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cda6ab11c1a25a572857b9ea2ded4b7cb13c2895 upstream.

Needed to properly lock the interface before using it.

Cc: Sonny Jiang <sonny.jiang@amd.com>
Reviewed-by: Sonny Jiang <sonny.jiang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8e37aa0bd56ba75801a6a21bed45f96372cd9fdc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v12_1.c |   46 +++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_1.c
@@ -254,9 +254,24 @@ static bool gmc_v12_1_get_vmid_pasid_map
  * by the amdgpu vm/hsa code.
  */
 
+/**
+ * gmc_v12_1_use_invalidate_semaphore - judge whether to use semaphore
+ *
+ * @adev: amdgpu_device pointer
+ * @vmhub: vmhub type
+ *
+ */
+static bool gmc_v12_1_use_invalidate_semaphore(struct amdgpu_device *adev,
+				       uint32_t vmhub)
+{
+	return ((!AMDGPU_IS_GFXHUB(vmhub)) &&
+		(!amdgpu_sriov_vf(adev)));
+}
+
 static void gmc_v12_1_flush_vm_hub(struct amdgpu_device *adev, uint32_t vmid,
 				   unsigned int vmhub, uint32_t flush_type)
 {
+	bool use_semaphore = gmc_v12_1_use_invalidate_semaphore(adev, vmhub);
 	struct amdgpu_vmhub *hub = &adev->vmhub[vmhub];
 	u32 inv_req = hub->vmhub_funcs->get_invalidate_req(vmid, flush_type);
 	u32 tmp;
@@ -270,6 +285,19 @@ static void gmc_v12_1_flush_vm_hub(struc
 
 	spin_lock(&adev->gmc.invalidate_lock);
 
+	if (use_semaphore) {
+		for (i = 0; i < adev->usec_timeout; i++) {
+			/* a read return value of 1 means semaphore acuqire */
+			tmp = RREG32_RLC_NO_KIQ(hub->vm_inv_eng0_sem + hub->eng_distance * eng, hub_ip);
+			if (tmp & 0x1)
+				break;
+			udelay(1);
+		}
+
+		if (i >= adev->usec_timeout)
+			DRM_ERROR("Timeout waiting for sem acquire in VM flush!\n");
+	}
+
 	WREG32_RLC_NO_KIQ(hub->vm_inv_eng0_req + hub->eng_distance * eng, inv_req, hub_ip);
 
 	/* Wait for ACK with a delay.*/
@@ -283,6 +311,9 @@ static void gmc_v12_1_flush_vm_hub(struc
 		udelay(1);
 	}
 
+	if (use_semaphore)
+		WREG32_RLC_NO_KIQ(hub->vm_inv_eng0_sem + hub->eng_distance * eng, 0, hub_ip);
+
 	/* Issue additional private vm invalidation to MMHUB */
 	if (!AMDGPU_IS_GFXHUB(vmhub) &&
 	    (hub->vm_l2_bank_select_reserved_cid2) &&
@@ -418,10 +449,17 @@ static void gmc_v12_1_flush_gpu_tlb_pasi
 static uint64_t gmc_v12_1_emit_flush_gpu_tlb(struct amdgpu_ring *ring,
 					     unsigned vmid, uint64_t pd_addr)
 {
+	bool use_semaphore = gmc_v12_1_use_invalidate_semaphore(ring->adev, ring->vm_hub);
 	struct amdgpu_vmhub *hub = &ring->adev->vmhub[ring->vm_hub];
 	uint32_t req = hub->vmhub_funcs->get_invalidate_req(vmid, 0);
 	unsigned eng = ring->vm_inv_eng;
 
+	if (use_semaphore)
+		/* a read return value of 1 means semaphore acuqire */
+		amdgpu_ring_emit_reg_wait(ring,
+					  hub->vm_inv_eng0_sem +
+					  hub->eng_distance * eng, 0x1, 0x1);
+
 	amdgpu_ring_emit_wreg(ring, hub->ctx0_ptb_addr_lo32 +
 			      (hub->ctx_addr_distance * vmid),
 			      lower_32_bits(pd_addr));
@@ -436,6 +474,14 @@ static uint64_t gmc_v12_1_emit_flush_gpu
 					    hub->eng_distance * eng,
 					    req, 1 << vmid);
 
+	if (use_semaphore)
+		/*
+		 * add semaphore release after invalidation,
+		 * write with 0 means semaphore release
+		 */
+		amdgpu_ring_emit_wreg(ring, hub->vm_inv_eng0_sem +
+				      hub->eng_distance * eng, 0);
+
 	return pd_addr;
 }
 


