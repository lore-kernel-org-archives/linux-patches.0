Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579B71F37A1;
	Tue, 17 Jun 2025 16:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176930; cv=none; b=WNi6msAWNplu5C5qk14uzYytTM62fp8oYBh+1JEua+RYUtifrE0lYNgY5h7ERFNxCycq3lSKCvlq9W3kAzriQ2C1LhDKtzVZwq24oULXD3BncC6dd3NIe4AP68v++Sm61/WZp01So4qJxaalmnz/wDMlu1BvlYlL0lQOtuU0GIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176930; c=relaxed/simple;
	bh=4Pf0ucuApfjdgu/5BRie3GN/ao8eGRGjESv8ox5wsh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrBCBacDY4ohk+dgXbm/8GlUuZzkV3BJsRNa/fwgJ06PqhchgxyfgIIYXqW3lWFLqxHNCT05hmOQkVIL2vpNYc3FXxOvl7aSPl11FqpKI6fu8BKrKBXa8mXig9vB0xuhYX03HqGePl3DPsZRUTVmQyLisNpRVdnaPOg55ho/vyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fve/Fyry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fve/Fyry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F1EC4CEE3;
	Tue, 17 Jun 2025 16:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176930;
	bh=4Pf0ucuApfjdgu/5BRie3GN/ao8eGRGjESv8ox5wsh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fve/FyryqGmOcptioZVIa2SZGx33f1z5/EZqB9/QLZBBP0H+k/0gVhXPLWI37qL7f
	 aUho77C3BdIi3VHwiegLZ6JgL5qns69UHUFexrAlA7Wc/YGD2JGACvVoZEft4ZXf1/
	 FA4MinIxXfoF4baWgPB5r43oWAihyrEAUGJCMV7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qinxin Xia <xiaqinxin@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 241/780] iommu/arm-smmu-v3: Fix incorrect return in arm_smmu_attach_dev
Date: Tue, 17 Jun 2025 17:19:09 +0200
Message-ID: <20250617152501.270080047@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qinxin Xia <xiaqinxin@huawei.com>

[ Upstream commit be5a2d3f8f9738ea1426e7d2243707164ed5bac2 ]

After commit 48e7b8e284e5 ("iommu/arm-smmu-v3: Remove
arm_smmu_domain_finalise() during attach"), an error code is not
returned on the attach path when the smmu does not match with the
domain. This causes problems with VFIO because
vfio_iommu_type1_attach_group() relies on this check to determine domain
compatability.

Re-instate the -EINVAL return value when the SMMU doesn't match on the
device attach path.

Fixes: 48e7b8e284e5 ("iommu/arm-smmu-v3: Remove arm_smmu_domain_finalise() during attach")
Signed-off-by: Qinxin Xia <xiaqinxin@huawei.com>
Link: https://lore.kernel.org/r/20250422112951.2027969-1-xiaqinxin@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 48d910399a1ba..be8d0f7db617d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2953,7 +2953,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	smmu = master->smmu;
 
 	if (smmu_domain->smmu != smmu)
-		return ret;
+		return -EINVAL;
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
-- 
2.39.5



