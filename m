Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9BF1D0DDC;
	Wed,  2 Oct 2024 14:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877704; cv=none; b=kv6+lXKATj7fAydKVd9pw33+dqAYx/g4eLUpAdAwjYcgIKoFvLV969mGmxal79dX3GpuMF6nZArmjDq7QX52A9OWBleSJclnQm4aBDBRZbfYs6JXhvGpl3vh1M23dr0ukhQEUkNhn4p57yfkV/Q6aG7K3FmonSlUaDPThcGIXUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877704; c=relaxed/simple;
	bh=TGkk7gB+pi/IxWbDb6qGLjGiIf33QLFPgdYMT948H5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgrk7pY+ymZG6d+N/ugB0H5O1suvyS6bWH2zSBU00osjTnsawAzgtdFMOWzHvuy0I8/p9zRFD02ZdZUrss3Uw/t/qMiKyisV0P+Db+7LXyxPYvMbfE9qw4rGMih7Mgl37+nULTzyl2uHsbepSFbgBRfbp0VtTegMETSP9Gys2fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcETLDMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcETLDMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EEDC4CEC2;
	Wed,  2 Oct 2024 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877703;
	bh=TGkk7gB+pi/IxWbDb6qGLjGiIf33QLFPgdYMT948H5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcETLDMdyNQRJs6bno5UTgCbuV++u12cb1orAHxKQUQK9myuyLssgpmB1DgcCCuA+
	 qhx+XVTY+spfAOi99EkcVsoZ84BXLvMklpBfmliV4Srh2eTr+2cb+/iOiDocpon8LY
	 dhUBspXQ2SG1WtjtU/GgYuqCq3YYObPxjmfwq0Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 164/634] iommu/amd: Handle error path in amd_iommu_probe_device()
Date: Wed,  2 Oct 2024 14:54:24 +0200
Message-ID: <20241002125817.584597521@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 293aa9ec694e633bff83ab93715a2684e15fe214 ]

Do not try to set max_pasids in error path as dev_data is not allocated.

Fixes: a0c47f233e68 ("iommu/amd: Introduce iommu_dev_data.max_pasids")
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20240828111029.5429-5-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b19e8c0f48fa2..fc660d4b10ac8 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2185,11 +2185,12 @@ static struct iommu_device *amd_iommu_probe_device(struct device *dev)
 		dev_err(dev, "Failed to initialize - trying to proceed anyway\n");
 		iommu_dev = ERR_PTR(ret);
 		iommu_ignore_device(iommu, dev);
-	} else {
-		amd_iommu_set_pci_msi_domain(dev, iommu);
-		iommu_dev = &iommu->iommu;
+		goto out_err;
 	}
 
+	amd_iommu_set_pci_msi_domain(dev, iommu);
+	iommu_dev = &iommu->iommu;
+
 	/*
 	 * If IOMMU and device supports PASID then it will contain max
 	 * supported PASIDs, else it will be zero.
@@ -2201,6 +2202,7 @@ static struct iommu_device *amd_iommu_probe_device(struct device *dev)
 					     pci_max_pasids(to_pci_dev(dev)));
 	}
 
+out_err:
 	iommu_completion_wait(iommu);
 
 	return iommu_dev;
-- 
2.43.0



