Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE941C9B91;
	Wed,  2 Oct 2024 13:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876736; cv=none; b=f2rm1xZ1LvDdSAzHeFQo4Wg5QILckyICIIR1S6gRckzyOisabcLkvbj9jkkCXPkK6IL+PLA6+K6qLMQe5J00t5AJG4h7X97PSKURZRLw5k0rPi9AczQWWgdknF2/OPWTukd+L4CaZQ2kvJrfXZrUBx4Lsi13TpycB/oUL5L7B6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876736; c=relaxed/simple;
	bh=nCbRAHXf4td0gqilfjjjKud2w5NJCHKhu7Q6FdcIFhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B77LM3KNqLRDAdE2KprwG74CvbQet6EnGxuGc+/tJOJkoiZyyqMju7YOSZq5jR+H9MjG+sENIveHnFNtLXZ9XOe7deoXhcgxUNNa05Ih+X7DMy30/my1vfFKydohE6TZacWHrcigOJKbolt9wZvH2/1qnMjMoxUX3VOomPWjVcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baWGhCgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baWGhCgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D0BC4CEC2;
	Wed,  2 Oct 2024 13:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876735;
	bh=nCbRAHXf4td0gqilfjjjKud2w5NJCHKhu7Q6FdcIFhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baWGhCgK7TVkWbOhsBgM3p5t37WVNIc/59vKfljFqSnjncvkGBiMvOR92odphgrBG
	 ItbCQe1Ka532edtSuwLdUEij1jgfz+0N8QKZKTLEb1Ih0R88BBJR2r3Tl1BTN8lGSV
	 YtfVSiOfwRFlXqjyBVHIWL21dQrHGvV9HrEpTKTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 545/695] drm/amdgpu/vcn: enable AV1 on both instances
Date: Wed,  2 Oct 2024 14:59:03 +0200
Message-ID: <20241002125844.257975703@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>

commit 8048e5ade8224969023902b0b3f64470f9c250a7 upstream.

v1 - remove cs parse code (Christian)

On VCN v4_0_6 AV1 is supported on both the instances.
Remove cs IB parse code since explict handling of AV1 schedule is
not required.

Signed-off-by: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c |  165 --------------------------------
 1 file changed, 165 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -1347,170 +1347,6 @@ static void vcn_v4_0_5_unified_ring_set_
 	}
 }
 
