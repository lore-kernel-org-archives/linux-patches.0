Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC85526B76A;
	Tue, 11 Nov 2025 01:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825070; cv=none; b=eSzyDeMAFvr1Xjh9eEGSLYnwfR0CcIktlW/ZLaaPMIUujhS96tuTODCwSsLs6k1GE3MtREdKSlSnGZ2BlUpzOqba9HHkUl/qp+Y+lToXP18rDyT1bNFDb/reLsbAlZsE9K6fjzFgiB4mS9aQVkp3Hhz1XRv4RQifYMd6mkFRUZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825070; c=relaxed/simple;
	bh=Qe5ARLfEWIRSKaPSCkRkTzv6G61vK1TRnnlXsnsXBQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNP0IoiihlU83gSqoUru8k+qIizbDghhE3jtYtW4r6Z3MH0nRJxIWYKsTgvSRduAicUChAtSkXr3Hx0kz+lqeemHuweWKKJlOZv+d5LKYnstv67eBKiHgGj8EfptfYIx+8zmo2SaXmHRoBBD4KohzYO36TSDZpXUMHrQaebV1p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAzXEoYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAzXEoYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B23C4CEF5;
	Tue, 11 Nov 2025 01:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825070;
	bh=Qe5ARLfEWIRSKaPSCkRkTzv6G61vK1TRnnlXsnsXBQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAzXEoYGaqZnmvR6/y4cJOViZbtbbmu77/w3zYWeP6XMEseiGu9VzIUbUOaOhu5+0
	 kZP5bb/Q+q4Pzu3xyFVaM6q8wYoaS8OS1M/MSypDV3A3zyZzhLU2rt+dyhZwp8SMKI
	 zHZbpMCOJl63da4CN8UaLZH1Vo/UU7XeVa9RI/TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 647/849] drm/amdgpu: Add fallback to pipe reset if KCQ ring reset fails
Date: Tue, 11 Nov 2025 09:43:37 +0900
Message-ID: <20251111004552.067973884@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 7469567d882374dcac3fdb8b300e0f28cf875a75 ]

Add a fallback mechanism to attempt pipe reset when KCQ reset
fails to recover the ring. After performing the KCQ reset and
queue remapping, test the ring functionality. If the ring test
fails, initiate a pipe reset as an additional recovery step.

v2: fix the typo (Lijo)
v3: try pipeline reset when kiq mapping fails (Lijo)

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index 51babf5c78c86..f06bc94cf6e14 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -3562,6 +3562,7 @@ static int gfx_v9_4_3_reset_kcq(struct amdgpu_ring *ring,
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_kiq *kiq = &adev->gfx.kiq[ring->xcc_id];
 	struct amdgpu_ring *kiq_ring = &kiq->ring;
+	int reset_mode = AMDGPU_RESET_TYPE_PER_QUEUE;
 	unsigned long flags;
 	int r;
 
@@ -3599,6 +3600,7 @@ static int gfx_v9_4_3_reset_kcq(struct amdgpu_ring *ring,
 		if (!(adev->gfx.compute_supported_reset & AMDGPU_RESET_TYPE_PER_PIPE))
 			return -EOPNOTSUPP;
 		r = gfx_v9_4_3_reset_hw_pipe(ring);
+		reset_mode = AMDGPU_RESET_TYPE_PER_PIPE;
 		dev_info(adev->dev, "ring: %s pipe reset :%s\n", ring->name,
 				r ? "failed" : "successfully");
 		if (r)
@@ -3621,10 +3623,20 @@ static int gfx_v9_4_3_reset_kcq(struct amdgpu_ring *ring,
 	r = amdgpu_ring_test_ring(kiq_ring);
 	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r) {
+		if (reset_mode == AMDGPU_RESET_TYPE_PER_QUEUE)
+			goto pipe_reset;
+
 		dev_err(adev->dev, "fail to remap queue\n");
 		return r;
 	}
 
+	if (reset_mode == AMDGPU_RESET_TYPE_PER_QUEUE) {
+		r = amdgpu_ring_test_ring(ring);
+		if (r)
+			goto pipe_reset;
+	}
+
+
 	return amdgpu_ring_reset_helper_end(ring, timedout_fence);
 }
 
-- 
2.51.0



