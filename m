Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210289;
	b=ZJCoNu78j7LoVHnnhaOfV/Kb+LzmddBVooXhqcHVzcb/MbBTeSfDx2d5OHJ8s1t1WDSn
	 KzzLDNCO3tL5cAfBh6btoHzRIoq8wjVMHIzRNBQE/ZJcgbfPnLyDVCUUGz5e8LypwEoWx
	 CHSKprXwJhIBdH2/4PcIxvqvI7iLOfu6OelYuW6yZYXYMDntdiUTjVpUbcmuzgH0ZJQW5
	 eyNfi+rcXJxySorCOubtafLPcyNzlJ+Oy8dWdXLXIxRKQtVrWSVvNoqmZspbzZKXCOysI
	 2Oh8L69kIGHLJJXsi6FgXOXGnYNcuyoxzCcJFsxtqlV86Fd6L1/jZcKOO7vqlBhu8WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2S/Q37fSTrJi7bozRrADgzq6lym8UASMwF3K5puYVHs=;
	b=MMIk5VPvMcCb5Y4sgN9dpYx1+gxZWZAFXBukwazMbNBN+pBOjs7AGd6vuHpdWMdyzHde
	 VQUYb0NJDZ1327ZqNAeDQd00Yi1rVEH7neAhTifPNPo7lJn0AquMLaUo9xq0yJQ8hEOA+
	 528ctnfk0QzndSFyo8nlfQW5BpV+cEbzwIYNF+x6Hv9eSgliwc982yF3vxJCjuzMXtV0V
	 F69Uh7O9e/GX5DKmdwpz461hgCr+GnIZ2ivuSZ6/DwtQ9mH65MdvuHqXtP/SbMeZ1W9//
	 bOZMnhhaQvFSbqAVTIBBY06s0zMlZVY0Sd2vSnbb7+dZSbAT08bKBtXU1PjfO1vUF3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwiyTyCp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97667606A31A;
	Wed, 28 Oct 2026 17:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwiyTyCp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A0D1F01825;
	Wed, 28 Oct 2026 17:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210289;
	bh=2S/Q37fSTrJi7bozRrADgzq6lym8UASMwF3K5puYVHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwiyTyCpkUfxMCyYhNbp07VWTu6zFv9P0ufGjnX2iIJE3hk4Ij3jNAWjMho2GDw/R
	 Fb9zhO+C+vXPMXMG7xJNuhorLA1qHiAaZg9X7eXIIcy64DoCVUnxRKeDFcNeNoQOw6
	 VDIGfBa9QpbDMWz96oz/WkZK948cvQFDy5FoVyN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.6 141/168] io_uring/poll: drop stale double poll entry on rearm
Date: Wed, 28 Oct 2026 18:01:17 +0100
Message-ID: <20261028165946.421914530@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit f2dbe87968a3aef74a11c025776d293b80964d3f upstream.

A file that uses two wait queues for poll, e.g. a tty, gets a second
io_poll entry, which IORING_OP_POLL_ADD keeps in ->async_data until the
request is freed. io_poll_add() can run more than once for a request
though: IORING_OP_POLL_REMOVE with one of the update flags disarms and
rearms it, and io_poll_task_func() reissues it if a wake up turns out to
be spurious. The second poll_wait() of the new round then finds
*poll_ptr set, with ->head cleared by the disarm, and __io_queue_proc()
fails what it takes for a third wait queue with -EINVAL.

For an update that means that the poll request is completed with
-ECANCELED, while the update itself reports success. For a spurious wake
up, e.g. tcsetattr() on the polled tty, the poll request fails with
-EINVAL.

Free the old entry and clear the poll flags before arming, which is what
io_arm_apoll() does for internal polling. All entries have been removed
from their wait queues at that point.

[ 6.6: no io_req_async_data_free(), open-coded ]
Fixes: b69de288e913 ("io_uring: allow events and user_data update of running poll requests")
Fixes: 6e5aedb9324a ("io_uring/poll: attempt request issue after racy poll wakeup")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-21-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -983,6 +983,18 @@ int io_poll_add(struct io_kiocb *req, un
 	if (req->ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_SINGLE_ISSUER))
 		req->flags |= REQ_F_HASH_LOCKED;
 
+	/*
+	 * A poll update or a spurious wake up arms the request again. Forget
+	 * the entries of the previous round like io_arm_apoll() does, a stale
+	 * second entry would be taken for a third wait queue.
+	 */
+	if (req_has_async_data(req)) {
+		kfree(req->async_data);
+		req->async_data = NULL;
+		req->flags &= ~REQ_F_ASYNC_DATA;
+	}
+	req->flags &= ~(REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL);
+
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events, issue_flags);
 	if (ret > 0) {
 		io_req_set_res(req, ipt.result_mask, 0);


