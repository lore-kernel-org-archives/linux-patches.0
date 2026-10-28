Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212050;
	b=ZiSqgdk8KJrumsmarXlbxQC2/85at0+pFeYrKF1Y0J8+gUfODFVx/fm7gUwP7iJxBPgp
	 x83mmUHeMoWtlUgOkfBwhm9lyc9ZexRWX8OZiZLXpyq3nx+xqlq9q1SXg24q6U21aDMxV
	 pIFZGVnNcQjpGVcOtEVpThnCURYBFInns4KJCRMBtdkGY3H4uF4EKlSEid/+fVFLgBwml
	 +7qc5NsfrLOPB4Sv59l72TMlG5o0Rs7Z6wZoePQyfdUi+7Q2SU1/OV1bQvDblSnDdPuiP
	 DmcZ91Paf2IVkdDFc6pVZ+Gm3cHbaDt243BYpWtnEiGyI2ambpbrh+js13DYGiHZ05A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KS3P9qDms3qOsLgh+89LTAL+AMIHO+Kxf8o3m4z1jR4=;
	b=gapbZNBY4ks7e0SUm1O2xoqgy6POSHcBL84sTkTswvFSr3ynunpBM1qncfkmsTmh3Dua
	 /mSYQsnXTpLGAY64ipsVdbwFHvRwUc4yoDNKKsEM82ZL2z7Nm6alYNIzcnESIGdZGJ7Av
	 jFBQiw85sinTf3C306NPb4b1quw/+MfPDDvkOWK3cPfjkTVRZZvGyvZEWVci8lNk41kG1
	 rnSe/VHZ1X4x77jARPgNAgpW8awri1HKzd3+zLLcXAQMzHb+3lWFpJEoZQJ+BWyKM25y5
	 uEsn5/u7F5RyVNhrnheEvNK5wzZi2VFHknW+8yAQNW8xZrcEOK1YB7h0x7ccpZExxJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lm5be7uw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B552B606A31C;
	Wed, 28 Oct 2026 18:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lm5be7uw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AE61F01825;
	Wed, 28 Oct 2026 18:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212049;
	bh=KS3P9qDms3qOsLgh+89LTAL+AMIHO+Kxf8o3m4z1jR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lm5be7uwIQZJp/tLhTGTNv9hk64ftEoN8CcDVipzdZg0Vk6n9FIxPQiEWmMcxFJA+
	 S1Bv4u9bXrjhcmpmKc1JJIO5ltFyRLhuJnQcdDHXlbGZsqXKQcypny1G2hkQuselTW
	 6NphvR/aVxt6TVgGiXyoRTbvMDKDpeBRyioKbPSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0009/1887] io_uring/cancel: dont forget that the work was running
Date: Wed, 28 Oct 2026 17:35:05 +0100
Message-ID: <20261028170459.433813533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 8aa0e5db4845fb5ac11abe40d7b1cac0656c3ee3 upstream.

If the request to be cancelled is being run by io-wq,
io_async_cancel_one() flags the work, signals the worker and returns
-EALREADY. Since commit ccbf726171b7 ("io_uring: perform poll removal even
if async work removal is successful") io_try_cancel() goes on regardless,
as poll may be armed for the request. If it isn't, and nothing else turns
up, the result is the -ENOENT of the last search.

__io_async_cancel() makes up for that. On -ENOENT it tries the io-wq of
every task that uses the ring, and that of the caller is one of them. So
the work is found a second time, and the result is -EALREADY after all.

Unless the worker is done with it by then. If the work is flagged before
io_wq_submit_work() looks at IO_WQ_WORK_CANCEL, all the worker does is to
queue the request to be failed by task work. Then it isn't anywhere to be
found until the task work has run, and

 - IORING_REGISTER_SYNC_CANCEL returns -ENOENT,
 - IORING_OP_ASYNC_CANCEL completes with -ENOENT,

for a request that they have just cancelled, and that completes with
-ECANCELED.

With a read of an empty pipe, IOSQE_ASYNC, and a sync cancel right behind
it, 1 to 3 of 1,000,000 calls return -ENOENT, and 50 to 110 with
IORING_SETUP_DEFER_TASKRUN (4 CPUs, KVM). Nothing is written to the pipe,
and all of these reads end with -ECANCELED.

Remember that the work was found. IORING_OP_ASYNC_CANCEL completes with
-EALREADY, as it does if the worker is a bit slower. For
IORING_REGISTER_SYNC_CANCEL it means to try again, which ends with 0.

The result of a linked timeout, which calls io_try_cancel() by itself,
and the number that is returned for IORING_ASYNC_CANCEL_ALL and _ANY don't
change.

Fixes: ccbf726171b7 ("io_uring: perform poll removal even if async work removal is successful")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-16-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |   13 ++++++++++++-
 io_uring/cancel.h |    2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -114,6 +114,8 @@ int io_try_cancel(struct io_uring_task *
 	 */
 	if (!ret)
 		return 0;
+	if (ret == -EALREADY)
+		cd->running = true;
 
 	ret = io_poll_cancel(ctx, cd, issue_flags);
 	if (ret != -ENOENT)
@@ -162,6 +164,7 @@ static int __io_async_cancel(struct io_c
 	struct io_tctx_node *node;
 	int ret, nr = 0;
 
+	cd->running = false;
 	do {
 		ret = io_try_cancel(tctx, cd, issue_flags);
 		if (ret == -ENOENT)
@@ -185,7 +188,15 @@ static int __io_async_cancel(struct io_c
 		}
 	}
 	io_ring_submit_unlock(ctx, issue_flags);
-	return all ? nr : ret;
+	if (all)
+		return nr;
+	/*
+	 * The worker may be done with the work that was found running, and
+	 * flagged, above. That isn't the same as not having found it.
+	 */
+	if (ret == -ENOENT && cd->running)
+		ret = -EALREADY;
+	return ret;
 }
 
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -9,6 +9,8 @@ struct io_cancel_data {
 	u8 opcode;
 	u32 flags;
 	int seq;
+	/* io_try_cancel() has found it being run by io-wq, and flagged it */
+	bool running;
 };
 
 int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);


