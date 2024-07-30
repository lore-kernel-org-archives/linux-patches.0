Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE41A76A9;
	Tue, 30 Jul 2024 17:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360032; cv=none; b=kB0P/tzi01TuzfpNWCk4QS24f4S182QbotHnLfvCda6VyrQ+glzaz6mnTaYG64FwMdcmnIEKfwwlAkuPC4rO/5kEscZe6o1E3KhSHhHVk9eisUF2hNt62NIM1Uiqp+u1fZGajB7L1/bJasFwC3oaI8nDF3iO2akjhsf1Y+5xHeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360032; c=relaxed/simple;
	bh=ycRKs9ZDGJEIS0uCi4XFHZ8SXstjYr9QuX9WJ0uBfJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWdbanyfPiNdOj7/C+EC9g3756jzj5m4xBDeuaFOHxOZemxMHOlv/j82DvmI9hE1kIwWu3I+ojt9IE9odFDIPGzSHl03ZkO/I5SdV509CZppb3JlSNEgzuHmeAqonf6A6S1e3OroW+TVF3ADdjqkHuGde+6IylE4VOWZxZCO9Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYZ1/DHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYZ1/DHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C354BC32782;
	Tue, 30 Jul 2024 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360032;
	bh=ycRKs9ZDGJEIS0uCi4XFHZ8SXstjYr9QuX9WJ0uBfJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYZ1/DHf2pMJqooF7pL+7iZSZa+jac3juLSiKPNnpt+FbXx9InD5h5vgOPnMpqdBk
	 Rx/GMMpsKVncgvMJ70lctcgOXwm8iPzjfxA86uw44hkl0mwWjNCJWrdktbIWWRHTnj
	 AJiYoEOfwBWk5NI8mubuiderPPBqJIDFRY9T2Ef4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 565/568] iommu: sprd: Avoid NULL deref in sprd_iommu_hw_en
Date: Tue, 30 Jul 2024 17:51:12 +0200
Message-ID: <20240730151702.240728526@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2fa9afebd4f5f..c8e79a2d8b4c6 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -236,8 +236,8 @@ static void sprd_iommu_cleanup(struct sprd_iommu_domain *dom)
 
 	pgt_size = sprd_iommu_pgt_size(&dom->domain);
 	dma_free_coherent(dom->sdev->dev, pgt_size, dom->pgt_va, dom->pgt_pa);
-	dom->sdev = NULL;
 	sprd_iommu_hw_en(dom->sdev, false);
+	dom->sdev = NULL;
 }
 
 static void sprd_iommu_domain_free(struct iommu_domain *domain)
-- 
2.43.0



