Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A953AE198;
	Wed, 23 Sep 2026 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174202; cv=none; b=R9RuCYJC6LECXWEobEq9iHHAazwBGL4N4t1tq8UMNJbQtSHwLw/YIZCtLneLWGbA4kH6WKdJBmJJpufQu88sodgnfHsBinhZ5DR0biWbsUHuVnr+RzE1NmqqF0WJUHXi0lG+JCM1/+eRd09MOXm2u/06Jm3LrZCPsy8M7pC+ius=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174202; c=relaxed/simple;
	bh=DstQleBGlytkDUXQlzqjPuNyjGkJq9dgwfBtlcPDyts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSYzCKDseU+e502TaMDNOxF08O7TrsEfBHlMWnuaGHfKqWVZ+qlZaFzypwl/DNuzvOn8/DvIqjmWp1bELdi0kafyeAeaczAq04IABqPHOghPmy6pwnAP1BkYxjlWQNRPCxPTaGdHs8w5jlpV9NtE9RxQvqzFBipqu+n6l8KzdcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZR5KiuQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZR5KiuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DD21F000FF;
	Wed, 23 Sep 2026 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174200;
	bh=XqBJwgnj8ydpezHOGqLXG2TbjCJsQ+umPsL1xL7vibc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HZR5KiuQl6iaBfsxWrfMtgEFMZCf25wYcjlVdbxg+99crLqG3ywJeWXpOE6IaQXtL
	 A0w7kKOhbdhSspcxqUtvfaOmJF0UN7ORzIpALjrl4jxRJix3LnwMlS7/KMaUC7DCSA
	 OSGA9zZFEtvXm+6A1gaMuubQ5t7C3hJ/pwqeDypM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Stian Halseth <stian@itx.no>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/398] sunvdc: fix -EIO issue due to lack of retries
Date: Wed, 23 Sep 2026 16:01:27 +0200
Message-ID: <20260923140643.785011481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5067d4ba713961d8ccea1e06cd4c453793f3121e ]

John reports that since commit:

a11f6ca9aef9 ("sunvdc: Do not spin in an infinite loop when vio_ldc_send() returns EAGAIN")

users of Linux inside Solaris ldom see occasional -EIO errors because
the request send loop now times out. The current loop does 10 retries,
and inside vio_ldc_send() a further 1000 1usec retries are done as well.
Even with 10.5 msec of busy loop retries that's apparently not enough to
always succeed.

Rather than introduce continued busy looping, requeue the request and
have the delayed queue kicking retry the request after another 10ms.
This obviously isn't ideal, but there's seemingly no way to wait for
this type of event. And if 10ms of busy looping was not enough to make
progress, then presumably this is an edge condition and we just need to
guarantee to make forward progress at some later point in time. That's
more suitably done through letting the CPU tend to other work, rather
than sitting in a tight loop retrying.

[stian: rebased on top of the cookie-unmap fix, without which every
 requeued attempt leaks LDC map table entries; tested on an
 UltraSPARC T4 LDOM where the vdc_tx_trigger failure condition was
 reproduced and absorbed by the requeue with no I/O error]

Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/all/20251006100226.4246-2-glaubitz@physik.fu-berlin.de/
Link: https://lore.kernel.org/all/418310b3-2b77-4534-b2fd-27dcc11e333c@kernel.dk/
Signed-off-by: Stian Halseth <stian@itx.no>
Link: https://patch.msgid.link/20260901173947.3292110-3-stian@itx.no
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/sunvdc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 2eb96136632ac..1b5757aae57bd 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -556,6 +556,7 @@ static blk_status_t vdc_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct vdc_port *port = hctx->queue->queuedata;
 	struct vio_dring_state *dr;
 	unsigned long flags;
+	int ret;
 
 	dr = &port->vio.drings[VIO_DRIVER_TX_RING];
 
@@ -577,7 +578,13 @@ static blk_status_t vdc_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return BLK_STS_DEV_RESOURCE;
 	}
 
-	if (__send_request(bd->rq) < 0) {
+	ret = __send_request(bd->rq);
+	if (ret == -EAGAIN) {
+		spin_unlock_irqrestore(&port->vio.lock, flags);
+		/* already spun for 10msec, defer 10msec and retry */
+		blk_mq_delay_kick_requeue_list(hctx->queue, 10);
+		return BLK_STS_DEV_RESOURCE;
+	} else if (ret < 0) {
 		spin_unlock_irqrestore(&port->vio.lock, flags);
 		return BLK_STS_IOERR;
 	}
-- 
2.53.0



