Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028247;
	b=zUEr79+uNv6YdrDFjvhj81prKQ9z7vq+MrRxc0KSmHiYU/nT66irowbBwe1CxoDUGekG
	 1UlofXMxKP5WpS1deJ5v2pKf8xHqT1udw1F1yV5LvjeG6SU7rGZNQrIeRgX4ZLd81FXkA
	 Pm59tkiUR6lCzeyBVXKDyPhEfvYLcSQshxGVRqERrHlPAufgFTlZrtQq4bwkei3uJ1zwS
	 1E4YOensuUGR2bJMUxydigs1/MGXUSFjYvZ0WWOHMXmjj41WvOPwLUCBPUA+EzZhLb2Ly
	 9A+PlNXZldJ46JrcGQrvYAyE21arIfbmAB3ov1z0XQocZyjd1byZ+qQ8Te12MGJ6XSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PTVnB4X/bpO5t4by/WsY691Xls+BBxYLNGuuhtbsg/M=;
	b=3Wr/fDU/83LDlyGFUhA9HqZF3JboRGu1A1xCyrAL7eP8rk2+WNjl83USAX2BIxxTpT9R
	 /GSAiMuRfg9ZsH4HoQE5jAN8J6xmnug5iM4ZMV4MhCTsaamK9yAX5/TcKnPA16UkQeF3F
	 vIa7Gtl9L9F9Nn8vjW0AHm9kAXNrbH8RWXbG8kS7fb0QlKLtXQXLPYkNHTjhUr0nQaigN
	 g6TpB6zYKxpcYcPV5TC2nav4gHIz0jGMXrzQytcYi+WoeUjdU1GbVNGLru6m217ejT3yJ
	 z0DthZAazsoLdHzd6J/BcG94F1kZzmjXzntV6o1VeQwdnVLb5DzNm4Jzbc0mjo3duyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEr5otNV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01114606A320;
	Wed, 18 Nov 2026 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEr5otNV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8D11F000C4;
	Wed, 18 Nov 2026 18:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028246;
	bh=PTVnB4X/bpO5t4by/WsY691Xls+BBxYLNGuuhtbsg/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEr5otNVYjxv/P8la7lycYPRWY5GX4rvummXi36LYGoukDKE+FYm9ssfB5N4XlZb9
	 pJVjAn+TJIumD2F0MIz61ajJ6hx7RPajNEg3m9byywahhdVcmbbNOKkA/mnz9ohNmj
	 eJn/N094Zq1lkXhsJecURUT4WRppoo1HcBT/9Xa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2076/2151] blk-mq: quiesce a queue that joins a quiesced tag set
Date: Wed, 18 Nov 2026 16:03:31 +0100
Message-ID: <20261118150237.340896528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 71ec3c7d6db80737b781d2739d1325b7e39758e1 ]

blk_mq_quiesce_tagset() only quiesces the queues on the list at that
moment. A queue added before blk_mq_unquiesce_tagset() runs unquiesced,
and then gets unquiesced without ever having been quiesced, which trips
the warning in blk_mq_unquiesce_queue(). NVMe gets there when a
controller fails while its namespaces are being scanned.

Count the quiesce calls in the tag set and quiesce a joining queue that
many times, under a spinlock that also serializes the two functions. It
can't be tag_list_lock, see commit 59e25ef2b413.

Fixes: 414dd48e882c ("blk-mq: add tagset quiesce interface")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-37-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c         | 22 ++++++++++++++++++++++
 include/linux/blk-mq.h |  6 ++++++
 2 files changed, 28 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8d22f0b6cb316..97cfdde6d8bfd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -336,12 +336,15 @@ void blk_mq_quiesce_tagset(struct blk_mq_tag_set *set)
 {
 	struct request_queue *q;
 
+	spin_lock(&set->quiesce_lock);
+	set->quiesce_depth++;
 	rcu_read_lock();
 	list_for_each_entry_rcu(q, &set->tag_list, tag_set_list) {
 		if (!blk_queue_skip_tagset_quiesce(q))
 			blk_mq_quiesce_queue_nowait(q);
 	}
 	rcu_read_unlock();
+	spin_unlock(&set->quiesce_lock);
 
 	blk_mq_wait_quiesce_done(set);
 }
@@ -351,12 +354,16 @@ void blk_mq_unquiesce_tagset(struct blk_mq_tag_set *set)
 {
 	struct request_queue *q;
 
+	spin_lock(&set->quiesce_lock);
+	if (set->quiesce_depth)
+		set->quiesce_depth--;
 	rcu_read_lock();
 	list_for_each_entry_rcu(q, &set->tag_list, tag_set_list) {
 		if (!blk_queue_skip_tagset_quiesce(q))
 			blk_mq_unquiesce_queue(q);
 	}
 	rcu_read_unlock();
+	spin_unlock(&set->quiesce_lock);
 }
 EXPORT_SYMBOL_GPL(blk_mq_unquiesce_tagset);
 
@@ -4353,6 +4360,8 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 				     struct request_queue *q)
 {
+	unsigned int i;
+
 	mutex_lock(&set->tag_list_lock);
 
 	/*
@@ -4366,7 +4375,18 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 	}
 	if (set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
 		queue_set_hctx_shared(q, true);
+
+	/*
+	 * A queue that joins a quiesced tag set is quiesced like the others,
+	 * and blk_mq_unquiesce_tagset() finds what it is going to undo.
+	 */
+	spin_lock(&set->quiesce_lock);
 	list_add_tail_rcu(&q->tag_set_list, &set->tag_list);
+	if (!blk_queue_skip_tagset_quiesce(q)) {
+		for (i = 0; i < set->quiesce_depth; i++)
+			blk_mq_quiesce_queue_nowait(q);
+	}
+	spin_unlock(&set->quiesce_lock);
 
 	mutex_unlock(&set->tag_list_lock);
 }
@@ -4930,6 +4950,8 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 
 	mutex_init(&set->tag_list_lock);
 	INIT_LIST_HEAD(&set->tag_list);
+	spin_lock_init(&set->quiesce_lock);
+	set->quiesce_depth = 0;
 
 	return 0;
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 0a1d40b8472e0..451c2fc5b46cc 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -521,6 +521,10 @@ enum hctx_type {
  * @tag_list_lock: Serializes tag_list accesses.
  * @tag_list:	   List of the request queues that use this tag set. See also
  *		   request_queue.tag_set_list.
+ * @quiesce_lock:  Serializes blk_mq_[un]quiesce_tagset() against each other
+ *		   and against a request queue being added to @tag_list.
+ * @quiesce_depth: How often blk_mq_quiesce_tagset() has been called without
+ *		   blk_mq_unquiesce_tagset().
  * @srcu:	   Use as lock when type of the request queue is blocking
  *		   (BLK_MQ_F_BLOCKING).
  * @update_nr_hwq_lock:
@@ -546,6 +550,8 @@ struct blk_mq_tag_set {
 
 	struct mutex		tag_list_lock;
 	struct list_head	tag_list;
+	spinlock_t		quiesce_lock;
+	unsigned int		quiesce_depth;
 	struct srcu_struct	*srcu;
 
 	struct rw_semaphore	update_nr_hwq_lock;
-- 
2.53.0



