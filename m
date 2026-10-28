Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209745;
	b=FXVTeTZaVescF7WgSO7lGzU1nJeVcoRshhW8LXgvLgTM7XgAeZl+H4Jb+3IK/yOWM1z+
	 CMA8fT1sBzXCv9axpV7soQQxn4qmDS67t344Caqm51PGJLRPDBcKf2QDdUQkwHJ3QH6en
	 L2LvpkLhCgorOlEFG/pC6E1saJ6HWBBJXl9khc0zixdNTmNHDZrlIKcBplOgxhjQ5oggQ
	 1DBhcmH9jZlPS+0wtjg+VA34/OZaADZq7v5Eo5aUgKgsRq4VGNhdL0iqc2LDFloCJk9N2
	 ebPxzu/lCtxvNbexIW/KWFl9CWJKJcAGvD4PbETVY1Um+xwfTZUgAuJ7ZXw+JPr36ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3B1P+67fjE68L+PYEpOpa9En7oAr2o0VH5KzDHWCi/c=;
	b=H3sjySUbyAyesPGZKPSppjS07oaABMThS5qNO57pPftmOYzpNHctqx8BtD+EvQvMRBXe
	 hzgESJXofTqWUzswhCR65sOAQJSYc/cnFGXv+D6MWTVXD197iZAMIZuUCVt3Zv+uYxJ0Z
	 32o8T9vrDs7FAUbFyTgc/YFlhhNVSxB3iyDTv1euA3oO5XCoZR+tti4UqRQBTDcgdSpwd
	 pO660OaHqj69/WjkvkkYCDR1erQ7JG/OamkEik5tgNGNRRu/AshkbI0te2kGas0sm/9n6
	 Y664wHT/4ZgplWXjse+H84CZlpd5Xqah4Kwf8w7Sy6QA/6wIKF5EkRTRpuJjf9Ao9ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1L9Un6y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44423606A31D;
	Wed, 28 Oct 2026 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1L9Un6y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955881F01825;
	Wed, 28 Oct 2026 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209745;
	bh=3B1P+67fjE68L+PYEpOpa9En7oAr2o0VH5KzDHWCi/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1L9Un6yTBo17livnkJJ0GKy7MlkorkQ1iTqGsBUGPADC75qNp38BqFwVEt3c8v8J
	 CZkKdCzFj+GZgFfLNwNRFsuZRDaz0TVbiJtJdVVYRGcLU+DREXw9eEEeElVUyAO4s+
	 TEnK4TKW8hfJc0TBOqlya26Ddls97XiXd6HJZnok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.18 062/109] io_uring/futex: allocate private hash before waiting
Date: Wed, 28 Oct 2026 18:00:46 +0100
Message-ID: <20261028165943.818080706@linuxfoundation.org>
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

[ 6.18: the futex vector is a local, not ifd->futexv, so free that on error ]

Fixes: 80367ad01d93 ("futex: Add basic infrastructure for local task local hash")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-22-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/futex.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -149,6 +149,24 @@ int io_futex_prep(struct io_kiocb *req,
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
@@ -158,9 +176,8 @@ int io_futex_wait_prep(struct io_kiocb *
 	if (unlikely(ret))
 		return ret;
 
-	/* inflight tracking only needed for mm private hash */
 	if (!(iof->futex_flags & FLAGS_SHARED))
-		io_req_track_inflight(req);
+		return io_futex_prep_private(req);
 	return 0;
 }
 
@@ -207,10 +224,13 @@ int io_futexv_prep(struct io_kiocb *req,
 		return ret;
 	}
 
-	/* inflight tracking only needed for mm private hash */
 	for (i = 0; i < iof->futex_nr; i++) {
 		if (!(futexv[i].w.flags & FLAGS_SHARED)) {
-			io_req_track_inflight(req);
+			ret = io_futex_prep_private(req);
+			if (ret) {
+				kfree(futexv);
+				return ret;
+			}
 			break;
 		}
 	}


