Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067B13173F;
	Fri, 24 Nov 2023 19:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjirQ9kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AA5C433C7;
	Fri, 24 Nov 2023 19:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853590;
	bh=ryqwDfMu/NX4dy2JbKL1AdyDfdXc5DaFeODroALTKq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjirQ9kzPStjDI/I0L2j8oE1JKUvJOEl+wMhAPeeHwkPLke4PyyG6tKGWX62nFijm
	 lhaKSh3fzHxrDG0I3L8k4tlkZi6+V67sd73g8H6YiE3jy43/y0XNvdFOdSKx6kz/fR
	 JWxJB2S/iSsaz5wIo7LuuAiYlJflUUpN9quFYC48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/297] powerpc/pseries/ddw: simplify enable_ddw()
Date: Fri, 24 Nov 2023 17:54:52 +0000
Message-ID: <20231124172008.932733130@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit fb4ee2b30cd09e95524640149e4ee0d7f22c3e7b ]

This drops rather useless ddw_enabled flag as direct_mapping implies
it anyway.

While at this, fix indents in enable_ddw().

This should not cause any behavioral change.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211108040320.3857636-3-aik@ozlabs.ru
Stable-dep-of: 3bf983e4e93c ("powerpc/pseries/iommu: enable_ddw incorrectly returns direct mapping for SR-IOV device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index ec5d84b4958c5..aa5f8074e9b10 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1241,7 +1241,6 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	u32 ddw_avail[DDW_APPLICABLE_SIZE];
 	struct dma_win *window;
 	struct property *win64;
-	bool ddw_enabled = false;
 	struct failed_ddw_pdn *fpdn;
 	bool default_win_removed = false, direct_mapping = false;
 	bool pmem_present;
@@ -1256,7 +1255,6 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 
 	if (find_existing_ddw(pdn, &dev->dev.archdata.dma_offset, &len)) {
 		direct_mapping = (len >= max_ram_len);
-		ddw_enabled = true;
 		goto out_unlock;
 	}
 
@@ -1411,8 +1409,8 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 			dev_info(&dev->dev, "failed to map DMA window for %pOF: %d\n",
 				 dn, ret);
 
-		/* Make sure to clean DDW if any TCE was set*/
-		clean_dma_window(pdn, win64->value);
+			/* Make sure to clean DDW if any TCE was set*/
+			clean_dma_window(pdn, win64->value);
 			goto out_del_list;
 		}
 	} else {
@@ -1459,7 +1457,6 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	spin_unlock(&dma_win_list_lock);
 
 	dev->dev.archdata.dma_offset = win_addr;
-	ddw_enabled = true;
 	goto out_unlock;
 
 out_del_list:
@@ -1495,10 +1492,10 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	 * as RAM, then we failed to create a window to cover persistent
 	 * memory and need to set the DMA limit.
 	 */
-	if (pmem_present && ddw_enabled && direct_mapping && len == max_ram_len)
+	if (pmem_present && direct_mapping && len == max_ram_len)
 		dev->dev.bus_dma_limit = dev->dev.archdata.dma_offset + (1ULL << len);
 
-    return ddw_enabled && direct_mapping;
+	return direct_mapping;
 }
 
 static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
-- 
2.42.0



