Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209768;
	b=plvE1cnnk2LI9r9GlxGqDaTzFSdxULXk4GfuCQi4AAgcBP8i6+YnLmSMK2nzI3+5JpB0
	 bX6A7dJjfbYnpirGQthkto0Fco8oQRQjXbsYpT9e5nlY9cF1iJ0Vx+JlhBGoN/dJT/AR4
	 1Gnwdf3mUBfCCQjPDb56ROtopc/rlZWpqtCTzgj2YI8IpYm+K4juuRsb+GR6LwV23yXlB
	 8EsxnIOaRtzDgxb2q5a1Ux5rTMrnvrKOiMgVqyZc8VLIpfiUkGVzA/9IMG3QFQvCTyAJK
	 hNVLkaikDtC1eg7oXt5OC+hsv4sducZH734V52H3/9cNLFKu2tsVDBb9XBGek4kWv+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6mfQ9/lAu+yHp8OTnTmJ033L2w2HZE5UmOTyKpPNCxw=;
	b=oK8mKZTPkFQkKwIx7dWK/P5Tb0aMYz/iG2Ei7xuK888Sh247YvCq24s7kCqIxCld9ntK
	 oyM+e2DtaINLWQ6S2YAX/fKD6fYDdPK9B6BCSYKH/PH0yuqTedVR7x1Dt5v1sYlec16rx
	 3xepXhXZmUGqLFnI0hP79qpJA8SbzFK2z0DngdZ6Ro25+msyulgBSGXKeWp5cZOmYPM6U
	 Fwv98hfStMmNup6zDrSczmnT676noOYaU4keJmi9dVupBWUQ0GpHxS1bxyS9AXiixDGCU
	 y8muCQbK2r7h206DTPgqfCUkkwCVjfmZ1U6Cp9T4PgeMg6kRr6K+Ljv9/U+yU9+aQ6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0zcEXdB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A526606A31D;
	Wed, 28 Oct 2026 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0zcEXdB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCF91F01825;
	Wed, 28 Oct 2026 17:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209767;
	bh=6mfQ9/lAu+yHp8OTnTmJ033L2w2HZE5UmOTyKpPNCxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0zcEXdBBvB7n+PLoUcBzof8WiM93XMn9Lw/XftBKycV4eh7wGobsYEolUtrpHB4/
	 8vcb/2dqSRZcm8/oxEudBUwBWBpN8stH4dn4F+RpvR6UfGDv0/uoTCz9sPNbvnNSQ8
	 1NVi5BFYfqogVZ/VNgEZqOSrYKbPtgDUWbGfKNA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.18 069/109] io_uring/wait: no early -ETIME if min_wait finds work
Date: Wed, 28 Oct 2026 18:00:53 +0100
Message-ID: <20261028165943.980706288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

[ 6.18: io_cqring_min_timer_wakeup() lives in io_uring.c, there is no wait.c yet ]

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
@@ -2583,9 +2583,16 @@ static enum hrtimer_restart io_cqring_mi
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


