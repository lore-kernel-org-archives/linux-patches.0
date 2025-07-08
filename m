Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03692E3AE8;
	Tue,  8 Jul 2025 16:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992523; cv=none; b=Dxys2g2JdSwBQQk2JKr7vlR96p6VUpUgj+xgxDVU8pUpTQ0vRJO9255LvLqubElB5JSwfkowkx5SSTCMrCoBdBwqHcJGkFYfapTQpWNXVR7jKW4I6j3KhT4tMkMPWKP8Q7Zodi2bjL3sEXxJObPam+B8fQ1VBFXM2oGjedVN9fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992523; c=relaxed/simple;
	bh=Of23CWC6H90ARrQahl/S59UDafKrI6u9Og/xVzgwtxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sdlu/UGcqdKWzZGTvm2nlylY36kopVCbJU2/hhUohQVRiF6G+tNJGbins0T2sYElsUHu6pgofIVGRRgTjyrpdC6g2XPWQfrQgl5Q5L8REIVXzyJd2r/JmlvqovtzZWNThKGzYh6x8uiHR/anmvFY0Uj0OZI3NaaFGhblefZhibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSuN/C7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSuN/C7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3733AC4CEED;
	Tue,  8 Jul 2025 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992523;
	bh=Of23CWC6H90ARrQahl/S59UDafKrI6u9Og/xVzgwtxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSuN/C7KnMxo/CSaVnNuTQb5uEhOLJtEYZ4Pql70UhE/nYhhL7/Rmx3E8Ii+ssoDY
	 /IDI66iltfJ3ihjK8GvkbPcwtsH6mq4sgnQxq0P/n3OV6ayS+3zXwtI912s1kx6+uE
	 94xyksECTP1Oj+lv4VAT3hmNM24kIE6IWI9aL0bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Xue <xxm@rock-chips.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 121/132] iommu/rockchip: prevent iommus dead loop when two masters share one IOMMU
Date: Tue,  8 Jul 2025 18:23:52 +0200
Message-ID: <20250708162234.083116512@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Xue <xxm@rock-chips.com>

commit 62e062a29ad5133f67c20b333ba0a952a99161ae upstream.

When two masters share an IOMMU, calling ops->of_xlate during
the second master's driver init may overwrite iommu->domain set
by the first. This causes the check if (iommu->domain == domain)
in rk_iommu_attach_device() to fail, resulting in the same
iommu->node being added twice to &rk_domain->iommus, which can
lead to an infinite loop in subsequent &rk_domain->iommus operations.

Cc: <stable@vger.kernel.org>
Fixes: 25c2325575cc ("iommu/rockchip: Add missing set_platform_dma_ops callback")
Signed-off-by: Simon Xue <xxm@rock-chips.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20250623020018.584802-1-xxm@rock-chips.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/rockchip-iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -1177,7 +1177,6 @@ static int rk_iommu_of_xlate(struct devi
 	iommu_dev = of_find_device_by_node(args->np);
 
 	data->iommu = platform_get_drvdata(iommu_dev);
-	data->iommu->domain = &rk_identity_domain;
 	dev_iommu_priv_set(dev, data);
 
 	platform_device_put(iommu_dev);
@@ -1217,6 +1216,8 @@ static int rk_iommu_probe(struct platfor
 	if (!iommu)
 		return -ENOMEM;
 
+	iommu->domain = &rk_identity_domain;
+
 	platform_set_drvdata(pdev, iommu);
 	iommu->dev = dev;
 	iommu->num_mmu = 0;


