Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82DC1C5799;
	Sat, 12 Sep 2026 18:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239432; cv=none; b=E1RUsARwrc4TdiH9WH7r1Kl4s0CqCUHsIIL/yGV4bzQLuJO2aBuZgUmXjaCV8G3gutEDdlp2bGUTEAI4r3s3mXporPESaRGB23BO2ybuhR4AZjrQtdSIDeWA8BTbXRhZeMRHHrE2arALjN0KaLTfLWvF3xARO7f0rRW3oUkf81U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239432; c=relaxed/simple;
	bh=P6wbgT+j5A+O8I76tfxSDwBvjHNuofg7kCQUJLT3yM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sl0qQex5RZw4mdZsHl/dIv1fUFRrgN/UgdamsBsTJyvDSm3NiyJ5ZHERSTJVFCVZltFUtXqB1NLTVkjCwSMg/giZPcdnY+s3JdM602s2+UiPLadnxWlrbboNmmMGo8qNaekeoOFYRLxfb4rHFGdO0b8fTO8sttMFVItnzo2MtGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uukRbrJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uukRbrJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B7C1F000FF;
	Sat, 12 Sep 2026 18:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239431;
	bh=MmLBJVNagFD8auyP2064IbrzFYguRdmYBp2g+aENwFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uukRbrJwx50yqzGh0tGlt5umnY0KuL23ymNk5Al2O0ahRJp6UpobYc5GVttva1zdJ
	 RAuc2Us9aZZZptVIcv87H/A4vjuCrnp9rU093lj0NuaFtO8PvQZcMOpAiog/X9E9m0
	 mgHTqoEsZCqXQL5jgZZY9ZLr6c+MMsJZMWcAuxz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 662/935] iommu/arm-smmu-v3: Convert to use atomic poll timeout
Date: Sat, 12 Sep 2026 09:01:32 +0200
Message-ID: <20260912065542.024408014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranjal Shrivastava <praan@google.com>

[ Upstream commit eced8058c82a3a81ae480a6546e2da32100dddfa ]

The arm_smmu_write_reg_sync() helper is currently implemented using
readl_relaxed_poll_timeout() (that relies on usleep_range() internally)
which becomes a critical issue when used in the gerror irq handler.

If the SMMU hits a gerror and enters Service Failure Mode
(GERROR_SFM_ERR), the gerror handler calls arm_smmu_device_disable() in
hard-irq context. This becomes a problem as arm_smmu_device_disable()
inevitably calls arm_smmu_write_reg_sync() which might attempt to sleep
inside a hard-irq context.

Fix this by converting the arm_smmu_write_reg_sync to use the
readl_relaxed_poll_timeout_atomic() polling helper.

(Discovered while running Sashiko locally on another patch series).

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 48ec83bcbcf5 ("iommu/arm-smmu: Add initial driver support for ARM SMMUv3 devices")
Signed-off-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b12e23800844a..adbd27704a819 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3161,8 +3161,9 @@ static int arm_smmu_write_reg_sync(struct arm_smmu_device *smmu, u32 val,
 	u32 reg;
 
 	writel_relaxed(val, smmu->base + reg_off);
-	return readl_relaxed_poll_timeout(smmu->base + ack_off, reg, reg == val,
-					  1, ARM_SMMU_POLL_TIMEOUT_US);
+	return readl_relaxed_poll_timeout_atomic(smmu->base + ack_off, reg,
+						reg == val, 1,
+						ARM_SMMU_POLL_TIMEOUT_US);
 }
 
 /* GBPA is "special" */
-- 
2.53.0



