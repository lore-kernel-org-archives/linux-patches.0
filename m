Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49BC1E8836;
	Fri,  9 Jan 2026 12:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962037; cv=none; b=iRr3JGc6rxWKEvpa2DyV7V+0KQTKNWlxOJdP/jNA6Zga1OLU6B8p7iwQZywU58YSKd3Jm3lMYYNtbToCPX7G1TgyRUdJ3uL/+mRIMBXcR3tEwDkiTuDA3c7ekZ2SeM5cttml053xi5Y/4LC6yQu8JmeZXDog8d3BY+N+wXStsRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962037; c=relaxed/simple;
	bh=/HK9a728RWmfD+1zuzbcyXMdHruj8tSjjRKfeshjqo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsWwHvhjHhZturoBmzIFGw1cvn1rrqkGzF8xLIqYfhaIvXBwNiSW/CyyROlgOF6BLK3uqlp2PuSXBybfak9CpZoOU/h7AGxG78cunGnRYA4p74m17QudYhav1JwWRigAPZMQMceyQWIX6wtsTaAp4rKP311PYpesn7B8Cvh9s7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1gHJXUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1gHJXUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306E4C4CEF1;
	Fri,  9 Jan 2026 12:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962037;
	bh=/HK9a728RWmfD+1zuzbcyXMdHruj8tSjjRKfeshjqo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1gHJXUadpwh5//9wMgDfK+5DktlW+isGnRpTo1eLwWCTYiBs/qwO+dpbVLQoj5Ip
	 KOVMx/lgOUh00TPGHoMdh30z7ZAUBguS4gpIn3Z6749i4JgL1FuYMY1pP3p8NCQxmx
	 hPapGULoh9R3Yvintpox1+NR+D+IB907HfsHYRp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/634] dma/pool: eliminate alloc_pages warning in atomic_pool_expand
Date: Fri,  9 Jan 2026 12:38:05 +0100
Message-ID: <20260109112125.227456057@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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



