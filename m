Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3724B46AA62;
	Tue, 21 Jul 2026 15:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648064; cv=none; b=L0IKMaMho58lbPds1aLh8x2aWs3ya2uo6rnttHJgV4XfcDFpeD5rZgJug0BlG8Pygbo8YY3Qgx6DMxVWUmDFxIuZ++T0JY9eiHBlHgQe/dGT5qkj+j0vcKD/+k5mkGhwrkIOLukebwRjiHjeJ0e8MuGWM+14Uh104ZUMJ+rj4GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648064; c=relaxed/simple;
	bh=pEeQOCndk5CJp/95e8ezMh9AwUt1Ps3WbgrAWOVstmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvxByTls9/bSDUIA740yI9QuM4CHmSnvZCEYOQhgItZeEonfsrp6U2sJ9lNM1x7xKsqPIMuJ3Ydy3tOUnGp9KdMqHhb0BVSjXIu1fHtVMGVo1aq5G/nwWkU7DpZlDhsuRLi/TLXSwJcq3J+O5mPbYfrea7W4D2e8zCfVDSuXYPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpebUAUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpebUAUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1871F000E9;
	Tue, 21 Jul 2026 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648063;
	bh=B44INflThN1+iD93X/nmNmJ3GSRzIRMUI/5CR99VoWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CpebUAUIrzLnIpi6WzadWPRpwXBdZ3Cns9vBVXnrca92HCOo95LlYdAU1Ey1cpDgm
	 rsg0XszaPujS9ZB3S2lsEKbs3OtppVVCxpQQKwwjX04N1twl0MsozTNyedrhoQlfC6
	 qqHwaxPFu82VG/fvLefzu5ZOyvzg3iS6ainbdexc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0058/2077] accel/amdxdna: Fix memory leak in amdxdna_iommu_alloc()
Date: Tue, 21 Jul 2026 16:55:31 +0200
Message-ID: <20260721152554.062583515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 432fafdc9a3122a7bee5b2bfd23dcf2dc262a3d7 ]

In amdxdna_iommu_alloc(), if iommu_map() fails after successfully
allocating both iova and cpu_addr, the code jumps to free_iova
which only frees the iova, leaking the allocated pages.

Fixes: ece3e8980907 ("accel/amdxdna: Allow forcing IOVA-based DMA via module parameter")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260416-amdxdna-v1-1-30c13008365c@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_iommu.c b/drivers/accel/amdxdna/amdxdna_iommu.c
index 2676cfcfabee0d..5a9f06183487fd 100644
--- a/drivers/accel/amdxdna/amdxdna_iommu.c
+++ b/drivers/accel/amdxdna/amdxdna_iommu.c
@@ -117,10 +117,12 @@ void *amdxdna_iommu_alloc(struct amdxdna_dev *xdna, size_t size, dma_addr_t *dma
 			iova_align(&xdna->iovad, size),
 			IOMMU_READ | IOMMU_WRITE, GFP_KERNEL);
 	if (ret)
-		goto free_iova;
+		goto free_cpu_addr;
 
 	return cpu_addr;
 
+free_cpu_addr:
+	free_pages((unsigned long)cpu_addr, get_order(size));
 free_iova:
 	__free_iova(&xdna->iovad, iova);
 	return ERR_PTR(ret);
-- 
2.53.0



