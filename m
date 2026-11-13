Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585698;
	b=f6l0chOMQ2Iz/y2uQ3Dc7Os4tFoOaLNnuxMpWkqmfNv95t2pEVKsJIcg4ypUy7+6c320
	 Fvfdg6SUWgJBsUscIl20ztzymgNyOuJ4m9cJb4HNiVox3x39YPk611l4eQ2cXACG3XbRl
	 wF3HbGiGpfZflVR5F8Pvdof5ys0YhldbXAdpG+Q9NusGB4qEmP2AK30iwXGpWcupUcE/4
	 ANYzAHV92w3kKtf2X+KPNkaw8D3Ywlq8sNOtIWoEfl7w10HmPV5+Qu6n2f4p52aLeN5w7
	 JF6PS4ampwYoB0qF4tm7XDK6W99JOc/DipwjbAKtzaVCKBvO1ey5gIpQNGL0j9khtIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7u5o857IYxrL9c8T0LsCUVwg1g/pwgo6QXKZw9o3g1I=;
	b=s6YgZyNHhqTl6TRdNtOmgT4DgChEZleaBfnupWFmTwnUk5s6ljInEHT++YubPVyP5h/U
	 jkxD2YOP3/xSe5TXfr+X048yYoLi30NBVsTN1Pl3rxiUGWyqt0ioSpOUGc4ckOb/kf/7m
	 jw4BfH9jRqp9jT789Fb4Masnuo+WmTidSvdI3w6Wlkn6Jyn2SLYocrZZTnWOaepYsUU1F
	 IzTY8rQTwB+4dZzrmT669rNX8NRzrkxAsZ9XG1d+9dvkxYqEwE183ctkrxTa2/8NOKj5w
	 7LQrClo3VDEj0g1J8O8fcl6uRYsSyMC5Z4VPRMVlOAUReNB+2+zrEuv/uDLMyU0wIkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oho4cgxA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14555606A8B5;
	Fri, 13 Nov 2026 16:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oho4cgxA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B436A1F000C4;
	Fri, 13 Nov 2026 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585697;
	bh=7u5o857IYxrL9c8T0LsCUVwg1g/pwgo6QXKZw9o3g1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oho4cgxAK2TjV4zmqpd/R9PsQePoOh8XyAQxnfHHh8Cc8h9vrhSYcKpzLmAvS0PH9
	 JcpbmnEK+I02sJXlmpaNj4kvWj0V1AUz3oLoiUVRrDWMzb70lMeLUAyWRByeyoj72b
	 1AOc2jjW31Hg+OHADnrY6L0hBRReKSdfXf24Y1JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reindl Harald <h.reindl@thelounge.net>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Laveesh Bansal <laveeshb@laveeshbansal.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 278/507] block: only serialize elevator switches of the same queue
Date: Fri, 13 Nov 2026 10:49:42 -0500
Message-ID: <20261113153804.336651203@linuxfoundation.org>
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

From: Laveesh Bansal <laveeshb@laveeshbansal.com>

[ Upstream commit 603523fd54664f17630f742229166278568c3ce8 ]

