Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061272;
	b=SmdHAgRRiLugGCghWCZjb2WT7cJowNb8EnV8hkcqzvIXpFttW56NDI0yFj5HCtd/RwiQ
	 2DaIUUYZBXGjZ3Qz2zydrjm83ZAPwpxpoWSgGq9QkeNzDnSdABcEx7q7aFvJd8phSWgKd
	 5TUAmaB8NdcoEpAy/slkzhUbXf7pkekmoydII0TIGYoY0OtaQoUPDpRxA3+W0UFuyf+nG
	 HgBmozhsJKMxSo+vMuiqU/x0+OIeSQYxhrZHLs+A+HMRcU0ParbDPAg5wKdww4taTcFHb
	 PSDxGWGsvtcRBFKGMIJCJtI+aOKmRJCEOiokDSBK5fxDhZVPpdnFZb5szHWL+u4EW8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LDEWYcKtuco275hyj4LHHjjTewxUL5cRcTka9UlfYPA=;
	b=vi/imuMweal4FwVZPgzX9pWGixOl09e+VyYMouNoFf4M08ZSTaa3MkSuvwHiT8DR0iwc
	 uuJrVQ6K2b0FRwJ5y9WSpku/LgQ6e1t9fMdx/vWJo88NH0EBlfJldmOINELyzKirNS1GJ
	 PiAjP17VIaz+mtu75foAyuSKnaN53AHZDNMWxZ/YVq6rDkh2HuXlk/qd5KOEJ4J6GfWHw
	 tjsxYfWsNqxsXR961O5MACAHaw+epkvm73edNn7VaAZpGcFyK+KbBeBofnXGipoXfsNP5
	 wy0BuTWesCO/GSauhAOk5Y0kZjG+uh3QFm4PwP9G5JR0FKHP3DwiX6FTJqJke8d5lPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vXsaFwTM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534CF606A326;
	Thu, 19 Nov 2026 04:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vXsaFwTM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44721F000C5;
	Thu, 19 Nov 2026 04:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061272;
	bh=LDEWYcKtuco275hyj4LHHjjTewxUL5cRcTka9UlfYPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXsaFwTMOTXWprWgIn3AfzopQjCuaDjwKEYeHFAYOKClq1wQGbV+mXtyh9t8GMYZC
	 2NNoRHNweuO5JMwNnXjTIt6iPW0TElraDokALYlgi+X8ajLiGtBpBzailVTQSILJkA
	 V6k8TiI4s31mFFmnlVQrE7qTWGpLYuajKt81qQ9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1492/1848] dmaengine: ste_dma40: Fix LCLA allocation order
Date: Wed, 18 Nov 2026 15:58:50 +0100
Message-ID: <20261118150021.690454310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 7d4dc355c574d414d2402ac481a2fc4ee51e2771 ]

d40_lcla_allocate() calculates the number of pages needed for LCLA, but
passes that raw page count as the allocation order to __get_free_pages().
The same value is later passed to free_pages().

Store the allocation order with get_order() instead, and use a separate
byte size for allocation diagnostics, fallback kmalloc() sizing and DMA
mapping.

Fixes: 508849ade23c ("DMAENGINE: ste_dma40: allocate LCLA dynamically")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225114.AE1511F000E9@smtp.kernel.org/
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-12-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 9408aeb72eeda..c4cd9ff90529c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -413,8 +413,8 @@ struct d40_desc {
  * @dma_addr: DMA address, if mapped
  * @base_unaligned: The orignal kmalloc pointer, if kmalloc is used.
  * This pointer is only there for clean-up on error.
- * @pages: The number of pages needed for all physical channels.
- * Only used later for clean-up on error
+ * @alloc_order: Order used for the LCLA page allocation.
+ * Only used later for clean-up on error.
  * @lock: Lock to protect the content in this struct.
  * @alloc_map: big map over which LCLA entry is own by which job.
  */
@@ -422,7 +422,7 @@ struct d40_lcla_pool {
 	void		*base;
 	dma_addr_t	dma_addr;
 	void		*base_unaligned;
-	int		 pages;
+	unsigned int	 alloc_order;
 	spinlock_t	 lock;
 	struct d40_desc	**alloc_map;
 };
@@ -3412,6 +3412,7 @@ static void __init d40_hw_init(struct d40_base *base)
 static int __init d40_lcla_allocate(struct d40_base *base)
 {
 	struct d40_lcla_pool *pool = &base->lcla_pool;
+	size_t lcla_size = SZ_1K * base->num_phy_chans;
 	unsigned long *page_list;
 	int i, j;
 	int ret;
@@ -3427,20 +3428,20 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 	if (!page_list)
 		return -ENOMEM;
 
-	/* Calculating how many pages that are required */
-	base->lcla_pool.pages = SZ_1K * base->num_phy_chans / PAGE_SIZE;
+	base->lcla_pool.alloc_order = get_order(lcla_size);
 
 	for (i = 0; i < MAX_LCLA_ALLOC_ATTEMPTS; i++) {
 		page_list[i] = __get_free_pages(GFP_KERNEL,
-						base->lcla_pool.pages);
+						base->lcla_pool.alloc_order);
 		if (!page_list[i]) {
 
-			d40_err(base->dev, "Failed to allocate %d pages.\n",
-				base->lcla_pool.pages);
+			d40_err(base->dev, "Failed to allocate %zu bytes.\n",
+				lcla_size);
 			ret = -ENOMEM;
 
 			for (j = 0; j < i; j++)
-				free_pages(page_list[j], base->lcla_pool.pages);
+				free_pages(page_list[j],
+					   base->lcla_pool.alloc_order);
 			goto free_page_list;
 		}
 
@@ -3450,7 +3451,7 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 	}
 
 	for (j = 0; j < i; j++)
-		free_pages(page_list[j], base->lcla_pool.pages);
+		free_pages(page_list[j], base->lcla_pool.alloc_order);
 
 	if (i < MAX_LCLA_ALLOC_ATTEMPTS) {
 		base->lcla_pool.base = (void *)page_list[i];
@@ -3460,10 +3461,9 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 		 * alignment, try with allocating a big buffer.
 		 */
 		dev_warn(base->dev,
-			 "[%s] Failed to get %d pages @ 18 bit align.\n",
-			 __func__, base->lcla_pool.pages);
-		base->lcla_pool.base_unaligned = kmalloc(SZ_1K *
-							 base->num_phy_chans +
+			 "[%s] Failed to get %zu bytes @ 18 bit align.\n",
+			 __func__, lcla_size);
+		base->lcla_pool.base_unaligned = kmalloc(lcla_size +
 							 LCLA_ALIGNMENT,
 							 GFP_KERNEL);
 		if (!base->lcla_pool.base_unaligned) {
@@ -3475,8 +3475,7 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 						 LCLA_ALIGNMENT);
 	}
 
-	pool->dma_addr = dma_map_single(base->dev, pool->base,
-					SZ_1K * base->num_phy_chans,
+	pool->dma_addr = dma_map_single(base->dev, pool->base, lcla_size,
 					DMA_TO_DEVICE);
 	if (dma_mapping_error(base->dev, pool->dma_addr)) {
 		pool->dma_addr = 0;
@@ -3710,7 +3709,7 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	if (!base->lcla_pool.base_unaligned && base->lcla_pool.base)
 		free_pages((unsigned long)base->lcla_pool.base,
-			   base->lcla_pool.pages);
+			   base->lcla_pool.alloc_order);
 
 	kfree(base->lcla_pool.base_unaligned);
 
-- 
2.53.0



