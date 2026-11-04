Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826838;
	b=WonU+RJRR/9krKEkGK75//X0VfhAKbuqEPF/C9R8MKXAOFmCoOzBrW5tgBgoAbhry4fq
	 zZSZynk11rjv+9XYM1mk1+TzgQy4mBO3myEyncDhPfHffbP+bPvrYBwq7CwtSqYV8KYNK
	 RxZgmjySN2yCMUqUfCfNWFmt8SMFhr9LCVNIGYgElEsP6xLLfC7nIal5DEYbB83j928Xv
	 /yGofqKJEcjO/j5+e3y6I1psE1/1TuNW46BwRdysCxZwxEKTQM9K/LuJ+yuDb3hxGelHs
	 czi5f10DAVIv3KCuiRdoGBWUoyHsyftYXvzg5l+EJfrEroXe+dTO53bLBdwVOx+MgQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1QniJBNAxeXpKgGG1F/qU350s8TEbj9xp5vmFu18J5w=;
	b=nkyhNKkXvF9c9u7WEjzitb5vGXWpV+pRFjIs+cdAiIs9wnsxWeOuUVTZRviTB1+UOUHM
	 3PxoAhsK+bWyUzE05fHIralV77j+ib5BqTvsdV36s0I0AnM08AOmQ2JueCUHT2Y2J1MjM
	 PudsKrCq6TtYTSOC0hB7G2O3LbkzbuAHdmEzaiAbAnvB1VATPgGpI9APCLU4Gj9C/QzDL
	 zQl7oqrq1ojhXutgvW3/z3wvJqiKBqrgQ/zLQdf7ZoHS0KFvKilefhHYn0H0UEKwd4vhc
	 zt+hqo+3uP14JPjV9+0Kq0Ud3CpAnFhgT4uHtbLgQSJi39KOARxrpR5aqG4OY+gt59Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dAxvWXBq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F46660B140E;
	Wed,  4 Nov 2026 21:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dAxvWXBq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804AE1F00A15;
	Wed,  4 Nov 2026 21:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826837;
	bh=1QniJBNAxeXpKgGG1F/qU350s8TEbj9xp5vmFu18J5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dAxvWXBq10AlAkBgGB9VD0WznlUVqimeSSRaV+IVu6rOpN9Dd1s3jckMI0fao8PUy
	 resHyL02gH71qvO1htVuwv2tRr4J7g8DbYpu+f7nzR3qORnuegnx91czjo4cVkPIsf
	 xIM+7P3wpDJNL7KZwJ5g+cjlJuGGMqxvWFU4UJsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 037/547] io_uring/poll: drop stale double poll entry on rearm
Date: Wed,  4 Nov 2026 16:03:41 -0500
Message-ID: <20261104211039.390206256@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f2dbe87968a3aef74a11c025776d293b80964d3f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 3e443b187eae0..4f04bda42f7ff 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -927,6 +927,15 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
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
-- 
2.53.0



