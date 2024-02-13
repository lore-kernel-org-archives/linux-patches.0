Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7712A5F54E;
	Tue, 13 Feb 2024 17:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845177; cv=none; b=dodWM4FHt7SqisZhhgC/z/dOTyw5gyTdUdIMO0FHM31z/QN+wzFH2AVuhXCJUSQKoCH9BC9ISZHV2PJq3cgCeuB30QAcYX2vzi4xWhXqTmyvlV0lQOE5xWhUDeLCQ1zri2EohegPrGgQNsG1HYdGqsMKF8dDBjp61+6rsAcaaOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845177; c=relaxed/simple;
	bh=haBlRJkP6HZTqmrsStmIwrNNPM5Je9Rut+2jHUXCbNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sssw3UG2v2fqe7QVtVUdWnHiynoNT03kHwS4/ipFAzsY8+08r5BapCPjY2d+suuS/Se7bEIUlgx80uPxtgTtWE5XpYjxpS95O6q6F5gcYRh4Xxn6ljEKVyibh0gp0RexbfQOoiE6abEztVAHYpT0RFIpnbzJ3GmkcQRPe+NfHeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PC/lHFVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PC/lHFVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25BCC433C7;
	Tue, 13 Feb 2024 17:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845177;
	bh=haBlRJkP6HZTqmrsStmIwrNNPM5Je9Rut+2jHUXCbNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PC/lHFVYc8XzLA9E0ihPI0DOMFb61P5PIzBFZbftanlClYsc2zniJpjYO7bqtPQB5
	 FCc0f0LGfFOrKu60/h7e4T4rghsq+j5OuGxGlJhdcXHgcmEoT575hQ8KXiJhhQ7hya
	 P3GQxb7raxHnx6Ro/DtYsgGkjXcXF87slzarnuVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 63/64] block: treat poll queue enter similarly to timeouts
Date: Tue, 13 Feb 2024 18:21:49 +0100
Message-ID: <20240213171846.717757238@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 33391eecd63158536fb5257fee5be3a3bdc30e3c upstream.

We ran into an issue where a production workload would randomly grind to
a halt and not continue until the pending IO had timed out. This turned
out to be a complicated interaction between queue freezing and polled
IO:

1) You have an application that does polled IO. At any point in time,
   there may be polled IO pending.

2) You have a monitoring application that issues a passthrough command,
   which is marked with side effects such that it needs to freeze the
   queue.

3) Passthrough command is started, which calls blk_freeze_queue_start()
   on the device. At this point the queue is marked frozen, and any
   attempt to enter the queue will fail (for non-blocking) or block.

4) Now the driver calls blk_mq_freeze_queue_wait(), which will return
   when the queue is quiesced and pending IO has completed.

5) The pending IO is polled IO, but any attempt to poll IO through the
   normal iocb_bio_iopoll() -> bio_poll() will fail when it gets to
   bio_queue_enter() as the queue is frozen. Rather than poll and
   complete IO, the polling threads will sit in a tight loop attempting
   to poll, but failing to enter the queue to do so.

The end result is that progress for either application will be stalled
until all pending polled IO has timed out. This causes obvious huge
latency issues for the application doing polled IO, but also long delays
for passthrough command.

Fix this by treating queue enter for polled IO just like we do for
timeouts. This allows quick quiesce of the queue as we still poll and
complete this IO, while still disallowing queueing up new IO.

Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -864,7 +864,16 @@ int bio_poll(struct bio *bio, struct io_
 	 */
 	blk_flush_plug(current->plug, false);
 
-	if (bio_queue_enter(bio))
+	/*
+	 * We need to be able to enter a frozen queue, similar to how
+	 * timeouts also need to do that. If that is blocked, then we can
+	 * have pending IO when a queue freeze is started, and then the
+	 * wait for the freeze to finish will wait for polled requests to
+	 * timeout as the poller is preventer from entering the queue and
+	 * completing them. As long as we prevent new IO from being queued,
+	 * that should be all that matters.
+	 */
+	if (!percpu_ref_tryget(&q->q_usage_counter))
 		return 0;
 	if (queue_is_mq(q)) {
 		ret = blk_mq_poll(q, cookie, iob, flags);


