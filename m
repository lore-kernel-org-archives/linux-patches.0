Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A503FB3B;
	Thu, 13 Feb 2025 15:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459842; cv=none; b=ABym46L9NnvLPcgY+2XZDTSnleEgVLijtFgc2PwpW1unEk8z/2woFpPXooXYPu3FygfgNjuTsZD9RpRrvY2mJLsG2ZcEJ1lfzDs1XjGHdz/54MEzd7sbIAMzCcVhTr0E3f6iwmtrWOxCrXVvkvH3eFpiErfmF+uBtaQ8M2PgY1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459842; c=relaxed/simple;
	bh=q9xqjp/z9uUiYN5APOT8EWhStaT05SyDBPl9xKMPvrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8ZGLRTOeWI8mUW/7Kt5g1kb9e2Vm9K2qxmI8DASDC6G6eIg/jxvzoh3xsVi0KwRooGOweCGzDA+13U8cQw/TIeihs94WzaWvkwgEnGrAPtKU9PSp81Jj2LpHI42cTzuKYxbMlUx1TvcjNrfcTckcy7RNfAi25ay5UE8daZvF98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8gtgeE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8gtgeE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEB2C4CED1;
	Thu, 13 Feb 2025 15:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459841;
	bh=q9xqjp/z9uUiYN5APOT8EWhStaT05SyDBPl9xKMPvrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8gtgeE70HCpiNjDkWBSoK5AU3nCg41YJd8fsbRHgD0hzE4ZDFhjce2fv1Id5Gond
	 dcRwsp1RZr3t2X624CsyvccfItZiuj4CfxujmDRdfX+QrqmwLH1J1vmE870UG/Eu09
	 tEeE5N4XtU8/YC9LudgSie8I4dsXdKaCpKJr7yVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Kalinowski <ikalinowski@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.13 348/443] iommu/tegra241-cmdqv: Read SMMU IDR1.CMDQS instead of hardcoding
Date: Thu, 13 Feb 2025 15:28:33 +0100
Message-ID: <20250213142454.049138184@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



