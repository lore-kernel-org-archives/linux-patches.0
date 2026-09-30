Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2F53DA7DB;
	Wed, 30 Sep 2026 19:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796008; cv=none; b=V9LnqkxBomrz4I+yV8VIOdB0y95bnfydAMaBnPdRE/3CxCw6/eOe+dQ2RiyxBVVaPiy8zZOCFgd5VXvb520Lj8Ous7Ca8MDX61XSLJxscBAMp9s2ucDBhJn8LU4oYOKCSYww7CeOIQ/GppnyJwUn5zCzq17pzNhKYlOLgczydIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796008; c=relaxed/simple;
	bh=Ge7XdWY1hoHXB61sjrarJkYPci5dEmGV6OpOvLVwVk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sh0hKQeM4yGQEbOC0/4Thji2cVmjKI1WNl+k7CiQkegactuMq334jPyLItv4gLOXGx58qNT0cuigUCfwlUR8SyLK9jTAINL3/HtiMVsMMZemdY0bFXU/n0lNL2CQCXy1Y7/9J3Dtot5EqemctZqFVDuGWBoyjft9W/fU12+0sD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xR3wRzmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xR3wRzmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BC21F000FF;
	Wed, 30 Sep 2026 19:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796006;
	bh=mkrY7KnbHW13tERDou3Rbh4qM2dA4tuKYYCb0WofR5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xR3wRzmIdkMa8GwrfF8gKXyaItQQXCMXEBumXals+a3NbCpWeNuT3hiaJJYa3IlfK
	 JfS/2SA7GimUvpvt+E0Pi7hSpS0+DbYFih0VrMsOqK6l54DS4k3GxtYMQDjgGxZ9il
	 J3LWoY8tnMEWRy4GDu2cTZjYjXR268TwIvwnbToo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Stian Halseth <stian@itx.no>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0716/1193] sunvdc: fix -EIO issue due to lack of retries
Date: Wed, 30 Sep 2026 17:23:20 +0200
Message-ID: <20260930152450.157048897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 829da2723fda4..3260b9f779937 100644
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



