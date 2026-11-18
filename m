Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033180;
	b=1ffkuiToH11tTxc5fmFS1cgChKBA3zDSoUN3racq6vWj6Y0PGtCQaRjK5USIXHlADs1x
	 LDuvKTRcXhH/x++XHbXhrxmGbUHkfxkledeQyqWnwxmwnGkjm2d7VTmciLgVRZY+y2sx+
	 pQNHWCBAAypADIrf0uaI4zAkNh6r3ZP9ncpmTU4t+Lc9nATvt1BR4GPEIETtRw2J891fE
	 fnwqUSE/DbhQkwL4AZP/zpmzxkpDyMVe56rgZbk4l1uDS8cP4sRznh2fDDjD/bWB7ujl1
	 cW5DBuj0R9LvlzdoNPb3CydPCSGWJTNDR4R6HgOCIzrC5mDHkfgfhxcBAZSraqIN1hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wgnU22beS/7SaOXWnfqorn2Flpw0BfomZUT+TlwPtcU=;
	b=M3h6xT8Ix/lHVrseoyePOLYMY/0mRGX0KZOZfit3+WynOq7GIB+0bTo+qNVs9b0yOnEc
	 35yJpKQ3yEQXYgS9kVEOOT1BHSy66dGCgE55/EFvnLqh9t0lKeTIibJmLnOYli3L/Dwmq
	 2wqJUlofP4APXs8mkWkWXR40q9wbwoT6/sUz9yhLo/IM0/oD+LeN/hu2U6dsBAi795a/w
	 xaUROfum7HxGK+th9JruBOODoT9Pg7GkQzz8SJEl7z8TWmgJkO2zs43g0X7GpwBGsIk+D
	 8QQ8E5Jw/a5fKFvgYjJZwWnIDAvGZg35zq9DQO2rk4jz/MPTpMHKs0UYE1mnjqeo++w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ES7yd3DF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CEC606A32C;
	Wed, 18 Nov 2026 20:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ES7yd3DF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7611F000C4;
	Wed, 18 Nov 2026 20:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033180;
	bh=wgnU22beS/7SaOXWnfqorn2Flpw0BfomZUT+TlwPtcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ES7yd3DFmGy4ACIS0UkXh7o/+5kAHNxzPVS+fR/Y/doRFEzzhsRL8qg9IWirjmtSY
	 cK9K07IlsAVmzRWiVtTIZJnG7FiRq/8ncJZ9ZvD9DNoUajf4M0Wk+5SnsZk4giV/8k
	 44K94C9S3yOaEsJBQi1AUhd6B7CTc4/+GOHl0Eyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1675/1756] blk-mq: exit the hctxs of a queue under tag_list_lock
Date: Wed, 18 Nov 2026 16:03:22 +0100
Message-ID: <20261118150116.358256897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 89a2381482d8ff8e4fe0b7d32797bb4f77503b89 ]

blk_mq_update_nr_hw_queues() exits and replaces the hctxs of every queue
on set->tag_list under tag_list_lock. blk_mq_exit_queue() exits its
hctxs without the lock and only then takes the queue off the list, so an
update running at the same time exits them again and sets up new ones
that nobody exits. del_gendisk() is kept away by update_nr_hwq_lock,
disk_release() of a never added disk and blk_mq_destroy_queue() are not,
and nvme_alloc_ns() drops such a disk when it finds the queues frozen by
a reset.

Hold tag_list_lock for both steps.

Fixes: 630ef623ed26 ("blk-mq: Swap two calls in blk_mq_exit_queue()")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-38-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5f261097425ad..65a08aec007d2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4267,7 +4267,8 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 
-	mutex_lock(&set->tag_list_lock);
+	lockdep_assert_held(&set->tag_list_lock);
+
 	list_del_rcu(&q->tag_set_list);
 	if (list_is_singular(&set->tag_list)) {
 		/* just transitioned to unshared */
@@ -4275,7 +4276,6 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		/* update existing queue */
 		blk_mq_update_tag_set_shared(set, false);
 	}
-	mutex_unlock(&set->tag_list_lock);
 }
 
 static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
@@ -4607,10 +4607,16 @@ void blk_mq_exit_queue(struct request_queue *q)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 
+	/*
+	 * As long as the queue is on set->tag_list, its hctxs belong to
+	 * blk_mq_update_nr_hw_queues() as well, which exits and replaces them.
+	 */
+	mutex_lock(&set->tag_list_lock);
 	/* Checks hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED. */
 	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
 	/* May clear BLK_MQ_F_TAG_QUEUE_SHARED in hctx->flags. */
 	blk_mq_del_queue_tag_set(q);
+	mutex_unlock(&set->tag_list_lock);
 }
 
 static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
-- 
2.53.0



