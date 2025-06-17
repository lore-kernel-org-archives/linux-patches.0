Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929CB2ED17D;
	Tue, 17 Jun 2025 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175384; cv=none; b=u28TkLgDdNSxqkTGUQnIsZef/zGWRnXdXQ2hd8pDPzZdQ2ysRiP0VKaniS17ImuVfUb1kOU+RRq3rYUC6jFjzcI5TURcP3Nh2quxuXHB46FzuT5frW8ZLcEW7cJMOssnoHTnqgjG07mNABgolWB6BV67nDqpsMfqcUlvzjJA69c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175384; c=relaxed/simple;
	bh=vdb1cPsSNCxF4qrRG9LKZNeoVJq7Ur7sGM7erCB+/Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/0eRRibhTK59fFmteb6jB6LtNQQ9rj8s0Z45CmiiFTFlFDkGERBZXeZkW79N6AMDG/hGia4uHHz/TPmPEmOyZynkAD6HtlRqOliMLkkSMYvyZES3f9RG+WMVPtBxH9PE79fi3/YFIygR5pPqs71nNWh7J/FXYh9EclyCKHP/G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o77as2L3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o77as2L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006D8C4CEE3;
	Tue, 17 Jun 2025 15:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175384;
	bh=vdb1cPsSNCxF4qrRG9LKZNeoVJq7Ur7sGM7erCB+/Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o77as2L3FZq3jbJy/GLsvNsvUmC7d34dz1En8MPFUAuC74y6XBYc7JMPrNPI1rrLA
	 BcsnWrE023gC2hQdlXa6CiIEH3FMFjWrZfn5qkEg6IIvVAOGzpVgGUhGW+mDMPmfxg
	 YRSjO3mNrHw89Kn43SRg6HgxPsx3vm75K3DIdu1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/512] page_pool: Move pp_magic check into helper functions
Date: Tue, 17 Jun 2025 17:21:27 +0200
Message-ID: <20250617152424.498265986@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit cd3c93167da0e760b5819246eae7a4ea30fd014b ]

Since we are about to stash some more information into the pp_magic
field, let's move the magic signature checks into a pair of helper
functions so it can be changed in one place.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Tested-by: Yonglong Liu <liuyonglong@huawei.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20250409-page-pool-track-dma-v9-1-6a9ef2e0cba8@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  4 ++--
 include/linux/mm.h                            | 20 +++++++++++++++++++
 mm/page_alloc.c                               |  8 ++------
 net/core/netmem_priv.h                        |  5 +++++
 net/core/skbuff.c                             | 16 ++-------------
 net/core/xdp.c                                |  4 ++--
 6 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 08ab0999f7b31..14192da4b8ed0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -706,8 +706,8 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
 				page = xdpi.page.page;
 
-				/* No need to check ((page->pp_magic & ~0x3UL) == PP_SIGNATURE)
-				 * as we know this is a page_pool page.
+				/* No need to check page_pool_page_is_pp() as we
+				 * know this is a page_pool page.
 				 */
 				page_pool_recycle_direct(page->pp, page);
 			} while (++n < num);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8617adc6becd1..412f5efe3ae79 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4243,4 +4243,24 @@ static inline void pgalloc_tag_copy(struct folio *new, struct folio *old)
 }
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
+/* Mask used for checking in page_pool_page_is_pp() below. page->pp_magic is
+ * OR'ed with PP_SIGNATURE after the allocation in order to preserve bit 0 for
+ * the head page of compound page and bit 1 for pfmemalloc page.
+ * page_is_pfmemalloc() is checked in __page_pool_put_page() to avoid recycling
+ * the pfmemalloc page.
+ */
+#define PP_MAGIC_MASK ~0x3UL
+
+#ifdef CONFIG_PAGE_POOL
+static inline bool page_pool_page_is_pp(struct page *page)
+{
+	return (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
+}
+#else
+static inline bool page_pool_page_is_pp(struct page *page)
+{
+	return false;
+}
+#endif
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 882903f42300b..752576749db9d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -872,9 +872,7 @@ static inline bool page_expected_state(struct page *page,
 #ifdef CONFIG_MEMCG
 			page->memcg_data |
 #endif
-#ifdef CONFIG_PAGE_POOL
-			((page->pp_magic & ~0x3UL) == PP_SIGNATURE) |
-#endif
+			page_pool_page_is_pp(page) |
 			(page->flags & check_flags)))
 		return false;
 
