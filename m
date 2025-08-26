Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002062BEC2B;
	Tue, 26 Aug 2025 11:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207408; cv=none; b=KYi75tJjqaoX8D5rOWkMdqQLOhOocK5AUGYUhx1nY6Oo1B2bQdkv55WI3dEaQ67BfPGaknyjZ/yxmyvACgqdvufcP6EYWaJj3bfEdisYI3JC8JDycH/MfRhx8VWvp/gPjvWxdupmhVJSLn55mDDnZjSyvJ/Fuf0xgg/0mtbKr6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207408; c=relaxed/simple;
	bh=CfPOEbFEnakMHgVxk/OUuBRw5rRBANytrfDlHyavC5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msS/C+5KwrbX04vbQev/kg2ash+BTvnZ5QFLqdD60CoOuPXiMmf1o+Q4SKVs7nUrc4m7eKjhQCJxjqgcj78IcqrcXbKQGPXduuBEsoWULpCmP1DVR9Em5mATivRT+IKO1WEHyJB/4w+svDbgvBwFOOE5ZpCepEdRhZ4LkF8bpxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iJw4rGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iJw4rGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420C6C4CEF1;
	Tue, 26 Aug 2025 11:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207407;
	bh=CfPOEbFEnakMHgVxk/OUuBRw5rRBANytrfDlHyavC5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iJw4rGL/4TwBRnpjX4XvaKAttHAU7b/oLyXk1Erq+XEWAr9nxgsSrTARBG9xBbII
	 pQ8qdyTwOLq8nBEgskn98g00xOZEdhfmDdqfpLUus1OukWB3ewtW39EY3i/FJ5HPT9
	 ErK/gOW4isVfnnsyHVAnAYCXci3QEfQP17WRwBlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 170/457] drm/amd/amdgpu: fix missing lock for cper.ring->rptr/wptr access
Date: Tue, 26 Aug 2025 13:07:34 +0200
Message-ID: <20250826110941.577935141@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 8e0d1edb5c16732b695eaf4bd7096b1569817cf0 upstream.

Add lock protection for 'ring->wptr'/'ring->rptr' to ensure the correct execution.

Fixes: 8652920d2c00 ("drm/amdgpu: add mutex lock for cper ring")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
index 15dde1f50328..25252231a68a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
@@ -459,7 +459,7 @@ static u32 amdgpu_cper_ring_get_ent_sz(struct amdgpu_ring *ring, u64 pos)
 
 void amdgpu_cper_ring_write(struct amdgpu_ring *ring, void *src, int count)
 {
-	u64 pos, wptr_old, rptr = *ring->rptr_cpu_addr & ring->ptr_mask;
+	u64 pos, wptr_old, rptr;
 	int rec_cnt_dw = count >> 2;
 	u32 chunk, ent_sz;
 	u8 *s = (u8 *)src;
@@ -472,9 +472,11 @@ void amdgpu_cper_ring_write(struct amdgpu_ring *ring, void *src, int count)
 		return;
 	}
 
-	wptr_old = ring->wptr;
-
 	mutex_lock(&ring->adev->cper.ring_lock);
+
+	wptr_old = ring->wptr;
+	rptr = *ring->rptr_cpu_addr & ring->ptr_mask;
+
 	while (count) {
 		ent_sz = amdgpu_cper_ring_get_ent_sz(ring, ring->wptr);
 		chunk = umin(ent_sz, count);
-- 
2.50.1



