Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207278;
	b=OtQcWLAkD8rZq+8acDKQmLckqZAsoJdWyrbNChE7lqPtR0ojDS/I8+XuwIPf7FgduYxj
	 G1ags5dFR0gKdlEf2hS6IVOP/gLGMcOn9YC0JwnuBjHxLg8UFHJXjMePN1YP8fBa3wrkT
	 ltG72Brt4riqAALaO1NfWA1Zuqd4As2FxlFN0KENB3jnFWiWYYiXgyFAn0xfJsxgnt17A
	 DOkEWX+HoVmSndslpTl2uaXLb3zZf0CFeSf1wG0vzJRSTfky3DEFcrU27zeE+jM+H5VzW
	 YdIGv5WxsoDcbMUEtzo1yHG0HDh3aj8oR7BnOVTx7yYhfFoMVOvM/wuygyS3XsySaow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vsUJqiVCJt5l3rdcfApObWqsFSienqg4JN2V0OV27eQ=;
	b=AYc/EeRuqOR07aLIT2WS8nC+WPK8dRTSoz8IhaYD9L0hHa41mM+ZIBdKtTiN0Vufv6Go
	 NZTmM0EoJT3WyDMwThd2MPZKuh6D0JDyXRigLB5SVFgRO1XtCqg++px78P/o5N+gbYDXF
	 whN7KAbS90A3WtAGRH/ztuSSsh8Ppf4/v04RI3Qrkh9SauU5dB+rNpePYXYXALAcDR/VX
	 nI6DQfYmOtzXLigDmlhZFLmL0gQ1jzGGhBb/SgguUi2UBHSemCJ/Xx7T0sFucF0mkh8bt
	 VQFHLuxZAEb5bIQ4zahTPLNrIM0WZCgzWvBynpop9XRGvu5xnJDpnfg2PxpQ5Bzx0Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j7TmyPFb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE2A606A31A;
	Wed, 28 Oct 2026 17:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j7TmyPFb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EF81F01825;
	Wed, 28 Oct 2026 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207277;
	bh=vsUJqiVCJt5l3rdcfApObWqsFSienqg4JN2V0OV27eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7TmyPFbDDKKG+NygxwlnWdEQOHLRpqwX/Ta1Qz5w6YjppqWSRdIo8llu3TLRxZ4P
	 qoQa5Ne7t/XJR8OlLh3PaCT7dRTYzPNpEcn0B9brUdqEqyh5O1ElRuHhVYG75ywvKm
	 LSdyII/OBquII7j7l/hm/z7VvCDWJQWH0JCuQ+M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 48/88] io_uring/wait: no early -ETIME if min_wait finds work
Date: Wed, 28 Oct 2026 17:59:56 +0100
Message-ID: <20261028165943.245015581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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

Fixes: 1100c4a2656d ("io_uring: add support for batch wait timeout")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-32-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/wait.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -77,9 +77,16 @@ static enum hrtimer_restart io_cqring_mi
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


