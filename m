Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585711;
	b=C1pKH2TiIuSLxzjl/+NC9NWwOhDXqXkChLunN1XAspOb0IcjaMme+pFOcIwXH+J8MPzE
	 3Bc50qmqL/orQhycm9Yr0LUGe1ZZS6Hj5iLTAjbMPB0e/tP7R7a8IYZCnaUVxfAPIpJ9Q
	 t+NhlD9vmBBhy9Wa/xWLQYVkT1y8cljb++mX7ToMe4kimr6gXJIfyneEm5gmnx450wIVy
	 BscUbFU4n7ePenXScoYwU7g3+XHLt/j9j8nJZE8HTf7XbMnbPbl+f04lOj6+fSAk72QBy
	 80jDTNrKnIjeb5l4KGqsj4E4eHX9NrXqiNmNhVQyfBOxzTdVcdG8DA2uNzuWglv7gFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DgjOxknKfO+ySaaIC/IlXaNn2We6bQimCeEVtFBvOBw=;
	b=4wcx1sindB8aevDiifJs7JYt6j4xjxlGatX02nYLS+aQ0WgeONapti63s+LBtshwMFDO
	 ejzOLHMm7G8Nlht5Ex2XU+e7TX0/+3bzfIOrOuRNOYvlkOVEp56O8tqkniutdXo0/Xs7b
	 oqaMzwZxgFlrSeR14leyk3H3qNcQUY92LbUQh7j84HjJYSTafD4wXee0aqV1Sc2vmG2b+
	 t7tNKqyjio+HyVj7CwiKxTQBSvEsEZDTOFny/aB3pu77dqub7jBQHCR91qCfOU/fN4oSM
	 rl2OQJVGFcxn5+su0sU2YQkz4HBxRUC5pJbM8Q6vP7dqbu9MsPyxoeiM2v7kxGTucXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AH0LaYQG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C14D60A383B;
	Fri, 13 Nov 2026 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AH0LaYQG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1F31F000C4;
	Fri, 13 Nov 2026 16:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585711;
	bh=DgjOxknKfO+ySaaIC/IlXaNn2We6bQimCeEVtFBvOBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AH0LaYQGGaOjliEYwO0aYiPkv28Rcu6KMRsonyNcIPVmK8AKaEoGkrrUghob/FB5H
	 GYArqsxAe4tlZk0bk6vfUljCNGIoZjhM6DJE7LE4PFap365+Rp7ovbL4TLC+JRoFSV
	 +umTBtKslwib6AjN2tukZ0PJncdjAxHt32e7Y28I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e90526cab23b9efcd03c@syzkaller.appspotmail.com,
	Nilay Shorff <nilay@linux.ibm.com>,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	syzbot@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 279/507] blk-mq: fix out-of-bounds read in blk_mq_free_rqs
Date: Fri, 13 Nov 2026 10:49:43 -0500
Message-ID: <20261113153804.431499432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

[ Upstream commit 894e4e6084924cfd590968d45fad20908e02ddae ]

A KASAN slab-out-of-bounds read can occur in blk_mq_free_rqs() when there
is a mismatch between the number of hardware queues allocated for the IO
scheduler (et->nr_hw_queues) and the number of hardware queues in the block
tag set (set->nr_hw_queues).

This mismatch can happen if blk_mq_update_nr_hw_queues() fails halfway
through (e.g., due to memory pressure during
blk_mq_prealloc_tag_set_tags()). In this error path, the elevator is
restored with a larger number of hardware queues than the block tag set
actually has.

When the elevator is later freed, blk_mq_free_sched_tags() iterates up to
the new et->nr_hw_queues and calls blk_mq_free_rqs(). In blk_mq_free_rqs(),
it attempts to access set->tags[hctx_idx] to get the driver tags. Because
set->nr_hw_queues was not updated due to the earlier failure, set->tags
still has the old (smaller) size, leading to an out-of-bounds read.

BUG: KASAN: slab-out-of-bounds in blk_mq_free_rqs+0xde/0x680
Read of size 8 at addr ffff88818d67fc28 by task syz-executor117/5839
Call Trace:
 blk_mq_free_rqs+0xde/0x680
 blk_mq_free_map_and_rqs+0x40/0xf0
 blk_mq_free_sched_tags
 blk_mq_free_sched_res+0xeb/0x280
 elevator_change_done+0x1d2/0x5c0
 elevator_change+0x34f/0x480
 elv_iosched_store+0x504/0x630
 queue_attr_store+0x207/0x2b0

To fix this, explicitly check if hctx_idx < set->nr_hw_queues before
accessing set->tags[hctx_idx]. If hctx_idx >= set->nr_hw_queues, the
hardware queue doesn't exist in the tag set, meaning there are no driver
tags to clear mappings from. In this case, safely set drv_tags to NULL. The
subsequent call to blk_mq_clear_rq_mapping() already handles a NULL
drv_tags pointer and will safely return.

Fixes: 04225d13aef1 ("block: fix potential deadlock while running nr_hw_queue update")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+e90526cab23b9efcd03c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e90526cab23b9efcd03c
Link: https://syzkaller.appspot.com/ai_job?id=827b5760-86a0-4f44-9c69-430b572eac12
Reviewed-by: Nilay Shorff <nilay@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.17+
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Tested-by: syzbot@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20261014170538.1089448-1-krystianmkaniewski@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6d111c6f0ecd1..e21d69767fd47 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3484,8 +3484,10 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 
 	if (blk_mq_is_shared_tags(set->flags))
 		drv_tags = set->shared_tags;
-	else
+	else if (hctx_idx < set->nr_hw_queues)
 		drv_tags = set->tags[hctx_idx];
+	else
+		drv_tags = NULL;
 
 	if (tags->static_rqs && set->ops->exit_request) {
 		int i;
-- 
2.53.0



