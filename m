Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581FB475334;
	Sat, 12 Sep 2026 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230620; cv=none; b=rjdD9dje3mrbnsERv5OX0Rq1yJY5K1A/SU5jIonLu/Gibk0MRZu+M7uF+TqXD6bdnPmHKCEtStdX3nJD/Hp3wWPcJC217DmpW8K8iIbQu81rlH2HXYkCNSqraPETXzwHiYM/Dlo8N4VjtBbYZPW7RKvrP52F4egxlLeq4NF0bUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230620; c=relaxed/simple;
	bh=3HOQWexL6cOwtD+OeVtnE/Nc14VbAneNC2AhNt0UXpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkq8aGoX7WugyvUERdkwrsoNEBTL+JCU4GvCKHBhXS17ppnO4TxFTzyV8eRbpgbZ65Hk0wpyuHSIV8e4iVAuG2lj6Bf776ZEBVDoXEqQp1v8DuELs+Ar0iFVmSCdH36mnzpJGUaoEqh15TIHBuVfhn1Ld60ACwE32knfhD0mNx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvXz1Cfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvXz1Cfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4204B1F000FF;
	Sat, 12 Sep 2026 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230619;
	bh=ZdZgf/zsxH664ywtwON0nB04oruJ+7lCqCju/CzJJVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BvXz1CfbtJEZXpc57rKfOfNvOWDPRCuJuc19SJuSyTZ9kX1/eXB9wKuEUzaDwkkNm
	 O4LBt5XxqQRB4FRIxw3J/CiNXUjygpeBQNAUpt9qV6jBN6fGZ1ug3rVFxA9gpAiD1u
	 LzH+9sWuaAYunAFSzgs8GGEqd9+XBB1TM04aaQZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Mostafa Saleh <smostafa@google.com>,
	Petr Tesarik <ptesarik@suse.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0789/1191] iommu/dma: Check atomic pool allocation result directly
Date: Sat, 12 Sep 2026 08:58:37 +0200
Message-ID: <20260912065605.996623160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

[ Upstream commit af95a0ebc0a0db0762be75f51eadf770bad01aaa ]

The non-blocking, non-coherent allocation path uses dma_alloc_from_pool(),
which returns the allocated page and fills cpu_addr only on success.

Do not rely on cpu_addr to detect allocation failure in this path. Check
the returned page directly before using it for the IOMMU mapping.

Fixes: 9420139f516d ("dma-pool: fix coherent pool allocations for IOMMU mappings")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Petr Tesarik <ptesarik@suse.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Link: https://lore.kernel.org/r/20260717180442.110954-4-aneesh.kumar@kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index cbf9ec320691a..c3e5f9a435ffb 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1459,13 +1459,16 @@ static void *iommu_dma_alloc(struct device *dev, size_t size,
 	}
 
 	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-	    !gfpflags_allow_blocking(gfp) && !coherent)
+	    !gfpflags_allow_blocking(gfp) && !coherent) {
 		page = dma_alloc_from_pool(dev, PAGE_ALIGN(size), &cpu_addr,
-					       gfp, NULL);
-	else
+					   gfp, NULL);
+		if (!page)
+			return NULL;
+	} else {
 		cpu_addr = iommu_dma_alloc_pages(dev, size, &page, gfp, attrs);
-	if (!cpu_addr)
-		return NULL;
+		if (!cpu_addr)
+			return NULL;
+	}
 
 	*handle = __iommu_dma_map(dev, page_to_phys(page), size, ioprot,
 			dev->coherent_dma_mask);
-- 
2.53.0



