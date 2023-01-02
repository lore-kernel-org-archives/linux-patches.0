Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52A928EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7B6C433EF;
	Mon,  2 Jan 2023 11:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658932;
	bh=GIolATIKk840jQEdXy1XAO1iPCjtDBumvx+yGs4YaP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdiE2uUd1vBfmNaMEmmKgmR47ANR7xK7vg3ixcBiS22qTjeRRAIGJ9VA1S9JhABRm
	 vYJQE0ecjVUhAXFBRg578L3eHREuMH8xjVgftzof1BI0PUcv/1o5REKMqIHzwrjWGS
	 JPIbEiPcm0tJfunN/jTp99JGmusSn+4NsttzraHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 54/74] eventfd: provide a eventfd_signal_mask() helper
Date: Mon,  2 Jan 2023 12:22:27 +0100
Message-Id: <20230102110554.407060232@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 03e02acda8e267a8183e1e0ed289ff1ef9cd7ed8 upstream.

This is identical to eventfd_signal(), but it allows the caller to pass
in a mask to be used for the poll wakeup key. The use case is avoiding
repeated multishot triggers if we have a dependency between eventfd and
io_uring.

If we setup an eventfd context and register that as the io_uring eventfd,
and at the same time queue a multishot poll request for the eventfd
context, then any CQE posted will repeatedly trigger the multishot request
until it terminates when the CQ ring overflows.

In preparation for io_uring detecting this circular dependency, add the
mentioned helper so that io_uring can pass in EPOLL_URING as part of the
poll wakeup key.

Cc: stable@vger.kernel.org # 6.0
[axboe: fold in !CONFIG_EVENTFD fix from Zhang Qilong]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventfd.c            | 37 +++++++++++++++++++++----------------
 include/linux/eventfd.h |  7 +++++++
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index c0ffee99ad23..249ca6c0b784 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -43,21 +43,7 @@ struct eventfd_ctx {
 	int id;
 };
 
-/**
- * eventfd_signal - Adds @n to the eventfd counter.
- * @ctx: [in] Pointer to the eventfd context.
- * @n: [in] Value of the counter to be added to the eventfd internal counter.
- *          The value cannot be negative.
- *
- * This function is supposed to be called by the kernel in paths that do not
- * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
- * value, and we signal this as overflow condition by returning a EPOLLERR
- * to poll(2).
- *
- * Returns the amount by which the counter was incremented.  This will be less
- * than @n if the counter has overflowed.
- */
-__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask)
 {
 	unsigned long flags;
 
@@ -78,12 +64,31 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
-		wake_up_locked_poll(&ctx->wqh, EPOLLIN);
+		wake_up_locked_poll(&ctx->wqh, EPOLLIN | mask);
 	current->in_eventfd = 0;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
 }
+
+/**
+ * eventfd_signal - Adds @n to the eventfd counter.
+ * @ctx: [in] Pointer to the eventfd context.
+ * @n: [in] Value of the counter to be added to the eventfd internal counter.
+ *          The value cannot be negative.
+ *
+ * This function is supposed to be called by the kernel in paths that do not
+ * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
+ * value, and we signal this as overflow condition by returning a EPOLLERR
+ * to poll(2).
+ *
+ * Returns the amount by which the counter was incremented.  This will be less
+ * than @n if the counter has overflowed.
+ */
+__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
+{
+	return eventfd_signal_mask(ctx, n, 0);
+}
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
 static void eventfd_free_ctx(struct eventfd_ctx *ctx)
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 30eb30d6909b..786824f58d3d 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -40,6 +40,7 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, unsigned mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
 void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
@@ -66,6 +67,12 @@ static inline int eventfd_signal(struct eventfd_ctx *ctx, int n)
 	return -ENOSYS;
 }
 
+static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
+				      unsigned mask)
+{
+	return -ENOSYS;
+}
+
 static inline void eventfd_ctx_put(struct eventfd_ctx *ctx)
 {
 
-- 
2.39.0



