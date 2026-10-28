Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210278;
	b=36HmRu1bGIe5cGhiHVK/Nqunw2mW6c2u4/uvHodMOh9VHunmCV3uiM53WNtMsTQtJ8wd
	 3Z+1FCoHqV6rqhQKkiyv80QL3PchgEXgpt2v4U3Q4Wie424xAJ42a2jh6mL3mCKCogjsG
	 RKQfNxr71YlF5ZcoOEeARbCdtN5znnQmeWeLQWu9UYfeHGaEVUjaZW7M2ZOD9/SlB1ygo
	 MQhPjrzUa5wskbo9/TtKfPNV3YX1qQZHZW7edi9nSBJMUxHg4UW5OJNDvT2p+3/acWvOi
	 18RTSMYUDlEyKap9RhHiuqgPg5Gu1RaM325RifVU1OpRnbYvyBIcmSL/7r33+HXvnpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gaITtSIgz7ardkTgeG3hNJdrOK+qZwHP4RHyPFPpiGo=;
	b=PCmhoRfi/escG99hX1+QwQbQFrEq3Rv6NrnFMFCXAYURo/ou33fIYUxyq5fNXaMXOD7x
	 b+j11W3C6r+B86WRyA1436m4mJPKN3lzGKp0htFpE0CBySGLRkoY+TivxKOja8Uh0L5kL
	 lQ9BRdq8EwBYL0mQgit60Zte2e2ZhhpbiTzGn7XdhCZvVoJiWB6Kstiakze4w2Lqi5flJ
	 W+TxDG/IGM72RqDGAl79Pd8bd7QOUIxy681BsVpKHXOV33K3XKQ7KQpeJmG5K0ZOMCOaX
	 AUmEkuuUzGZ2a01SMCvCcs8N3+0E2wR6k7SO86ZOTrVzB2zfQILAQkqX01TbZboMTpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XypPLvDt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81928606A31C;
	Wed, 28 Oct 2026 17:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XypPLvDt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCAC1F01825;
	Wed, 28 Oct 2026 17:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210278;
	bh=gaITtSIgz7ardkTgeG3hNJdrOK+qZwHP4RHyPFPpiGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XypPLvDtADvwVwy/JWEBLeN7B3HM6Hop+2VWCvIyYoTa1jwbAR8bEXUmfdjvFP0tI
	 3v6voZGOpqrml0xxqGW8WRlZz+Rdw7u8DlcJhHC8Ox5FjOhB7tCYVtkst9t2pbwNbQ
	 crjAy3c3K1RNTMwE0HG+I/J3XNCesXb7PRqfDyhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.6 137/168] io_uring/cancel: dont default to setting req->work.cancel_seq
Date: Wed, 28 Oct 2026 18:01:13 +0100
Message-ID: <20261028165946.326040387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 521223d7c229f83915619f888c99e952f24dc39f upstream.

Just leave it unset by default, avoiding dipping into the last
cacheline (which is otherwise untouched) for the fast path of using
poll to drive networked traffic. Add a flag that tells us if the
sequence is valid or not, and then we can defer actually assigning
the flag and sequence until someone runs cancelations.

[ 6.6: prerequisite for "io_uring/cancel: let CANCEL_ALL find parked requests". There is no free request flag bit here, so use the cancel_seq_set field that commit f4a1254f2a07 ("io_uring: fix cancellation overwriting req->flags") introduces upstream, which this also covers ]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    3 ++-
 io_uring/cancel.c              |    3 +--
 io_uring/cancel.h              |   10 ++++++++++
 io_uring/io_uring.c            |    2 +-
 io_uring/poll.c                |    6 +-----
 5 files changed, 15 insertions(+), 9 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -576,7 +576,7 @@ struct io_kiocb {
 		__poll_t apoll_events;
 	};
 	atomic_t			refs;
-	atomic_t			poll_refs;
+	bool				cancel_seq_set;
 	struct io_task_work		io_task_work;
 	unsigned			nr_tw;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
@@ -586,6 +586,7 @@ struct io_kiocb {
 	/* opcode allocated if it needs to store data for async defer */
 	void				*async_data;
 	/* linked requests, IFF REQ_F_HARDLINK or REQ_F_LINK are set */
+	atomic_t			poll_refs;
 	struct io_kiocb			*link;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -56,9 +56,8 @@ bool io_cancel_req_match(struct io_kiocb
 		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
 check_seq:
-		if (cd->seq == req->work.cancel_seq)
+		if (io_cancel_match_sequence(req, cd->seq))
 			return false;
-		req->work.cancel_seq = cd->seq;
 	}
 
 	return true;
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -22,3 +22,13 @@ void init_hash_table(struct io_hash_tabl
 
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
 bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
+
+static inline bool io_cancel_match_sequence(struct io_kiocb *req, int sequence)
+{
+	if (req->cancel_seq_set && sequence == req->work.cancel_seq)
+		return true;
+
+	req->cancel_seq_set = true;
+	req->work.cancel_seq = sequence;
+	return false;
+}
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -434,7 +434,6 @@ static void io_prep_async_work(struct io
 
 	req->work.list.next = NULL;
 	req->work.flags = 0;
-	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
@@ -2164,6 +2163,7 @@ static int io_init_req(struct io_ring_ct
 	req->file = NULL;
 	req->rsrc_node = NULL;
 	req->task = current;
+	req->cancel_seq_set = false;
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -585,10 +585,7 @@ static int __io_arm_poll_handler(struct
 				 struct io_poll_table *ipt, __poll_t mask,
 				 unsigned issue_flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	INIT_HLIST_NODE(&req->hash_node);
-	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	io_init_poll_iocb(poll, mask);
 	poll->file = req->file;
 	req->apoll_events = poll->events;
@@ -826,9 +823,8 @@ static struct io_kiocb *io_poll_find(str
 		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
 			continue;
 		if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
-			if (cd->seq == req->work.cancel_seq)
+			if (io_cancel_match_sequence(req, cd->seq))
 				continue;
-			req->work.cancel_seq = cd->seq;
 		}
 		*out_bucket = hb;
 		return req;


