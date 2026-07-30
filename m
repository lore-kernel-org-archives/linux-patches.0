Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346CF3B6366;
	Thu, 30 Jul 2026 14:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423297; cv=none; b=Wx3/ZoWEkr88tNHraNAVW9XvZjZKRqdxsdP0ioc7MYtTFpbsOhZH1lObh2Dc0aNRdMylR8Qx2jfVy8n8aEjJ633hOFk08s2UGGqFHPLYZksJh3ogCmZZxmDYF2fFOxMMTov0m/YPXPG9FjRyKl4XEjlhcEz2UPa5K9hQ8+14eG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423297; c=relaxed/simple;
	bh=J/sVAVAJZADBHgvRc9F9/YQRMSui+e5oIHj3QYIn8Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnarydfALxXyv00qL6A0NgbWN6c2SyBe69nPy4BkpM2iqqabqkQkLY7k6QAXYCBvoe/aOiMNj40ShghtXh0CPYq+bIQhKYt1b8L9MOTgmfOnGmjLOVvsolUdX1dc9AiAzDcW0jm4Rl2iUl5oNwGIOHBvaX+2bPrquLLH9mc0z6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiDT4pOg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiDT4pOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9006A1F000E9;
	Thu, 30 Jul 2026 14:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423296;
	bh=eLcNYqASs2/es1fhvps0w7cdcnCbq7bvs78IWEwdvaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiDT4pOgHTZiUn1bHm78GQ/zFK/pwyiG2Tsq4qthrigbGNTl/pUqWETFNGt80X4zp
	 +11bMqnk4cG9sfrbcq7b5B97GuIQRSV69qken+V/mnbnSrASQmz6fngr6iCir4b6Yt
	 KAtLcqOh5dXd3M0vV/8zwv9FgTeLC3YMZ29Xach4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>
Subject: [PATCH 7.1 698/744] drm/amdgpu/gfx12: fix EOP interrupt routing for KQ and userq
Date: Thu, 30 Jul 2026 16:16:11 +0200
Message-ID: <20260730141459.108533961@linuxfoundation.org>
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

commit 128abbbfa913e7e099b75ae652cc90cfd66c6d6b upstream.

Try KQ by ring_id first (KCQ and UQ never share a HW slot); fall back
to amdgpu_userq_process_fence_irq() on miss, since KCQ EOPs were
misrouted into the userq fence path when enable_mes is true.

Require a strict (me,pipe,queue) match in the gfx case, then userq gfx
EOPs fall through to amdgpu_userq_process_fence_irq().

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6c1f4f7ff08448e0e18cd7fc4e59d6c96a36f25d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |   43 ++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -4854,25 +4854,33 @@ static int gfx_v12_0_eop_irq(struct amdg
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
@@ -4884,13 +4892,20 @@ static int gfx_v12_0_eop_irq(struct amdg
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
 


