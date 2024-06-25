Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529EA13C90B;
	Tue, 25 Jun 2024 10:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309609; cv=none; b=Jk01dJiKuq25XWkdBflcNJqZVir1GpJ+dFT9uKBGKeLTfFaYesfQGncRjSQQqcwq/ZoeqPhuqZxqfi0ODirWnUnaWr70BA8RNhQwccKGxmq5mEIlFcBpjahXz+D+14Mm7WxzwgJzQgASHJmuTsxca0izP1uGatxBtBkzEe9Y7MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309609; c=relaxed/simple;
	bh=4uiifowXDysQwNTYJz7J5UT1rmNJFhG4lOEFt8gHzi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+k3s8RS0KjXPhGSbSFu8K8QDtrDFcyYDhXOV38IYK7OXdNRIP3ujG+Pcqgcf/x7g8AQlsc8BPsGFYK1+HBP3BifbD1s//KqS5fuavU3yfMs30rfeeL7T/77mtcjUvBvQUIFkJHjhhY6QM7i1q+TkHK6BwWFkZbb4T3rd3FkmHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKQfey9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKQfey9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A62C32781;
	Tue, 25 Jun 2024 10:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309609;
	bh=4uiifowXDysQwNTYJz7J5UT1rmNJFhG4lOEFt8gHzi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKQfey9fLapOgJq61C6cOnZtA97aXK738UhN+p5/SNQAueeLY0QN2cB8PS/iPZcWH
	 98PrPFug2Pbr2E4JwLAedBilc76K86WY56cpJIu9lkRRrUEmeeRNrRm+H/2Oz2kk0t
	 vuxynOFg+id+48AfadKo6pN8aPvSTldHdwjIpFxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/131] iommu/arm-smmu-v3: Free MSIs in case of ENOMEM
Date: Tue, 25 Jun 2024 11:33:08 +0200
Message-ID: <20240625085527.209950808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Aprelkov <aaprelkov@usergate.com>

[ Upstream commit 80fea979dd9d48d67c5b48d2f690c5da3e543ebd ]

If devm_add_action() returns -ENOMEM, then MSIs are allocated but not
not freed on teardown. Use devm_add_action_or_reset() instead to keep
the static analyser happy.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Aleksandr Aprelkov <aaprelkov@usergate.com>
Link: https://lore.kernel.org/r/20240403053759.643164-1-aaprelkov@usergate.com
[will: Tweak commit message, remove warning message]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 82f100e591b5a..45b43f729f895 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3199,7 +3199,7 @@ static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 	smmu->priq.q.irq = msi_get_virq(dev, PRIQ_MSI_INDEX);
 
 	/* Add callback to free MSIs on teardown */
-	devm_add_action(dev, arm_smmu_free_msis, dev);
+	devm_add_action_or_reset(dev, arm_smmu_free_msis, dev);
 }
 
 static void arm_smmu_setup_unique_irqs(struct arm_smmu_device *smmu)
-- 
2.43.0



