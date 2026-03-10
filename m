Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FBD2BF3E2;
	Tue, 10 Mar 2026 11:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141068; cv=none; b=Tn/Wlc3FmYzaapUVpW+QBUHkoUWNNSqnNyM2GpVmbMeK6uZfaJLyqkX3u5/LKx4h7Bf+ZhGBIdHFcUOSvUEk8oor2uYJukp9e5eBPFBkA8NA+D7EONe/qmJ70fg+bZZzNzWlRaJ3n6qQGvSQN2Vm5IDBRNgFTtCG7LparPYNt6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141068; c=relaxed/simple;
	bh=avD9sZeolHDwlxOVhN0g1MIZEY5uAja4XjIk/DCrDHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PtiASdLtM+zwPjc6d8gKqANewsOoBy641lqixju5TsXEqOzzJ6whRjZ/fB8sStBYQXG/9zuPlY7uqTQOVjFEFuvukYyuIq8dfNRYWYVNQB4vm8ZwLpgEnnBRbPuoC0HHYWAceG7Ft5e8A+Zu8nLxXVh2qIotbvbSxy7/p6uJ8FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/U3e9Rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/U3e9Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6537C2BC86;
	Tue, 10 Mar 2026 11:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141067;
	bh=avD9sZeolHDwlxOVhN0g1MIZEY5uAja4XjIk/DCrDHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/U3e9RhiZcJqet5Qx/Mu6Oydy3JB3z3k61/oo8UqmwCyVlpQfvmCju60J/IGbvI2
	 dedIc+NozH1nwOQX0C6ZUlFCKTe5bT59LGjINZPZE5JgnI2/RmG1KQxa6+8nMtGxuF
	 QX+rm4wkF/OOBppIlMuXbZClSap32q5bIO/gxvUoyKUL9c4ZGMvqRnpd/59ot2uscW
	 KzomedqGoUYl8jd7kovJvJ1PEnAOCimR7sVRGD9XM0E/G3rtNDSQxp/qomxbCSjvwI
	 SR66J3sI213XwG3vY3CnBgMkR3Jr/N8t5wt2xJAASloti5V7ZpRmfu7ysRuJoBg5vS
	 V2Vt96kxvIvJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 067/311] drm/amdgpu/userq: Do not allow userspace to trivially triger kernel warnings
Date: Tue, 10 Mar 2026 07:01:54 -0400
Message-ID: <8a555539c1552465319a69309e0c755540c16fa8.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 85e9edc1cb6ff..f61886745e33d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -830,7 +830,7 @@ int amdgpu_userq_wait_ioctl(struct drm_device *dev, void *data,
 
 			dma_resv_for_each_fence(&resv_cursor, gobj_read[i]->resv,
 						DMA_RESV_USAGE_READ, fence) {
-				if (WARN_ON_ONCE(num_fences >= wait_info->num_fences)) {
+				if (num_fences >= wait_info->num_fences) {
 					r = -EINVAL;
 					goto free_fences;
 				}
@@ -847,7 +847,7 @@ int amdgpu_userq_wait_ioctl(struct drm_device *dev, void *data,
 
 			dma_resv_for_each_fence(&resv_cursor, gobj_write[i]->resv,
 						DMA_RESV_USAGE_WRITE, fence) {
-				if (WARN_ON_ONCE(num_fences >= wait_info->num_fences)) {
+				if (num_fences >= wait_info->num_fences) {
 					r = -EINVAL;
 					goto free_fences;
 				}
@@ -871,7 +871,7 @@ int amdgpu_userq_wait_ioctl(struct drm_device *dev, void *data,
 					goto free_fences;
 
 				dma_fence_unwrap_for_each(f, &iter, fence) {
-					if (WARN_ON_ONCE(num_fences >= wait_info->num_fences)) {
+					if (num_fences >= wait_info->num_fences) {
 						r = -EINVAL;
 						goto free_fences;
 					}
@@ -895,7 +895,7 @@ int amdgpu_userq_wait_ioctl(struct drm_device *dev, void *data,
 			if (r)
 				goto free_fences;
 
-			if (WARN_ON_ONCE(num_fences >= wait_info->num_fences)) {
+			if (num_fences >= wait_info->num_fences) {
 				r = -EINVAL;
 				goto free_fences;
 			}
-- 
2.51.0

