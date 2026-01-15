Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034983BFE3B;
	Thu, 15 Jan 2026 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499883; cv=none; b=ZlfWrx3LKkrhwQxuqTjfVFMGprm3cBiQuGGqzEBOqS53TTeqNZyqVH5imJQ0ekArGD0rHm2u+G67h7rYsPwTwd4ZyixQaI1D8+rY/xRyjNm/uWxfbNtTvcgQBb9kYQIc+BbNtDBc/ZLX1JHBYAQ5N50Weei1xR+VGR4kAPVuGlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499883; c=relaxed/simple;
	bh=xSzdY7XISreeEJ/3mRDiHlTG7vBJg3Lle6aBFCxNn2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mht2oIn8HoUtEOuqy53FRgYDAucmyKcTziWJ9hLG0yWDWgfGV7URHE/0AgReHHjxYzfEdyaUBW9o1EVRUTjW3WMZsgzyS12IQnXL4uZ0Ydi1TY/7D905LgGXRfBah22pDWzaPIqP3Ad4XrJsyD+xrCYAwRqq3ebYMzTKEAVBUUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyBT25hj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyBT25hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87706C116D0;
	Thu, 15 Jan 2026 17:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499882;
	bh=xSzdY7XISreeEJ/3mRDiHlTG7vBJg3Lle6aBFCxNn2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyBT25hjufJhpbVh6XWtQ0rK0LvOUSZMmDQLuAifmDHp1vDZvRBKMJvp9VHtcYPra
	 9mAihj2/gbRGHdnagk4k6S3ffjgXv/xNtFlbYrY4q71CUt+HMTuYvpuuiB5CdYR+Oe
	 FU5n9kQuCgY9wFqnr8dHUVrYWL0JAlgRRdSTzj4g=
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
Subject: [PATCH 5.10 375/451] iommu/qcom: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:49:36 +0100
Message-ID: <20260115164244.482456981@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -586,15 +586,15 @@ static int qcom_iommu_of_xlate(struct de
 
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
@@ -603,10 +603,8 @@ static int qcom_iommu_of_xlate(struct de
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


