Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD0B36405A;
	Wed, 20 May 2026 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295166; cv=none; b=IdmGItwFt+EWNQ0oZbKHB74JJ8jhmUzAhHGe++dnPtTsHUwSnIx3IF6YlakUB747o4P/Vhk2u5+ForYfrzBmV35DfFjE1j7q8naw/Hs19ZRXjQcOGOlKTn9zkrie4KC8nxNq96okAP+Wxp4f+NdQstHhUMuuEknLcbnCTv8ZsD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295166; c=relaxed/simple;
	bh=RgMXSFEopIbsZtjHegEblDLiOYQBgBw/I+eE3GlnpKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBW/k25uS+jrnJqeORFISq/HCTgUl/JRa0GfU6749aN0K09slKSFZaUwDy499X7UsPHyF53nft3+ZD4rUfsfUd5RujYCxirhBhoQs2ZasD1engR6Cig2MoAAfb1CT1/RS9AJEOXIS44Mpaw5I/9Ow+FJxjXG+flH6GVHIzt2/FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luiUTNci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luiUTNci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548E01F00893;
	Wed, 20 May 2026 16:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295163;
	bh=gynRydofAxmW8VO1puS0eRfr0Yu6S5Syu/e0/oPLXOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luiUTNci47b8MAsEVXXtblKZ43oqPWYCk1x9y8bUNNJS4AcH4DvobzO17VH303PKP
	 RbuYGYHDPNWmrbtL1XeRspA8gjyzDlWFRjmzgaQkRvTi2gfz9YUQAm4Kyg2Zm+1Y5I
	 RKF3jE8r8FQWCmJIwnNjpvaZbc84rHttAJLQSLvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0316/1146] iommu/tegra241-cmdqv: Set supports_cmd op in tegra241_vcmdq_hw_init()
Date: Wed, 20 May 2026 18:09:26 +0200
Message-ID: <20260520162155.349400778@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit 803e41f36d227022ab9bbe780c82283fd4713b2e ]

vintf->hyp_own is finalized in tegra241_vintf_hw_init(). On the other hand,
tegra241_vcmdq_alloc_smmu_cmdq() is called via an init_structures callback,
which is earlier than tegra241_vintf_hw_init().

This results in the supports_cmd op always being set to the guest function,
although this doesn't break any functionality nor have some noticeable perf
impact since non-invalidation commands are not issued in the perf sensitive
context.

Fix this by moving supports_cmd to tegra241_vcmdq_hw_init().

After this change,
 - For a guest kernel, this will be a status quo
 - For a host kernel, non-invalidation commands will be issued to VCMDQ(s)

Fixes: a9d40285bdef ("iommu/tegra241-cmdqv: Limit CMDs for VCMDQs of a guest owned VINTF")
Reported-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Shameer Kolothum <skolothumtho@nvidia.com>
Closes: https://lore.kernel.org/qemu-devel/CH3PR12MB754836BEE54E39B30C7210C0AB44A@CH3PR12MB7548.namprd12.prod.outlook.com/
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Shameer Kolothum <skolothumtho@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 6fe5563eaf9eb..83f6e9f6c51d6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -479,6 +479,10 @@ static int tegra241_vcmdq_hw_init(struct tegra241_vcmdq *vcmdq)
 	/* Reset VCMDQ */
 	tegra241_vcmdq_hw_deinit(vcmdq);
 
+	/* vintf->hyp_own is a HW state finalized in tegra241_vintf_hw_init() */
+	if (!vcmdq->vintf->hyp_own)
+		vcmdq->cmdq.supports_cmd = tegra241_guest_vcmdq_supports_cmd;
+
 	/* Configure and enable VCMDQ */
 	writeq_relaxed(vcmdq->cmdq.q.q_base, REG_VCMDQ_PAGE1(vcmdq, BASE));
 
@@ -639,9 +643,6 @@ static int tegra241_vcmdq_alloc_smmu_cmdq(struct tegra241_vcmdq *vcmdq)
 	q->q_base = q->base_dma & VCMDQ_ADDR;
 	q->q_base |= FIELD_PREP(VCMDQ_LOG2SIZE, q->llq.max_n_shift);
 
-	if (!vcmdq->vintf->hyp_own)
-		cmdq->supports_cmd = tegra241_guest_vcmdq_supports_cmd;
-
 	return arm_smmu_cmdq_init(smmu, cmdq);
 }
 
-- 
2.53.0



