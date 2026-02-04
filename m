Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49113219301;
	Wed,  4 Feb 2026 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216588; cv=none; b=bExVfM+EaUZ7iNVhAnfEbbUSparB3HkXoIgeeXwKdUhOYUC72zEu89Tp9F57L88lJE11Ee+9K8sHM9dckyLCv+1Yn1oL5Mfe1tiRWHpZ4Doo8OZdXKxHvrGB4lFvhyYx9ISyAYREbAlwQk66WFR11k4qJS3Nree9S6b52fknRVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216588; c=relaxed/simple;
	bh=Ld1d69TiqeuMuNxbSE3FIefMMmRmZUa/3qm6ljFSwcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvNPOq5ew2bLMWesRyKeHgvVtRzEQL4jBufcyUb0ARRASStxXjINKXKSJhnOVQE//aJE4QiU1ja5/hkOy82O1PbdWvExtWZnlVrNPiUe06Zq30u87zVnFp2B8TCf9IIBXozJu7/okuHW6d/gq1OB66tGwyPHcvSLNXuE02Y8In8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3/g1o71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3/g1o71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD836C4CEF7;
	Wed,  4 Feb 2026 14:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216588;
	bh=Ld1d69TiqeuMuNxbSE3FIefMMmRmZUa/3qm6ljFSwcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3/g1o71QwEKm17wXa74qonnOcICQbELgUm6iTG8mEnbec5B34zU1JFiGIFjNJXy7
	 dQ7jKRSIJY95E1e0W2blrm/JKczuA6eAC2zVC5V8mZGW6lc3joOgL6IhHROkZLp2Br
	 tCDJDpC8eqAvSAkRK7a8slRh1ASZwlAWHv/PkR1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Sree Kartheek Adivi <s-adivi@ti.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/161] dma/pool: distinguish between missing and exhausted atomic pools
Date: Wed,  4 Feb 2026 15:39:54 +0100
Message-ID: <20260204143856.456488383@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sai Sree Kartheek Adivi <s-adivi@ti.com>

[ Upstream commit 56c430c7f06d838fe3b2077dbbc4cc0bf992312b ]

Currently, dma_alloc_from_pool() unconditionally warns and dumps a stack
trace when an allocation fails, with the message "Failed to get suitable
pool".

This conflates two distinct failure modes:
1. Configuration error: No atomic pool is available for the requested
   DMA mask (a fundamental system setup issue)
2. Resource Exhaustion: A suitable pool exists but is currently full (a
   recoverable runtime state)

This lack of distinction prevents drivers from using __GFP_NOWARN to
suppress error messages during temporary pressure spikes, such as when
awaiting synchronous reclaim of descriptors.

Refactor the error handling to distinguish these cases:
- If no suitable pool is found, keep the unconditional WARN regarding
  the missing pool.
- If a pool was found but is exhausted, respect __GFP_NOWARN and update
  the warning message to explicitly state "DMA pool exhausted".

Fixes: 9420139f516d ("dma-pool: fix coherent pool allocations for IOMMU mappings")
Signed-off-by: Sai Sree Kartheek Adivi <s-adivi@ti.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260128133554.3056582-1-s-adivi@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/pool.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -271,15 +271,20 @@ struct page *dma_alloc_from_pool(struct
 {
 	struct gen_pool *pool = NULL;
 	struct page *page;
+	bool pool_found = false;
 
 	while ((pool = dma_guess_pool(pool, gfp))) {
+		pool_found = true;
 		page = __dma_alloc_from_pool(dev, size, pool, cpu_addr,
 					     phys_addr_ok);
 		if (page)
 			return page;
 	}
 
-	WARN(1, "Failed to get suitable pool for %s\n", dev_name(dev));
+	if (pool_found)
+		WARN(!(gfp & __GFP_NOWARN), "DMA pool exhausted for %s\n", dev_name(dev));
+	else
+		WARN(1, "Failed to get suitable pool for %s\n", dev_name(dev));
 	return NULL;
 }
 


