Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185242222CB;
	Mon, 29 Dec 2025 16:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025438; cv=none; b=U2PNga+71rrVtS9+1pV1/RG2UJ3P1MgRTx+NtCOMz8YuKXftEcrfLY6AhsY/cvaTLzoCUSxR7bvhPF7VmMCwXuFAdiNQLvfZlERKE4hZzVmhcDRrGuGxpTpGhMHDxQuVAJTJ8u+z6OKPIGlL5Yx0baIvo/c++9A4cNE7roKrLcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025438; c=relaxed/simple;
	bh=dheCsTu0yyanaYCZgt0zrLoFJ+kz5no97/REEwo8iKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWU14cUzpzcIiVUPN1ZG+HMWTdmR+PFSh7q5PkCfBvAMZtFnZ5k4l6EKs6c68XliNthxtVDTHHiv6UyuTVFpLNsagaHTWR9NHLQVF2UH88YEUmLBth8csnK789jgATQMNMuj54ohJCjPWhDW17ZkT0t07qjDOF3hln93LBeYwXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSZGBbuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSZGBbuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D35C4CEF7;
	Mon, 29 Dec 2025 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025437;
	bh=dheCsTu0yyanaYCZgt0zrLoFJ+kz5no97/REEwo8iKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSZGBbuZLynWntw9HEGEdGsxSg3w/QE0g27D6A6UW6mLF10glHRbb8+nDefdOU7eO
	 3Urh+YPKE2kVexWWNlhLzy0+PQ9accLi5q2NXNK9scXrpErPyEERe6fMC4JOajI7cR
	 hYFjVIt6U2n05WbVz7Qa1pPgNgtyjvI/Ev4+PV/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 214/430] drm/msm: adreno: fix deferencing ifpc_reglist when not declared
Date: Mon, 29 Dec 2025 17:10:16 +0100
Message-ID: <20251229160732.228457729@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 129049d4fe22c998ae9fd1ec479fbb4ed5338c15 ]

On plaforms with an a7xx GPU not supporting IFPC, the ifpc_reglist
if still deferenced in a7xx_patch_pwrup_reglist() which causes
a kernel crash:
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
...
pc : a6xx_hw_init+0x155c/0x1e4c [msm]
lr : a6xx_hw_init+0x9a8/0x1e4c [msm]
...
Call trace:
  a6xx_hw_init+0x155c/0x1e4c [msm] (P)
  msm_gpu_hw_init+0x58/0x88 [msm]
  adreno_load_gpu+0x94/0x1fc [msm]
  msm_open+0xe4/0xf4 [msm]
  drm_file_alloc+0x1a0/0x2e4 [drm]
  drm_client_init+0x7c/0x104 [drm]
  drm_fbdev_client_setup+0x94/0xcf0 [drm_client_lib]
  drm_client_setup+0xb4/0xd8 [drm_client_lib]
  msm_drm_kms_post_init+0x2c/0x3c [msm]
  msm_drm_init+0x1a4/0x228 [msm]
  msm_drm_bind+0x30/0x3c [msm]
...

Check the validity of ifpc_reglist before deferencing the table
to setup the register values.

Fixes: a6a0157cc68e ("drm/msm/a6xx: Enable IFPC on Adreno X1-85")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/688944/
Message-ID: <20251117-topic-sm8x50-fix-a6xx-non-ifpc-v1-1-e4473cbf5903@linaro.org>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 6f7ed07670b1..d1eaa849b197 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -837,15 +837,17 @@ static void a7xx_patch_pwrup_reglist(struct msm_gpu *gpu)
 	lock->gpu_req = lock->cpu_req = lock->turn = 0;
 
 	reglist = adreno_gpu->info->a6xx->ifpc_reglist;
-	lock->ifpc_list_len = reglist->count;
+	if (reglist) {
+		lock->ifpc_list_len = reglist->count;
 
-	/*
-	 * For each entry in each of the lists, write the offset and the current
-	 * register value into the GPU buffer
-	 */
-	for (i = 0; i < reglist->count; i++) {
-		*dest++ = reglist->regs[i];
-		*dest++ = gpu_read(gpu, reglist->regs[i]);
+		/*
+		 * For each entry in each of the lists, write the offset and the current
+		 * register value into the GPU buffer
+		 */
+		for (i = 0; i < reglist->count; i++) {
+			*dest++ = reglist->regs[i];
+			*dest++ = gpu_read(gpu, reglist->regs[i]);
+		}
 	}
 
 	reglist = adreno_gpu->info->a6xx->pwrup_reglist;
-- 
2.51.0



