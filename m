Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBF31C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32695C433EF;
	Wed, 28 Dec 2022 16:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244700;
	bh=qNLVgOCpTLN32DhSLdvueH8qqG8sjzSc6ai5ptu6FbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEMLE8KG2JM9nGOg/u30kuuDoDc3/KYxcKk3FWzJpq9lRs9k6rnArRkpwmv7lXcom
	 WjpWZbEPby5IMB3xxtPQbbSSg7pfpNGvSpPUyprvM8UVVs1us85zogeGy8TJEFufwB
	 BsxH9uq/ko5zYZf7SbeLfcguQusrOoJQjGNlwSwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0759/1073] RDMA/siw: Fix pointer cast warning
Date: Wed, 28 Dec 2022 15:39:07 +0100
Message-Id: <20221228144348.631979433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5244ca88671a1981ceec09c5c8809f003e6a62aa ]

The previous build fix left a remaining issue in configurations with
64-bit dma_addr_t on 32-bit architectures:

drivers/infiniband/sw/siw/siw_qp_tx.c: In function 'siw_get_pblpage':
drivers/infiniband/sw/siw/siw_qp_tx.c:32:37: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
   32 |                 return virt_to_page((void *)paddr);
      |                                     ^

Use the same double cast here that the driver uses elsewhere to convert
between dma_addr_t and void*.

Fixes: 0d1b756acf60 ("RDMA/siw: Pass a pointer to virt_to_page()")
Link: https://lore.kernel.org/r/20221215170347.2612403-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 7d47b521070b..05052b49107f 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -29,7 +29,7 @@ static struct page *siw_get_pblpage(struct siw_mem *mem, u64 addr, int *idx)
 	dma_addr_t paddr = siw_pbl_get_buffer(pbl, offset, NULL, idx);
 
 	if (paddr)
-		return virt_to_page((void *)paddr);
+		return virt_to_page((void *)(uintptr_t)paddr);
 
 	return NULL;
 }
-- 
2.35.1



