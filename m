Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207241;
	b=Qx+Io3vvz3ubKW8oJyc1vEqy/RAyNGovK2q/QbO0roHfXyX/s06q+4ONBoyroIr6mOuW
	 ypybmdHvsAaP3Av4DJkLiAzubcdr3Jt5R/PHWBvb4C9ysEesg43X/uuh+zmkeuTlphG0N
	 xuBKzCZgGXXOhErKeKeSECs+4za+GcJLzb+HhoF3KMkaedray+Sz4ElY4NZuMgyVg39SX
	 A5DTK+kcg9+7RcMz2/EPZxDQmbnDSZJ2Et1mkpdKOxCsUNicm/ISMB6lHrgVS9NSLrHz1
	 Ai2T7EqkWOv23hjPf8zv0tnXo2hRxWOU8qofpLBI4tVv27zUW3mmSJ3GGwfZba4u+gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uNNWvevqyCYXXDbkalsZCiALDQQLyLr+xUXFIXU5A7M=;
	b=CYjEF+GL0yhzN0W/gcPMu8JPbvrl5HFqlplqYi+vvOM02T0fxeoSfAqHdCYGYs9mocFk
	 QQwpqe0TD5ZyVoBSZfYXywS8MXx2AL6A7dSXrKnOsRrm7xkBdTy4rYz2ivhGKayIcXduV
	 9pLjFCpCXrROSSBsjDKrkNY5oPbUhxwROEKttCs6KjGpjoEQnsp33cOH61hkRQzhiLhff
	 QYDWaB8WbfkuZqgsxklp2ME+30Lsxq0e1uPz5ErslKIPDkFgaLoqLij55yJbSokPd36/0
	 wRRFxApVsDOb9L/D92Zu+wChOKBLDsYV4mptoA/R7kc5ZEEVQ4St0U5jTJNmzWfdGvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ke+CaJcm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001BC606A31C;
	Wed, 28 Oct 2026 17:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ke+CaJcm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523541F01825;
	Wed, 28 Oct 2026 17:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207240;
	bh=uNNWvevqyCYXXDbkalsZCiALDQQLyLr+xUXFIXU5A7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ke+CaJcmEI+Abk+mHtJU8xnuDQYSdF4iQ7O4A42ALD7aeBKMUetw1F6+hwuAlej5m
	 kB0Yy5AlCH0dLBPYNdkNeQP/J5TpTQSnYgZnd761sGELf+NgHuk6hP7wrjaFWo08R7
	 GhGsS7zSYInnFUIYJ/B9mJpm8RJrMIcTH/+PCC5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 37/88] io_uring/poll: drop stale double poll entry on rearm
Date: Wed, 28 Oct 2026 17:59:45 +0100
Message-ID: <20261028165942.985782015@linuxfoundation.org>
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

Fixes: b69de288e913 ("io_uring: allow events and user_data update of running poll requests")
Fixes: 6e5aedb9324a ("io_uring/poll: attempt request issue after racy poll wakeup")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-21-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -918,6 +918,15 @@ int io_poll_add(struct io_kiocb *req, un
 
 	ipt.pt._qproc = io_poll_queue_proc;
 
+	/*
+	 * A poll update or a spurious wake up arms the request again. Forget
+	 * the entries of the previous round like io_arm_apoll() does, a stale
+	 * second entry would be taken for a third wait queue.
+	 */
+	if (req_has_async_data(req))
+		io_req_async_data_free(req);
+	req->flags &= ~(REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL);
+
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events, issue_flags);
 	if (ret > 0) {
 		io_req_set_res(req, ipt.result_mask, 0);


