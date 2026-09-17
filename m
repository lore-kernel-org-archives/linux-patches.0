Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C564FD274;
	Thu, 17 Sep 2026 17:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664745; cv=none; b=OCKYF+OnxpnbeOtXhdxmxRYInOTpyM122+cYhM2fYvwCx5SJpzMZiHrkN6VYl+cMxiQCIW8APLR9kTisvl2IVbD7ewkj7cAfaJp+XvtaiLRRAQA2n61TF0DpJZGt1U4vZz8At6rI0lQUHHvRugpxFJkg907M0UTn1ssTK2aumL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664745; c=relaxed/simple;
	bh=IGaC9Z3P+KWshi+nkVAGaLZu6Y+bdOcDAH+y5Nv6pTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uO3Zebe/GhAllKnOHwjw1u/NGRcTsUFR0aHC/rA9kKfVb6HqsxKxcyjB2Otysx/pNywP4bqvBYYmMJ0EHcrkpKP/tx2m+DBPumY/xnUCwrf1y6R0oqjdd50vg3cvSMAWRSyuejhYnkhxAump6nfTSI8G7COdgkhml5baF8G/IN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YO6XuYIl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YO6XuYIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7212E1F000FF;
	Thu, 17 Sep 2026 17:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664744;
	bh=m6OvVw4SomxXM8PaWMDAoD92DgM8d/2qz1yihmmAtoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YO6XuYIlfhQv2lB+KRa7q7oCeX3IHaOXIjGm69ubtEKz2pjEZLy6Cx/1B80hH37qK
	 jlPQF840vGUiCvXDXmXHnqr7pmdrNOu3aJ5LJBMFYzm0io9AC+/odn+JP/eDa1EK4F
	 YHeMJjIccBNvJrdzJhcKU64pGMHKHqTrYBS+Kfdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0435/1250] drm/amdkfd: check find_first_zero_bit before __set_bit on kfd->doorbell_bitmap
Date: Thu, 17 Sep 2026 16:03:50 +0100
Message-ID: <20260917151603.804987038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 516bf737a5602875f6c28d1028967837c8edf2c0 ]

If inx from find_first_zero_bit is beyond range not need set doorbell_bitmap.

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2664ce9143d174651a793d96a6a2326050c4f45a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index 05c74887fd6fd..fdcf7f2d1b5b4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -153,14 +153,16 @@ void __iomem *kfd_get_kernel_doorbell(struct kfd_dev *kfd,
 	u32 inx;
 
 	mutex_lock(&kfd->doorbell_mutex);
+
 	inx = find_first_zero_bit(kfd->doorbell_bitmap, PAGE_SIZE / sizeof(u32));
+	if (inx >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS) {
+		mutex_unlock(&kfd->doorbell_mutex);
+		return NULL;
+	}
 
 	__set_bit(inx, kfd->doorbell_bitmap);
 	mutex_unlock(&kfd->doorbell_mutex);
 
-	if (inx >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
-		return NULL;
-
 	*doorbell_off = amdgpu_doorbell_index_on_bar(kfd->adev,
 						     kfd->doorbells,
 						     inx,
-- 
2.53.0



