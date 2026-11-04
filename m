Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829229;
	b=k1qV54vsN9nEYyJdFrZXEY9AVpq6UPm+TMpfNjdb64Js8EdDHjFLizEwXunQCUqkpKWt
	 6UxtvtnuxVJ5B+Pqf1657gTj4mfBT6o0o3bwY3SRWG72EqsiOKaF6yWelv60amuFT3oNN
	 srJcIYoXzEDMgG9K3elpQBvJVSS0GLSeX6KNLe8KL3cL2hA6G2b2vyee0LdIRcieW1RXW
	 GoEqH8eZnDZDPYUF6xeH1Ayv4WSE2w9AWNGgHf9JqrBXw+5FjMDuqGvF/FHSsd8BJIumz
	 IEgSuZZJmuMaCeLGc/qiZcBTEarxi5DQDHy4GW4qPJNGx7nKjljONwc6Kyvt9P5L6Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MWUWPsRTRdkN2YpXj5eoGzw03tyFJzFmZ7rUtyrlyDI=;
	b=dhzmY/93WfN89lDNWiUwLy7EazaSq4Xxwc/iYBAwfNgq59jF5LcLSWanKGf51UVuvJcx
	 6+BCtr75wzamR0bNuAPpZpEmQEeMth+u+ehvD0rrg3cuDcOOWf9aKpee/AGR3rCb2md5m
	 xgGMVYra8qmxKoVNdUY87ZCgm79uQsy4g9tTIsrzrBl+pNGGLRSAbG0+r5iGoQawUj3W9
	 9Tpyukfc2gO9+9DiT7UiHLQWrcDCFlcUM+4XpGWEXN3XOhsR/tksKcFw9K4gAjzMy5KYT
	 i3dO8kJDSdPqo/frRI4tKMHYTggH5y62SkjlUjB1k/Q9haeUa93s/3S5sl0bIQy423A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ff4Z7Zlo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7CD6070A88;
	Wed,  4 Nov 2026 21:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ff4Z7Zlo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E7C1F000C1;
	Wed,  4 Nov 2026 21:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829229;
	bh=MWUWPsRTRdkN2YpXj5eoGzw03tyFJzFmZ7rUtyrlyDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ff4Z7Zloz+dPPAG8TZfOP9Hlm4Wuwv7YSCSq48Yf6Uz2Xfr5ByuuanGztgNp9+JNc
	 YUNVhq/Zc1ZRqwR5U7k9/0QtbuP0eQ6ebObgq2TWeXT6rJxIjrEge2vin+TxbNl+xR
	 biRlocawxn5IuB8RNoMtGTwzaYTAWywhnyHaLMcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 530/547] io_uring/sqpoll: dont wait for the thread to exit
Date: Wed,  4 Nov 2026 16:11:54 -0500
Message-ID: <20261104211053.449255205@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

Commit 360395e8dbf9d23579f74b84a1af11190813b0f8 upstream.

io_sq_thread_stop() wakes the SQPOLL thread and waits for it to exit.
The thread belongs to the thread group that created the ring, so a
SIGSTOP or the cgroup freezer holds it in get_signal(), and the wake up
doesn't change that. io_ring_exit_work() then sleeps in that wait until
someone continues or kills the process. iou_exit has 64 slots, so 64
closed SQPOLL rings of a stopped process keep every other ring from
being freed, for everyone.

Don't wait. Set the stop bit, wake the thread, and let it exit when it
gets to run again. The sqd can now outlive its last ring, so give it a
second refcount with one reference for the rings and one for the thread,
and free it with the last one. The thread can't reach a freed ring,
rings leave ctx_list before dropping their reference, and the io-wq hash
is refcounted.

Fixes: 16efa4fce3b7 ("io_uring: allow IO worker threads to be frozen")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |   28 +++++++++++++++++++++++-----
 io_uring/sqpoll.h |    3 ++-
 2 files changed, 25 insertions(+), 6 deletions(-)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -63,6 +63,24 @@ void io_sq_thread_park(struct io_sq_data
 	}
 }
 
+/*
+ * The sqd has two holders: its rings, as one, and its thread. Neither waits
+ * for the other to let go. The one that lets go last frees the sqd.
+ */
+static void io_sq_data_release(struct io_sq_data *sqd)
+{
+	if (refcount_dec_and_test(&sqd->free_refs))
+		kfree(sqd);
+}
+
+/*
+ * Ask the thread to exit, and don't wait for it. A thread that is stopped or
+ * frozen exits only when a user lets it run again, and the exit work of the
+ * ring would keep its place in the workqueue until then. All rings have left
+ * ctx_list by now and have no request left, so the thread can reach none of
+ * them. What it still uses is its own or counted: the sqd by free_refs, the
+ * hash of its io-wq by hash->refs.
+ */
 void io_sq_thread_stop(struct io_sq_data *sqd)
 {
 	struct task_struct *tsk;
@@ -77,7 +95,6 @@ void io_sq_thread_stop(struct io_sq_data
 		wake_up_process(tsk);
 	}
 	mutex_unlock(&sqd->lock);
-	wait_for_completion(&sqd->exited);
 }
 
 void io_put_sq_data(struct io_sq_data *sqd)
@@ -86,7 +103,7 @@ void io_put_sq_data(struct io_sq_data *s
 		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
 
 		io_sq_thread_stop(sqd);
-		kfree(sqd);
+		io_sq_data_release(sqd);
 	}
 }
 
@@ -160,10 +177,10 @@ static struct io_sq_data *io_get_sq_data
 
 	atomic_set(&sqd->park_pending, 0);
 	refcount_set(&sqd->refs, 1);
+	refcount_set(&sqd->free_refs, 2);
 	INIT_LIST_HEAD(&sqd->ctx_list);
 	mutex_init(&sqd->lock);
 	init_waitqueue_head(&sqd->wait);
-	init_completion(&sqd->exited);
 	return sqd;
 }
 
@@ -424,7 +441,7 @@ static int io_sq_thread(void *data)
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 err_out:
-	complete(&sqd->exited);
+	io_sq_data_release(sqd);
 	do_exit(0);
 }
 
@@ -544,7 +561,8 @@ __cold int io_sq_offload_create(struct i
 	}
 	return 0;
 err_sqpoll:
-	complete(&ctx->sq_data->exited);
+	/* no thread was made: let go of its share */
+	io_sq_data_release(ctx->sq_data);
 err:
 	io_sq_thread_finish(ctx);
 	return ret;
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -2,6 +2,8 @@
 
 struct io_sq_data {
 	refcount_t		refs;
+	/* one for all the rings, one for the thread: the last put frees */
+	refcount_t		free_refs;
 	atomic_t		park_pending;
 	struct mutex		lock;
 
@@ -18,7 +20,6 @@ struct io_sq_data {
 
 	u64			work_time;
 	unsigned long		state;
-	struct completion	exited;
 };
 
 int io_sq_offload_create(struct io_ring_ctx *ctx, struct io_uring_params *p);