-static int vcn_v4_0_5_limit_sched(struct amdgpu_cs_parser *p,
-				struct amdgpu_job *job)
-{
-	struct drm_gpu_scheduler **scheds;
-
-	/* The create msg must be in the first IB submitted */
-	if (atomic_read(&job->base.entity->fence_seq))
-		return -EINVAL;
-
-	/* if VCN0 is harvested, we can't support AV1 */
-	if (p->adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0)
-		return -EINVAL;
-
-	scheds = p->adev->gpu_sched[AMDGPU_HW_IP_VCN_ENC]
-		[AMDGPU_RING_PRIO_0].sched;
-	drm_sched_entity_modify_sched(job->base.entity, scheds, 1);
-	return 0;
-}
-
-static int vcn_v4_0_5_dec_msg(struct amdgpu_cs_parser *p, struct amdgpu_job *job,
-			    uint64_t addr)
-{
-	struct ttm_operation_ctx ctx = { false, false };
-	struct amdgpu_bo_va_mapping *map;
-	uint32_t *msg, num_buffers;
-	struct amdgpu_bo *bo;
-	uint64_t start, end;
-	unsigned int i;
-	void *ptr;
-	int r;
-
-	addr &= AMDGPU_GMC_HOLE_MASK;
-	r = amdgpu_cs_find_mapping(p, addr, &bo, &map);
-	if (r) {
-		DRM_ERROR("Can't find BO for addr 0x%08llx\n", addr);
-		return r;
-	}
-
-	start = map->start * AMDGPU_GPU_PAGE_SIZE;
-	end = (map->last + 1) * AMDGPU_GPU_PAGE_SIZE;
-	if (addr & 0x7) {
-		DRM_ERROR("VCN messages must be 8 byte aligned!\n");
-		return -EINVAL;
-	}
-
-	bo->flags |= AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
-	amdgpu_bo_placement_from_domain(bo, bo->allowed_domains);
-	r = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
-	if (r) {
-		DRM_ERROR("Failed validating the VCN message BO (%d)!\n", r);
-		return r;
-	}
-
-	r = amdgpu_bo_kmap(bo, &ptr);
-	if (r) {
-		DRM_ERROR("Failed mapping the VCN message (%d)!\n", r);
-		return r;
-	}
-
-	msg = ptr + addr - start;
-
-	/* Check length */
-	if (msg[1] > end - addr) {
-		r = -EINVAL;
-		goto out;
-	}
-
-	if (msg[3] != RDECODE_MSG_CREATE)
-		goto out;
-
-	num_buffers = msg[2];
-	for (i = 0, msg = &msg[6]; i < num_buffers; ++i, msg += 4) {
-		uint32_t offset, size, *create;
-
-		if (msg[0] != RDECODE_MESSAGE_CREATE)
-			continue;
-
-		offset = msg[1];
-		size = msg[2];
-
-		if (offset + size > end) {
-			r = -EINVAL;
-			goto out;
-		}
-
-		create = ptr + addr + offset - start;
-
-		/* H264, HEVC and VP9 can run on any instance */
-		if (create[0] == 0x7 || create[0] == 0x10 || create[0] == 0x11)
-			continue;
-
-		r = vcn_v4_0_5_limit_sched(p, job);
-		if (r)
-			goto out;
-	}
-
-out:
-	amdgpu_bo_kunmap(bo);
-	return r;
-}
-
-#define RADEON_VCN_ENGINE_TYPE_ENCODE			(0x00000002)
-#define RADEON_VCN_ENGINE_TYPE_DECODE			(0x00000003)
-
-#define RADEON_VCN_ENGINE_INFO				(0x30000001)
-#define RADEON_VCN_ENGINE_INFO_MAX_OFFSET		16
-
-#define RENCODE_ENCODE_STANDARD_AV1			2
-#define RENCODE_IB_PARAM_SESSION_INIT			0x00000003
-#define RENCODE_IB_PARAM_SESSION_INIT_MAX_OFFSET	64
-
-/* return the offset in ib if id is found, -1 otherwise
- * to speed up the searching we only search upto max_offset
- */
-static int vcn_v4_0_5_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int max_offset)
-{
-	int i;
-
-	for (i = 0; i < ib->length_dw && i < max_offset && ib->ptr[i] >= 8; i += ib->ptr[i]/4) {
-		if (ib->ptr[i + 1] == id)
-			return i;
-	}
-	return -1;
-}
-
-static int vcn_v4_0_5_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
-					   struct amdgpu_job *job,
-					   struct amdgpu_ib *ib)
-{
-	struct amdgpu_ring *ring = amdgpu_job_ring(job);
-	struct amdgpu_vcn_decode_buffer *decode_buffer;
-	uint64_t addr;
-	uint32_t val;
-	int idx;
-
-	/* The first instance can decode anything */
-	if (!ring->me)
-		return 0;
-
-	/* RADEON_VCN_ENGINE_INFO is at the top of ib block */
-	idx = vcn_v4_0_5_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO,
-			RADEON_VCN_ENGINE_INFO_MAX_OFFSET);
-	if (idx < 0) /* engine info is missing */
-		return 0;
-
-	val = amdgpu_ib_get_value(ib, idx + 2); /* RADEON_VCN_ENGINE_TYPE */
-	if (val == RADEON_VCN_ENGINE_TYPE_DECODE) {
-		decode_buffer = (struct amdgpu_vcn_decode_buffer *)&ib->ptr[idx + 6];
-
-		if (!(decode_buffer->valid_buf_flag  & 0x1))
-			return 0;
-
-		addr = ((u64)decode_buffer->msg_buffer_address_hi) << 32 |
-			decode_buffer->msg_buffer_address_lo;
-		return vcn_v4_0_5_dec_msg(p, job, addr);
-	} else if (val == RADEON_VCN_ENGINE_TYPE_ENCODE) {
-		idx = vcn_v4_0_5_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT,
-			RENCODE_IB_PARAM_SESSION_INIT_MAX_OFFSET);
-		if (idx >= 0 && ib->ptr[idx + 2] == RENCODE_ENCODE_STANDARD_AV1)
-			return vcn_v4_0_5_limit_sched(p, job);
-	}
-	return 0;
-}
-
 static const struct amdgpu_ring_funcs vcn_v4_0_5_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
@@ -1518,7 +1354,6 @@ static const struct amdgpu_ring_funcs vc
 	.get_rptr = vcn_v4_0_5_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_5_unified_ring_get_wptr,
 	.set_wptr = vcn_v4_0_5_unified_ring_set_wptr,
-	.patch_cs_in_place = vcn_v4_0_5_ring_patch_cs_in_place,
 	.emit_frame_size =
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 3 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 4 +


