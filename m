Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B1D368271;
	Tue, 16 Dec 2025 12:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888579; cv=none; b=SVJ762b51BDpkdMfgKow+j+jFxRJq9amvqoWj4eFhh/n6NvDjdbYFwyOlvtH1r9MT9nTie2hlErGwdurhJCS+awvedfG5Ib5NSWMGM75T8Q/G4P+hFfrDTwnOwvTGEdBfqS7BQOLxW8pzZlH7/dnLHwLL72RON/IAJGkXi/LVn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888579; c=relaxed/simple;
	bh=DwFUIefzRQbHk0K4yFzErvhZTPoDwsnsnHzQsGSai6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSjUU7GOM4E2lZg6aHvuIXrMlAQFaemuDobuFkVv6140ROxdhoCYwA50aQfYdXpJU11U60BjuUu0XxIvSNpvRK3hsnre2FjEBIn4vWBvmUOblSLBeJMhi8R46iETflXtyocgJTxOxlHtenkofNfEn4GKULF2Z52zSO8pyJA2QMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCkiffH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCkiffH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740E4C4CEF1;
	Tue, 16 Dec 2025 12:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888578;
	bh=DwFUIefzRQbHk0K4yFzErvhZTPoDwsnsnHzQsGSai6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCkiffH30ND7tdnLfyLcEF0Bo7orQ5kFGQyRNkbNnHXh8BW0MQF2nbUVHBMc2UaEo
	 yaF4gj+tZzzWb0fAfMpWVLvHzq0fq7zGfzW+VCn5PSc8yhwPRfioWGZ+mhp8dLNH4o
	 kFT83JSxOOjjjw3fELjKslgKX0G+OSUvka/pfyoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 577/614] dma/pool: eliminate alloc_pages warning in atomic_pool_expand
Date: Tue, 16 Dec 2025 12:15:44 +0100
Message-ID: <20251216111422.290497808@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



