Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5593D37C90E;
	Thu, 20 Aug 2026 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238360; cv=none; b=Ou6ChwrlOWtGHH6r8RmZBs5IPuYo0Uu+gQzrOa/99l/gT41aDW9nvl4Z62k4c6aJuRfL7Zyr71e7bHYvaZEJzgSngMb+2ug5QNxbzCbx0RH71X393Lvmbe+EXHIbPnZVYE2lELuAT9hueps7tgu5XJ0P5EWrbm16VzcMybYTJdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238360; c=relaxed/simple;
	bh=sZ4r/PSjekjYDh2hi/8K9Zpoyio5tvczgCLVutJScTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhAeiLwmUkH64K2/hDcaTL3k7JiylfUluCZDAkrDSHYHsejDYRrTFWE9SI2wLAEaNxf/W0hWRmLrTPXyOAt9xmSoGYcuQKAvxQhSjPrhrOQw/BL2Lye0IKFFRt5ydLAZlV+rAlyiPtJMqC/Wh6VLW3MA1egEYUu9g1URpnxoLfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzFObZF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzFObZF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09E01F000E9;
	Thu, 20 Aug 2026 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238359;
	bh=Ut31MSWsCZMEprhjpHxL8W+YutLau0H3deL1MfUgqzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XzFObZF93Vx5Ynn0e6TVQjRlfoWUB+chENN55jqUji8+ixdGiSw7bg5e5t9Cgjl+n
	 3JcmjniJ+0G6vi8APEQvMZ8PjSJ3k1tBOhSJtktXOA5Zgkd6Y2pz2kYEftUy2ppidM
	 PILoPo0319Y7L3GZjVOo8MC+l8VoON37AZcWFCgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 120/228] drm/amdgpu: Implement insert_end for VCE 3
Date: Thu, 20 Aug 2026 16:54:22 +0200
Message-ID: <20260820145248.276577915@linuxfoundation.org>
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

From: David Rosca <david.rosca@amd.com>

commit d5ab4c6a64efef2d143a96df5357f59703cd703d upstream.

After a recent change VCE now hangs when VCE_CMD_END is emitted
after a pipeline sync without VM flush.
Implement insert_end to correctly insert only one VCE_CMD_END per job.

Fixes: bc639a9eadc7 ("drm/amdgpu: always emit the job vm fence")
Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8897ea8c761b856f02061848a7908040a1fe5e68)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -875,6 +875,23 @@ static void vce_v3_0_ring_emit_ib(struct
 	amdgpu_ring_write(ring, ib->length_dw);
 }
 
+static void vce_v3_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr,
+			u64 seq, unsigned flags)
+{
+	WARN_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
+
+	amdgpu_ring_write(ring, VCE_CMD_FENCE);
+	amdgpu_ring_write(ring, addr);
+	amdgpu_ring_write(ring, upper_32_bits(addr));
+	amdgpu_ring_write(ring, seq);
+	amdgpu_ring_write(ring, VCE_CMD_TRAP);
+}
+
+static void vce_v3_0_ring_insert_end(struct amdgpu_ring *ring)
+{
+	amdgpu_ring_write(ring, VCE_CMD_END);
+}
+
 static void vce_v3_0_emit_vm_flush(struct amdgpu_ring *ring,
 				   unsigned int vmid, uint64_t pd_addr)
 {
@@ -884,7 +901,6 @@ static void vce_v3_0_emit_vm_flush(struc
 
 	amdgpu_ring_write(ring, VCE_CMD_FLUSH_TLB);
 	amdgpu_ring_write(ring, vmid);
-	amdgpu_ring_write(ring, VCE_CMD_END);
 }
 
 static void vce_v3_0_emit_pipeline_sync(struct amdgpu_ring *ring)
@@ -953,17 +969,19 @@ static const struct amdgpu_ring_funcs vc
 	.set_wptr = vce_v3_0_ring_set_wptr,
 	.patch_cs_in_place = amdgpu_vce_ring_parse_cs_vm,
 	.emit_frame_size =
-		6 + /* vce_v3_0_emit_vm_flush */
+		5 + /* vce_v3_0_emit_vm_flush */
 		4 + /* vce_v3_0_emit_pipeline_sync */
-		6 + 6, /* amdgpu_vce_ring_emit_fence x2 vm fence */
+		5 + 5 + /* vce_v3_0_ring_emit_fence x2 vm fence */
+		1, /* vce_v3_0_ring_insert_end */
 	.emit_ib_size = 5, /* vce_v3_0_ring_emit_ib */
 	.emit_ib = vce_v3_0_ring_emit_ib,
 	.emit_vm_flush = vce_v3_0_emit_vm_flush,
 	.emit_pipeline_sync = vce_v3_0_emit_pipeline_sync,
-	.emit_fence = amdgpu_vce_ring_emit_fence,
+	.emit_fence = vce_v3_0_ring_emit_fence,
 	.test_ring = amdgpu_vce_ring_test_ring,
 	.test_ib = amdgpu_vce_ring_test_ib,
 	.insert_nop = amdgpu_ring_insert_nop,
+	.insert_end = vce_v3_0_ring_insert_end,
 	.pad_ib = amdgpu_ring_generic_pad_ib,
 	.begin_use = amdgpu_vce_ring_begin_use,
 	.end_use = amdgpu_vce_ring_end_use,


