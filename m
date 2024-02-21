Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEDE46B9B;
	Wed, 21 Feb 2024 13:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521488; cv=none; b=G3XmBNAow+oi5i/0IJmbrIVOJKeqQx4gG/fcD6FlYXt75BR0Lc9HdDbMr9H6iS8VzKFINqNsXChqonAAkminAJtBb2QKa0CYIP+CefdZno+PeOFuBeWEvo1jZ5pBtYnLt8Yr6UfbojSBZsqxcEszrivAe49PwaZv0RZPwHD2tlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521488; c=relaxed/simple;
	bh=pcVRx/ZNJ+WGfIZPTrCTS2RwNZUzVLVYpjCx/L4qJr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZ8PCJ5cPt2PX68Ob6ITxrQpBzYalpqnAAesg4T2szfQ8VnQ8Oc6NkSGyFFdfoTp2d6TczliGjfDr1H3nEt6UUxO3SBF1HzWQULvcSA9H213w/71uXg+UXnDLv3WdAF0kN4zzkap+Bv6A7MNtSKp6P+x2DX1mabpmWrDo4PPFBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ayu2N0Lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ayu2N0Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF59DC433F1;
	Wed, 21 Feb 2024 13:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521488;
	bh=pcVRx/ZNJ+WGfIZPTrCTS2RwNZUzVLVYpjCx/L4qJr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ayu2N0LvICxjJteT5SCyShfi424POaMSyojSHbHamGdj316EIKIQ8krc8RwxwSVnV
	 h9MPmrJQgaMsRb2TLlseO3qkXvM+QaVEK9LvSqvBNAX8Xg44Rqwz3zqMxYGZExi75y
	 AAQqPkPbK/12zvYEE4RIo0GTaMx9mG9ZDYk8ueow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Changhui Zhong <czhong@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 126/202] blk-mq: fix IO hang from sbitmap wakeup race
Date: Wed, 21 Feb 2024 14:07:07 +0100
Message-ID: <20240221125935.778038382@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 5266caaf5660529e3da53004b8b7174cab6374ed ]

In blk_mq_mark_tag_wait(), __add_wait_queue() may be re-ordered
with the following blk_mq_get_driver_tag() in case of getting driver
tag failure.

Then in __sbitmap_queue_wake_up(), waitqueue_active() may not observe
the added waiter in blk_mq_mark_tag_wait() and wake up nothing, meantime
blk_mq_mark_tag_wait() can't get driver tag successfully.

This issue can be reproduced by running the following test in loop, and
fio hang can be observed in < 30min when running it on my test VM
in laptop.

	modprobe -r scsi_debug
	modprobe scsi_debug delay=0 dev_size_mb=4096 max_queue=1 host_max_queue=1 submit_queues=4
	dev=`ls -d /sys/bus/pseudo/drivers/scsi_debug/adapter*/host*/target*/*/block/* | head -1 | xargs basename`
	fio --filename=/dev/"$dev" --direct=1 --rw=randrw --bs=4k --iodepth=1 \
       		--runtime=100 --numjobs=40 --time_based --name=test \
        	--ioengine=libaio

Fix the issue by adding one explicit barrier in blk_mq_mark_tag_wait(), which
is just fine in case of running out of tag.

Cc: Jan Kara <jack@suse.cz>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Reported-by: Changhui Zhong <czhong@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240112122626.4181044-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ae70b4809bec..0cb559d63998 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1064,6 +1064,22 @@ static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx *hctx,
 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
 	__add_wait_queue(wq, wait);
 
+	/*
+	 * Add one explicit barrier since blk_mq_get_driver_tag() may
+	 * not imply barrier in case of failure.
+	 *
+	 * Order adding us to wait queue and allocating driver tag.
+	 *
+	 * The pair is the one implied in sbitmap_queue_wake_up() which
+	 * orders clearing sbitmap tag bits and waitqueue_active() in
+	 * __sbitmap_queue_wake_up(), since waitqueue_active() is lockless
+	 *
+	 * Otherwise, re-order of adding wait queue and getting driver tag
+	 * may cause __sbitmap_queue_wake_up() to wake up nothing because
+	 * the waitqueue_active() may not observe us in wait queue.
+	 */
+	smp_mb();
+
 	/*
 	 * It's possible that a tag was freed in the window between the
 	 * allocation failure and adding the hardware queue to the wait
-- 
2.43.0



