Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022228;
	b=ziFby3DKFgLZFWcn4RaooE5oqHBFWvaxEVN6CnAoqQjlJFNRcJS4ray/MXzkUSS4FcgG
	 fQypg2xcGzWQ5KW+0QSkNHrCSgIaPBTxY6pYdrKUwSJylOGOtcbuv9fcX7dRqOd5GASlO
	 A36mFo/lroaApQ/7C1+ZzI5O6T7a2eWS+sKu+sK7ZY/+VHju0sPV9qTKqk6099TGYINVc
	 RDGy+iYf2M3OjuvNo6XbpYoPhhly3j4oKC42Rzet6y37LC6HGT2+h5sVG+qlelyJkw55f
	 irafNgRaQ3ExgcDKnpI1Xf0G7+fqEs2oBEaK2BC0FZhzmNoQzO+yuhlr88CKP/mZXKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rP+wzwaerI+lVKNVrGoJ6bBzC/7Cmm4ycgBEFL9l/BU=;
	b=OMk1AS1pjrkEz4L+PgaNBvG8qMMCWdZXVjQ6D7CUmN/32MFi5gxVMyJSzX+O6Ue4zSbE
	 sJK8qMSrnBM8FuG+OcpRGCuJk1Eq0IsvW3WxxOwGaU7DOH3m/TJvbZPB5f+pegdr8reZQ
	 1zlyon8VNVRK3aduUfsXpusWBiOzejr2ggJGAFh8KCq29iMaImY7k1iEVmZQlOnEnze/h
	 VuVfYHxdKwEPW3GSdbXRGlHAchH4Ij7H2o41qKGLj0OXM+sq9w86RRDEP9PU0smYj15a3
	 sCU3LRZsHcqyTg0P3yMFD5P5/ROhZ/E1QM8w5X1SNyUXYShUy0WK5aBoUId4Y2bnPOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pwYrwYh5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1070606A320;
	Wed, 18 Nov 2026 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pwYrwYh5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B6D1F000C4;
	Wed, 18 Nov 2026 17:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022227;
	bh=rP+wzwaerI+lVKNVrGoJ6bBzC/7Cmm4ycgBEFL9l/BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pwYrwYh5v/hTr8ALe0L48OfOCWR94RCOdEYeN8hFovIvpiYhCmmXNwANmmoOH0bg0
	 6IUDKoCzn36ymHA+2N7I5grfRzSRDJh6DZ6J1FMVcuiUy23DiVnwIVbK/RyQz69uzz
	 67BAxl2ieRG/4goVFPv2iOxezqmc0PieYxDiYlvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2588/2651] blk-mq: set up a queue under tag_list_lock
Date: Wed, 18 Nov 2026 16:03:48 +0100
Message-ID: <20261118150417.457030387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 4fcc499ea9bc31b02393904a1903e794d146f5f7 ]

blk_mq_init_allocated_queue() only takes tag_list_lock at the end, when
it adds the queue to the set. Before that it sizes the queue by
set->nr_hw_queues, hands out set->tags[], maps by set->map[], and
blk_mq_map_swqueue() frees tags of the set. An update clearing the maps
at that time makes the new queue free tags that all the other queues
share. An NVMe controller reset during a namespace scan does exactly
that.

Take the lock before the first look at the set. An update can be part of
error handling, so the allocations under the lock must not wait for IO:
memalloc_noio_save(), as in add_disk_fwnode().

Fixes: 868f2f0b7206 ("blk-mq: dynamic h/w context count")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-39-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 01008b7e4401e..a162a64648c82 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4355,7 +4355,7 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 {
 	unsigned int i;
 
-	mutex_lock(&set->tag_list_lock);
+	lockdep_assert_held(&set->tag_list_lock);
 
 	/*
 	 * Check to see if we're transitioning to shared (from 1 to 2 queues).
@@ -4380,8 +4380,6 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 			blk_mq_quiesce_queue_nowait(q);
 	}
 	spin_unlock(&set->quiesce_lock);
-
-	mutex_unlock(&set->tag_list_lock);
 }
 
 /* All allocations will be freed in release handler of q->mq_kobj */
@@ -4658,6 +4656,8 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 		struct request_queue *q)
 {
+	unsigned int memflags;
+
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
 
@@ -4676,6 +4676,16 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	INIT_LIST_HEAD(&q->unused_hctx_list);
 	spin_lock_init(&q->unused_hctx_lock);
 
+	/*
+	 * Keep blk_mq_update_nr_hw_queues() away until the queue is on
+	 * set->tag_list: it changes the number of hardware queues, the tags and
+	 * the maps, and blk_mq_map_swqueue() allocates and frees tags of the set.
+	 * An update can be part of the error handling of a driver, so it must
+	 * not have to wait for somebody who waits for I/O.
+	 */
+	memflags = memalloc_noio_save();
+	mutex_lock(&set->tag_list_lock);
+
 	blk_mq_realloc_hw_ctxs(set, q);
 	if (!q->nr_hw_queues)
 		goto err_hctxs;
@@ -4696,9 +4706,14 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 	blk_mq_map_swqueue(q);
 	blk_mq_add_queue_tag_set(set, q);
+
+	mutex_unlock(&set->tag_list_lock);
+	memalloc_noio_restore(memflags);
 	return 0;
 
 err_hctxs:
+	mutex_unlock(&set->tag_list_lock);
+	memalloc_noio_restore(memflags);
 	blk_mq_release(q);
 err_exit:
 	q->mq_ops = NULL;
-- 
2.53.0



