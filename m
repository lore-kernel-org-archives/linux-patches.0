Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99E120B3E;
	Tue, 23 Apr 2024 21:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908452; cv=none; b=RoRZ5Aox13Tj+8KoSopDGkLlttRaTCdXhh3Q3oqzbRZi5fMn9sj6YuauLPUmS8Jvgi/z4POk92s8v4LB4SyWTW8PiIgxJiZW0M9oxs2Hc/i0Gj5eJj8B5WUtQxptq2gQ3KmYg+jdKKByJ2nlfEzyrxANiyPgCIwJOEcZKIQylFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908452; c=relaxed/simple;
	bh=O9e1rlR17TsMH/Aw0x6f4a7mRyXli8yaFew9EXbQ3Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZ3TvyI5feJ9NrG8uxmmTQ6IXwN5xiyLrxYH+E8PcXjGehxzkZF4je0+P7PDvtyN2tE4rknpc1IsbNZncIA8TksgHUPvw+UipZxxwlChHpyOMECkhekuLZ7THMUvr1jGd1C0TlH/S0d+FKkE8X+cPgk9RbGlnzs7/8xRaZzIPT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afAbqlVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afAbqlVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9668AC116B1;
	Tue, 23 Apr 2024 21:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908451;
	bh=O9e1rlR17TsMH/Aw0x6f4a7mRyXli8yaFew9EXbQ3Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afAbqlVdjlMagQK2NMsnJOIk50R7gmmHlG61xcjby2/VdGkrnCXnBeAAif9piSZ78
	 icszFAJ7lqlyITuNG1e5BmaKlsSipjKrsO/y6eqKJGtGD/UHUie1eHEllcFP0eRohb
	 W3y+Z+OTl/8ErilspcYgSQpOIBZqv6MWVYap8QPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Izbyshev <izbyshev@ispras.ru>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 001/158] io_uring: Fix io_cqring_wait() not restoring sigmask on get_timespec64() failure
Date: Tue, 23 Apr 2024 14:37:03 -0700
Message-ID: <20240423213855.878147778@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Izbyshev <izbyshev@ispras.ru>

Commit 978e5c19dfefc271e5550efba92fcef0d3f62864 upstream.

This bug was introduced in commit 950e79dd7313 ("io_uring: minor
io_cqring_wait() optimization"), which was made in preparation for
adc8682ec690 ("io_uring: Add support for napi_busy_poll"). The latter
got reverted in cb3182167325 ("Revert "io_uring: Add support for
napi_busy_poll""), so simply undo the former as well.

Cc: stable@vger.kernel.org
Fixes: 950e79dd7313 ("io_uring: minor io_cqring_wait() optimization")
Signed-off-by: Alexey Izbyshev <izbyshev@ispras.ru>
Link: https://lore.kernel.org/r/20240405125551.237142-1-izbyshev@ispras.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2610,19 +2610,6 @@ static int io_cqring_wait(struct io_ring
 	if (__io_cqring_events_user(ctx) >= min_events)
 		return 0;
 
-	if (sig) {
-#ifdef CONFIG_COMPAT
-		if (in_compat_syscall())
-			ret = set_compat_user_sigmask((const compat_sigset_t __user *)sig,
-						      sigsz);
-		else
-#endif
-			ret = set_user_sigmask(sig, sigsz);
-
-		if (ret)
-			return ret;
-	}
-
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
 	iowq.wq.private = current;
 	INIT_LIST_HEAD(&iowq.wq.entry);
@@ -2639,6 +2626,19 @@ static int io_cqring_wait(struct io_ring
 		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
 	}
 
+	if (sig) {
+#ifdef CONFIG_COMPAT
+		if (in_compat_syscall())
+			ret = set_compat_user_sigmask((const compat_sigset_t __user *)sig,
+						      sigsz);
+		else
+#endif
+			ret = set_user_sigmask(sig, sigsz);
+
+		if (ret)
+			return ret;
+	}
+
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		int nr_wait = (int) iowq.cq_tail - READ_ONCE(ctx->rings->cq.tail);


