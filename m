Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B703B530F;
	Thu, 15 Jan 2026 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498275; cv=none; b=GaCXLO5BdFSV3k1QGYPqLxxQB8sRtXUvTFEvgd4tdtMtBJlztXL0D5N6zZB6C9h6tcW7OhHGKJXNCb16ST3Z6zbyBtN/ZwaMPTV5vFPrYRU66yxi1oXOZQ2w8oMvsByw2N/8yaPa2qJ5k2eFqgv58Do6UizI9IpKd7Sc0kk3A4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498275; c=relaxed/simple;
	bh=bCSkDlNZzTqSMgtMoVCW2wKjf2AAPUky2BPqviw/ibE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAO/eVCTxA0mzlSVqmfzu0f+LcJSDqUSeM8YjGHU8amzVH562Rpq3ieysJNsaFyMnDOYh9BVafPCxmUsLZTWFIgRtqBbX/MWz0P14dL8l1Ja8QjeJSnfDB32HJNIjpRN5xdWVwwvK6f9YeqzppNuiF2eNDJk1/rLjUUax52OR+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnqVutGp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnqVutGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FAEC116D0;
	Thu, 15 Jan 2026 17:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498275;
	bh=bCSkDlNZzTqSMgtMoVCW2wKjf2AAPUky2BPqviw/ibE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnqVutGp9vfRNJLQJiQR63X8AS95wRO2oBiTMvLT3KpJZttOM92gM7a5xU4jXyRyU
	 zTOuFLnOGMBgwqg06RM5vKyBI+qrdNFH/WB3IH+964n8x5pTT6WkRTXSUMyKI23x+d
	 QggmExWz1Mui86rVDyNw4OUkTKwyoFi6jgrv7uDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.15 374/554] iommu/exynos: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:47:20 +0100
Message-ID: <20260115164259.769660680@linuxfoundation.org>
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

commit 05913cc43cb122f9afecdbe775115c058b906e1b upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Note that commit 1a26044954a6 ("iommu/exynos: add missing put_device()
call in exynos_iommu_of_xlate()") fixed the leak in a couple of error
paths, but the reference is still leaking on success.

Fixes: aa759fd376fb ("iommu/exynos: Add callback for initializing devices from device tree")
Cc: stable@vger.kernel.org	# 4.2: 1a26044954a6
Cc: Yu Kuai <yukuai3@huawei.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/exynos-iommu.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1284,17 +1284,14 @@ static int exynos_iommu_of_xlate(struct
 		return -ENODEV;
 
 	data = platform_get_drvdata(sysmmu);
-	if (!data) {
-		put_device(&sysmmu->dev);
+	put_device(&sysmmu->dev);
+	if (!data)
 		return -ENODEV;
-	}
 
 	if (!owner) {
 		owner = kzalloc(sizeof(*owner), GFP_KERNEL);
-		if (!owner) {
-			put_device(&sysmmu->dev);
+		if (!owner)
 			return -ENOMEM;
-		}
 
 		INIT_LIST_HEAD(&owner->controllers);
 		mutex_init(&owner->rpm_lock);


