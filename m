Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623953;
	b=P2a2hYiW4z1c2hGadHUefVJcn5dR6Il4NFG44r8biLjuh+J1CALSSzmK++VRmjh9F01Y
	 3OpML1OcSe5U2+8ejgx1wQiqOHniQ6l/BXB48o9ebMfzgXPn8m1Ab44zP1rKAajgOX/n0
	 4KGSYaW/Qywy6Tdu6g49CpyHOAFeX3tHhaR/vvbKBEV3/SMPuGJvGXZRKEVwcEsOKXINc
	 KSw60LxoBnsAqvevMIVe7VbM1Ae6u3vx7DrHP8j3vCM8v71vDnCZD5KDDTfUITzUWWqYC
	 k1s1DtbBe1nlKjxW+pC3GK0Jw/0D0aHxpqNxC7eIBrLZX/4eR1D4Wx6meqmPOa2nyEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VBJXXDlJ2mVhbri4v5QwvlUHugI21uqlnX0nrxTMa7w=;
	b=ByNYT5cu3M0IcEfdWKD8tKvmB0VsSN788jNYz5zahaFjAjitPYgfAaT9pY4P/4g7MgPx
	 K+d6yB8uKF8Pk9C8PkZNnGkSQ+OXZuLSLPt3qhkPtwpE3H1tFI1W398g3+jtoUTsILaDZ
	 Ji37rxQI93+PplieT3tjSv//WMRkq2HgQf1qPxBV3tYOTUMCdg4pdqEUvHfQRyIRDsT8r
	 ofkSxM+jB51mGXNawOzH5Nb5l52jUUpnFnpVoXnzLmyhKdKxgfYrCpI2Qd6BUEoLaPNuF
	 pDIRcCaWmJCieNzXhWKFwsLX1esbmxiPuUU/efBjq4Dt1IKvwy/2Jm4Ny+YFVrJooxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u2DQGQgd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B7C606A321;
	Wed, 25 Nov 2026 16:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u2DQGQgd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182721F000C6;
	Wed, 25 Nov 2026 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623952;
	bh=VBJXXDlJ2mVhbri4v5QwvlUHugI21uqlnX0nrxTMa7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u2DQGQgd5xgpVeGow/iV2Hk2kH24U08HFwmQ2IQTQwd0IqJpwqAlkIkYTveTCv2Qp
	 Tf4c+y7gzYUfp95ilvik92FQA8AqEho2wWmEaUIzWXz2Cj/rhKZWRXFM1wBEqysBtF
	 FiI3vTVEgBWnNFWX9I/7RuxpCcVANZmoOYY7TsL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/816] io_uring: enable toggle of iowait usage when waiting on CQEs
Date: Wed, 25 Nov 2026 15:26:19 +0100
Message-ID: <20261125143849.938732486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 07754bfd9aee59063f8549f6e4d455eae636ecc7 upstream.

By default, io_uring marks a waiting task as being in iowait, if it's
sleeping waiting on events and there are pending requests. This isn't
necessarily always useful, and may be confusing on non-storage setups
where iowait isn't expected. It can also cause extra power usage, by
preventing the CPU from entering lower sleep states.

This adds a new enter flag, IORING_ENTER_NO_IOWAIT. If set, then
io_uring will not account the sleeping task as being in iowait. If the
kernel supports this feature, then it will be marked by having the
IORING_FEAT_NO_IOWAIT feature flag set.

As the kernel currently does not support separating the iowait
accounting and CPU frequency boosting, the IORING_ENTER_NO_IOWAIT
controls both of these at the same time. In the future, if those do end
up being split, then it'd be possible to control them separately.
However, it seems more likely that the kernel will decouple iowait and
CPU frequency boosting anyway.

[ 6.12: only the NO_IOWAIT flag bits are added, the EXT_ARG_REG and
  RW_ATTR bits before them don't exist here. io_get_ext_arg() has no
  ctx argument. ]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/io_uring.c           | 31 +++++++++++++++++++------------
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index fdd7b931ea1d4..e777e6b128e85 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -518,6 +518,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_EXT_ARG		(1U << 3)
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
 #define IORING_ENTER_ABS_TIMER		(1U << 5)
+#define IORING_ENTER_NO_IOWAIT		(1U << 7)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -554,6 +555,7 @@ struct io_uring_params {
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
 #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
 #define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
+#define IORING_FEAT_NO_IOWAIT		(1U << 17)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 09551e3907f91..630b306a849f0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2532,8 +2532,17 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
 	return READ_ONCE(iowq->hit_timeout) ? -ETIME : 0;
 }
 
+struct ext_arg {
+	size_t argsz;
+	struct __kernel_timespec __user *ts;
+	const sigset_t __user *sig;
+	ktime_t min_time;
+	bool iowait;
+};
+
 static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 				     struct io_wait_queue *iowq,
+				     struct ext_arg *ext_arg,
 				     ktime_t start_time)
 {
 	int ret = 0;
@@ -2543,7 +2552,7 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 * can take into account that the task is waiting for IO - turns out
 	 * to be important for low QD IO.
 	 */
-	if (current_pending_io())
+	if (ext_arg->iowait && current_pending_io())
 		current->in_iowait = 1;
 	if (iowq->timeout != KTIME_MAX || iowq->min_timeout)
 		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
@@ -2556,6 +2565,7 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 /* If this returns > 0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
+					  struct ext_arg *ext_arg,
 					  ktime_t start_time)
 {
 	if (unlikely(READ_ONCE(ctx->check_cq)))
@@ -2569,16 +2579,9 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
 
-	return __io_cqring_wait_schedule(ctx, iowq, start_time);
+	return __io_cqring_wait_schedule(ctx, iowq, ext_arg, start_time);
 }
 
-struct ext_arg {
-	size_t argsz;
-	struct __kernel_timespec __user *ts;
-	const sigset_t __user *sig;
-	ktime_t min_time;
-};
-
 /*
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
@@ -2660,7 +2663,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 							TASK_INTERRUPTIBLE);
 		}
 
-		ret = io_cqring_wait_schedule(ctx, &iowq, start_time);
+		ret = io_cqring_wait_schedule(ctx, &iowq, ext_arg, start_time);
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 
@@ -3363,6 +3366,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 {
 	struct io_uring_getevents_arg arg;
 
+	ext_arg->iowait = !(flags & IORING_ENTER_NO_IOWAIT);
+
 	/*
 	 * If EXT_ARG isn't set, then we have no timespec and the argp pointer
 	 * is just a pointer to the sigset_t.
@@ -3399,7 +3404,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
 			       IORING_ENTER_REGISTERED_RING |
-			       IORING_ENTER_ABS_TIMER)))
+			       IORING_ENTER_ABS_TIMER |
+			       IORING_ENTER_NO_IOWAIT)))
 		return -EINVAL;
 
 	/*
@@ -3786,7 +3792,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
 			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT;
+			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT |
+			IORING_FEAT_NO_IOWAIT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
-- 
2.53.0



