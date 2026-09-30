Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F1E5038F7;
	Wed, 30 Sep 2026 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785658; cv=none; b=pyL8uBondmWIulcrl0kv0QA+JpNiI5F777XcUiHvLI/qtmgWmijs1i/wbQm8E9B0FxUC7mVRuoBh6a7DqnUSNl13m05ODFC8dWg30d4CSxHlE3HGShJzwHkzuFmgLDeB9rEF+6wVvTFQ4tN6HzxaKisEb7rcBNWD6hm7j5SCcA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785658; c=relaxed/simple;
	bh=2b1kuQvwAVVrEM8qeSGEfLwJC0WjwAs8jVbvLMM/88A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trRn1vMf32EugQazIksXE0BNTQgv81CB3FB81QkQA3zKEtIkDXA0qFCA6Z/MiB2XttL92+KguJ5oEjRlyjicT+U924URtOgLP4TR8bR3Fxm59mgSNLcgp9SI21rAjVk796Zio2gn1C5gUM5NFn6YamgHVPGEXNoj6bqn6SXy74U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMu8m4ql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMu8m4ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922BE1F000FF;
	Wed, 30 Sep 2026 16:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785654;
	bh=613PTElfDtyGz9+5HydwLOhuQj+P6ClMs5qrRVRPRWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMu8m4qlnTWD2/MAimmrMxOx61p6Ya3MVUZY40yr1Dy3AhbodF+F7LhmtoNx+AMSh
	 RAo3Cg8ydqxsIZQnuAyGqZE2OhXyrvZ6+tVWNwgrvdEpJu/U2EsR3BbM9VzM41ZlYr
	 8SwaqXC7huIupm6Us+me2ywtx6iHVyBZpKkDOSQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Stian Halseth <stian@itx.no>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 583/982] sunvdc: fix -EIO issue due to lack of retries
Date: Wed, 30 Sep 2026 17:21:59 +0200
Message-ID: <20260930152429.301452497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index f03bf77da8c4d..11bdbf5b2f963 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -557,6 +557,7 @@ static blk_status_t vdc_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct vdc_port *port = hctx->queue->queuedata;
 	struct vio_dring_state *dr;
 	unsigned long flags;
+	int ret;
 
 	dr = &port->vio.drings[VIO_DRIVER_TX_RING];
 
@@ -578,7 +579,13 @@ static blk_status_t vdc_queue_rq(struct blk_mq_hw_ctx *hctx,
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



