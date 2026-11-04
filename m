Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826859;
	b=ZDO6/vqLTSJRfdtJ5WDH8wOI/aaONd9/kzh0svwIgg4owBlGBwleVc7yNJi32JzJAZ7t
	 Pa1upKU2a7PHj8hxWk9CZ7RZmQINtY+bAaUGbE4wdwbF+XC16EVGyXgBPsKP0/aNByvAg
	 x2OPPJgyB2jW+VxWgEo+NcuR8H+NqLZVa0D52Mn++fbzxKHVcO0qUbeGgBatw5MwnhXEu
	 oLr0IrzW4xgzGuOrjnLqev166re2cNoraWVn4nHoyD/m+cdXVB0mgKmUUYGn9sQTFBx3X
	 jae3pjshmqI+0EL59QmygfDX3/XjOfQvLL3CeBwzAOuNI8LYZB8GiFu9lYzE1VKWt2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nm7nB6TGIfMPCXQMyiEej9CKa40X4XX/tNs5A1GrocQ=;
	b=vXAhpXKLOcMEojRlVy7zwqckyFwQlmfBeCOjDSx5PVxoEYtnmVGwrAp1ey5bMC/I6D+Z
	 f7KwaVB+EKEYEkLa4GpxdmE8xf+05T58Dy6jHrACQcs36hUmYlyTBQQ40Q/GJ1/fbxUTi
	 6NuoKPhsEiNDARK6e8Xnx1dPUUA5LytNpCh6IUqtwp4PgOWLV13xMEmFNz5DGdIoc00Xq
	 eCQY6hQfm7JUsXMKx/S+x5F9zgpTaduzXcBtSeoFrO1kr/4ZZorFqV4l5cD1MRUNFgGnT
	 ImoNDZOY4eFmdQh9li7CMmUTiAYoiHomdBAGKlCROlEtFIqku6o0scuVSTRQWq2B0hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GsTsPa/l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBCF606EEB7;
	Wed,  4 Nov 2026 21:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsTsPa/l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3C21F0093A;
	Wed,  4 Nov 2026 21:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826859;
	bh=Nm7nB6TGIfMPCXQMyiEej9CKa40X4XX/tNs5A1GrocQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsTsPa/l/Ip2/fug1dxfDDiImFAqxi0eppiBlSG8dE63TYnLpXv9sHmf4tS77GMQe
	 5NkUjd6vSLFrtTShbBI/eFnSOQY3YUcdl4zzvaYDLMGxz5b+t5O2DxDMCxS1qtBMly
	 M5laF2jCw2Vc9BbyoWjB+9Pz0S0nlWsXbdz6UcWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 048/547] io_uring/wait: no early -ETIME if min_wait finds work
Date: Wed,  4 Nov 2026 16:03:52 -0500
Message-ID: <20261104211039.674593206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 83cce67298ab1f4d2e9205a49f56975475cdb154 ]

When the min wait time is over and there is work to run, which for
DEFER_TASKRUN includes task_work that was queued lazily and didn't wake
the waiter, io_cqring_min_timer_wakeup() ends the wait via
io_cqring_timer_wakeup(). That flags it as timed out. io_cqring_wait()
runs the work, leaves the loop, and returns 0 if the CQ ring holds
something.

Running task_work doesn't have to result in a CQE, though. A poll wake up
can turn out to be spurious, for instance if somebody else has read the
data by the time the request is retried. The application then gets -ETIME
once the min wait time has passed, no matter how far away the timeout it
asked for is.

Wake the task without declaring a timeout. From now on a single CQE
satisfies the wait, like in the case where the timer is switched over to
the normal timeout. If running the work doesn't post one, the loop in
io_cqring_wait() goes back to sleep with the normal timeout.

Fixes: 1100c4a2656d ("io_uring: add support for batch wait timeout")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-32-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/wait.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/io_uring/wait.c b/io_uring/wait.c
index 078fa8b076a99..fb1c082993a7e 100644
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -78,9 +78,16 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 	if (iowq->timeout == KTIME_MAX ||
 	    ktime_compare(iowq->min_timeout, iowq->timeout) >= 0)
 		goto out_wake;
-	/* work we may need to run, wake function will see if we need to wake */
-	if (io_has_work(ctx))
-		goto out_wake;
+	/*
+	 * Work we need to run. It isn't known if that is going to post a CQE,
+	 * so this isn't a timeout. Carry on with the normal one if it doesn't.
+	 */
+	if (io_has_work(ctx)) {
+		iowq->min_timeout = 0;
+		iowq->cq_tail = iowq->cq_min_tail + 1;
+		wake_up_process(iowq->wq.private);
+		return HRTIMER_NORESTART;
+	}
 	/* got events since we started waiting, min timeout is done */
 	scoped_guard(rcu) {
 		struct io_rings *rings = io_get_rings(ctx);
-- 
2.53.0



