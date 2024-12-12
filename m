Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50ED2156FF;
	Thu, 12 Dec 2024 15:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015936; cv=none; b=ooZlrLmhumhIRfziHUAwErEcWabat3zz+vP2NhWCWw/LM0Q2RXChk9oo+VcK2oDT7ggnzDPOPY31ET2pEnG+0Sk3BuYuzcfiaaaw/fVS1FeKilVmESKa1MGF4Z6hFo1J8lj7tJdqfdJ/b5lcmZilggHWEPdGtWCi+Xv0+qBnvWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015936; c=relaxed/simple;
	bh=qiQh5ahLbr8j8i5h66aj0rGgACw7p1+MLr0glwUDY68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbfMaSwRms1n34try6GQu1B7dVNw4oHy2VkFOvfk4cXVxJ4DSaLfsEgVSnRvv3QbZvPFl1/lqCGGyct2AhySfkeLP0sJFncVjZJZu/p6szOSCAFNxkl1DS6mkCwthkTpI6glSY44BzHMjtJBQGCPxdcy+vCP7upeWW/FufLbUWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIQ0lFRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIQ0lFRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC784C4CECE;
	Thu, 12 Dec 2024 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015936;
	bh=qiQh5ahLbr8j8i5h66aj0rGgACw7p1+MLr0glwUDY68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIQ0lFRsQmHlEM9Fs9pE7Egl7rAo9cgFWOT7YP/j9P9nq0mUjYzP4N3EB2EC5GRUP
	 Z3V4mSb39/gcHxFQHfHR+NmpCoIWkHUk7Opl329yRTha8YHjTSTYNIyRnRDlR9aIrW
	 pBXo/2ksP4qdNLnVJEKpqw6/lsmq4qNIPLo1nXp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alasdair McWilliam <alasdair.mcwilliam@outlook.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/466] xsk: always clear DMA mapping information when unmapping the pool
Date: Thu, 12 Dec 2024 15:54:14 +0100
Message-ID: <20241212144310.178858681@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit ac9a48a6f1610b094072b815e884e1668aea4401 ]

When the umem is shared, the DMA mapping is also shared between the xsk
pools, therefore it should stay valid as long as at least 1 user remains.
However, the pool also keeps the copies of DMA-related information that are
initialized in the same way in xp_init_dma_info(), but cleared by
xp_dma_unmap() only for the last remaining pool, this causes the problems
below.

The first one is that the commit adbf5a42341f ("ice: remove af_xdp_zc_qps
bitmap") relies on pool->dev to determine the presence of a ZC pool on a
given queue, avoiding internal bookkeeping. This works perfectly fine if
the UMEM is not shared, but reliably fails otherwise as stated in the
linked report.

The second one is pool->dma_pages which is dynamically allocated and
only freed in xp_dma_unmap(), this leads to a small memory leak. kmemleak
does not catch it, but by printing the allocation results after terminating
the userspace program it is possible to see that all addresses except the
one belonging to the last detached pool are still accessible through the
kmemleak dump functionality.

Always clear the DMA mapping information from the pool and free
pool->dma_pages when unmapping the pool, so that the only difference
between results of the last remaining user's call and the ones before would
be the destruction of the DMA mapping.

Fixes: adbf5a42341f ("ice: remove af_xdp_zc_qps bitmap")
Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
Reported-by: Alasdair McWilliam <alasdair.mcwilliam@outlook.com>
Closes: https://lore.kernel.org/PA4P194MB10056F208AF221D043F57A3D86512@PA4P194MB1005.EURP194.PROD.OUTLOOK.COM
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://lore.kernel.org/r/20241122112912.89881-1-larysa.zaremba@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_buff_pool.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 521a2938e50a1..0662d34b09ee7 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -387,10 +387,9 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 		return;
 	}
 
-	if (!refcount_dec_and_test(&dma_map->users))
-		return;
+	if (refcount_dec_and_test(&dma_map->users))
+		__xp_dma_unmap(dma_map, attrs);
 
-	__xp_dma_unmap(dma_map, attrs);
 	kvfree(pool->dma_pages);
 	pool->dma_pages = NULL;
 	pool->dma_pages_cnt = 0;
-- 
2.43.0



