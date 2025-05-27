Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFAE2110E;
	Tue, 27 May 2025 17:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367222; cv=none; b=qowjNSonQ7bFZNds4poB5cKbwyG98/nk8esVrATe1ueb5HAL8TtCsgxMtPh8bpi9abEwcVylXf0VStuKWdqj28LeCpTiiXaJaV+NNdAI32rYsq3zZPe27ONXn9PFzUlixNuAdjOeyuDNKm3EF5nqR0M3BuB4a6pS+u3Ib7W8LWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367222; c=relaxed/simple;
	bh=C4IXLh7MonqntMt+0IkNkf7dr8ooj5/iFlv7LnrGghg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDYbURnz0MBE93tJaE78zMXOsrnjQoXWGJ/hDyNYR7A3lnAaiFslkwldl5UMH7aOW1ucMxUBV2a9O5EbL/5XVXFVQLG/qmZECYdeLmvY9wxeknFHtKm62eu19ocE83DeOVOcSWU4SzG92tGcoZbCYwgSAkTchSTJBd8fPniVGOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g37BGUNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g37BGUNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2952C4CEE9;
	Tue, 27 May 2025 17:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367222;
	bh=C4IXLh7MonqntMt+0IkNkf7dr8ooj5/iFlv7LnrGghg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g37BGUNdA8H7Ezm3R/TQcGqUR/2XLqA/9ZXKZQb7myA9UEmdUHiHq74pnpNvYKULC
	 ebURc9DQ+Upf5/cTnMWhp97ptP5r1D0Npg4ZhAwNsV67xIYlRKLApiXT9I1v7QezfW
	 SO8tdWAUhjMupEW7nAQ5Vx1y5RC0nNQFDYh6MUrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 287/783] drm/amdgpu: Add offset normalization in VCN v5.0.1
Date: Tue, 27 May 2025 18:21:24 +0200
Message-ID: <20250527162524.772984588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 0b9647d40ef82837d5025de6daad64db775ea1c5 ]

VCN v5.0.1 also will need register offset normalization. Reuse the logic
from VCN v4.0.3. Also, avoid HDP flush similar to VCN v4.0.3

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c | 14 ++++++++------
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.h |  9 +++++++++
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c | 20 +++++++++++---------
 3 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index a2d1a4b2f03a5..855da1149c5c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -31,6 +31,7 @@
 #include "soc15d.h"
 #include "soc15_hw_ip.h"
 #include "vcn_v2_0.h"
+#include "vcn_v4_0_3.h"
 #include "mmsch_v4_0_3.h"
 
 #include "vcn/vcn_4_0_3_offset.h"
@@ -1462,8 +1463,8 @@ static uint64_t vcn_v4_0_3_unified_ring_get_wptr(struct amdgpu_ring *ring)
 				    regUVD_RB_WPTR);
 }
 
