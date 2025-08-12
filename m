Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116792F4A0A;
	Tue, 12 Aug 2025 18:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023817; cv=none; b=sdwVxB6sSW97qeyuSzgAmRa5rDkwL/uzuPYsHMjr7XFK43zLS+NmtMasCd+WSoyGPyJxSnSLStDx99+o/eR4j2HnDiYDo1nNW8RsXbDd/zBd7YyVLWZJ8EzzlkJxflZV63SkkH2H8vWKzpgRCX7EjBTWypxx90yBHxtWusgt3DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023817; c=relaxed/simple;
	bh=4ezptqIphjyKHJMeveY+PhIWqZ5LYmKvbmfUzngCIRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ny3xU/3kCFEZmDNhlgJ2mRz590Ktsw7kmvqtzblI+Ou+nEYsKfstqFXD/893UX+MLbL0FzzkrzmxW+T9fyv4+rcUW4g77SUAakCt2f65cP1EMEMCzmGtCvKX09xbSsT+2kM3SYT68EjkTYG2dq6Gm1u/UuTNgt6gT1deBTgNK8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbhBAS3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbhBAS3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECB2C4CEF0;
	Tue, 12 Aug 2025 18:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023816;
	bh=4ezptqIphjyKHJMeveY+PhIWqZ5LYmKvbmfUzngCIRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbhBAS3Qm+wSsd1MOjoaERbF1er5N3N6au7Kk37/GHSo7XsVWzn7X2RkeyiBsWKvf
	 RHRGMkb14VrudtAitWaZoiE5UaTuBL9LvWwSAlDcCcMI+m1UQnTwXxJv/xX0VMsjYm
	 7By8WjnDmm7R52Gs9GdhAKKli/z1LCzUucDF614A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 190/627] drm/amdgpu/gfx10: fix KGQ reset sequence
Date: Tue, 12 Aug 2025 19:28:05 +0200
Message-ID: <20250812173426.500894947@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 14b2d71a9a24727f1b9f2131ed5eb2e345840a3a ]

Need to reinit the ring before remapping it and all of
the KIQ handling needs to be within the kiq lock.

Fixes: 1741281a157f ("drm/amdgpu/gfx10: add ring reset callbacks")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 777e383d75e2..e7df0487eaae 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -9540,7 +9540,7 @@ static int gfx_v10_0_reset_kgq(struct amdgpu_ring *ring, unsigned int vmid)
 
 	spin_lock_irqsave(&kiq->ring_lock, flags);
 
-	if (amdgpu_ring_alloc(kiq_ring, 5 + 7 + 7 + kiq->pmf->map_queues_size)) {
+	if (amdgpu_ring_alloc(kiq_ring, 5 + 7 + 7)) {
 		spin_unlock_irqrestore(&kiq->ring_lock, flags);
 		return -ENOMEM;
 	}
@@ -9560,12 +9560,9 @@ static int gfx_v10_0_reset_kgq(struct amdgpu_ring *ring, unsigned int vmid)
 			       0, 1, 0x20);
 	gfx_v10_0_ring_emit_reg_wait(kiq_ring,
 				     SOC15_REG_OFFSET(GC, 0, mmCP_VMID_RESET), 0, 0xffffffff);
-	kiq->pmf->kiq_map_queues(kiq_ring, ring);
 	amdgpu_ring_commit(kiq_ring);
-
-	spin_unlock_irqrestore(&kiq->ring_lock, flags);
-
 	r = amdgpu_ring_test_ring(kiq_ring);
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r)
 		return r;
 
@@ -9575,6 +9572,19 @@ static int gfx_v10_0_reset_kgq(struct amdgpu_ring *ring, unsigned int vmid)
 		return r;
 	}
 
+	spin_lock_irqsave(&kiq->ring_lock, flags);
+
+	if (amdgpu_ring_alloc(kiq_ring, kiq->pmf->map_queues_size)) {
+		spin_unlock_irqrestore(&kiq->ring_lock, flags);
+		return -ENOMEM;
+	}
+	kiq->pmf->kiq_map_queues(kiq_ring, ring);
+	amdgpu_ring_commit(kiq_ring);
+	r = amdgpu_ring_test_ring(kiq_ring);
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
+	if (r)
+		return r;
+
 	r = amdgpu_ring_test_ring(ring);
 	if (r)
 		return r;
-- 
2.39.5



