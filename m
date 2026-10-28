Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210046;
	b=blgQP9ut6fVDmWxZVbsTOaxx/hOThrAFOrWY3jwqi4PfARKF/fd0OpsREqc7xTMYyYnt
	 JypJFe2+5inWQhzfRfZvjOuens00ZBuD1UH+pZ/LiCRUZCQP2/X9TrnDPwUllA89Na4Mk
	 qL4FPm+9UzxHgL5pGmi0dtJB/Fvv6u/jRRgVdRJO+Babdgo07CE9iAKQnBgYyMktDLms6
	 sV2Mdi8I7ocU3cKTcKA8bvKFjxKsd2VfLFi0GPzAzuLS9D6UZ9IjTZku42WqwCOH1boP6
	 ap5ZpDlWIlr0R7koaOCVaiKlvDmP6WFF3royF94zhIle40u29T0mAUgEqUssZIaBdrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4kCC7QhpQfLOLUWqIvin0vlt1ty7MYTt13o2eR2+W90=;
	b=ryTUA5yvz41sqocGk3U0tLq7XRG7wmDKg7ExsmgMZeYUXd9qjSkDM+stK/y1MdIUPspI
	 raAzGboi+ky0eXOTiEmflg8ZnpGhJfYzHtJAi6kbuArRUY/gpwDZcMFXP5yOc0/uadojo
	 zyd5MbXMSR2iYbkoquYLoqTcndbNTpQipmLDy/29iuXPWcO/NtCc99ntz8PXzP1C5RFNV
	 tEtINJXsT30alnzifp6TqQXlVcoY83MlDD46+R7kUVipcgGzeRScTcIwU6EuEraap9e7u
	 pOa788Oi0KAcKdDwAQHY8pxN2LNIlqWexqOLhiqWFr9DYcvIn4rKPgA8IIS/Dytu6qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EX9plmaL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105A9606A321;
	Wed, 28 Oct 2026 17:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EX9plmaL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627491F01825;
	Wed, 28 Oct 2026 17:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210044;
	bh=4kCC7QhpQfLOLUWqIvin0vlt1ty7MYTt13o2eR2+W90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EX9plmaLKpd4XvpfpqPDbgVf6yiEdiQoN4fDshpyAyCRROOIJ2Rm+gz1L288/+5JZ
	 0xm4vc7JZwDe4KdkBTV3GHP3fl0ieBs0qbDk5asG5UOgIYYOYnHcbKj+WKHqhptblV
	 fpUgn8Ca8rcskY4PaMCAFGU0KojUweeQzR+tLx9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 6.6 058/168] drm/amdgpu/sdma3: Work around POLL_REGMEM / FENCE hang
Date: Wed, 28 Oct 2026 17:59:54 +0100
Message-ID: <20261028165944.459007756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 752480ad62964edf0254e151110d3e53a7cb37de upstream.

SDMA can randomly hang on Polaris 10. Hard to reproduce,
but has been occurring sporadically in the Mesa CI
on the RADV Polaris 10 job even when Mesa isn't using
the SDMA engine.

When Mesa actually uses the SDMA on Polaris, the hang
becomes more frequent and the reproduction rate goes up
significantly in the CI system.

We don't know why the hangs occur, but it seems
that inserting a single NOP packet before each
POLL_REGMEM and FENCE packet works around it.
At the moment it's unclear which GPUs are affected,
so let's apply this to SDMA 3.x for now.

Note that this issue is not documented or acknowledged by AMD.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c343a27ed90823d08de125f7c447d96d056b75d9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c
@@ -454,6 +454,9 @@ static void sdma_v3_0_ring_emit_hdp_flus
 	else
 		ref_and_mask = REG_SET_FIELD(ref_and_mask, GPU_HDP_FLUSH_DONE, SDMA1, 1);
 
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(1) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_FUNC(3)); /* == */
@@ -481,6 +484,10 @@ static void sdma_v3_0_ring_emit_fence(st
 				      unsigned flags)
 {
 	bool write64bit = flags & AMDGPU_FENCE_FLAG_64BIT;
+
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	/* write the fence */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 	amdgpu_ring_write(ring, lower_32_bits(addr));
@@ -489,7 +496,11 @@ static void sdma_v3_0_ring_emit_fence(st
 
 	/* optionally write high bits as well */
 	if (write64bit) {
+		/* Hang workaround */
+		amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 		addr += 4;
+
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
@@ -1035,6 +1046,9 @@ static void sdma_v3_0_ring_emit_pipeline
 	uint32_t seq = ring->fence_drv.sync_seq;
 	uint64_t addr = ring->fence_drv.gpu_addr;
 
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	/* wait for idle */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(0) |
@@ -1063,6 +1077,9 @@ static void sdma_v3_0_ring_emit_vm_flush
 {
 	amdgpu_gmc_emit_flush_gpu_tlb(ring, vmid, pd_addr);
 
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	/* wait for flush */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(0) |
@@ -1571,11 +1588,11 @@ static const struct amdgpu_ring_funcs sd
 	.get_wptr = sdma_v3_0_ring_get_wptr,
 	.set_wptr = sdma_v3_0_ring_set_wptr,
 	.emit_frame_size =
-		6 + /* sdma_v3_0_ring_emit_hdp_flush */
+		6 + 1 + /* sdma_v3_0_ring_emit_hdp_flush */
 		3 + /* hdp invalidate */
-		6 + /* sdma_v3_0_ring_emit_pipeline_sync */
-		VI_FLUSH_GPU_TLB_NUM_WREG * 3 + 6 + /* sdma_v3_0_ring_emit_vm_flush */
-		10 + 10 + 10, /* sdma_v3_0_ring_emit_fence x3 for user fence, vm fence */
+		6 + 1 + /* sdma_v3_0_ring_emit_pipeline_sync */
+		VI_FLUSH_GPU_TLB_NUM_WREG * 3 + 6 + 1 + /* sdma_v3_0_ring_emit_vm_flush */
+		(10 + 1) * 3, /* sdma_v3_0_ring_emit_fence x3 for user fence, vm fence */
 	.emit_ib_size = 7 + 6, /* sdma_v3_0_ring_emit_ib */
 	.emit_ib = sdma_v3_0_ring_emit_ib,
 	.emit_fence = sdma_v3_0_ring_emit_fence,


