Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590902;
	b=NKoO/98K4ZtHPRtC+BI9cloJ8PbEBfhOYDz4TNvyhB7CZOKaUbcE3lPlZYQYAa+yKLkb
	 xK6mqEwZgBlwwrWKEiJLQABz8u2mjmmQfuzkGTFZk3ZZLAvNZbiStssVFMCKnnqkxgbCa
	 fb+4DlOfMb2DjTmm7Z1YhIHJDkT/5P9w3Cbbw2sT77nufUrtD6kU7R+u87RAu/AigVBVL
	 pzIFEUBPbfZW5p3Oinfz/+W2A17uLVsykZGdHVudw1+BbEUeymB6d0ZeAi0MwoSAY/34l
	 j8CjTpSTJhL/rblmBGplD8iGZI7owRnlgBvoqe4tOHwGFKKf+qHDZIxKlc5i05/alLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qhoK4W/T2lFJClnYblRm16Jig4kv56KL4gy/L+fI74k=;
	b=uXvfKCJuFQRlGLrRHkG6QfNRVlbANwz0HrI5PX4Wd+H1jeEAVCX2ZCc4PqjEE/X+IXwk
	 dMJjTBjpIxO0ndRQIit2ACWNJmtqCZWn+ZvT5/LysfMHDn0WOziaDUiwmGgULTgRtL1yJ
	 sZaWU2Kkh8+kfzMXMsabhVI+bBAH47kCA0he7V8017hZ7wSkH7ZlNZeims9cO1fR+bMwx
	 iHSbbXRVWBR/TO7c0yjWBsSlZbqLOT28Uf/JFsoGvey3mIes8QB+vSyarFV4CdtG6DNNb
	 bE45Zbh/nHl0tdOitT2IqAL+y2hKq+B9Z66z38U5uwUXwt3U8d800eiISRbpm2Tl0Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ujbe1I9O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AA6606E237;
	Fri, 13 Nov 2026 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ujbe1I9O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1511F000C4;
	Fri, 13 Nov 2026 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590902;
	bh=qhoK4W/T2lFJClnYblRm16Jig4kv56KL4gy/L+fI74k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ujbe1I9ODSPiMhF3YYFAySfOmXFMNRI0K+HqLM0meAfglBMTecCID5Zf8K935UR0P
	 Fj1/dMWTIfvxGbh0Du7l/t4AjjuGMuYF+ncD1YgyYgkHHlzSnt+Qqgwsma80+wkwFc
	 PQWPo+Z9JU87p42Tpxo14kRauHgc8a5LoQ3U0bME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/670] io_uring/poll: dont poll a writer for a read side hangup
Date: Fri, 13 Nov 2026 10:43:40 -0500
Message-ID: <20261113153813.400871029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 74c1f1048e4401d6a953ab2299b14ace1ad6a899 upstream.

io_init_poll_iocb() adds EPOLLRDHUP to every poll, including the async
poll of a send that waits for buffer space. Once the peer has shut down
its sending side, the socket keeps reporting EPOLLRDHUP, so each re-arm
in __io_arm_poll_handler() finds a ready mask and the request is issued
again. The send still can't make progress, the request burns through
APOLL_MAX_RETRY in a few milliseconds and ends up in io-wq.

A send in io-wq blocks until the peer reads, but sendmsg and writev go
through ____sys_sendmsg() and sock_write_iter(), which turn O_NONBLOCK
into MSG_DONTWAIT, and the application gets -EAGAIN for a request that
never asked for a non-blocking send.

Only add EPOLLRDHUP for polls that want to read. A peer that stopped
sending is no event for a writer, and a poll that asks for it explicitly
still gets it.

Fixes: 464dca612bc6 ("io_uring: mask in error/nval/hangup consistently for poll")
Reported-by: Lukáš Lalinský <lukas@lalinsky.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 39418fe05d59c..7884ea7b23c5a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -169,12 +169,24 @@ static void io_poll_tw_hash_eject(struct io_kiocb *req, struct io_tw_state *ts)
 	}
 }
 
+#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL)
+
+static __poll_t io_poll_unmask(__poll_t events)
+{
+	/*
+	 * A peer that stopped sending is an event for a reader, but a write
+	 * only poll must stay armed until the file is writable again.
+	 */
+	if (events & (EPOLLIN | EPOLLRDNORM | EPOLLRDBAND))
+		return IO_POLL_UNMASK | EPOLLRDHUP;
+	return IO_POLL_UNMASK;
+}
+
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events)
 {
 	poll->head = NULL;
-#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
 	/* mask in events that we always want/need */
-	poll->events = events | IO_POLL_UNMASK;
+	poll->events = events | io_poll_unmask(events);
 	INIT_LIST_HEAD(&poll->wait.entry);
 	init_waitqueue_func_entry(&poll->wait, io_poll_wake);
 }
@@ -1112,7 +1124,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 			poll->events &= ~0xffff;
 			poll->events |= poll_update->events & 0xffff;
-			poll->events |= IO_POLL_UNMASK;
+			poll->events |= io_poll_unmask(poll->events);
 		}
 		if (poll_update->update_user_data)
 			preq->cqe.user_data = poll_update->new_user_data;
-- 
2.53.0



