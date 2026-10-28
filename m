Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207247;
	b=gucZCp3rkLmsIi8SBqSONhhA84uZDjMuWVtY/rKMIhA+dVyWSfXvUp3Zicq+aj5q5CpQ
	 BIpxDUD1utPmnaMTGYt2N6Pc3lp98mkh9i2le/5OiAmct3qbC9vsmIfAQxHUHjE6w0ayK
	 W5qozEypZPH4KgKrnmlgLQOGGGI6DrzgJnYoJ1yHAuSaQolHGOuR2HbWdgC5EDx7U6C/j
	 Y1kZXAtjZ05hnuUmtz1Xrms0/WH8Gep42wcAAyfnroO/Y8aHV8wg2Oi5gpKN+j7JHxwNu
	 EQlWFx/N16jN6k9nwjCP8MwMcoAJNd9dq85ySQbR9NoCNEbv2Pf2lizJIzVSMkzChKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dtYtnhO50B5KXTCKyhtIHu1FUCoESCCwsDVK4kZhhkM=;
	b=tXia/NyJkZGDeZ91Qswz1Lz6zyeTn7WQxm0hh9tGNDqTKorG9ZZFEJ8gJnOlX5VBUO8k
	 2WMMIPQQevjT9GroGGzbZ6wUJwfPirVAtfwJkjHP0Zp1xlwu5J2Tumxe8/XhSQUYUJSPm
	 bcYIPpSR2JWbi3pgmV7d7lRTzb93iF2kGnmu6ffY2iLvK71yuZuIuOSmhpGAWUeKOZ+vK
	 BIguIRML2NSIa0UHsuDSJzD3fvw00/GktKh4e7ooQSMSXn5twJTZRaUGXb85dINw3AJwv
	 tgl63/IgCjO6f2zkRQEyLVBs7vRuBj416q11SjRauJSosas17XSAO49/vqot8ofMAAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5Qbdcmy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A612B606A31C;
	Wed, 28 Oct 2026 17:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5Qbdcmy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BF51F01825;
	Wed, 28 Oct 2026 17:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207246;
	bh=dtYtnhO50B5KXTCKyhtIHu1FUCoESCCwsDVK4kZhhkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5QbdcmyaiVToieK/uk6gsqkLMp9S1atmhUQU2IhktDtMFEbG8VR6H9VZJSO/CgcD
	 kOMtXVyyk0kreHDjkO62lgPFSfK+BoW70jzxLptuI3CD+F6XcXNoVrK5zUOnNdfFdD
	 l1x+4ry50WYUYZ06RMYo0TII6zplLAi6lLA5zBI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 38/88] io_uring/futex: allocate private hash before waiting
Date: Wed, 28 Oct 2026 17:59:46 +0100
Message-ID: <20261028165943.009164720@linuxfoundation.org>
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

Commit 3eff68bce25584cded3fb6ec033ff9a1c9913d04 upstream.

The futex code relies on there being no private futex waiters by the time
the first private hash of a mm is installed: __futex_pivot_hash() moves
the waiters from the previous private hash to the new one, but it does not
look for them in the global hash which is used as long as there is no
private hash. That is why every clone(CLONE_VM) allocates it up front: a
task which is alone in its mm cannot block in futex_wait() and create a
thread or invoke prctl(PR_FUTEX_HASH) at the same time.

IORING_OP_FUTEX_WAIT and IORING_OP_FUTEX_WAITV do not block the submitter
though:

  io_uring_enter()
    io_futex_wait()
      futex_wait_setup()	// no private hash: queued in the global hash
  pthread_create()
    futex_hash_allocate_default()
      __futex_pivot_hash()	// first private hash, nothing is moved
				futex(FUTEX_WAKE_PRIVATE)
				  futex_hash()	// private hash: no waiter

The wakeup is lost and the request only completes when it is cancelled.
prctl(PR_FUTEX_HASH, PR_FUTEX_HASH_SET_SLOTS, n) instead of
pthread_create() has the same effect.

Allocate the default private hash when a wait request on a private futex
is prepared, which happens in the context of the submitter. This is a RCU
protected pointer check once the hash exists. A failure to allocate it
fails the request with -ENOMEM.

Fixes: 80367ad01d93 ("futex: Add basic infrastructure for local task local hash")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-22-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/futex.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -152,6 +152,24 @@ int io_futex_prep(struct io_kiocb *req,
 	return 0;
 }
 
+/*
+ * A wait on a private futex does not block the submitter. Even a single
+ * threaded task can go on and have the mm private hash installed by clone()
+ * or prctl(), which does not pick up waiters from the global hash. Make
+ * sure the private hash exists before the first waiter is queued.
+ */
+static int io_futex_prep_private(struct io_kiocb *req)
+{
+	int ret = futex_hash_allocate_default();
+
+	if (unlikely(ret))
+		return ret;
+
+	/* inflight tracking only needed for mm private hash */
+	io_req_track_inflight(req);
+	return 0;
+}
+
 int io_futex_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
@@ -161,9 +179,8 @@ int io_futex_wait_prep(struct io_kiocb *
 	if (unlikely(ret))
 		return ret;
 
-	/* inflight tracking only needed for mm private hash */
 	if (!(iof->futex_flags & FLAGS_SHARED))
-		io_req_track_inflight(req);
+		return io_futex_prep_private(req);
 	return 0;
 }
 
@@ -213,10 +230,13 @@ int io_futexv_prep(struct io_kiocb *req,
 		return ret;
 	}
 
-	/* inflight tracking only needed for mm private hash */
 	for (i = 0; i < iof->futex_nr; i++) {
 		if (!(ifd->futexv[i].w.flags & FLAGS_SHARED)) {
-			io_req_track_inflight(req);
+			ret = io_futex_prep_private(req);
+			if (ret) {
+				kfree(ifd);
+				return ret;
+			}
 			break;
 		}
 	}


