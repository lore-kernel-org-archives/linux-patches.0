Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7FF1A76A3;
	Tue, 30 Jul 2024 17:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359717; cv=none; b=OtlJ6yA70RenXWuymoeiEmwzafXcl1SgFbGxXKzMLJG1DtWBnxJB+DOuQL7obJRlLlAGoWfvrc58zuSRd+oM1Y4jf3dnM3+O0KY4LYDx16fz7izovbrAX55iBCUiE6TALQcDa6xhX1sm8OTH+tSnFTJjXktlyphWgWUR+D3nVMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359717; c=relaxed/simple;
	bh=1zOrTbTRyy0TOyex5cZ3X5npeuE3zwhLTnvTrCwCLaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0oiEnuNPLo5QB4BE22oR0Dj73f62BMsE9mesi98EWJijGANTBxessN7LzXZZpzXrxNR8DTIzD5OElUtxOghVLQQJ8GZIj1pnxXwo15WFes2b4OQpf0DmaHkeq4PgOp01A8niGSp4Bc7SsJ+TS3kueIT3pyJ0J6r7drHKOS2xlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvlsO0st; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvlsO0st"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55FCC4AF0E;
	Tue, 30 Jul 2024 17:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359717;
	bh=1zOrTbTRyy0TOyex5cZ3X5npeuE3zwhLTnvTrCwCLaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvlsO0stI0o34edch7WRmgpikZSviRf7UD8974OQWM2ot/aPqq8jVmbEEBGvonbXe
	 Dzp1NKZkquM6J1iE+pYUxrLevAvD/l0IsMkmhk6CgGNP05mHjl8XB05LXHLDof1nL7
	 ffaPRVqZl7oUHHgr0FAo7pV2eTU0l9SVue9yzoe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yang <yang.yang@vivo.com>,
	Ming Lei <ming.lei@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 523/809] sbitmap: fix io hung due to race on sbitmap_word::cleared
Date: Tue, 30 Jul 2024 17:46:39 +0200
Message-ID: <20240730151745.396082429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yang <yang.yang@vivo.com>

[ Upstream commit 72d04bdcf3f7d7e07d82f9757946f68802a7270a ]

Configuration for sbq:
  depth=64, wake_batch=6, shift=6, map_nr=1

1. There are 64 requests in progress:
  map->word = 0xFFFFFFFFFFFFFFFF
2. After all the 64 requests complete, and no more requests come:
  map->word = 0xFFFFFFFFFFFFFFFF, map->cleared = 0xFFFFFFFFFFFFFFFF
3. Now two tasks try to allocate requests:
  T1:                                       T2:
  __blk_mq_get_tag                          .
  __sbitmap_queue_get                       .
  sbitmap_get                               .
  sbitmap_find_bit                          .
  sbitmap_find_bit_in_word                  .
  __sbitmap_get_word  -> nr=-1              __blk_mq_get_tag
  sbitmap_deferred_clear                    __sbitmap_queue_get
  /* map->cleared=0xFFFFFFFFFFFFFFFF */     sbitmap_find_bit
    if (!READ_ONCE(map->cleared))           sbitmap_find_bit_in_word
      return false;                         __sbitmap_get_word -> nr=-1
    mask = xchg(&map->cleared, 0)           sbitmap_deferred_clear
    atomic_long_andnot()                    /* map->cleared=0 */
                                              if (!(map->cleared))
                                                return false;
                                     /*
                                      * map->cleared is cleared by T1
                                      * T2 fail to acquire the tag
                                      */

4. T2 is the sole tag waiter. When T1 puts the tag, T2 cannot be woken
up due to the wake_batch being set at 6. If no more requests come, T1
will wait here indefinitely.

This patch achieves two purposes:
1. Check on ->cleared and update on both ->cleared and ->word need to
be done atomically, and using spinlock could be the simplest solution.
2. Add extra check in sbitmap_deferred_clear(), to identify whether
->word has free bits.

