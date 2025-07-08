Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9C62DAFAE;
	Tue,  8 Jul 2025 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993702; cv=none; b=tTV6coD6t/0Ubnz0LDGvCeeLQ8+5ihthLT9foUJhQfZMh5t3wVTuVIRsU6HgAVTNI4HiuBPirwRHlEHvj0g6UFh+fqGZ20GWbO2p2dhDV9R2ldJZFTtzT8V7SxKXgyiFBCd7WS0X8HVkzypcCP+XAcrg9smP7i9F4ZmK9iuS75c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993702; c=relaxed/simple;
	bh=+wRBvGEERmGix20yjir88w6XQfwKsIHhLZtEXyiH4gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRgOuTZGWkIFS07EUrClWE07IIFHUygTu8sxzUamiRAdQnjJO99fEcVEzveAlaGf0v5zZL1gVPGWg9bbMsoOVXN2uTENNodo6BKbgbmHpnNLFABEq8UcPvFwzUHDRf28hmDVKjuE/K4K7SypKsUsvLOX/U09bUP78rRGJRk6NiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyN0njWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyN0njWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD14AC4CEED;
	Tue,  8 Jul 2025 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993702;
	bh=+wRBvGEERmGix20yjir88w6XQfwKsIHhLZtEXyiH4gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyN0njWWcQxW2wNU0UPVVetrJCzAoLlLe0vqAnAu4F/+jNYXo0oQ3cLno99hsC9dR
	 f6ACzNbC3oB1zr+8KjSQis068D5whsw+vrCX+m2H61ABf5er3S8m1C37ZtpUfHHzMk
	 49mI9+gclRSfjhALuiyatei2f0gJptwB0nvOcynQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Xue <xxm@rock-chips.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.15 164/178] iommu/rockchip: prevent iommus dead loop when two masters share one IOMMU
Date: Tue,  8 Jul 2025 18:23:21 +0200
Message-ID: <20250708162240.760603465@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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
@@ -1155,7 +1155,6 @@ static int rk_iommu_of_xlate(struct devi
 		return -ENOMEM;
 
 	data->iommu = platform_get_drvdata(iommu_dev);
-	data->iommu->domain = &rk_identity_domain;
 	dev_iommu_priv_set(dev, data);
 
 	platform_device_put(iommu_dev);
@@ -1193,6 +1192,8 @@ static int rk_iommu_probe(struct platfor
 	if (!iommu)
 		return -ENOMEM;
 
+	iommu->domain = &rk_identity_domain;
+
 	platform_set_drvdata(pdev, iommu);
 	iommu->dev = dev;
 	iommu->num_mmu = 0;


