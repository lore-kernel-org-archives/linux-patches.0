Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621547;
	b=T7PHoU2Yl13D8j5uLIpFJzgI/R0kw0OCvd6eBBKNdGoUtPQuLSewbnECM7fNPFWZ/ayo
	 0DN88YFOJu/4WXgNfh1KYpZb3xl3vh4pZzHvhtxAV0XIOs5+9FIVaI0fqX+dcfGFzyC9g
	 nLiGeDqjHRrByWAxayebMeoDD2YS50kVYeXPThPolPfhyIwoQ5zCjN21iayL1iKMK46NO
	 9eiPTlLQ2WAAvUWmcw6/R5VBw2Eel+/MnD0OvqUwXq7I2q4KmDu8UC61u+9v0ZwqUYf2n
	 txWJEmpvr0qhr+frVgl++rC9z8DmJRNWwI4JKamPazWT2zlEAU2GdoUB6uGxJpXkFKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ylwNQiaAJ2jzFtq++9ZtXuBNg4fy7UVr8MZhSM8R/0o=;
	b=k6fkQ6NtfvkYGbyp0IBI9wxjlO3Vi6a9kGmL/YAUVpSiwo2lrp9ohRn4fyY1RjU3MqdE
	 bH3k4cOuFupDWZAGf6ebx3lLCCRPe3yEfdNBeTBYD9kQW2KuwHj7/Kian2qjOoJlGCBUt
	 ESJQbSx9Qt7VcZMobKaqu5o0jWGLrbB/Q23PYNjITwZiAFAAGg438jM8MskEIS0m4jLX5
	 5D2Ec71hA7fxHPOKRp2maeg8Hiv4bzCZsPLKsivk22Lj93W6A/PH4E06h3pw4c4IaLSPU
	 Iqs3smkWYmhUUA8ifkPRyEzFC+DSMBCxjT6fn21sle5cU6WtZ0ag1C3qEwc6+0SP5Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URyw5UCU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D4B606A321;
	Wed, 25 Nov 2026 15:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URyw5UCU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010051F000C6;
	Wed, 25 Nov 2026 15:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621547;
	bh=ylwNQiaAJ2jzFtq++9ZtXuBNg4fy7UVr8MZhSM8R/0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URyw5UCUzE7KSX7fbSj/Fzel/3p4BPmfiuJtx0VWP4plpTgloo9G5hkBQuf3aMzBh
	 Yvl387lclD+Y/LEoh9IyMswYl8BsPYNMK7W4jErGtE0tW+BLG+JJmKiFy1U4OG+mKY
	 mbW25eVfXJdPcZu7rPxyJk2jav5nJD49tk88kz+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianan Huang <jnhuang95@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 214/990] blk-mq: reset queue state on scheduler teardown
Date: Wed, 25 Nov 2026 15:26:21 +0100
Message-ID: <20261125143827.102007131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianan Huang <jnhuang95@gmail.com>

[ Upstream commit 3a9892bca4dd0182db61702e131cad569b1d71e6 ]

We observed I/O timeouts with requests stalled in per-CPU software
queues.

The affected queue had no elevator, but QUEUE_FLAG_SQ_SCHED remained
set. A failed elevator switch can leave this state when falling back to
none without clearing the flag. With empty hctx dispatch lists, a
queue-wide restart on CPU4 would skip requests pending in ctx5/ctx7:

CPU4: blk_mq_run_hw_queues(q)
  sq_hctx = hctx4
  hctx4: no pending requests   -> selected
  hctx5: 9 reads in ctx5       -> skipped
  hctx7: 3 writes in ctx7      -> skipped

The pending requests may remain undispatched until another event runs
their hardware queues.

Clear the flag and restore nr_requests and async_depth to the driver
queue depth in the common scheduler teardown path, covering both
scheduler exit and failed initialization.

Fixes: 4d337cebcb1c ("blk-mq: avoid to touch q->elevator without any protection")
Assisted-by: LLM
Signed-off-by: Jianan Huang <jnhuang95@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261023092611.116795-1-jnhuang95@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 128f2be9d4207..d18175ffa1b18 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -374,7 +374,7 @@ bool blk_mq_sched_try_insert_merge(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL_GPL(blk_mq_sched_try_insert_merge);
 
-/* called in queue's release handler, tagset has gone away */
+/* Clear scheduler tags and reset queue state. */
 static void blk_mq_sched_tags_teardown(struct request_queue *q, unsigned int flags)
 {
 	struct blk_mq_hw_ctx *hctx;
@@ -385,6 +385,10 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q, unsigned int fla
 
 	if (blk_mq_is_shared_tags(flags))
 		q->sched_shared_tags = NULL;
+
+	blk_queue_flag_clear(QUEUE_FLAG_SQ_SCHED, q);
+	q->nr_requests = q->tag_set->queue_depth;
+	q->async_depth = q->tag_set->queue_depth;
 }
 
 void blk_mq_sched_reg_debugfs(struct request_queue *q)
-- 
2.53.0



