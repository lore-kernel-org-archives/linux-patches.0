Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060A01D6AA;
	Wed, 28 Jan 2026 15:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615733; cv=none; b=JtVv2PjTYmJNT/dWb5yUa3fAk2dGOlpT+nC7rVpAVXfGpppdUNi06Nc2x0lvM510I3V96FDUN82ZZmos/QFkn9DXfiNgbp0v5/rsaJbB4iSvj4sBTbxvJYIlDyzrOG1yoJJ28LT8XVgW8Hd92ZOZk3ZAh6bQkRpms2TMzIq7cAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615733; c=relaxed/simple;
	bh=ngpLxkl6vBKZ0Rv/TMh8TDGuJciE2fxIjZqM2L/Q8os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pbcxCJVWgUZJBJcVXbKmZ23ariWzFXr5y4U6oW/roniYnewv88xKy9JNgn9+FZgQenmsjPSOW8h9gWPKcJt+FjW2DpSpXE++8IbLMKisZ3g08miW4FM53Hs52auUhujbQpcgT1orAM009/OZD36yZH16PTYqJZsXX34ilvWQ9UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxBEZwOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxBEZwOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896ABC4CEF1;
	Wed, 28 Jan 2026 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615732;
	bh=ngpLxkl6vBKZ0Rv/TMh8TDGuJciE2fxIjZqM2L/Q8os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxBEZwOf/Cd2++j4CZjG1MAbtF5QtEjuH20lqCl2YDO6sN25SbiEuY6hKSmvDqKf8
	 d6XkhTZmCQTQ2D6QtW9YgFeJqNirV094VFseg6L2FTwSaqQtt+UA5H9xpExALTp/GI
	 UjH8HFTx5w6VmOMTifLhYn+OBjBVY505dvjQKgPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rakuram Eswaran <rakuram.e96@gmail.com>,
	=?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/227] iommu/amd: Fix error path in amd_iommu_probe_device()
Date: Wed, 28 Jan 2026 16:22:21 +0100
Message-ID: <20260128145347.786825202@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 3222b6de5145272c43a90cb8667377d676635ea0 ]

Currently, the error path of amd_iommu_probe_device() unconditionally
references dev_data, which may not be initialized if an early failure
occurs (like iommu_init_device() fails).

Move the out_err label to ensure the function exits immediately on
failure without accessing potentially uninitialized dev_data.

Fixes: 19e5cc156cb ("iommu/amd: Enable support for up to 2K interrupts per function")
Cc: Rakuram Eswaran <rakuram.e96@gmail.com>
Cc: Jörg Rödel <joro@8bytes.org>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202512191724.meqJENXe-lkp@intel.com/
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a38304f1a8df5..5914bef0c8c19 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2426,8 +2426,6 @@ static struct iommu_device *amd_iommu_probe_device(struct device *dev)
 		goto out_err;
 	}
 
-out_err:
-
 	iommu_completion_wait(iommu);
 
 	if (FEATURE_NUM_INT_REMAP_SUP_2K(amd_iommu_efr2))
@@ -2438,6 +2436,7 @@ static struct iommu_device *amd_iommu_probe_device(struct device *dev)
 	if (dev_is_pci(dev))
 		pci_prepare_ats(to_pci_dev(dev), PAGE_SHIFT);
 
+out_err:
 	return iommu_dev;
 }
 
-- 
2.51.0



