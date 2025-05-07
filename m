Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906271FF5EC;
	Wed,  7 May 2025 18:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643909; cv=none; b=unBQCEB+Xh+PgwvfokbgG1ZNw4ac0JMNa2pqPWz5F0R2Flm7IN9/vLJpt3/qmZru8ZJDSJ9cDyjg1yUAvgVfFmphBzHY3jy4umTk1v7dLW1VLagv7AP7lN52lz/Z53oJvKRYMTqqABEJ3FMlBZhYqitk1hQGbSuulhbgOxTCHH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643909; c=relaxed/simple;
	bh=t21PjLjAe9MuQQnVuVw2+8gZPJWarjSwe7SS4LJFKXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTZSzoGtDpr4/Zf8BjzXN0K7y3ixD4adbL8h30CUkW/xRAdBJxjgtzy2+1PjThhMZAl3QLf1zkOdBx3eLe5iJUfYQaVLCqsaIG3rnMiY4oohdf1bptYKOlTLOywXZ/noEPPbffiBV8OTmseFCBY74OHqo8jTxiPGM+71Xtt84+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gY0NeuAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gY0NeuAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F3DC4CEE2;
	Wed,  7 May 2025 18:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643909;
	bh=t21PjLjAe9MuQQnVuVw2+8gZPJWarjSwe7SS4LJFKXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gY0NeuARLkULFIAqIpySmoZz7KarXiaEs/RscfwpE4yq/A3Om9b3S9SSpoL6iVCqA
	 g8n8RxuEh8WD2QtubgWLy8frpLTw7Y96v+ANcOE9Ia3cqWHKWTaiBinBSsCbkgNE+t
	 O00gTPCWKzi6wh621PzR5s7Tqh3X6CqKfgekfgW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 058/183] iommu/arm-smmu-v3: Add missing S2FWB feature detection
Date: Wed,  7 May 2025 20:38:23 +0200
Message-ID: <20250507183827.038152927@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

[ Upstream commit 45e00e36718902d81bdaebb37b3a8244e685bc48 ]

Commit 67e4fe398513 ("iommu/arm-smmu-v3: Use S2FWB for NESTED domains")
introduced S2FWB usage but omitted the corresponding feature detection.
As a result, vIOMMU allocation fails on FVP in arm_vsmmu_alloc(), due to
the following check:

	if (!arm_smmu_master_canwbs(master) &&
	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
		return ERR_PTR(-EOPNOTSUPP);

This patch adds the missing detection logic to prevent allocation
failure when S2FWB is supported.

Fixes: 67e4fe398513 ("iommu/arm-smmu-v3: Use S2FWB for NESTED domains")
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Link: https://lore.kernel.org/r/20250408033351.1012411-1-aneesh.kumar@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ae803c64ae1ee..e495334d1c43a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4416,6 +4416,8 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
 	if (FIELD_GET(IDR3_RIL, reg))
 		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
+	if (FIELD_GET(IDR3_FWB, reg))
+		smmu->features |= ARM_SMMU_FEAT_S2FWB;
 
 	/* IDR5 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);
-- 
2.39.5



