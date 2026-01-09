Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D6533B6ED;
	Fri,  9 Jan 2026 12:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963175; cv=none; b=mXUoUijiZj2R1zdg7weymehHwyZtrmFZtUWm2MffeN7WR957H+NP9nS5Tjb70NYz3xP0GHe3M7ll2wt27xRFhrgMZ5KCVeZLPsAstiYocdwNVp9hR+7nmsLHtduWBm+J5Do/L+75jXK2OJ47Dn0XbNAztjBzyoscX1pDarWVcbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963175; c=relaxed/simple;
	bh=C/1t6DK0C6g0OhT1U6phfMViiJqw1udC7d+E5on8OHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkoZYhAi+pq8FeBgqrJRiE252h1ZlsFtIq8IbXdqJauV+HF5xo5KNKArSRLvlNVEMcv1V56qEEZ6ySFv9AnMkO3sqt13sH3CgWSupjch0EtHx9lkmPos7axjFVxJFaP953WrUGVq9LK3eExd3QMPpmoam4Skw+BYVmaFH7mRB3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMu9Wc72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMu9Wc72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28452C4CEF1;
	Fri,  9 Jan 2026 12:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963175;
	bh=C/1t6DK0C6g0OhT1U6phfMViiJqw1udC7d+E5on8OHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMu9Wc72w7xe1GieyuNr2ISRv0r64rcXiBwEO1lRaB5B6Dw3v1SBLRR06lItkNWFT
	 UshJgz0fIgdjgRXc+EN6ATjr3wHSCVWlE6Zu/86QbKaBCT91/Nj+vPP5g+xpZLty8Z
	 xI6YvIUeYN0khoH2DtOCLNAt44j9CGWdS5xQB/Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Rick Koch <mr.rickkoch@gmail.com>
Subject: [PATCH 6.1 622/634] blk-mq: setup queue ->tag_set before initializing hctx
Date: Fri,  9 Jan 2026 12:45:00 +0100
Message-ID: <20260109112141.043152618@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ming Lei <ming.lei@redhat.com>

commit c25c0c9035bb8b28c844dfddeda7b8bdbcfcae95 upstream.

Commit 7b815817aa58 ("blk-mq: add helper for checking if one CPU is mapped to specified hctx")
needs to check queue mapping via tag set in hctx's cpuhp handler.

However, q->tag_set may not be setup yet when the cpuhp handler is
enabled, then kernel oops is triggered.

Fix the issue by setup queue tag_set before initializing hctx.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Rick Koch <mr.rickkoch@gmail.com>
Closes: https://lore.kernel.org/linux-block/CANa58eeNDozLaBHKPLxSAhEy__FPfJT_F71W=sEQw49UCrC9PQ@mail.gmail.com
Fixes: 7b815817aa58 ("blk-mq: add helper for checking if one CPU is mapped to specified hctx")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241014005115.2699642-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4337,6 +4337,12 @@ int blk_mq_init_allocated_queue(struct b
 	if (!q->poll_cb)
 		goto err_exit;
 
+	/*
+	 * ->tag_set has to be setup before initialize hctx, which cpuphp
+	 * handler needs it for checking queue mapping
+	 */
+	q->tag_set = set;
+
 	if (blk_mq_alloc_ctxs(q))
 		goto err_poll;
 
@@ -4355,8 +4361,6 @@ int blk_mq_init_allocated_queue(struct b
 	INIT_WORK(&q->timeout_work, blk_mq_timeout_work);
 	blk_queue_rq_timeout(q, set->timeout ? set->timeout : 30 * HZ);
 
-	q->tag_set = set;
-
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 	blk_mq_update_poll_flag(q);
 