Since commit 4ff58d6bc9dd ("block: serialize elevator changes for the
same queue using a writer lock"), a write to queue/scheduler fails with
-EBUSY whenever something else holds set->update_nr_hwq_lock. That
commit takes the lock for write, and it has to be a trylock because of
commit ce8ee8583ed8 ("block: use trylock to avoid lockdep circular
dependency in sysfs").

The lock covers the whole tag set, so it is easy to hit. A scheduler
write fails while another queue of the set is switching, or while a
sibling disk of the same SCSI host or NVMe controller is added or
removed. This matches the udev failures reported on 7.2.

Go back to taking the lock for read. The write lock was there to keep
two switches of one queue from overlapping in elevator_change_done(),
which touches the elevator sysfs and debugfs entries outside of
q->elevator_lock. Use QUEUE_FLAG_NO_ELV_SWITCH for that instead: a
write sets it before elevator_change() and clears it afterwards, and a
write that finds it set returns -EBUSY. Disk removal already sets the
flag under the write lock, so no switch can start once it has run.

Writes to the same queue, and writes that race with an nr_hw_queues
update, an nr_requests write or disk removal, can still get -EBUSY, as
with 4ff58d6bc9dd. A write to a disk that is being removed now gets
-EBUSY instead of -ENOENT.

Fixes: 4ff58d6bc9dd ("block: serialize elevator changes for the same queue using a writer lock")
Cc: stable@vger.kernel.org # v7.2+
Reported-by: Reindl Harald <h.reindl@thelounge.net>
Closes: https://lore.kernel.org/r/077dd42e-cbc9-4c23-a5ef-3d20e4fc7757@thelounge.net
Suggested-by: Nilay Shroff <nilay@linux.ibm.com>
Assisted-by: LLM
Signed-off-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20261031044141.5569-1-laveeshb@laveeshbansal.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/elevator.c       | 30 +++++++++++++++++-------------
 include/linux/blkdev.h |  4 +---
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 2161b6eea680c..66edf1a5768a8 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -812,25 +812,29 @@ ssize_t elv_iosched_store(struct gendisk *disk, const char *buf,
 	 * reference during concurrent disk deletion:
 	 *   update_nr_hwq_lock -> kn->active (via del_gendisk -> kobject_del)
 	 *   kn->active -> update_nr_hwq_lock (via this sysfs write path)
-	 *
-	 * Use the writer lock instead of the reader lock of update_nr_hwq_lock
-	 * to serialize the two-stage elevator switch steps in
-	 * elevator_change(): the core switch step under the elevator lock and
-	 * the elevator_change_done() step outside the elevator lock.
 	 */
-	if (!down_write_trylock(&set->update_nr_hwq_lock)) {
+	if (!down_read_trylock(&set->update_nr_hwq_lock)) {
 		ret = -EBUSY;
 		goto out;
 	}
-	if (!blk_queue_no_elv_switch(q)) {
-		ret = elevator_change(q, &ctx);
-		if (!ret)
-			ret = count;
-	} else {
-		ret = -ENOENT;
+
+	/*
+	 * The reader lock is shared, so use QUEUE_FLAG_NO_ELV_SWITCH to allow
+	 * only one switch of this queue at a time, and none once the disk is
+	 * going away.
+	 */
+	if (test_and_set_bit(QUEUE_FLAG_NO_ELV_SWITCH, &q->queue_flags)) {
+		ret = -EBUSY;
+		goto out_unlock;
 	}
-	up_write(&set->update_nr_hwq_lock);
 
+	ret = elevator_change(q, &ctx);
+	if (!ret)
+		ret = count;
+
+	blk_queue_flag_clear(QUEUE_FLAG_NO_ELV_SWITCH, q);
+out_unlock:
+	up_read(&set->update_nr_hwq_lock);
 out:
 	if (ctx.type)
 		elevator_put(ctx.type);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4f7905c3412b8..3989bb0dd43be 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -675,7 +675,7 @@ enum {
 	QUEUE_FLAG_HCTX_ACTIVE,		/* at least one blk-mq hctx is active */
 	QUEUE_FLAG_SQ_SCHED,		/* single queue style io dispatch */
 	QUEUE_FLAG_DISABLE_WBT_DEF,	/* for sched to disable/enable wbt */
-	QUEUE_FLAG_NO_ELV_SWITCH,	/* can't switch elevator any more */
+	QUEUE_FLAG_NO_ELV_SWITCH,	/* a switch is running or disk is going away */
 	QUEUE_FLAG_QOS_ENABLED,		/* qos is enabled */
 	QUEUE_FLAG_BIO_ISSUE_TIME,	/* record bio->issue_time_ns */
 	QUEUE_FLAG_ZONED_QD1_WRITES,	/* Limit zoned devices writes to QD=1 */
@@ -716,8 +716,6 @@ void blk_queue_flag_clear(unsigned int flag, struct request_queue *q);
 	((q)->limits.features & BLK_FEAT_SKIP_TAGSET_QUIESCE)
 #define blk_queue_disable_wbt(q)	\
 	test_bit(QUEUE_FLAG_DISABLE_WBT_DEF, &(q)->queue_flags)
-#define blk_queue_no_elv_switch(q)	\
-	test_bit(QUEUE_FLAG_NO_ELV_SWITCH, &(q)->queue_flags)
 #define blk_queue_zoned_qd1_writes(q)	\
 	test_bit(QUEUE_FLAG_ZONED_QD1_WRITES, &(q)->queue_flags)
 
-- 
2.53.0



