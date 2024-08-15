Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05301714A1;
	Thu, 15 Aug 2024 13:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730069; cv=none; b=Bitw0bykF8xu1QqWXA4rUXf+dLHCrxF0k8t/5wdP7N84WG3jUoC8EjH7oIfwWHNLs/sZNFYaqpPc7DI8zS1wPxOVZMzzkgtzChCZekwVq/PFA7Hv9dAwkH1LeWk0++2o75bmuwM43o1VbgiAgYaRG+lCrkV1oQv6zWlDA06L/ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730069; c=relaxed/simple;
	bh=ICHs+cyAUmFs9Etj+5Fi9UgOHBF0wMZlZEwJNpECfY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNNeRHF1wBCO4YjYnWYzPPWgCTOFmnbORFa9tC6JlOjz42/kan72Q+E1T0AFx5CP9oHp4fnCk3luH843qHslnbRvOXu493eE6unu3HQRkv9Ab3GpdeIBSIIRaMyipBUJSS+QxFH2aqmE7gyUPyQ4aAWTLj9W9Jdz6WJbW5dvKLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAWSlHmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAWSlHmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C456C4AF0A;
	Thu, 15 Aug 2024 13:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730068;
	bh=ICHs+cyAUmFs9Etj+5Fi9UgOHBF0wMZlZEwJNpECfY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAWSlHmkRZvJvTWQ+7AWoQrGn/M7ukO8K+kWcbjhFw30QHJlKdBeMB2I5oiKZ+y/D
	 ZtPKEBYIJ1mgq7trK80XsT6S2mHMnNtGy/3VRtDPbieYskliBKy99Y5FQryfDGBPGr
	 89IPB7uznzYTLr7zODEalpKxOJ27ld/ZXsSpHLis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/484] iommu: sprd: Avoid NULL deref in sprd_iommu_hw_en
Date: Thu, 15 Aug 2024 15:22:31 +0200
Message-ID: <20240815131952.724180081@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6b11770e3d75a..f9392dbe6511e 100644
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



