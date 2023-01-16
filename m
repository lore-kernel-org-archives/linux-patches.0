Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA51933F0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACEBC433EF;
	Mon, 16 Jan 2023 15:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884641;
	bh=CsKm78zPTazvingQ1Le32COlzZJiD4hVMkvcP/fx/1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvxE9nrSPXf7wq/VyVszHduN4TQbiqDxBsSd3eMW2cQOHyfreWt9dbg/0hycspeGJ
	 RR52Gow0cL8+a0gmat8sPFpjDsT0D7pDS43pA8ZWneTlgKSqhXkhD99t1Dy4pv9/mr
	 FHdhmbVE42pVZwZQoGG8bQri1i1rhtInQHY20fuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 084/183] iommu/arm-smmu-v3: Dont unregister on shutdown
Date: Mon, 16 Jan 2023 16:50:07 +0100
Message-Id: <20230116154806.980119335@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 32ea2c57dc216b6ad8125fa680d31daa5d421c95 upstream.

Similar to SMMUv2, this driver calls iommu_device_unregister() from the
shutdown path, which removes the IOMMU groups with no coordination
whatsoever with their users - shutdown methods are optional in device
drivers. This can lead to NULL pointer dereferences in those drivers'
DMA API calls, or worse.

Instead of calling the full arm_smmu_device_remove() from
arm_smmu_device_shutdown(), let's pick only the relevant function call -
arm_smmu_device_disable() - more or less the reverse of
arm_smmu_device_reset() - and call just that from the shutdown path.

Fixes: 57365a04c921 ("iommu: Move bus setup to IOMMU device registration")
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20221215141251.3688780-2-vladimir.oltean@nxp.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3854,7 +3854,9 @@ static int arm_smmu_device_remove(struct
 
 static void arm_smmu_device_shutdown(struct platform_device *pdev)
 {
-	arm_smmu_device_remove(pdev);
+	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
+
+	arm_smmu_device_disable(smmu);
 }
 
 static const struct of_device_id arm_smmu_of_match[] = {


