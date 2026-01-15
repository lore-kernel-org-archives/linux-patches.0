Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C0B3BF2E6;
	Thu, 15 Jan 2026 17:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498530; cv=none; b=kI2gqlq9cQnDj5dIKAP3RLr3RO/JfIFIgDq3wvhp7f0J4YBzotjg0BVIIvLANY+68b1y8mJ/iSaVMbESbu8CNjo7HlHmQqi05HNgdt9C19MO7ASTmNZSILIXKvrSiYoVeHMhONS8IkcNpco2hqtQ2s6RZ1czmXJl+Bp5rcoC+20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498530; c=relaxed/simple;
	bh=SLdwwsMhhkBAtBxwn7jIneC0yXopNco7nyOXhwZdDDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkRLxQ9YBNvtX5YKqdWr4YY3yRC6ilN+0ImyVBWfUVSxtq2GVuzvww9y6m5VaEA9kiDMxp/PhxKtJ+9SjtPJbdSTXFeyWADv1S6XePgS/MDQm0hreP8GoqLEVAcII9zhWo17oZmvoPidNYxOV2VhB/Qw1I1GZJohOGQV1JccDOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJpBNWv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJpBNWv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24037C116D0;
	Thu, 15 Jan 2026 17:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498530;
	bh=SLdwwsMhhkBAtBxwn7jIneC0yXopNco7nyOXhwZdDDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJpBNWv69Gd/qTN8btx6mS31vo+8z+3LL97datKrOrbTFGyG6yg+LxpqL8ZgYr9Rv
	 Ny6pOXWHk7Tw5eOoNAu4T9VVelqhDC9lDPN8hJH+zD23fj5M35KYDu+kUuXnoetfme
	 Ve/Ohf4A4kBJUCh3tK6om6416wQ6yNTxEDScc5nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 465/554] iommu/qcom: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:48:51 +0100
Message-ID: <20260115164303.117857179@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 6a3908ce56e6879920b44ef136252b2f0c954194 ]

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Note that commit e2eae09939a8 ("iommu/qcom: add missing put_device()
call in qcom_iommu_of_xlate()") fixed the leak in a couple of error
paths, but the reference is still leaking on success and late failures.

Fixes: 0ae349a0f33f ("iommu/qcom: Add qcom_iommu")
Cc: stable@vger.kernel.org	# 4.14: e2eae09939a8
Cc: Rob Clark <robin.clark@oss.qualcomm.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[ adapted validation logic from max_asid to num_ctxs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -568,15 +568,15 @@ static int qcom_iommu_of_xlate(struct de
 
 	qcom_iommu = platform_get_drvdata(iommu_pdev);
 
+	put_device(&iommu_pdev->dev);
+
 	/* make sure the asid specified in dt is valid, so we don't have
 	 * to sanity check this elsewhere, since 'asid - 1' is used to
 	 * index into qcom_iommu->ctxs:
 	 */
 	if (WARN_ON(asid < 1) ||
-	    WARN_ON(asid > qcom_iommu->num_ctxs)) {
-		put_device(&iommu_pdev->dev);
+	    WARN_ON(asid > qcom_iommu->num_ctxs))
 		return -EINVAL;
-	}
 
 	if (!dev_iommu_priv_get(dev)) {
 		dev_iommu_priv_set(dev, qcom_iommu);
@@ -585,10 +585,8 @@ static int qcom_iommu_of_xlate(struct de
 		 * multiple different iommu devices.  Multiple context
 		 * banks are ok, but multiple devices are not:
 		 */
-		if (WARN_ON(qcom_iommu != dev_iommu_priv_get(dev))) {
-			put_device(&iommu_pdev->dev);
+		if (WARN_ON(qcom_iommu != dev_iommu_priv_get(dev)))
 			return -EINVAL;
-		}
 	}
 
 	return iommu_fwspec_add_ids(dev, &asid, 1);


