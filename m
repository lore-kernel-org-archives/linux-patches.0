Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03C21F75AE;
	Tue,  3 Dec 2024 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241505; cv=none; b=MEEKziiRamuAO5LWiwU/UPzBzjxB8ifARZ22pPAiyfcpfiTCceu+6Mu2IhNcZs+kmx8IQeNAVNnXvAURw8EngEGNT2ASWoyUhlUUixQ6h9DMnIMB06h/A/JFxmla2e5LexbPyXQADRp7H68rrL+spDxmaQmS3Bq5WYK6OlZMG3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241505; c=relaxed/simple;
	bh=ael25QfdyRmdMYzNuAOub2aIEIb9wKH0ZBi1B3jXeSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZwNBus4/8iFNoWZp8HjQuhgzIGqXmJyJvRiNHAJuYZdDT8eID20nEnZ4QGg2VeLYiHcmpQG4JkkDDJqdqvueXNwiAfnHnIH65G5ZSnfEBlJG0wr8WifQdTb5zVdyjdbnauZDh3Sy35hYqHQn/vcjNAYnSq8eL5qhAryMSoAeSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIkavq03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIkavq03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA46C4CECF;
	Tue,  3 Dec 2024 15:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241505;
	bh=ael25QfdyRmdMYzNuAOub2aIEIb9wKH0ZBi1B3jXeSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIkavq03RsEU0OCsDPP5tp7LKLn6WSoMF5FtZiNSRnO39g3qYK4uTGgA+gZHaatDB
	 1EVgoUuklEIG/P6JK9FIujdc5zngv5uwTni1eNz0EyBJPlwbPNwX4t98N5Krr54dd3
	 PkkIQESssdH2DyOGTK1eK0JaD7truxjekX8+4Vzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 437/826] iommu/tegra241-cmdqv: Fix alignment failure at max_n_shift
Date: Tue,  3 Dec 2024 15:42:44 +0100
Message-ID: <20241203144800.809722948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit a3799717b881aa0f4e722afb70e7b8ba84ae4f36 ]

When configuring a kernel with PAGE_SIZE=4KB, depending on its setting of
CONFIG_CMA_ALIGNMENT, VCMDQ_LOG2SIZE_MAX=19 could fail the alignment test
and trigger a WARN_ON:
    WARNING: at drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c:3646
    Call trace:
     arm_smmu_init_one_queue+0x15c/0x210
     tegra241_cmdqv_init_structures+0x114/0x338
     arm_smmu_device_probe+0xb48/0x1d90

Fix it by capping max_n_shift to CMDQ_MAX_SZ_SHIFT as SMMUv3 CMDQ does.

Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Link: https://lore.kernel.org/r/20241111030226.1940737-1-nicolinc@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index a243c543598ce..6b479592140c4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -509,7 +509,8 @@ static int tegra241_vcmdq_alloc_smmu_cmdq(struct tegra241_vcmdq *vcmdq)
 
 	snprintf(name, 16, "vcmdq%u", vcmdq->idx);
 
-	q->llq.max_n_shift = VCMDQ_LOG2SIZE_MAX;
+	/* Queue size, capped to ensure natural alignment */
+	q->llq.max_n_shift = min_t(u32, CMDQ_MAX_SZ_SHIFT, VCMDQ_LOG2SIZE_MAX);
 
 	/* Use the common helper to init the VCMDQ, and then... */
 	ret = arm_smmu_init_one_queue(smmu, q, vcmdq->page0,
-- 
2.43.0