-static void vcn_v4_0_3_enc_ring_emit_reg_wait(struct amdgpu_ring *ring, uint32_t reg,
-				uint32_t val, uint32_t mask)
+void vcn_v4_0_3_enc_ring_emit_reg_wait(struct amdgpu_ring *ring, uint32_t reg,
+				       uint32_t val, uint32_t mask)
 {
 	/* Use normalized offsets when required */
 	if (vcn_v4_0_3_normalizn_reqd(ring->adev))
@@ -1475,7 +1476,8 @@ static void vcn_v4_0_3_enc_ring_emit_reg_wait(struct amdgpu_ring *ring, uint32_t
 	amdgpu_ring_write(ring, val);
 }
 
-static void vcn_v4_0_3_enc_ring_emit_wreg(struct amdgpu_ring *ring, uint32_t reg, uint32_t val)
+void vcn_v4_0_3_enc_ring_emit_wreg(struct amdgpu_ring *ring, uint32_t reg,
+				   uint32_t val)
 {
 	/* Use normalized offsets when required */
 	if (vcn_v4_0_3_normalizn_reqd(ring->adev))
@@ -1486,8 +1488,8 @@ static void vcn_v4_0_3_enc_ring_emit_wreg(struct amdgpu_ring *ring, uint32_t reg
 	amdgpu_ring_write(ring, val);
 }
 
-static void vcn_v4_0_3_enc_ring_emit_vm_flush(struct amdgpu_ring *ring,
-				unsigned int vmid, uint64_t pd_addr)
+void vcn_v4_0_3_enc_ring_emit_vm_flush(struct amdgpu_ring *ring,
+				       unsigned int vmid, uint64_t pd_addr)
 {
 	struct amdgpu_vmhub *hub = &ring->adev->vmhub[ring->vm_hub];
 
@@ -1499,7 +1501,7 @@ static void vcn_v4_0_3_enc_ring_emit_vm_flush(struct amdgpu_ring *ring,
 					lower_32_bits(pd_addr), 0xffffffff);
 }
 
-static void vcn_v4_0_3_ring_emit_hdp_flush(struct amdgpu_ring *ring)
+void vcn_v4_0_3_ring_emit_hdp_flush(struct amdgpu_ring *ring)
 {
 	/* VCN engine access for HDP flush doesn't work when RRMT is enabled.
 	 * This is a workaround to avoid any HDP flush through VCN ring.
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.h b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.h
index 0b046114373ae..03572a1d0c9cb 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.h
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.h
@@ -26,4 +26,13 @@
 
 extern const struct amdgpu_ip_block_version vcn_v4_0_3_ip_block;
 
+void vcn_v4_0_3_enc_ring_emit_reg_wait(struct amdgpu_ring *ring, uint32_t reg,
+				       uint32_t val, uint32_t mask);
+
+void vcn_v4_0_3_enc_ring_emit_wreg(struct amdgpu_ring *ring, uint32_t reg,
+				   uint32_t val);
+void vcn_v4_0_3_enc_ring_emit_vm_flush(struct amdgpu_ring *ring,
+				       unsigned int vmid, uint64_t pd_addr);
+void vcn_v4_0_3_ring_emit_hdp_flush(struct amdgpu_ring *ring);
+
 #endif /* __VCN_V4_0_3_H__ */
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
index cdbc10d7c9fb7..f893a84282832 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -29,6 +29,7 @@
 #include "soc15d.h"
 #include "soc15_hw_ip.h"
 #include "vcn_v2_0.h"
+#include "vcn_v4_0_3.h"
 
 #include "vcn/vcn_5_0_0_offset.h"
 #include "vcn/vcn_5_0_0_sh_mask.h"
@@ -905,16 +906,17 @@ static const struct amdgpu_ring_funcs vcn_v5_0_1_unified_ring_vm_funcs = {
 	.get_rptr = vcn_v5_0_1_unified_ring_get_rptr,
 	.get_wptr = vcn_v5_0_1_unified_ring_get_wptr,
 	.set_wptr = vcn_v5_0_1_unified_ring_set_wptr,
-	.emit_frame_size =
-		SOC15_FLUSH_GPU_TLB_NUM_WREG * 3 +
-		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 4 +
-		4 + /* vcn_v2_0_enc_ring_emit_vm_flush */
-		5 + 5 + /* vcn_v2_0_enc_ring_emit_fence x2 vm fence */
-		1, /* vcn_v2_0_enc_ring_insert_end */
+	.emit_frame_size = SOC15_FLUSH_GPU_TLB_NUM_WREG * 3 +
+			   SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 4 +
+			   4 + /* vcn_v2_0_enc_ring_emit_vm_flush */
+			   5 +
+			   5 + /* vcn_v2_0_enc_ring_emit_fence x2 vm fence */
+			   1, /* vcn_v2_0_enc_ring_insert_end */
 	.emit_ib_size = 5, /* vcn_v2_0_enc_ring_emit_ib */
 	.emit_ib = vcn_v2_0_enc_ring_emit_ib,
 	.emit_fence = vcn_v2_0_enc_ring_emit_fence,
-	.emit_vm_flush = vcn_v2_0_enc_ring_emit_vm_flush,
+	.emit_vm_flush = vcn_v4_0_3_enc_ring_emit_vm_flush,
+	.emit_hdp_flush = vcn_v4_0_3_ring_emit_hdp_flush,
 	.test_ring = amdgpu_vcn_enc_ring_test_ring,
 	.test_ib = amdgpu_vcn_unified_ring_test_ib,
 	.insert_nop = amdgpu_ring_insert_nop,
@@ -922,8 +924,8 @@ static const struct amdgpu_ring_funcs vcn_v5_0_1_unified_ring_vm_funcs = {
 	.pad_ib = amdgpu_ring_generic_pad_ib,
 	.begin_use = amdgpu_vcn_ring_begin_use,
 	.end_use = amdgpu_vcn_ring_end_use,
-	.emit_wreg = vcn_v2_0_enc_ring_emit_wreg,
-	.emit_reg_wait = vcn_v2_0_enc_ring_emit_reg_wait,
+	.emit_wreg = vcn_v4_0_3_enc_ring_emit_wreg,
+	.emit_reg_wait = vcn_v4_0_3_enc_ring_emit_reg_wait,
 	.emit_reg_write_reg_wait = amdgpu_ring_emit_reg_write_reg_wait_helper,
 };
 
-- 
2.39.5