@@ -901,10 +899,8 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
 	if (unlikely(page->memcg_data))
 		bad_reason = "page still charged to cgroup";
 #endif
-#ifdef CONFIG_PAGE_POOL
-	if (unlikely((page->pp_magic & ~0x3UL) == PP_SIGNATURE))
+	if (unlikely(page_pool_page_is_pp(page)))
 		bad_reason = "page_pool leak";
-#endif
 	return bad_reason;
 }
 
diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
index 7eadb8393e002..f33162fd281c2 100644
--- a/net/core/netmem_priv.h
+++ b/net/core/netmem_priv.h
@@ -18,6 +18,11 @@ static inline void netmem_clear_pp_magic(netmem_ref netmem)
 	__netmem_clear_lsb(netmem)->pp_magic = 0;
 }
 
+static inline bool netmem_is_pp(netmem_ref netmem)
+{
+	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
+}
+
 static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
 {
 	__netmem_clear_lsb(netmem)->pp = pool;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f220306731dac..fdb36165c58f5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -925,11 +925,6 @@ static void skb_clone_fraglist(struct sk_buff *skb)
 		skb_get(list);
 }
 
-static bool is_pp_netmem(netmem_ref netmem)
-{
-	return (netmem_get_pp_magic(netmem) & ~0x3UL) == PP_SIGNATURE;
-}
-
 int skb_pp_cow_data(struct page_pool *pool, struct sk_buff **pskb,
 		    unsigned int headroom)
 {
@@ -1027,14 +1022,7 @@ bool napi_pp_put_page(netmem_ref netmem)
 {
 	netmem = netmem_compound_head(netmem);
 
-	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
-	 * in order to preserve any existing bits, such as bit 0 for the
-	 * head page of compound page and bit 1 for pfmemalloc page, so
-	 * mask those bits for freeing side when doing below checking,
-	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
-	 * to avoid recycling the pfmemalloc page.
-	 */
-	if (unlikely(!is_pp_netmem(netmem)))
+	if (unlikely(!netmem_is_pp(netmem)))
 		return false;
 
 	page_pool_put_full_netmem(netmem_get_pp(netmem), netmem, false);
@@ -1074,7 +1062,7 @@ static int skb_pp_frag_ref(struct sk_buff *skb)
 
 	for (i = 0; i < shinfo->nr_frags; i++) {
 		head_netmem = netmem_compound_head(shinfo->frags[i].netmem);
-		if (likely(is_pp_netmem(head_netmem)))
+		if (likely(netmem_is_pp(head_netmem)))
 			page_pool_ref_netmem(head_netmem);
 		else
 			page_ref_inc(netmem_to_page(head_netmem));
diff --git a/net/core/xdp.c b/net/core/xdp.c
index bcc5551c6424b..23e7d736718b0 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -381,8 +381,8 @@ void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		page = virt_to_head_page(data);
 		if (napi_direct && xdp_return_frame_no_direct())
 			napi_direct = false;
-		/* No need to check ((page->pp_magic & ~0x3UL) == PP_SIGNATURE)
-		 * as mem->type knows this a page_pool page
+		/* No need to check netmem_is_pp() as mem->type knows this a
+		 * page_pool page
 		 */
 		page_pool_put_full_page(page->pp, page, napi_direct);
 		break;
-- 
2.39.5



