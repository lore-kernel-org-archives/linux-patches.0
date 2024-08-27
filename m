Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536981BDA93;
	Tue, 27 Aug 2024 15:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772711; cv=none; b=tSJ4RQDnHG4Ek30lOCwTMP7UHDzpJEheBayXoj2FVNQLRRv5YRoBDzBxBXwg3PL8ME9X13RKBCREDZoxw/Xmqv3ebcmInJDDepWqSvr/MH+QQC61lLPvy0yE5WARxhf2OnJYQn0ySlWNRiqaFjH0IUf7azIZX9ZiBLFF4J384IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772711; c=relaxed/simple;
	bh=PcI4D/qc85Yciv5nJ8EYBolnwVw3eGcDRPbMdxT3F4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNemH+nHcL21A9bJlp5AWxkOlZ+OrB4W+xmgqWOMRyR0JEY6ghMe2a3MJpHz4kqBVgz8m2PrTgdckIIh4x8G4guCAuKa8MxIfgZtE2yUsGgcx9mCHuo65T5b8sp7uq9uN/WWa49CC3iuOJ+32gvjFpWm9iuY2WLVR0paL3bM+1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1J2CrFF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1J2CrFF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A25C4DDF1;
	Tue, 27 Aug 2024 15:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772710;
	bh=PcI4D/qc85Yciv5nJ8EYBolnwVw3eGcDRPbMdxT3F4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1J2CrFF6fQI36UZ+Qcelfpju9gjQ/7SqQPpi+LX2dHo4HGVyl8DCoQCiEA9ic/0nw
	 lfQpz30AjxlWmlPhDYFwO8hXu6c6EfY6ykPw3eOyCMrQR8U8eGDR8EZWEqpFK7BKyp
	 MG06L6o5UTNrysqF/fQZSfP+4YRpFIsgANT/1Sz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 296/321] drm/amdgpu/vcn: identify unified queue in sw init
Date: Tue, 27 Aug 2024 16:40:04 +0200
Message-ID: <20240827143849.524617788@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -239,6 +239,10 @@ int amdgpu_vcn_sw_init(struct amdgpu_dev
 		return r;
 	}
 
+	/* from vcn4 and above, only unified queue is used */
+	adev->vcn.using_unified_queue =
+		adev->ip_versions[UVD_HWIP][0] >= IP_VERSION(4, 0, 0);
+
 	hdr = (const struct common_firmware_header *)adev->vcn.fw->data;
 	adev->vcn.fw_version = le32_to_cpu(hdr->ucode_version);
 
@@ -357,18 +361,6 @@ int amdgpu_vcn_sw_fini(struct amdgpu_dev
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
@@ -806,12 +798,11 @@ static int amdgpu_vcn_dec_sw_send_msg(st
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
 
 	r = amdgpu_job_alloc_with_ib(adev, ib_size_dw * 4,
@@ -823,7 +814,7 @@ static int amdgpu_vcn_dec_sw_send_msg(st
 	ib->length_dw = 0;
 
 	/* single queue headers */
-	if (sq) {
+	if (adev->vcn.using_unified_queue) {
 		ib_pack_in_dw = sizeof(struct amdgpu_vcn_decode_buffer) / sizeof(uint32_t)
 						+ 4 + 2; /* engine info + decoding ib in dw */
 		ib_checksum = amdgpu_vcn_unified_ring_ib_header(ib, ib_pack_in_dw, false);
@@ -842,7 +833,7 @@ static int amdgpu_vcn_dec_sw_send_msg(st
 	for (i = ib->length_dw; i < ib_size_dw; ++i)
 		ib->ptr[i] = 0x0;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		amdgpu_vcn_unified_ring_ib_checksum(&ib_checksum, ib_pack_in_dw);
 
 	r = amdgpu_job_submit_direct(job, ring, &f);
@@ -932,15 +923,15 @@ static int amdgpu_vcn_enc_get_create_msg
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
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, ib_size_dw * 4,
@@ -953,7 +944,7 @@ static int amdgpu_vcn_enc_get_create_msg
 
 	ib->length_dw = 0;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		ib_checksum = amdgpu_vcn_unified_ring_ib_header(ib, 0x11, true);
 
 	ib->ptr[ib->length_dw++] = 0x00000018;
@@ -975,7 +966,7 @@ static int amdgpu_vcn_enc_get_create_msg
 	for (i = ib->length_dw; i < ib_size_dw; ++i)
 		ib->ptr[i] = 0x0;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		amdgpu_vcn_unified_ring_ib_checksum(&ib_checksum, 0x11);
 
 	r = amdgpu_job_submit_direct(job, ring, &f);
@@ -998,15 +989,15 @@ static int amdgpu_vcn_enc_get_destroy_ms
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
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, ib_size_dw * 4,
@@ -1019,7 +1010,7 @@ static int amdgpu_vcn_enc_get_destroy_ms
 
 	ib->length_dw = 0;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		ib_checksum = amdgpu_vcn_unified_ring_ib_header(ib, 0x11, true);
 
 	ib->ptr[ib->length_dw++] = 0x00000018;
@@ -1041,7 +1032,7 @@ static int amdgpu_vcn_enc_get_destroy_ms
 	for (i = ib->length_dw; i < ib_size_dw; ++i)
 		ib->ptr[i] = 0x0;
 
-	if (sq)
+	if (adev->vcn.using_unified_queue)
 		amdgpu_vcn_unified_ring_ib_checksum(&ib_checksum, 0x11);
 
 	r = amdgpu_job_submit_direct(job, ring, &f);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -271,6 +271,7 @@ struct amdgpu_vcn {
 
 	struct ras_common_if    *ras_if;
 	struct amdgpu_vcn_ras   *ras;
+	bool using_unified_queue;
 };
 
 struct amdgpu_fw_shared_rb_ptrs_struct {


