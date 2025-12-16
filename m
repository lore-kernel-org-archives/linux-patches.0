Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB0D3570B0;
	Tue, 16 Dec 2025 12:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886559; cv=none; b=TD9Qzd5k4Jc6stNS1NC16x0Zo7Qoiupl7ACsBSNgkkjByJNWI85q4LaRSE6x59Xnck4w+mAMrazqGAV90oV6Nsc45EauhunxqCw1A9cJ+8v0yVy5IqZthOQIeKCkkw23LWIFbnb1tEmKIe7b+PdLGz+XQlppbSGr000JeWvEqsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886559; c=relaxed/simple;
	bh=h/1dZJoK35LsBGPmIDmJN3X8N6QKD0XBzFb/NFOs2hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcgSnY7oHOyfxgI5KliExdeIEJvu+j7EgR2z+dWVUtPeWoEtq5g0RO+s294N4a+N3YuKDdK1a3SWa4xXe+gLbyAZ38J/bCeeeXBp8VRg7LeoFAU/838cwsHrR1o1VTIUQi+KQkhhQbyG3P0wjXWoEgmELgz6in/mHO32ZXZbemE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg3YzMTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg3YzMTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956E7C4CEF1;
	Tue, 16 Dec 2025 12:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886559;
	bh=h/1dZJoK35LsBGPmIDmJN3X8N6QKD0XBzFb/NFOs2hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg3YzMTHvCSa9hZK33k6YifqdPKNVHXFFRRPGqPp9MnwWpT/BmS0tTUaMyYxSK9Of
	 HP5821O/AaXeofBOlBQuAKb1oXKpEJXOVycZC1iPhRQaTod5A2bHdCj40hHkjtBOYH
	 BbPiNdjA/z8UWC+vhuhn/fn2INdZ8jtfxEkM/dwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 473/507] dma/pool: eliminate alloc_pages warning in atomic_pool_expand
Date: Tue, 16 Dec 2025 12:15:14 +0100
Message-ID: <20251216111402.580219751@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 463d439becb81383f3a5a5d840800131f265a09c ]

atomic_pool_expand iteratively tries the allocation while decrementing
the page order. There is no need to issue a warning if an attempted
allocation fails.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Fixes: d7e673ec2c8e ("dma-pool: Only allocate from CMA when in same memory zone")
[mszyprow: fixed typo]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20251202152810.142370-1-dave.kleikamp@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index ee45dee33d491..26392badc36b0 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -93,7 +93,7 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 			page = dma_alloc_from_contiguous(NULL, 1 << order,
 							 order, false);
 		if (!page)
-			page = alloc_pages(gfp, order);
+			page = alloc_pages(gfp | __GFP_NOWARN, order);
 	} while (!page && order-- > 0);
 	if (!page)
 		goto out;
-- 
2.51.0



