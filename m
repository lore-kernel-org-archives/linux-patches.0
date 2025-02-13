Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BC826B085;
	Thu, 13 Feb 2025 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458136; cv=none; b=Bs38KMP3dD2f5aN51MrkLkXCY/mYM/S5woldSC5fgDxYRKByQFAd9DmuEjVBozX66grGMDNybyCEkOZhfiWWG3+mkm65Q/6mjLaWY/KKtro7fjsiCiAMt5gBo/wMQxTDESiFvKModsNsgDnPlhcSkpIeKmWZgUYJIoG19XXxnLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458136; c=relaxed/simple;
	bh=D7x2CvPRlS/BFYbug48ir+9pYbgpqMnKrtq8K4nYF8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCG44hg9dNYVKTa7Sgms/jxQlt2UeG2omcqi7GhV6+2cOhg8sgGr9TDgIX4vVYDk1sdNM9sMVbPzGj3imuxbR7t4tKmAb/WClGezfv1LvI7L32NFrwl3jIEREeWy8GSFB9kJikvwLSELJf8hC0oCyYWZOFphwnpMijyQjnsUau4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8kGcgYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8kGcgYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89ACC4CED1;
	Thu, 13 Feb 2025 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458136;
	bh=D7x2CvPRlS/BFYbug48ir+9pYbgpqMnKrtq8K4nYF8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8kGcgYFYwTQ8lAB1arHOrk/vzC18RfGrX0t//sR2R3nsQgcFU2ENww1xrEc6COL6
	 mT1Qj8JmRJmM5PAECUznZziCAndxBWlxytV270xLjfXV63/kUlThp5cUvmLL+Fu6mN
	 EMdQ0md/5CTcy8d+n6Kxx9Ilg2GFreI6A3AoAY2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Kalinowski <ikalinowski@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 313/422] iommu/tegra241-cmdqv: Read SMMU IDR1.CMDQS instead of hardcoding
Date: Thu, 13 Feb 2025 15:27:42 +0100
Message-ID: <20250213142448.622416441@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit e94dc6ddda8dd3770879a132d577accd2cce25f9 upstream.

The hardware limitation "max=19" actually comes from SMMU Command Queue.
So, it'd be more natural for tegra241-cmdqv driver to read it out rather
than hardcoding it itself.

This is not an issue yet for a kernel on a baremetal system, but a guest
kernel setting the queue base/size in form of IPA/gPA might result in a
noncontiguous queue in the physical address space, if underlying physical
pages backing up the guest RAM aren't contiguous entirely: e.g. 2MB-page
backed guest RAM cannot guarantee a contiguous queue if it is 8MB (capped
to VCMDQ_LOG2SIZE_MAX=19). This might lead to command errors when HW does
linear-read from a noncontiguous queue memory.

Adding this extra IDR1.CMDQS cap (in the guest kernel) allows VMM to set
SMMU's IDR1.CMDQS=17 for the case mentioned above, so a guest-level queue
will be capped to maximum 2MB, ensuring a contiguous queue memory.

Fixes: a3799717b881 ("iommu/tegra241-cmdqv: Fix alignment failure at max_n_shift")
Reported-by: Ian Kalinowski <ikalinowski@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Link: https://lore.kernel.org/r/20241219051421.1850267-1-nicolinc@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index c8ec74f089f3..dc7af970e9d0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -79,7 +79,6 @@
 #define TEGRA241_VCMDQ_PAGE1(q)		(TEGRA241_VCMDQ_PAGE1_BASE + 0x80*(q))
 #define  VCMDQ_ADDR			GENMASK(47, 5)
 #define  VCMDQ_LOG2SIZE			GENMASK(4, 0)
-#define  VCMDQ_LOG2SIZE_MAX		19
 
 #define TEGRA241_VCMDQ_BASE		0x00000
 #define TEGRA241_VCMDQ_CONS_INDX_BASE	0x00008
@@ -505,12 +504,15 @@ static int tegra241_vcmdq_alloc_smmu_cmdq(struct tegra241_vcmdq *vcmdq)
 	struct arm_smmu_cmdq *cmdq = &vcmdq->cmdq;
 	struct arm_smmu_queue *q = &cmdq->q;
 	char name[16];
+	u32 regval;
 	int ret;
 
 	snprintf(name, 16, "vcmdq%u", vcmdq->idx);
 
-	/* Queue size, capped to ensure natural alignment */
-	q->llq.max_n_shift = min_t(u32, CMDQ_MAX_SZ_SHIFT, VCMDQ_LOG2SIZE_MAX);
+	/* Cap queue size to SMMU's IDR1.CMDQS and ensure natural alignment */
+	regval = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
+	q->llq.max_n_shift =
+		min_t(u32, CMDQ_MAX_SZ_SHIFT, FIELD_GET(IDR1_CMDQS, regval));
 
 	/* Use the common helper to init the VCMDQ, and then... */
 	ret = arm_smmu_init_one_queue(smmu, q, vcmdq->page0,
-- 
2.48.1



