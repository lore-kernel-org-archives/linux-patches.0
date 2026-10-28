Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207998;
	b=3YbXi9koXPhnYO+aBpGS3H4fRg35ZDmYkxjCY5cGGP72aucF+kalneOKUQyxH8WirsO5
	 CMhwE8w3lXavKOaqGTbM5YunSc5hq2cp+GSs2bUi48oFzxEAhFb0sPX0SQFjqMw6tv0Nk
	 fuNHz9x+SNAmap0i2Qz8TZ0n0TAsLx0qHGlAMJ1yR1+epXjP2qeWugi+g07AJEcwRVyI2
	 WYWKT7LzIqH5K3POJEPBbODcn0Gbc2JeI/nrei6gWYqE1GY9sDuzOn44oGJUdobuAisz/
	 SNLlVG5SR/ScxYr0g8ETgJKK3VLEgRBzzjG/EJ7uLFpopt2zdyFZidjHjdxdBypj6QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ST3qZ0AeArvuUW/7UvjLC5tZjk32E2y6C2A+VrpreO4=;
	b=AD+BXFrWHiqQ6DYlax474/6Hn71z81+6/8MeKptXEW2VsXxHarZ0rV7kf/mz+QlLYLLC
	 0gGz+jyQvZ2Ao4y7lMeEI3aCoPTWQlI0yuSVZGtgVXEifGzyvzzF9zCRXRhI/icb9IkmM
	 Dm2OJ6O++VOIQuLqyZhonpZveXglcfaAwD01pNCShc4yzdgPoWi/7qGisVuWqbqJkD7Ta
	 MbW8WkNB7byGlk0uwWDGh/emmr2joFQ04VEHR2xeQ0hS2OrEsl54OE1s2JXxIKyg3LFF4
	 BVZFIE7shg7QldCNoJKoBKh9ZH4HeaOF6RMEH6+KSUTzFlRmyMQ8iaZkxuGSckdPXcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YJGF+hlv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4906606A31E;
	Wed, 28 Oct 2026 17:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YJGF+hlv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4781F01825;
	Wed, 28 Oct 2026 17:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207997;
	bh=ST3qZ0AeArvuUW/7UvjLC5tZjk32E2y6C2A+VrpreO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJGF+hlvCVodbkcyLJDriUBxCvQMhpjYMK41O3cwk4NyRb8KEHovktnU4/AnuJReR
	 cW4B6L8MK63U1hOEb+59dTMIld2XmXLM02CvA1GqpwSD4MAmzSrQdQVSLwm8OM0iWR
	 4CwzRlmKYD2+rGHnT326skR+2SrrpSjD4Or9Hjn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.12 212/247] io_uring/wait: no early -ETIME if min_wait finds work
Date: Wed, 28 Oct 2026 18:00:15 +0100
Message-ID: <20261028165952.441860365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 83cce67298ab1f4d2e9205a49f56975475cdb154 upstream.

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

[ 6.12: io_cqring_min_timer_wakeup() is in io_uring.c ]
Fixes: 1100c4a2656d ("io_uring: add support for batch wait timeout")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-32-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2435,9 +2435,16 @@ static enum hrtimer_restart io_cqring_mi
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
 	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
 		goto out_wake;


