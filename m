Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C93CFC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA06C433EF;
	Mon, 15 May 2023 17:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172559;
	bh=qiH6Q78HRt0KtkWuXHDlnhFGhd/Zw7UZ7mWe+nT+1Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0opFjuEoK+vXgwHVCSEfGijZwqC86UI9C096wGXdnKvYkfomb204p6xvhHveJOget
	 jhZZQLHoXpCEWQDT8/HI61BSavZY4mJsX0u1IxjDfV8xq4Wei4gNq0yU7qCoqW8bnX
	 IQXtSRlUdJpk2jWrLUXEi5me7b9rWxOu/XWD84fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kal Conley <kal.conley@dectris.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/381] xsk: Fix unaligned descriptor validation
Date: Mon, 15 May 2023 18:26:55 +0200
Message-Id: <20230515161744.211736691@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kal Conley <kal.conley@dectris.com>

[ Upstream commit d769ccaf957fe7391f357c0a923de71f594b8a2b ]

Make sure unaligned descriptors that straddle the end of the UMEM are
considered invalid. Currently, descriptor validation is broken for
zero-copy mode which only checks descriptors at page granularity.
For example, descriptors in zero-copy mode that overrun the end of the
UMEM but not a page boundary are (incorrectly) considered valid. The
UMEM boundary check needs to happen before the page boundary and
contiguity checks in xp_desc_crosses_non_contig_pg(). Do this check in
xp_unaligned_validate_desc() instead like xp_check_unaligned() already
does.

Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/r/20230405235920.7305-2-kal.conley@dectris.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xsk_buff_pool.h | 9 ++-------
 net/xdp/xsk_queue.h         | 1 +
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index c9a47d3d8f503..5a63e3b12335a 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -150,13 +150,8 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 	if (likely(!cross_pg))
 		return false;
 
-	if (pool->dma_pages_cnt) {
-		return !(pool->dma_pages[addr >> PAGE_SHIFT] &
-			 XSK_NEXT_PG_CONTIG_MASK);
-	}
-
-	/* skb path */
-	return addr + len > pool->addrs_cnt;
+	return pool->dma_pages_cnt &&
+	       !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
 }
 
 static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 3c7ce60fe9a5a..a76d43787549f 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -155,6 +155,7 @@ static inline bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
 		return false;
 
 	if (base_addr >= pool->addrs_cnt || addr >= pool->addrs_cnt ||
+	    addr + desc->len > pool->addrs_cnt ||
 	    xp_desc_crosses_non_contig_pg(pool, addr, desc->len))
 		return false;
 
-- 
2.39.2