Fixes: ea86ea2cdced ("sbitmap: ammortize cost of clearing bits")
Signed-off-by: Yang Yang <yang.yang@vivo.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240716082644.659566-1-yang.yang@vivo.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sbitmap.h |  5 +++++
 lib/sbitmap.c           | 36 +++++++++++++++++++++++++++++-------
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index d662cf136021d..c09cdcc99471e 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -36,6 +36,11 @@ struct sbitmap_word {
 	 * @cleared: word holding cleared bits
 	 */
 	unsigned long cleared ____cacheline_aligned_in_smp;
+
+	/**
+	 * @swap_lock: serializes simultaneous updates of ->word and ->cleared
+	 */
+	spinlock_t swap_lock;
 } ____cacheline_aligned_in_smp;
 
 /**
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 1e453f825c05d..5e2e93307f0d0 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -60,12 +60,30 @@ static inline void update_alloc_hint_after_get(struct sbitmap *sb,
 /*
  * See if we have deferred clears that we can batch move
  */
-static inline bool sbitmap_deferred_clear(struct sbitmap_word *map)
+static inline bool sbitmap_deferred_clear(struct sbitmap_word *map,
+		unsigned int depth, unsigned int alloc_hint, bool wrap)
 {
-	unsigned long mask;
+	unsigned long mask, word_mask;
 
-	if (!READ_ONCE(map->cleared))
-		return false;
+	guard(spinlock_irqsave)(&map->swap_lock);
+
+	if (!map->cleared) {
+		if (depth == 0)
+			return false;
+
+		word_mask = (~0UL) >> (BITS_PER_LONG - depth);
+		/*
+		 * The current behavior is to always retry after moving
+		 * ->cleared to word, and we change it to retry in case
+		 * of any free bits. To avoid an infinite loop, we need
+		 * to take wrap & alloc_hint into account, otherwise a
+		 * soft lockup may occur.
+		 */
+		if (!wrap && alloc_hint)
+			word_mask &= ~((1UL << alloc_hint) - 1);
+
+		return (READ_ONCE(map->word) & word_mask) != word_mask;
+	}
 
 	/*
 	 * First get a stable cleared mask, setting the old mask to 0.
@@ -85,6 +103,7 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
 		      bool alloc_hint)
 {
 	unsigned int bits_per_word;
+	int i;
 
 	if (shift < 0)
 		shift = sbitmap_calculate_shift(depth);
@@ -116,6 +135,9 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
 		return -ENOMEM;
 	}
 
+	for (i = 0; i < sb->map_nr; i++)
+		spin_lock_init(&sb->map[i].swap_lock);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sbitmap_init_node);
@@ -126,7 +148,7 @@ void sbitmap_resize(struct sbitmap *sb, unsigned int depth)
 	unsigned int i;
 
 	for (i = 0; i < sb->map_nr; i++)
-		sbitmap_deferred_clear(&sb->map[i]);
+		sbitmap_deferred_clear(&sb->map[i], 0, 0, 0);
 
 	sb->depth = depth;
 	sb->map_nr = DIV_ROUND_UP(sb->depth, bits_per_word);
@@ -179,7 +201,7 @@ static int sbitmap_find_bit_in_word(struct sbitmap_word *map,
 					alloc_hint, wrap);
 		if (nr != -1)
 			break;
-		if (!sbitmap_deferred_clear(map))
+		if (!sbitmap_deferred_clear(map, depth, alloc_hint, wrap))
 			break;
 	} while (1);
 
@@ -496,7 +518,7 @@ unsigned long __sbitmap_queue_get_batch(struct sbitmap_queue *sbq, int nr_tags,
 		unsigned int map_depth = __map_depth(sb, index);
 		unsigned long val;
 
-		sbitmap_deferred_clear(map);
+		sbitmap_deferred_clear(map, 0, 0, 0);
 		val = READ_ONCE(map->word);
 		if (val == (1UL << (map_depth - 1)) - 1)
 			goto next;
-- 
2.43.0



