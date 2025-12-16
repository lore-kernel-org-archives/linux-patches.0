Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F60E342C9E;
	Tue, 16 Dec 2025 11:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884889; cv=none; b=nCz7GbzfUzTFuclt9VjGaIjSxGzVtfDsFKFOauKFuS94MYipU9au3UxXI4apqdkNlV5vPI/nUA8aCU8Vq1r/BfCEULgKYY20R8taicrGUkG7lu9Tboupab6qYyU87s8kKOo6fdFV66byDYcCelrfONw0k5fmmO1PXAAufhl8ojU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884889; c=relaxed/simple;
	bh=dU0p12wom2untaYCBQU9Vl5v+Ehq0ORSluDC35VG0RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdg0pMJ38kslRZyM/UOGGwgbet8eL9aI70zXffux6JqLA2Ire4CUKGhjF4s+zIM/Fj+VajduxJjPZZcrQYvoc1FSDZBkes5WCmyofDs6vffdbsYB63ykZHqQuZOYrX6Fmp6DbhmGISjSmTjTZyuDTyPTRJaHD2HXL5PCZF4xSxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6NBnsT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6NBnsT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD912C4CEF1;
	Tue, 16 Dec 2025 11:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884889;
	bh=dU0p12wom2untaYCBQU9Vl5v+Ehq0ORSluDC35VG0RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6NBnsT4uwtXEAeqpif0EkTjKeyyISmFZ3oB0Y7GV94EZM8OVlghaJaa01uMjFOL+
	 AAwOmySJGfalcv/s/HmUgK5flKp/o6N3iOmTzdcr817gDN7qyErhYfwoa3vWDJCBhU
	 9rei4alSSurc3GNNRlXi/4AJP/KaFrXGdHPmiaxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/354] dma/pool: eliminate alloc_pages warning in atomic_pool_expand
Date: Tue, 16 Dec 2025 12:14:57 +0100
Message-ID: <20251216111332.865528424@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



