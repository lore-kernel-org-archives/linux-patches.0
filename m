Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C531F76D1;
	Tue,  3 Dec 2024 16:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242867; cv=none; b=oH8FY+VhK8BG9tz898e7VK4BFZJjuzhrCYnQuvpIVOG7LddPouqv4xvwbj+sqAuuSRQiSwyNjSfWy/NzUvFBzlLSQ3t/8UNTN4qZqCp6gziBqruOXZsDfCppOZl1cXLgdN2ckdvC15iXQMLV5LPxuFQ4okQblvE0pirOJoNgW2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242867; c=relaxed/simple;
	bh=SCbRFYA1M03yGQOLK7SJuki27Chq8PYvSqz125QU4t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7dsEi5Hereoq/D9PVcNRQMbKvmPloJywF70R0blixjAFBEX9vR7ViZUJLRI4Q7tw9wCd1ICjxDFHclXFTCck7GdqIwI6qcsuRHJ/gOJv0jW/y9FrqWRY+9w+PCQdy3M9pM1UXLcofKX2nyJX9R9U/sQhMAno1sfqBiA/xczKF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtL8VCx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtL8VCx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D22C4CECF;
	Tue,  3 Dec 2024 16:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242867;
	bh=SCbRFYA1M03yGQOLK7SJuki27Chq8PYvSqz125QU4t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtL8VCx8AF8Rxl6n0T5lqxYIT6GNZ5FsvQhDSCZyq3nhKLE7HTsLksbohyIHR9Adl
	 sfJ4ZzUiD9/JW2c6vR7p+QeF8QO0BLcPuj/auASmBjlkV0Lhe5DjKONEXP+1PU9dRX
	 /TqXiPZspMmN+n0cu60Q5kIV2DTBQpbYKdJv/zLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Lai Yi <yi1.lai@linux.intel.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 826/826] block: dont verify IO lock for freeze/unfreeze in elevator_init_mq()
Date: Tue,  3 Dec 2024 15:49:13 +0100
Message-ID: <20241203144815.973544410@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 357e1b7f730bd85a383e7afa75a3caba329c5707 upstream.

elevator_init_mq() is only called at the entry of add_disk_fwnode() when
disk IO isn't allowed yet.

So not verify io lock(q->io_lockdep_map) for freeze & unfreeze in
elevator_init_mq().

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reported-by: Lai Yi <yi1.lai@linux.intel.com>
Fixes: f1be1788a32e ("block: model freeze & enter queue as lock for supporting lockdep")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241031133723.303835-5-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/elevator.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/block/elevator.c
+++ b/block/elevator.c
@@ -598,13 +598,19 @@ void elevator_init_mq(struct request_que
 	 * drain any dispatch activities originated from passthrough
 	 * requests, then no need to quiesce queue which may add long boot
 	 * latency, especially when lots of disks are involved.
+	 *
+	 * Disk isn't added yet, so verifying queue lock only manually.
 	 */
-	blk_mq_freeze_queue(q);
+	blk_freeze_queue_start_non_owner(q);
+	blk_freeze_acquire_lock(q, true, false);
+	blk_mq_freeze_queue_wait(q);
+
 	blk_mq_cancel_work_sync(q);
 
 	err = blk_mq_init_sched(q, e);
 
-	blk_mq_unfreeze_queue(q);
+	blk_unfreeze_release_lock(q, true, false);
+	blk_mq_unfreeze_queue_non_owner(q);
 
 	if (err) {
 		pr_warn("\"%s\" elevator initialization failed, "


