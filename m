Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095E3337699;
	Thu, 30 Jul 2026 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423266; cv=none; b=pn43ae159fHDyVfmre/37N27l+hFAgP+mbOMsNzwbFOjgSx6m6+iRQUuYS+JKGsrTYdMyIe1NpnYN6RzjMmS2/Rj/neeSHxAs1gmNONWDItLdru4ZUT6Yb3VC+kxL/+gw5z+QMx+dlEpUBK5ju9+v9fm4lBLtQsT5gt1+CfCWWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423266; c=relaxed/simple;
	bh=SQBCZP0L1SrWy5lZcWb6wC7BnW0uRkf/g0pOCr0C/6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sF1KenhYQ7vyIDfsn32rQqojFSvaI85EXhCSTAIiGD7j1uzltFwZ4BlWnyXCYwN08hDmaStSfK/ClNT0XxRuyidVeXWFtHkHG/lnaT72m7UG5RWWcScixXg55eFtWP3QS8H8o/dzVa7D4F9eBaDdv2YLm1DLozSTO6y2NYJyRwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAzJRcXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAzJRcXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647561F000E9;
	Thu, 30 Jul 2026 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423264;
	bh=CZ9hveDwdk2NbGXEDgwdTYqwgEyz2J5tvnr8Nu6WNQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAzJRcXKgILr5hmE00RwaZof935ICSC8WjYW2ZKOVITuXOj6286ZZOK2/k768j8Jy
	 R4q2V6uzKev1pfYjUDu0v9o4V75Zn/a9JUcWfZ80Gkthu9JAgVqBTUzNqP+GHS633f
	 skncEhQY2gFBaRipG2cfaIRiqODWAMqQX0mgib84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>
Subject: [PATCH 7.1 697/744] drm/amdgpu/gfx11: fix EOP interrupt routing for KQ and userq
Date: Thu, 30 Jul 2026 16:16:10 +0200
Message-ID: <20260730141459.085505068@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit 0a3d35460320baf8744c7dcc3e287e07fbaf6d36 upstream.

Try KQ by ring_id first (KCQ and UQ never share a HW slot); fall back
to amdgpu_userq_process_fence_irq() on miss, since KQ EOPs were
misrouted into the userq fence path when enable_mes is true.

Require a strict (me,pipe,queue) match in the gfx case, then userq gfx
EOPs fall through to amdgpu_userq_process_fence_irq().

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 88e589cc811ba907209a426c426c469bcb4bb894)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |   43 ++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -6513,25 +6513,33 @@ static int gfx_v11_0_eop_irq(struct amdg
 			     struct amdgpu_iv_entry *entry)
 {
 	u32 doorbell_offset = entry->src_data[0];
-	u8 me_id, pipe_id, queue_id;
-	struct amdgpu_ring *ring;
-	int i;
 
 	DRM_DEBUG("IH: CP EOP\n");
 
-	if (adev->enable_mes && doorbell_offset) {
-		amdgpu_userq_process_fence_irq(adev, doorbell_offset);
-	} else {
-		me_id = (entry->ring_id & 0x0c) >> 2;
-		pipe_id = (entry->ring_id & 0x03) >> 0;
-		queue_id = (entry->ring_id & 0x70) >> 4;
+	if (!adev->gfx.disable_kq) {
+		u8 me_id = (entry->ring_id & 0x0c) >> 2;
+		u8 pipe_id = (entry->ring_id & 0x03) >> 0;
+		u8 queue_id = (entry->ring_id & 0x70) >> 4;
+		struct amdgpu_ring *ring;
+		int i;
 
 		switch (me_id) {
 		case 0:
-			if (pipe_id == 0)
-				amdgpu_fence_process(&adev->gfx.gfx_ring[0]);
-			else
-				amdgpu_fence_process(&adev->gfx.gfx_ring[1]);
+			/*
+			 * MES splits gfx HQDs per (me,pipe): KGQ owns queue=0,
+			 * userq gfx owns queue>=1 (see amdgpu_mes_get_hqd_mask).
+			 * Require a strict (me,pipe,queue) match so userq gfx
+			 * EOPs fall through to amdgpu_userq_process_fence_irq().
+			 */
+			for (i = 0; i < adev->gfx.num_gfx_rings; i++) {
+				ring = &adev->gfx.gfx_ring[i];
+				if ((ring->me == me_id) &&
+				    (ring->pipe == pipe_id) &&
+				    (ring->queue == queue_id)) {
+					amdgpu_fence_process(ring);
+					return 0;
+				}
+			}
 			break;
 		case 1:
 		case 2:
@@ -6543,13 +6551,20 @@ static int gfx_v11_0_eop_irq(struct amdg
 				 */
 				if ((ring->me == me_id) &&
 				    (ring->pipe == pipe_id) &&
-				    (ring->queue == queue_id))
+				    (ring->queue == queue_id)) {
 					amdgpu_fence_process(ring);
+					return 0;
+				}
 			}
 			break;
+		default:
+			break;
 		}
 	}
 
+	if (adev->enable_mes && doorbell_offset)
+		amdgpu_userq_process_fence_irq(adev, doorbell_offset);
+
 	return 0;
 }
 


