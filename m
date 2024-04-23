Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186A4143889;
	Tue, 23 Apr 2024 21:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908589; cv=none; b=WrTxI7TPREsvyGBYUQQhLgC+28Yg1qSHVy2fRkuEdy7o6YWQqe4VKhpk4Ab4nZD2baykeHMC+U2PodthtzYOEw7gsaUBvNmXNTQO+74LYKpDLC43aPQbEq2y2QJryXhGOg5TVjnhj9u4u871k2e7rh3KdK4reQcTmYxHtr1vMRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908589; c=relaxed/simple;
	bh=12txO5VIjoINW6a3vAA+wOa5YDaG/Uss8xnjiOuW464=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRuGURhFJ7urt5O8SxdcMPPOyXE4UZf/yXObYOPiQL73ztY0tivdjiij7U4/4JPjETulkEulMotJQpVpgKbxNzI0TAsHQ+nVLcYEbMAhi0Uc3RSK1MMaPg+5WK8FMMn0SRVmx5rS+EMjE0o816kgLo+vPTpYk90jaH5liJIoslE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YORQrAZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YORQrAZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28F7C116B1;
	Tue, 23 Apr 2024 21:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908589;
	bh=12txO5VIjoINW6a3vAA+wOa5YDaG/Uss8xnjiOuW464=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YORQrAZR1sYhW1R1Ep85CHwN5hMGL243dRyXe+rGj+aWKjLUI89eaYso8HP5TLIEU
	 TN0/3UygLUkzDyx6o6AKMu8jAKouEq5Ae8ZRwkLkP8Q78PC4tUBCIM2uCJyYr+YNCM
	 mysaEu/HgSjDv71vs/RMNrze7u8Dw4Yr1vvXB9CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Izbyshev <izbyshev@ispras.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 023/158] io_uring: Fix io_cqring_wait() not restoring sigmask on get_timespec64() failure
Date: Tue, 23 Apr 2024 14:37:40 -0700
Message-ID: <20240423213856.489936855@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2559,19 +2559,6 @@ static int io_cqring_wait(struct io_ring
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
@@ -2588,6 +2575,19 @@ static int io_cqring_wait(struct io_ring
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


