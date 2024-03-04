Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD958F58;
	Mon,  4 Mar 2024 21:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588641; cv=none; b=oGegs1nZG7ekBdiu0VQKDEKJE0JK7w7Www8032ADwJL42W4SfHDU6u3KGOH/bTtSoFNIFZZ3xIwRFl9tGKZP7cxzoSEckgVNh1pAuRHv5yQuvgEY19Dgjq+jqlixs+ww4BcTBw8KRCpadROCzkwvZR+QinsdeI8Ed194S/Ijf28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588641; c=relaxed/simple;
	bh=NpYWsEqb4JCBsL/NBUYO+yOSKUZ8nyyrO2wevtPDhlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDvw+zEREMUZ4z6ADSR48jb/83N8Rurson80FMd7Hp0dspWBCsKUA4ia0YmkTYVOPNlnZGpAgmz0TEEsSiIeDpgiPWRnixptM8CDpJ5QhbCQUsQC6LBEIVrKt+frBgA0n2yJf689tXgPyKwWUJ461gXL77E/4cFDp80D5FHnFDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkE1TLw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkE1TLw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3E5C433C7;
	Mon,  4 Mar 2024 21:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588641;
	bh=NpYWsEqb4JCBsL/NBUYO+yOSKUZ8nyyrO2wevtPDhlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkE1TLw2WKeVM/SXgqqhpRtIiPWcCAwXlA+kUgQoh30OBOjVqv2yUNJMrIuIwjhx6
	 QSD+5iG7McatPLPYl8rue6qYX/18GTbDrEz4fzYEXL97+vVakAGaipGRhqmlf1VYqN
	 eTHlu1gVA4kNf5jVlwRtJeJ0cw+WWQYEb9k6YmT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunyan Zhang <chunyan.zhang@unisoc.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/215] iommu/sprd: Release dma buffer to avoid memory leak
Date: Mon,  4 Mar 2024 21:21:20 +0000
Message-ID: <20240304211557.556199841@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 9afea57384d4ae7b2034593eac7fa76c7122762a ]

When attaching to a domain, the driver would alloc a DMA buffer which
is used to store address mapping table, and it need to be released
when the IOMMU domain is freed.

Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lore.kernel.org/r/20230331033124.864691-2-zhang.lyra@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sprd-iommu.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
index 8261066de07d7..e4358393fe378 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -152,13 +152,6 @@ static struct iommu_domain *sprd_iommu_domain_alloc(unsigned int domain_type)
 	return &dom->domain;
 }
 
-static void sprd_iommu_domain_free(struct iommu_domain *domain)
-{
-	struct sprd_iommu_domain *dom = to_sprd_domain(domain);
-
-	kfree(dom);
-}
-
 static void sprd_iommu_first_vpn(struct sprd_iommu_domain *dom)
 {
 	struct sprd_iommu_device *sdev = dom->sdev;
@@ -231,6 +224,28 @@ static void sprd_iommu_hw_en(struct sprd_iommu_device *sdev, bool en)
 	sprd_iommu_update_bits(sdev, reg_cfg, mask, 0, val);
 }
 
+static void sprd_iommu_cleanup(struct sprd_iommu_domain *dom)
+{
+	size_t pgt_size;
+
+	/* Nothing need to do if the domain hasn't been attached */
+	if (!dom->sdev)
+		return;
+
+	pgt_size = sprd_iommu_pgt_size(&dom->domain);
+	dma_free_coherent(dom->sdev->dev, pgt_size, dom->pgt_va, dom->pgt_pa);
+	dom->sdev = NULL;
+	sprd_iommu_hw_en(dom->sdev, false);
+}
+
+static void sprd_iommu_domain_free(struct iommu_domain *domain)
+{
+	struct sprd_iommu_domain *dom = to_sprd_domain(domain);
+
+	sprd_iommu_cleanup(dom);
+	kfree(dom);
+}
+
 static int sprd_iommu_attach_device(struct iommu_domain *domain,
 				    struct device *dev)
 {
-- 
2.43.0



