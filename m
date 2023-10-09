Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C7217990
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5UHCfis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2925C433C9;
	Mon,  9 Oct 2023 13:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856886;
	bh=YfDhM6iMnY0xzzhZps3W+qIyAzMj8ZLuUKW40U9FG4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5UHCfis30XJrHH7RfzfVJiVOvY/ZKYucKCQqq3EESpYjgrOAtnK0Q46POMDLdVjS
	 sfNNs0BIW34esunHFnPDpM7wEyHeIVSqUNE5u032WrK/etxSCwS5K1b9WAEbjikBsm
	 BN058yhPVyd0FIL1RtcanJVekLCWdjO+2P8+YPSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Zhu <zhurui3@huawei.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 023/163] iommu/arm-smmu-v3: Avoid constructing invalid range commands
Date: Mon,  9 Oct 2023 14:59:47 +0200
Message-ID: <20231009130124.649720603@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit eb6c97647be227822c7ce23655482b05e348fba5 ]

Although io-pgtable's non-leaf invalidations are always for full tables,
I missed that SVA also uses non-leaf invalidations, while being at the
mercy of whatever range the MMU notifier throws at it. This means it
definitely wants the previous TTL fix as well, since it also doesn't
know exactly which leaf level(s) may need invalidating, but it can also
give us less-aligned ranges wherein certain corners may lead to building
an invalid command where TTL, Num and Scale are all 0. It should be fine
to handle this by over-invalidating an extra page, since falling back to
a non-range command opens up a whole can of errata-flavoured worms.

Fixes: 6833b8f2e199 ("iommu/arm-smmu-v3: Set TTL invalidation hint better")
Reported-by: Rui Zhu <zhurui3@huawei.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/b99cfe71af2bd93a8a2930f20967fb2a4f7748dd.1694432734.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9b0dc35056019..6ccbae9b93a14 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1895,18 +1895,23 @@ static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
 		/* Get the leaf page size */
 		tg = __ffs(smmu_domain->domain.pgsize_bitmap);
 
+		num_pages = size >> tg;
+
 		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
 		cmd->tlbi.tg = (tg - 10) / 2;
 
 		/*
-		 * Determine what level the granule is at. For non-leaf, io-pgtable
-		 * assumes .tlb_flush_walk can invalidate multiple levels at once,
-		 * so ignore the nominal last-level granule and leave TTL=0.
+		 * Determine what level the granule is at. For non-leaf, both
+		 * io-pgtable and SVA pass a nominal last-level granule because
+		 * they don't know what level(s) actually apply, so ignore that
+		 * and leave TTL=0. However for various errata reasons we still
+		 * want to use a range command, so avoid the SVA corner case
+		 * where both scale and num could be 0 as well.
 		 */
 		if (cmd->tlbi.leaf)
 			cmd->tlbi.ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
-
-		num_pages = size >> tg;
+		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
+			num_pages++;
 	}
 
 	cmds.num = 0;
-- 
2.40.1



