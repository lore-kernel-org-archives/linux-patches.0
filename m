Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609421A6192;
	Tue, 30 Jul 2024 17:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358961; cv=none; b=MALtI514K/KiGLaDQMXpnnU2yiP5uIoIM5wWN2Zp5gtngaUqRH0RWTsoNs2mbZvPbs9lqZcEAzDahepF6RtLNcKwBI5mF/7htrtcN4kJ91TQ8gls12bFCzINB/NGCWIhLIbeLv7DcAuQqBMr25NiBi91xSjOOlk5UJCG92F9rHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358961; c=relaxed/simple;
	bh=PUYqQU5oahFhp1AXNzebjxBEEp0f1X4Ncon1r41rn00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9MC8nI0vkw0ZdzoiVQVs6qfO0/nIjV6o8PmRlLh/HxDg6UbKfv7s9/3mifVH/9y2BgLr/gScW3N3z78+TubnLmLjEiQk+DrghlCjFI96KydcRRMrFBLXlizwYIKcjcCdsdZdRTGsnPl3NkK8zu3MnFv7b2HIqWDEWnyBRzJSEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLw4Aqzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLw4Aqzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4453C32782;
	Tue, 30 Jul 2024 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358961;
	bh=PUYqQU5oahFhp1AXNzebjxBEEp0f1X4Ncon1r41rn00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLw4AqzouaZVv+w9UF16yyw8TX3APVPqHk3ZwpR5qucRlsTkm5FvOvpOFhalYiHKg
	 mEiEVCqVT5PCm3DU90CEaC4zmbZR0YCiXDv5nLktVZAgbde8Tb0/6RH9cQRYvnW8ZB
	 JxKuQIBhylR+ZUJI6O+7q7b29w65KyqyE7E6UiJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 437/440] iommu: sprd: Avoid NULL deref in sprd_iommu_hw_en
Date: Tue, 30 Jul 2024 17:51:10 +0200
Message-ID: <20240730151632.842020517@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit 630482ee0653decf9e2482ac6181897eb6cde5b8 ]

In sprd_iommu_cleanup() before calling function sprd_iommu_hw_en()
dom->sdev is equal to NULL, which leads to null dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9afea57384d4 ("iommu/sprd: Release dma buffer to avoid memory leak")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Chunyan Zhang <zhang.lyra@gmail.com>
Link: https://lore.kernel.org/r/20240716125522.3690358-1-artem.chernyshev@red-soft.ru
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sprd-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
index e4358393fe378..71d22daaec2ed 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -234,8 +234,8 @@ static void sprd_iommu_cleanup(struct sprd_iommu_domain *dom)
 
 	pgt_size = sprd_iommu_pgt_size(&dom->domain);
 	dma_free_coherent(dom->sdev->dev, pgt_size, dom->pgt_va, dom->pgt_pa);
-	dom->sdev = NULL;
 	sprd_iommu_hw_en(dom->sdev, false);
+	dom->sdev = NULL;
 }
 
 static void sprd_iommu_domain_free(struct iommu_domain *domain)
-- 
2.43.0



