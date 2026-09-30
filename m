Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908764ABBA5;
	Wed, 30 Sep 2026 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791798; cv=none; b=vCJSDzJf1kPDNlN5LOADbg73ToCHcfrbd6emv7jSs7Fzpy3tqfy9ViUJLSw7aEDIOJD4sX+lyImXTUC/nmydu06iain8IzZZ2vV9ECaAwlACmzVh5uXCw+YDia64PAxIIY+B8yI3n3Y32msG7Xp1qs/CdzTJX6h7Y5grX5hAEk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791798; c=relaxed/simple;
	bh=8LkmI96qBt281nggt+YNHmIl9NlApE8yJRdiUzFNs94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8U/BtjkwMgeVkOSqKLekaN8wKxLeNq/g+7yBjvy2RXs0I1EsDjK3yPtj/2QCv2yjdkhy9ABeEv3/3dUHcPwmDr9M5aCFzFoLQPPZC+H2IUoWRT0GoG2mvPZ7wxGYf4sK1s2KKhvCb+BxEEo3LdMzbSoJlqV2GnkC09xSOzKY9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4GcTpQz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4GcTpQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A2F1F000FF;
	Wed, 30 Sep 2026 18:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791797;
	bh=ctl5LLdVmF+768RKChY0DBdbE+mCSFxiW/Xi71O+bvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4GcTpQzoLofOQqvDJLld3YNvaTDhU6HCI4Q+V5spT9VkSvHDCtyO+hlu0zBz2TN7
	 bOboQnGbIEnIKEex8r+Lgo/JLIduylrW12tW6nNCCcZExFZLwrkN1AMJARxXawZ0VV
	 v+YElhtLdbwn4tCjDkCMNaqideFIjP1JbGYey6fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Stian Halseth <stian@itx.no>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/752] sunvdc: fix -EIO issue due to lack of retries
Date: Wed, 30 Sep 2026 17:25:00 +0200
Message-ID: <20260930152407.590182440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 992837bdd487d..9274d2787ad99 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -555,6 +555,7 @@ static blk_status_t vdc_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct vdc_port *port = hctx->queue->queuedata;
 	struct vio_dring_state *dr;
 	unsigned long flags;
+	int ret;
 
 	dr = &port->vio.drings[VIO_DRIVER_TX_RING];
 
@@ -576,7 +577,13 @@ static blk_status_t vdc_queue_rq(struct blk_mq_hw_ctx *hctx,
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



