Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2EA2D9494;
	Thu, 15 Jan 2026 17:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497747; cv=none; b=XT+OufhEMoisIkmjMEFJrT43B3t1qVKvx+YEDzTCsSXwPOCvwG9sRPjdtf7YRsDTsFvQ8yRKSwPlm9df9EPKirfJlUrRLjEluUof9H6a6HjrQMtljjozExZGRBKzQOpxZHeiVhMZndp/zEwTZ2kDytU88Zik0JEYqWmP1Qhimmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497747; c=relaxed/simple;
	bh=8fEcr555e31aUU5sxZk2D6HvG/uzZzdXKnOCO0IKAF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOsnHtFpEnM1HftNXXymPzvxxfdIw1z+y1jRFjdkQSzgJej7vji+Z7NkZ1SS6lt04RZBrOm+9eb/wMNqrVhjQV90Kco0hX7jA6xYckR2zuaF2HErbZeBd2071YD2DOwfuQJeOzhG7AYQhW8bem3KenFYT26IVOp8bNqH9gt2EJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZF4GXPYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZF4GXPYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4912EC116D0;
	Thu, 15 Jan 2026 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497747;
	bh=8fEcr555e31aUU5sxZk2D6HvG/uzZzdXKnOCO0IKAF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZF4GXPYaA2RQpd9d1UETvRKBYdtjLiVegwgQgYa4IKjhhZZ+S4WkT9itwCKR8sLSD
	 NEp5MOEV429CLqCc8PeXAFfhUd2pajujiyQ92FjyoOsM9dYdOOA3Qs/GxGB4ndyJIy
	 kh/2y6QXQgEU2+N9aPYCJPLvLWjfGLbv+7xwp3j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/554] dma/pool: eliminate alloc_pages warning in atomic_pool_expand
Date: Thu, 15 Jan 2026 17:44:15 +0100
Message-ID: <20260115164253.102194169@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 37d3ddd36ae5b..1e9d4cb018693 100644
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



