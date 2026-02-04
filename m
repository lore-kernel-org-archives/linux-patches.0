Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7E11C5D57;
	Wed,  4 Feb 2026 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219057; cv=none; b=GQjvNXU1UrsoqGWmfkC0sTLZwggkRvpcDksG366xH4tksKC1oK2LJB0tKJ+jnzIaeluII7Kh+RAaM0k4FFBDnlHd3Tf3Q5kW4OAHabS4vOH4Bwrx2hSeqB2pFov+Llsw+lH5M6b+MZZRcsQWaRd5ksEejU4fq/9bzg46mbxRhyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219057; c=relaxed/simple;
	bh=T4ta11f/igTjqB5BRg+ZaQQOg9PRxuKSGcpRFybDy7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOFIzJcbnelBKuGhIVRKERg1g6pn//z0iBeD0SVm6mrOBmximlPQQdEEHoW6QIWnu7gTCEHHCl32ameWTH5wv4ppfTr0fIT4B/SIUb9sbzGaekZ0qBUtBb2OydeL7ScWGNc4hZeSdbFk9eTPeYi9hxBnQUAGifQoGeieB5Y4azE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQDA36QW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQDA36QW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23671C4CEF7;
	Wed,  4 Feb 2026 15:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219057;
	bh=T4ta11f/igTjqB5BRg+ZaQQOg9PRxuKSGcpRFybDy7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQDA36QWFr3l/KBLmP4xUX4c2SUjNQPn736B0zEDSHQkQJpfKOgnaFhb+nueJUYND
	 igCCi2YWmKAjQpqR6S5hyOpimXE8w/KniyO0JisUd/o/xxXQSlFVgG7hmZAn991TIy
	 fZn6RerEBq58KNSpJB4y4AmERzxcdxs+ilpS1XRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Sree Kartheek Adivi <s-adivi@ti.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/122] dma/pool: distinguish between missing and exhausted atomic pools
Date: Wed,  4 Feb 2026 15:40:35 +0100
Message-ID: <20260204143853.762843931@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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
 kernel/dma/pool.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 26392badc36b0..985d6aa102b67 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -268,15 +268,20 @@ struct page *dma_alloc_from_pool(struct device *dev, size_t size,
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
 
-- 
2.51.0



