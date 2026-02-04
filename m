Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5122D8763;
	Wed,  4 Feb 2026 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218865; cv=none; b=f0UvsDlLIPbtLqR/XVqB9VEiB2czcUCLx2Ut8qiknCX1x6ekZ/ZdUY4t4q52gkwVzzA4VDHtuCr1DoC/XP2+tat/Z7jGRUgmE701Wu5fMZNM0N4VXjYfJSbfcTNDGdtK7ZGbSEfXGxUTCTtrdFp44rMn5aQ92SyrrXBXRgoNNT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218865; c=relaxed/simple;
	bh=Bexqxq06BVeipxrDn8n6J+p+yyQL5jvHsYZkmhCwV8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gRMdxsmBcBikSXYN5Bv683KLfFegRd//mMsgwErfnZAwLkOW7jmlEF2PwS3g+VUEmUnnSLOJBKnoIX07GzXWNEQj3TJ1ObOBZ/XhjqHiW0szeZDMu6TG5Q7V3D2QD1DzhCW9KnnlFyNczT2JyGf+aEZz+nd+r8plHTKsyKFdG5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLHJGcz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLHJGcz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4565C4CEF7;
	Wed,  4 Feb 2026 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218865;
	bh=Bexqxq06BVeipxrDn8n6J+p+yyQL5jvHsYZkmhCwV8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLHJGcz2XzB+DvbE0JoULtvgBuXd0BlyQUqBCnL/WXTbm1qFZHc+gzOOHz89OU7M9
	 5fEVJUYwcKV6YATSx7aoRQ+kJvWRHy9x9CqpiB+1NEWHLjt3Rbd4RZM4f2JrxUWRe+
	 pozyZJzktTt4YFuz2lWlV5E4NpMwMAExbaAbkdX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 83/87] drm/amdgpu/gfx11: adjust KGQ reset sequence
Date: Wed,  4 Feb 2026 15:41:21 +0100
Message-ID: <20260204143849.913879503@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 3eb46fbb601f9a0b4df8eba79252a0a85e983044 ]

Kernel gfx queues do not need to be reinitialized or
remapped after a reset.  This fixes queue reset failures
on APUs.

v2: preserve init and remap for MMIO case.

Fixes: b3e9bfd86658 ("drm/amdgpu/gfx11: add ring reset callbacks")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4789
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b340ff216fdabfe71ba0cdd47e9835a141d08e10)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |   45 +++++++++++++++++----------------
 1 file changed, 24 insertions(+), 21 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -6568,36 +6568,39 @@ static void gfx_v11_0_emit_mem_sync(stru
 static int gfx_v11_0_reset_kgq(struct amdgpu_ring *ring, unsigned int vmid)
 {
 	struct amdgpu_device *adev = ring->adev;
+	bool use_mmio = false;
 	int r;
 
 	if (amdgpu_sriov_vf(adev))
 		return -EINVAL;
 
-	r = amdgpu_mes_reset_legacy_queue(ring->adev, ring, vmid, false);
+	r = amdgpu_mes_reset_legacy_queue(ring->adev, ring, vmid, use_mmio);
 	if (r)
 		return r;
 
-	r = amdgpu_bo_reserve(ring->mqd_obj, false);
-	if (unlikely(r != 0)) {
-		dev_err(adev->dev, "fail to resv mqd_obj\n");
-		return r;
-	}
-	r = amdgpu_bo_kmap(ring->mqd_obj, (void **)&ring->mqd_ptr);
-	if (!r) {
-		r = gfx_v11_0_kgq_init_queue(ring, true);
-		amdgpu_bo_kunmap(ring->mqd_obj);
-		ring->mqd_ptr = NULL;
-	}
-	amdgpu_bo_unreserve(ring->mqd_obj);
-	if (r) {
-		dev_err(adev->dev, "fail to unresv mqd_obj\n");
-		return r;
-	}
+	if (use_mmio) {
+		r = amdgpu_bo_reserve(ring->mqd_obj, false);
+		if (unlikely(r != 0)) {
+			dev_err(adev->dev, "fail to resv mqd_obj\n");
+			return r;
+		}
+		r = amdgpu_bo_kmap(ring->mqd_obj, (void **)&ring->mqd_ptr);
+		if (!r) {
+			r = gfx_v11_0_kgq_init_queue(ring, true);
+			amdgpu_bo_kunmap(ring->mqd_obj);
+			ring->mqd_ptr = NULL;
+		}
+		amdgpu_bo_unreserve(ring->mqd_obj);
+		if (r) {
+			dev_err(adev->dev, "fail to unresv mqd_obj\n");
+			return r;
+		}
 
-	r = amdgpu_mes_map_legacy_queue(adev, ring);
-	if (r) {
-		dev_err(adev->dev, "failed to remap kgq\n");
-		return r;
+		r = amdgpu_mes_map_legacy_queue(adev, ring);
+		if (r) {
+			dev_err(adev->dev, "failed to remap kgq\n");
+			return r;
+		}
 	}
 
 	return amdgpu_ring_test_ring(ring);


