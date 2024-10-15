Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF12E1C07ED;
	Tue, 15 Oct 2024 13:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997930; cv=none; b=BWEdD7GBH2jzdqvxgAVh9CsLvMAjH4UZzL8nm2ztA4xmuc4dOTU7s48xuvWnlKMFdlNn0jV4AI26ANi/o9J1TovR3YjITqJkr+GRcYuA8+sxFtGBHyo+SsjIX+w8KjXQRSthHZkZYnKWLVz35A5VqM7qotkL/7VmVGrPWQIOcJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997930; c=relaxed/simple;
	bh=VrCN6hRIR6PN+ahJrmIRrSjzY6Uvj2S6tP8HyOro/Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmp2ABJq9XWtG93bOjrp0ZXZQi7q5fXmDuY2lz8IMpO39VBSayymX64wRdUOXYwB5ZXhzfTsfYB2a7c0/JnakBJVsh2fPBdLxyYeUH18PTeben5Q1dgpbK9hLFKtKL+OKy0lVQSAIglhpAtaVheHYe73iPIejcDCu8IJd2EjfQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjroMde5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjroMde5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0BBC4CEC6;
	Tue, 15 Oct 2024 13:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997929;
	bh=VrCN6hRIR6PN+ahJrmIRrSjzY6Uvj2S6tP8HyOro/Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjroMde5WBfnk25E2vAOlbrkNq+T3bAPRmxum7Q2WWdiHw1jE4JTpNMKdKv5y7H8C
	 S1RJzOFLpVYYA+A/kE0UsqabKQwQQ3mLVgSN7rKYaG6quYs2SpBbincq1Y0vJ1Kq4K
	 csAN15R7tFW/pixOEfz7Ovmv1RMxcWBbSUxgrNlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 329/518] iommu/vt-d: Always reserve a domain ID for identity setup
Date: Tue, 15 Oct 2024 14:43:53 +0200
Message-ID: <20241015123929.676479829@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 2c13012e09190174614fd6901857a1b8c199e17d ]

We will use a global static identity domain. Reserve a static domain ID
for it.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20240809055431.36513-4-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6be92e0afdb06..c694ecbd304e2 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1847,10 +1847,10 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	 * entry for first-level or pass-through translation modes should
 	 * be programmed with a domain id different from those used for
 	 * second-level or nested translation. We reserve a domain id for
-	 * this purpose.
+	 * this purpose. This domain id is also used for identity domain
+	 * in legacy mode.
 	 */
-	if (sm_supported(iommu))
-		set_bit(FLPT_DEFAULT_DID, iommu->domain_ids);
+	set_bit(FLPT_DEFAULT_DID, iommu->domain_ids);
 
 	return 0;
 }
-- 
2.43.0



