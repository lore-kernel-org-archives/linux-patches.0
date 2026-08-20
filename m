Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206E537F72E;
	Thu, 20 Aug 2026 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238953; cv=none; b=DuOWvqKKFdnyk3twzLMz88Wsflz+GNt9BFzrWod0jUNWjYd9rgHUeyEumCvVzxMmkIl+0EW3w8oI0CyTSRP0G30Lf2B3XUnhvwnUuNzXJ3zvEcCAlYvscun3Sx5w2XbOmfO2zez9zsobaBo79cBIIoAql/s7rs1AHYcAAnkgilQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238953; c=relaxed/simple;
	bh=Zmu0V08nnpticTlfsRNU+vJv0JZxQpsicPIbbQkXarc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecBXYJSs/L6CCg+zxOKEdshz56MSjvGdH3gs3nuC4w2HjnmD877DNkE5u5ywXrCFVs+WnaGGJMthT6Lm44NWvZaPJBi86N2A3RnhwNb+9IFDQvVZyhUsIpKsy7epAXPiAYK5cllaq9+pq7STdFKUbcaXFMupbjEGAIIaOnpyZgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrklKTBw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrklKTBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655971F000E9;
	Thu, 20 Aug 2026 15:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238951;
	bh=ZgLem6HWrmAsjD5aP3h1mVdOPfuTJ0LMkLamzlXTC0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrklKTBwJ55LrQy1KZLXbpHbfxl7Z/Ng6cnAg38yxNWrhjG+d6ML/+99sR9WbtOOp
	 uH1Rfx0UAQ/DawQQk2xfVe1rYLamkvruvtMO+kjXAWGknIT/2W1dRyunor7IzXZCiF
	 E4+tlKc5u1aF+DTlmJ+EBv+0AsKWciiKTgoi4Nig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 098/217] drm/amdgpu: Implement insert_end for VCE 3
Date: Thu, 20 Aug 2026 16:54:26 +0200
Message-ID: <20260820145240.697126840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -870,6 +870,23 @@ static void vce_v3_0_ring_emit_ib(struct
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
@@ -879,7 +896,6 @@ static void vce_v3_0_emit_vm_flush(struc
 
 	amdgpu_ring_write(ring, VCE_CMD_FLUSH_TLB);
 	amdgpu_ring_write(ring, vmid);
-	amdgpu_ring_write(ring, VCE_CMD_END);
 }
 
 static void vce_v3_0_emit_pipeline_sync(struct amdgpu_ring *ring)
@@ -948,17 +964,19 @@ static const struct amdgpu_ring_funcs vc
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


