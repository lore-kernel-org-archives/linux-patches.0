Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E243803CD;
	Tue, 10 Mar 2026 11:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141924; cv=none; b=DwER2fTVuY2c3sU959KvjVz8tpaR5rVn/ER0el2HzHGBIlzudWM2yNFOgju4f7JmbhfdfXk+i6A8dZ0szp5CCkEC1yfbP3VK/0T6GBN+k6R62SWALNJOt9Lj4lWWQehhgcwaOEGCB21wk31DMhsEfWzv95mDU5gcCYro3cKWYbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141924; c=relaxed/simple;
	bh=BLXrZOdh6J5LKfL+wresQSvJ657X1tqO8/6I/ccrxow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5OUrmnRok7k3lbKrDiOx63cBopLxrZy/SbqHXaP0YyyOICuNqPzayFRNOQ/nAoTq67gVE+u+6qkfD3LFC8vsVo5xPMv4ycR/0oWlAiW+/dSMmzhBLdfpmZyO1EQafzs8Evwz2bTXFnNLCnTcovraR1TAN5NkRA1KKyuw7OdBRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bwn2QMsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bwn2QMsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AC1C19423;
	Tue, 10 Mar 2026 11:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141924;
	bh=BLXrZOdh6J5LKfL+wresQSvJ657X1tqO8/6I/ccrxow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bwn2QMsFDy9xFGFknwQg7yJG/K7uj8eurvB7JFTW1GuGC3e4VDygvGtIo3XNpp6wQ
	 RwKhCSbjNSzoDp1QMx+f+tVC1PuWQtPyPUT0qOUzFTa3EbRtsd+Ih1Kq7gTWjckLCu
	 J1u7Wrp8Wabjs/F+blNr7uZEHtxayrmzkKXRAWpvLHRN+/Afvnocp3IcTvKqkqKws2
	 cuthubFTrUZTfFa9p0/tnRQTT3mqLbEOm2+GyaNeRLxt7sPvcKLE5WhRwKMgRQYNtS
	 fI5qVHOs1TMKHkdqZtn45vkwx1PSeYGVsGTQ4IL2vkiDomjIHKWcb00Zwc3lEQ/QeF
	 F1iJiYrDFiB7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/314] drm/amdgpu/userq: Do not allow userspace to trivially triger kernel warnings
Date: Tue, 10 Mar 2026 07:15:07 -0400
Message-ID: <c4817aa4826452ae3ce08138a2d9a67f57ea76ca.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit 7b7d7693a55d606d700beb9549c9f7f0e5d9c24f ]

Userspace can either deliberately pass in the too small num_fences, or the
required number can legitimately grow between the two calls to the userq
wait ioctl. In both cases we do not want the emit the kernel warning
backtrace since nothing is wrong with the kernel and userspace will simply
get an errno reported back. So lets simply drop the WARN_ONs.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: a292fdecd728 ("drm/amdgpu: Implement userqueue signal/wait IOCTL")
Cc: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2c333ea579de6cc20ea7bc50e9595ef72863e65c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index 5c181ac75d548..ead1538974454 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -829,7 +829,7 @@ int amdgpu_userq_wait_ioctl(struct drm_device *dev, void *data,
 
 			dma_resv_for_each_fence(&resv_cursor, gobj_read[i]->resv,
 						DMA_RESV_USAGE_READ, fence) {
-				if (WARN_ON_ONCE(num_fences >= wait_info->num_fences)) {
+				if (num_fences >= wait_info->num_fences) {
 					r = -EINVAL;
 					goto free_fences;
 				}
@@ -846,7 +846,7 @@ int amdgpu_userq_wait_ioctl(struct drm_device *dev, void *data,
 
 			dma_resv_for_each_fence(&resv_cursor, gobj_write[i]->resv,
 						DMA_RESV_USAGE_WRITE, fence) {
-				if (WARN_ON_ONCE(num_fences >= wait_info->num_fences)) {
+				if (num_fences >= wait_info->num_fences) {
 					r = -EINVAL;
 					goto free_fences;
 				}
@@ -870,7 +870,7 @@ int amdgpu_userq_wait_ioctl(struct drm_device *dev, void *data,
 					goto free_fences;
 
 				dma_fence_unwrap_for_each(f, &iter, fence) {
-					if (WARN_ON_ONCE(num_fences >= wait_info->num_fences)) {
+					if (num_fences >= wait_info->num_fences) {
 						r = -EINVAL;
 						goto free_fences;
 					}
@@ -894,7 +894,7 @@ int amdgpu_userq_wait_ioctl(struct drm_device *dev, void *data,
 			if (r)
 				goto free_fences;
 
-			if (WARN_ON_ONCE(num_fences >= wait_info->num_fences)) {
+			if (num_fences >= wait_info->num_fences) {
 				r = -EINVAL;
 				goto free_fences;
 			}
-- 
2.51.0

