Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290CD1BA88C;
	Tue, 27 Aug 2024 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770792; cv=none; b=U1CNkwAStp8zYAW01+zuv3e1+A+CizhrIQQnXT4Ucsy2RCobWdeILr3enAJG/Rjj5LQfdfj1zWtRdUUy2+udXKUbKxsmGocw8xH4DETJlhQYXAK5/gaUsWNsL+B456Naq4fKX7/5tveAqF+LD2LZcPy17n76uobVzl2RCwyGfVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770792; c=relaxed/simple;
	bh=z2YaAQS2Ebpdb8CW/KCycVSH0QpQrBu2Ds223ifioFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVTOqFCQeE1X+fLB8XeJLWuoZ3IuHRsLkui774fGfvcaRV3Ekql01QKkiMNp2r597y2LT7PYOmvxQ4mI91MkIor0RAC8f2uxvPKVHYCwP8zhNL0sO9Kehxjw5cxg+BBnTc9nnmAU272cnmJpLkHqoa8JqmO2lbNKePbUoTNQbZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9iQucBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9iQucBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5572C4AF1A;
	Tue, 27 Aug 2024 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770792;
	bh=z2YaAQS2Ebpdb8CW/KCycVSH0QpQrBu2Ds223ifioFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9iQucBjttz4LaKjT2BCM4u0WavJFnzHV4xlG2KWZv88ZpsLtJwWh4NXvcbtwUlfn
	 aeT2qGFO/eG7TL511tRErwA4d04QG6g+GyX7XMUOE6b3PpmKvgkX+UyQq+5t5yG6wv
	 g85OM26wnvMVtBNC9ei8UZS1OQlpTOHca0+FWAQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 336/341] drm/amdgpu/vcn: identify unified queue in sw init
Date: Tue, 27 Aug 2024 16:39:27 +0200
Message-ID: <20240827143856.179881152@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Boyuan Zhang <boyuan.zhang@amd.com>

commit ecfa23c8df7ef3ea2a429dfe039341bf792e95b4 upstream.

Determine whether VCN using unified queue in sw_init, instead of calling
functions later on.

v2: fix coding style

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c |   39 ++++++++++++--------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h |    1 
 2 files changed, 16 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -135,6 +135,10 @@ int amdgpu_vcn_sw_init(struct amdgpu_dev
 		}
 	}
 
+	/* from vcn4 and above, only unified queue is used */
+	adev->vcn.using_unified_queue =
+		adev->ip_versions[UVD_HWIP][0] >= IP_VERSION(4, 0, 0);
+
 	hdr = (const struct common_firmware_header *)adev->vcn.fw->data;
 	adev->vcn.fw_version = le32_to_cpu(hdr->ucode_version);
 
@@ -259,18 +263,6 @@ int amdgpu_vcn_sw_fini(struct amdgpu_dev
 	return 0;
 }
 
-/* from vcn4 and above, only unified queue is used */
-static bool amdgpu_vcn_using_unified_queue(struct amdgpu_ring *ring)
-{
-	struct amdgpu_device *adev = ring->adev;
-	bool ret = false;
-
-	if (adev->ip_versions[UVD_HWIP][0] >= IP_VERSION(4, 0, 0))
-		ret = true;
-
-	return ret;
-}
-
 bool amdgpu_vcn_is_disabled_vcn(struct amdgpu_device *adev, enum vcn_ring_type type, uint32_t vcn_instance)
 {
 	bool ret = false;
@@ -707,12 +699,11 @@ static int amdgpu_vcn_dec_sw_send_msg(st
 	struct amdgpu_job *job;
 	struct amdgpu_ib *ib;
 	uint64_t addr = AMDGPU_GPU_PAGE_ALIGN(ib_msg->gpu_addr);
-	bool sq = amdgpu_vcn_using_unified_queue(ring);
 	uint32_t *ib_checksum;
 	uint32_t ib_pack_in_dw;
 	int i, r;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		ib_size_dw += 8;
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, NULL, NULL,
@@ -725,7 +716,7 @@ static int amdgpu_vcn_dec_sw_send_msg(st
 	ib->length_dw = 0;
 
 	/* single queue headers */
-	if (sq) {
+	if (adev->vcn.using_unified_queue) {
 		ib_pack_in_dw = sizeof(struct amdgpu_vcn_decode_buffer) / sizeof(uint32_t)
 						+ 4 + 2; /* engine info + decoding ib in dw */
 		ib_checksum = amdgpu_vcn_unified_ring_ib_header(ib, ib_pack_in_dw, false);
@@ -744,7 +735,7 @@ static int amdgpu_vcn_dec_sw_send_msg(st
 	for (i = ib->length_dw; i < ib_size_dw; ++i)
 		ib->ptr[i] = 0x0;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		amdgpu_vcn_unified_ring_ib_checksum(&ib_checksum, ib_pack_in_dw);
 
 	r = amdgpu_job_submit_direct(job, ring, &f);
@@ -834,15 +825,15 @@ static int amdgpu_vcn_enc_get_create_msg
 					 struct dma_fence **fence)
 {
 	unsigned int ib_size_dw = 16;
+	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_job *job;
 	struct amdgpu_ib *ib;
 	struct dma_fence *f = NULL;
 	uint32_t *ib_checksum = NULL;
 	uint64_t addr;
-	bool sq = amdgpu_vcn_using_unified_queue(ring);
 	int i, r;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		ib_size_dw += 8;
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, NULL, NULL,
@@ -856,7 +847,7 @@ static int amdgpu_vcn_enc_get_create_msg
 
 	ib->length_dw = 0;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		ib_checksum = amdgpu_vcn_unified_ring_ib_header(ib, 0x11, true);
 
 	ib->ptr[ib->length_dw++] = 0x00000018;
@@ -878,7 +869,7 @@ static int amdgpu_vcn_enc_get_create_msg
 	for (i = ib->length_dw; i < ib_size_dw; ++i)
 		ib->ptr[i] = 0x0;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		amdgpu_vcn_unified_ring_ib_checksum(&ib_checksum, 0x11);
 
 	r = amdgpu_job_submit_direct(job, ring, &f);
@@ -901,15 +892,15 @@ static int amdgpu_vcn_enc_get_destroy_ms
 					  struct dma_fence **fence)
 {
 	unsigned int ib_size_dw = 16;
+	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_job *job;
 	struct amdgpu_ib *ib;
 	struct dma_fence *f = NULL;
 	uint32_t *ib_checksum = NULL;
 	uint64_t addr;
-	bool sq = amdgpu_vcn_using_unified_queue(ring);
 	int i, r;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		ib_size_dw += 8;
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, NULL, NULL,
@@ -923,7 +914,7 @@ static int amdgpu_vcn_enc_get_destroy_ms
 
 	ib->length_dw = 0;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		ib_checksum = amdgpu_vcn_unified_ring_ib_header(ib, 0x11, true);
 
 	ib->ptr[ib->length_dw++] = 0x00000018;
@@ -945,7 +936,7 @@ static int amdgpu_vcn_enc_get_destroy_ms
 	for (i = ib->length_dw; i < ib_size_dw; ++i)
 		ib->ptr[i] = 0x0;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		amdgpu_vcn_unified_ring_ib_checksum(&ib_checksum, 0x11);
 
 	r = amdgpu_job_submit_direct(job, ring, &f);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -284,6 +284,7 @@ struct amdgpu_vcn {
 
 	uint16_t inst_mask;
 	uint8_t	num_inst_per_aid;
+	bool using_unified_queue;
 };
 
 struct amdgpu_fw_shared_rb_ptrs_struct {


