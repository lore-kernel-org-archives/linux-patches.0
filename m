Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0F23AEF2D;
	Thu, 17 Sep 2026 18:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668268; cv=none; b=IQi9RW5FuSbUAFTTGkWqL3mJ+yzl/SG6IGIf0Put0n7L0ynoAb7q+7XDdMPAyA+pujr0YheUFcfz33i2/3dXuYKfbv5Mj3+JTVqnBvPbDdEz3iRNQDRMTNHi6k1Ne9Ay5tVKt8kPuhpuTLv10yh9S9pq/F2xRjcqXiwuYr61dgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668268; c=relaxed/simple;
	bh=xK6up6Y7i2LJklJ8oMKr1P0nze12U2Cpm36CclmO3J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jC1W/6yc4trP/rtQGYVB2Wz9KAzkH/dJdtYpBd0EbPkpCa5YhX/4bPXOeX6zy52KTiA3+td+3I1XTZ1bnCILH2TIsJklIPBy5/0+36oI3uKNh4fumASIfj1POF1YZ87QTPD1FrU4kkAGnDGJ1wII67qWCt+++mpCtCIFfS0kFeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiDtD3I6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiDtD3I6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022D01F000FF;
	Thu, 17 Sep 2026 18:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668266;
	bh=YFwRX/Qm/EJ0eXAVwf2m+7ert/q95eiehJ2LO+Uj5vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiDtD3I6BOU7p2JiQnMhPr2LaBygjoPGXKFGsVq7/pBdCskfj/g+OvSWnCwonbmdp
	 uh5OXHyHMv5/50TsYV2nxztCmdElbStyKLmj6L7xmgvZsnKWjcb6pe+TTSJ9EexxGH
	 +M4LApX1OOWqHnqicHX407X/BnKtQE8ECMYtB00Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0330/1102] drm/amdkfd: check find_first_zero_bit before __set_bit on kfd->doorbell_bitmap
Date: Thu, 17 Sep 2026 16:04:33 +0100
Message-ID: <20260917151547.917458684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



