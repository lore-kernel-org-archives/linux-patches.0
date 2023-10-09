Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214D11A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1l6oETzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920A1C433C7;
	Mon,  9 Oct 2023 13:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857843;
	bh=tZ9maNSqMzJyVW0Ml0y4qXaLS9h3uqVuPs6DUz0OgFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1l6oETzGVVf/b4JnfCLeyYF05it/IBO/wY0gnJblkA7aWYkyxbnFgGPxwwE7fOh67
	 kNVF+bsgoU1z6T6NNtOvAoEeCwIWojbngXbMD1nkGn5yTbcb6C3DjxWCI1ndERrqqE
	 mv4eGaJADjkZwWdszsnFVkLJIBXd25ke1COwlP6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/75] iommu/arm-smmu-v3: Set TTL invalidation hint better
Date: Mon,  9 Oct 2023 15:01:33 +0200
Message-ID: <20231009130111.623359861@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 6833b8f2e19945a41e4d5efd8c6d9f4cae9a5b7d ]

When io-pgtable unmaps a whole table, rather than waste time walking it
to find the leaf entries to invalidate exactly, it simply expects
.tlb_flush_walk with nominal last-level granularity to invalidate any
leaf entries at higher intermediate levels as well. This works fine with
page-based invalidation, but with range commands we need to be careful
with the TTL hint - unconditionally setting it based on the given level
3 granule means that an invalidation for a level 1 table would strictly
not be required to affect level 2 block entries. It's easy to comply
with the expected behaviour by simply not setting the TTL hint for
non-leaf invalidations, so let's do that.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/b409d9a17c52dc0db51faee91d92737bb7975f5b.1685637456.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 340ef116d574a..67845f8e1df9f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1884,8 +1884,13 @@ static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
 		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
 		cmd->tlbi.tg = (tg - 10) / 2;
 
-		/* Determine what level the granule is at */
-		cmd->tlbi.ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
+		/*
+		 * Determine what level the granule is at. For non-leaf, io-pgtable
+		 * assumes .tlb_flush_walk can invalidate multiple levels at once,
+		 * so ignore the nominal last-level granule and leave TTL=0.
+		 */
+		if (cmd->tlbi.leaf)
+			cmd->tlbi.ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
 
 		num_pages = size >> tg;
 	}
-- 
2.40.1



