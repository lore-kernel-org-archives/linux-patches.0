Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8338B14A4E7;
	Tue, 17 Dec 2024 17:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456516; cv=none; b=HFEC33dxOvazehJLlHFly2z/2GEUgtWblmQnjs6RT5ptjxWISTcnkqerwYdFtDktnMLX0lArox4UbHqYDeGS3d/OhofD5W6bAVD1e2VzeUfhKexQAbUqwLaKMzkgSalT7i/o/PFLPZ7D932YeCcvzrRntJviZXFLCcgOThBf4rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456516; c=relaxed/simple;
	bh=G/kSGlkRXvMo1cb6Tc7oMDI8qZbkYUb1NC9SDl115QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YA1Gh4HL/t8Hc51zAgIi+ubXxH23/glMf31levqU6NVUyvpdW7K290SlarMb7lordadjg9DfROuz4hPG+0u8kOtKqslxK9sst/hQTHx1JmPQKUchrYHEwiYosusuJ9s77G8rTCMCDTKxzlla7nU4hBySUg9DDhq6kMcDmV5nqlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqKSq1oH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqKSq1oH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEDAC4CED3;
	Tue, 17 Dec 2024 17:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456516;
	bh=G/kSGlkRXvMo1cb6Tc7oMDI8qZbkYUb1NC9SDl115QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqKSq1oHS8zmMrq55An2LW93bedccir16nr/ozTAGEfHGGl8woJiDnQLvjO7uMdHC
	 +N3MmIMn9h33lH5hr4Mq4KLnDrx94h8oy5nkzjdSOrSsZoxXP1tJ3+LA5yrxvnY5Nl
	 j+nUodRAV5i9/bExenOuzUFz5g+dLaTnFjuyfcSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 053/172] iommu/tegra241-cmdqv: do not use smp_processor_id in preemptible context
Date: Tue, 17 Dec 2024 18:06:49 +0100
Message-ID: <20241217170548.470697178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

From: Luis Claudio R. Goncalves <lgoncalv@redhat.com>

commit 1f806218164d1bb93f3db21eaf61254b08acdf03 upstream.

During boot some of the calls to tegra241_cmdqv_get_cmdq() will happen
in preemptible context. As this function calls smp_processor_id(), if
CONFIG_DEBUG_PREEMPT is enabled, these calls will trigger a series of
"BUG: using smp_processor_id() in preemptible" backtraces.

As tegra241_cmdqv_get_cmdq() only calls smp_processor_id() to use the
CPU number as a factor to balance out traffic on cmdq usage, it is safe
to use raw_smp_processor_id() here.

Cc: <stable@vger.kernel.org>
Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
Signed-off-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Link: https://lore.kernel.org/r/Z1L1mja3nXzsJ0Pk@uudg.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index c8ec74f089f3..6e41ddaa24d6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -339,7 +339,7 @@ tegra241_cmdqv_get_cmdq(struct arm_smmu_device *smmu,
 	 * one CPU at a time can enter the process, while the others
 	 * will be spinning at the same lock.
 	 */
-	lidx = smp_processor_id() % cmdqv->num_lvcmdqs_per_vintf;
+	lidx = raw_smp_processor_id() % cmdqv->num_lvcmdqs_per_vintf;
 	vcmdq = vintf->lvcmdqs[lidx];
 	if (!vcmdq || !READ_ONCE(vcmdq->enabled))
 		return NULL;
-- 
2.47.1



