Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B876FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB77FC433C7;
	Sun, 17 Sep 2023 20:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981102;
	bh=szUOsgoyGnld9wPzHnMT2Xj9OSq9XJDlCdNQ3KaVsH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2HGKbLNRi3NQvrq5RT7kL0q/oMu8Y5HS6CtSPp7eH3BclEAG5Bsoml1En4mwldkf
	 BIINddt1a2AkBn2I/JooF+ib/DxWtaGdJAIsaLqbSFamMDR/pMzu1p9w4ZyoIWblxg
	 ovAs8MjnZFCSwpdm1G6zVYFWO6WOzPg7SeMmIbmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ajay Kaher <akaher@vmware.com>
Subject: [PATCH 6.1 053/219] net: remove osize variable in __alloc_skb()
Date: Sun, 17 Sep 2023 21:13:00 +0200
Message-ID: <20230917191042.922231265@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 65998d2bf857b9ae5acc1f3b70892bd1b429ccab upstream.

This is a cleanup patch, to prepare following change.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[Ajay: Regenerated the patch for v6.1.y]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -479,7 +479,6 @@ struct sk_buff *__alloc_skb(unsigned int
 {
 	struct kmem_cache *cache;
 	struct sk_buff *skb;
-	unsigned int osize;
 	bool pfmemalloc;
 	u8 *data;
 
@@ -505,16 +504,15 @@ struct sk_buff *__alloc_skb(unsigned int
 	 * Both skb->head and skb_shared_info are cache line aligned.
 	 */
 	size = SKB_HEAD_ALIGN(size);
-	osize = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(osize, gfp_mask, node, &pfmemalloc);
+	size = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
 	if (unlikely(!data))
 		goto nodata;
 	/* kmalloc_size_roundup() might give us more room than requested.
 	 * Put skb_shared_info exactly at the end of allocated zone,
 	 * to allow max possible filling before reallocation.
 	 */
-	size = SKB_WITH_OVERHEAD(osize);
-	prefetchw(data + size);
+	prefetchw(data + SKB_WITH_OVERHEAD(size));
 
 	/*
 	 * Only clear those fields we need to clear, not those that we will
@@ -522,7 +520,7 @@ struct sk_buff *__alloc_skb(unsigned int
 	 * the tail pointer in struct sk_buff!
 	 */
 	memset(skb, 0, offsetof(struct sk_buff, tail));
-	__build_skb_around(skb, data, osize);
+	__build_skb_around(skb, data, size);
 	skb->pfmemalloc = pfmemalloc;
 
 	if (flags & SKB_ALLOC_FCLONE) {


