Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050772;
	b=vgSeboZo/5sOACWuN8qSbqPZuRflGpOuAtY9P9E71p1LQw8my2IMtm9X5AADTg8TTDyy
	 j07KKdSmG+/FDKtZuA67ZgeVZe/6QUDj7FLMEt23/qFwyX3xhyR9IhHZ/K0x7sNS1BFWv
	 bgYduwst+vM9XtH+abGwNrokNdykO8lkvGpRF2hWleBkwtYn7Xz0eWnxIrz8l1IureC08
	 wzJVfayjFB8pcXqRhFekI5j6HwhIkrD3J1awRHcECXNvjmAIF3Z5xGX9KdefwRwJHrK4W
	 HWq1rbpwOdsCtHIbIBffBjkHPsjLlo6zFXbpgsv0pBtap/9xxOS7AYN3FH9iO4IQxIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WrCp1rCgxka5sJ6RLTVQTkBkPnlcZeXjnGBd5GRiuVc=;
	b=OcONlIBnK01Ni54YxM4aLIujSt+XKX7PqJ5SIu8cx94iXPTdNzr9ey4AdMR4cdo+AsdG
	 r+9fLkEQNWrpiy42Mf3vsVFk6toJQ57aemffriImxoS/O1VjMeP7B2lXVcYbtCKZ4j4OS
	 txB/bs3DtovooV+sAvQqYT6+WprGuBmmPEhToBJyqfx6XNcA/IKk9XuUMegyVDH4/tBCU
	 k/0v8yz0Guc5sybg9fMb/K3+8ypFpauPW4rZ1EmcgorcTRe+8Vl8im3l5E/oGzCRE0B3b
	 X8oNDatKtJIGpH/SwTLeqsxX9jbAwR+oAG4gsyzqOCwPeD1GQb5fIE98su1ErVYzW5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RrM5jUjL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF0B606A320;
	Thu, 19 Nov 2026 01:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RrM5jUjL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D574A1F000C4;
	Thu, 19 Nov 2026 01:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050772;
	bh=WrCp1rCgxka5sJ6RLTVQTkBkPnlcZeXjnGBd5GRiuVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrM5jUjLe/FkdTefebwCR9V+qfsLZ7BfzwauufUN7mBqRjJmYpdhwehZQ6qiYdzdL
	 iSEKV5PsCpn3jYv4oBW8dBqN/vJ3GW/TBtQYZnz/dFdbCmEFq6i2NwvQ4VzPtKOYvm
	 mqWWzca+fLNVz81hYTmdHOo2Q/CBWoDYMngpo9PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2800/2857] blk-mq: keep sharing tags fairly after a queue update
Date: Wed, 18 Nov 2026 16:03:54 +0100
Message-ID: <20261118150342.409299801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 620cfc7a664278a55d068ed88fff1242fddc4ef2 ]

A hctx only gets BLK_MQ_F_TAG_QUEUE_SHARED from
blk_mq_add_queue_tag_set(). The hctxs blk_mq_update_nr_hw_queues()
allocates for queues that joined long ago never get it, so they aren't
counted in active_queues and hctx_may_queue() lets them take all the
tags. One NVMe namespace can starve the others after the first update.

Set the flag on the new hctxs.

Fixes: 868f2f0b7206 ("blk-mq: dynamic h/w context count")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-30-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 25dfedc77fbba..155d602bb2afb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4848,6 +4848,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 			goto fallback;
 		}
 		blk_mq_map_swqueue(q);
+		/* The new hctxs don't know yet that they share their tags */
+		if (set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
+			queue_set_hctx_shared(q, true);
 	}
 
 reregister:
-- 
2.53.0



