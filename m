Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652C718A6A5;
	Tue, 30 Jul 2024 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360811; cv=none; b=INLluLf9PotBlNOi13jq+/ut2B/BcBkEMaIeGGpIIUp1uQuhJ+dn3eVHO02m0/IPuvmN/5TEpyI+rTVvJWpSoGjAIHrsdAxLhv/0OoaPVQ4Wqlzo8qtX6c/jBmsvz433CgMUn2NDQdHxuRE5jPX+ZgNoFCcNmlskMY9t6V/QQgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360811; c=relaxed/simple;
	bh=C5SckMnpYBIbyKGHYdgiSdKpE0g/VD+IOzHGB4Y1hts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSaaHb9O1S+wi7jbMtBF+WF7POAMmx3mNUNsRXg5SxZKlBG+ZYXiMB4L3ADQ254NmCLSgYt5aNMiU1HiwXtYpHco3IgjaaEI+1AuGPWmLEKrpwZ4P7HLemGy0tzbzYCzIzVuq78pkM1GMPoRjhPtc85eCyvrUzzsFacOFoJszk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kiimq3MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kiimq3MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882F1C32782;
	Tue, 30 Jul 2024 17:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360811;
	bh=C5SckMnpYBIbyKGHYdgiSdKpE0g/VD+IOzHGB4Y1hts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kiimq3MMBq1Oj4E2osrN4TVNLkWvZD3MstMmFrOtMR+hysOjrhbMotVeZDB5STiE8
	 rSh+8Tfj1opa9/NmiD0jGwmxnUZt26ggnBzRMgGGejcp9OzvYl/7boPZULeZ8MLciO
	 cLrPyNQ7ZegHKl+fA+0v4E7UrCZxO2lrA0AgSrS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 799/809] iommu: sprd: Avoid NULL deref in sprd_iommu_hw_en
Date: Tue, 30 Jul 2024 17:51:15 +0200
Message-ID: <20240730151756.538991247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ba53571a82390..a2f4ffe6d9491 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -232,8 +232,8 @@ static void sprd_iommu_cleanup(struct sprd_iommu_domain *dom)
 
 	pgt_size = sprd_iommu_pgt_size(&dom->domain);
 	dma_free_coherent(dom->sdev->dev, pgt_size, dom->pgt_va, dom->pgt_pa);
-	dom->sdev = NULL;
 	sprd_iommu_hw_en(dom->sdev, false);
+	dom->sdev = NULL;
 }
 
 static void sprd_iommu_domain_free(struct iommu_domain *domain)
-- 
2.43.0



