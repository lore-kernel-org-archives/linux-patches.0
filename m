Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABE41917E3;
	Tue, 29 Apr 2025 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948410; cv=none; b=ZpxZYDHekjnWnDdqxh772kYhadcxsnSI2CIGTlEykfrJ9cIMc4I3F1W0n9mHZy4ILL8f0Pe+PSmbUjlYgnOnv+eWwBpbNpT/zjaP/pVjzouP1q4rKUXhjQ/ikN1bE5IVJ0sUzRjyLdMjbM+REg5mlyuXifS0avOHsaxgCcUDeko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948410; c=relaxed/simple;
	bh=H978HMNV2rmYPflarVEVee5TDY1tJ67cxkC1bKwMOoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilVJk2pvHm/DAcktF7BIHRfiq/3TE+2JQOirJfSUDK4xiDzr1VAQKFrIjQ6IwR8prFrK5goUI3Jk2vDXTbnP3+ID5c0brBQgp0JD4Qr1hW5tGDbCiJZx6waJyrSaktVDpDD+k4MHY9+zz8xxx/PhAVxiLM2+u5+Ki5IN1EEzjZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=em2Q/SEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="em2Q/SEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D70C4CEE3;
	Tue, 29 Apr 2025 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948410;
	bh=H978HMNV2rmYPflarVEVee5TDY1tJ67cxkC1bKwMOoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=em2Q/SElZXTd1odbVZpkTF9R0zclYua1mSnHfb9dJjHjOGtlWo52Or8IQajsa4CEF
	 VE8LV1wYKbNefVEDHT6mbOgqZR9SFOf268oSeG2+Fl6uolz0mZgzx9fHHvnr4za7/5
	 rykap2crBAnHs1zJHlvoCTAU2ETB4/W314RSCCeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 280/280] mq-deadline: dont call req_get_ioprio from the I/O completion handler
Date: Tue, 29 Apr 2025 18:43:41 +0200
Message-ID: <20250429161126.588690301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christoph Hellwig <hch@lst.de>

commit 1b0cab327e060ccf397ae634a34c84dd1d4d2bb2 upstream.

req_get_ioprio looks at req->bio to find the I/O priority, which is not
set when completing bios that the driver fully iterated through.

Stash away the dd_per_prio in the elevator private data instead of looking
it up again to optimize the code a bit while fixing the regression from
removing the per-request ioprio value.

Fixes: 6975c1a486a4 ("block: remove the ioprio field from struct request")
Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Reported-by: Sam Protsenko <semen.protsenko@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Tested-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20241126102136.619067-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/mq-deadline.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -685,10 +685,9 @@ static void dd_insert_request(struct blk
 
 	prio = ioprio_class_to_prio[ioprio_class];
 	per_prio = &dd->per_prio[prio];
-	if (!rq->elv.priv[0]) {
+	if (!rq->elv.priv[0])
 		per_prio->stats.inserted++;
-		rq->elv.priv[0] = (void *)(uintptr_t)1;
-	}
+	rq->elv.priv[0] = per_prio;
 
 	if (blk_mq_sched_try_insert_merge(q, rq, free))
 		return;
@@ -753,18 +752,14 @@ static void dd_prepare_request(struct re
  */
 static void dd_finish_request(struct request *rq)
 {
-	struct request_queue *q = rq->q;
-	struct deadline_data *dd = q->elevator->elevator_data;
-	const u8 ioprio_class = dd_rq_ioclass(rq);
-	const enum dd_prio prio = ioprio_class_to_prio[ioprio_class];
-	struct dd_per_prio *per_prio = &dd->per_prio[prio];
+	struct dd_per_prio *per_prio = rq->elv.priv[0];
 
 	/*
 	 * The block layer core may call dd_finish_request() without having
 	 * called dd_insert_requests(). Skip requests that bypassed I/O
 	 * scheduling. See also blk_mq_request_bypass_insert().
 	 */
-	if (rq->elv.priv[0])
+	if (per_prio)
 		atomic_inc(&per_prio->stats.completed);
 }
 


