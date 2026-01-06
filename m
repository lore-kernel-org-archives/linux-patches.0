Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBB93019AA;
	Tue,  6 Jan 2026 17:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721941; cv=none; b=XeyZcYvwCl6bmPgDNVBcuZR0ZGX/mheg7ejHzLaeI+y+llup5adjuGx1sUa8/pnPF3HosJoD11TzhwHzqgGqyksxOtbQbKl3tnQJXCZRDgfZaktQsKjdluHt+JVRqEqpQgkCJxoocMn/djx1V+6koOyHTj0RLLg0OgdyaKuJitM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721941; c=relaxed/simple;
	bh=5Ce0nVvdrgOmw5ZpV2zrYzzirdV2Kx4HHUMLiSDN0Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KySWkYAMzGRPZFaZXdSYRR2pIO8R+yKc6F+oXzsmsTUpLXC8QrUOGpyBmQCo+a8PcyRLhFAljKCyrd9V9oM91nTR7s6aKoCPOa2/85v8hVFEIHyIGS+5YUti/qhmJ8Q023Mkk0c+lWgB3gln8qj9aTn0v7ZfuMYPI2IJ+ohzVnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rH4TE/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rH4TE/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3015FC116C6;
	Tue,  6 Jan 2026 17:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721941;
	bh=5Ce0nVvdrgOmw5ZpV2zrYzzirdV2Kx4HHUMLiSDN0Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rH4TE/uRch4CtUosTNKzCGp4FxfY8EO/6e7Ac4GC6ltRn3IaQtHGE0JYa62VKU0c
	 maM0p53BttG37iBL8DdUQvSF3fSG0Gkx2j3X4AVJ6yPSy5km4+Zd+yPSCLQSrg+qgE
	 WWdcgPQYDU0FesCFo8D02OcG5poWzFhOZTPxsMvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 117/312] iommu/qcom: fix device leak on of_xlate()
Date: Tue,  6 Jan 2026 18:03:11 +0100
Message-ID: <20260106170552.074955838@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6a3908ce56e6879920b44ef136252b2f0c954194 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -565,14 +565,14 @@ static int qcom_iommu_of_xlate(struct de
 
 	qcom_iommu = platform_get_drvdata(iommu_pdev);
 
+	put_device(&iommu_pdev->dev);
+
 	/* make sure the asid specified in dt is valid, so we don't have
 	 * to sanity check this elsewhere:
 	 */
 	if (WARN_ON(asid > qcom_iommu->max_asid) ||
-	    WARN_ON(qcom_iommu->ctxs[asid] == NULL)) {
-		put_device(&iommu_pdev->dev);
+	    WARN_ON(qcom_iommu->ctxs[asid] == NULL))
 		return -EINVAL;
-	}
 
 	if (!dev_iommu_priv_get(dev)) {
 		dev_iommu_priv_set(dev, qcom_iommu);
@@ -581,10 +581,8 @@ static int qcom_iommu_of_xlate(struct de
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


