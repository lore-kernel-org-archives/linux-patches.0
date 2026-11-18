Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037380;
	b=sVjS5E3yt2PM76r3JcOAzq4Xq4+5qDyhLOt7h0eroNJdM7sqsayAmsIDtuKzlQg+8H1e
	 8I1HnWexbURXBiQhKWWB2krPeA1eyR314rgM6rVSBuE2J0y+8myt03CzHSp59MJbUwVd4
	 cGlsRias41mWT2fmZpk+QzipXOC65V/b0ofSDcyhNN03B6yMDL3aM5qLcXLwwbREinVVt
	 MEwacD0JMwb6rwh0RtBC6EmdpaeddO0WFwIpFGqTzx9JVzuNivQp0sVCiBnfgLhXvfI5l
	 /UzX5pRzpH5XjQyDsWmITB9MwwF2d0AT6ovs3IQjA+L0pdq8sWwZGxaPNGXNLF0XAWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lF4YCirc1DMaristKZvLmC7OFM06KO76ReEIatPf0yw=;
	b=DDo93P/29UWbLaliKk34kmk6T/pE/FPZQFjTfb3R1agGmr3jJZvC/TNNEIIwDToEGJXG
	 GvDHxvl02UqAPz0hQ2LfWUCmpBrHOqJTN0oBGR6dU0MU1GOQvB0Fu6yQjkowEja1equJW
	 qiS2Z3IU5f+2RcnzZxiVp7trThafy87B9O/G3EfHzXmcyAn7f6iLNOHDhHmpwdYtVdpD8
	 PE5hPujGm2UwxCyYF5GYhcga4RCgrfC4ZjlpVvNi7LME+H4bs1VOKoQEz5wIuKDEu2A5i
	 S0Bq7G11He2H6Ejh0bk22V1nGj6BQhMEuqJazCi4aW3r/WLTnkuWLVwObIh203/AK5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aNDhLV1z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F053F606A32A;
	Wed, 18 Nov 2026 21:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aNDhLV1z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3834D1F000C4;
	Wed, 18 Nov 2026 21:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037379;
	bh=lF4YCirc1DMaristKZvLmC7OFM06KO76ReEIatPf0yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNDhLV1zyGMw7xuCG7X06qxUfwo/tEHAfhqoNg3c2zw/uZphKSE/x2Dyd09IPfwhs
	 nHjIdr7Gen0JaW6jrCOTfy/6nMigMl8y5+0I5asqTS5FismsML2n5CHYiioxeTdf3s
	 MWPPW0oDVUg8qkGqmFF6ZPDk7FdfDYWPFBDISgpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1341/3318] io_uring/poll: dont poll a writer for a read side hangup
Date: Wed, 18 Nov 2026 15:32:43 +0100
Message-ID: <20261118150400.597608228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 08d65792f3cbe..de7da2bd283a8 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -167,12 +167,24 @@ static void io_poll_tw_hash_eject(struct io_kiocb *req, struct io_tw_state *ts)
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
@@ -1099,7 +1111,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 			poll->events &= ~0xffff;
 			poll->events |= poll_update->events & 0xffff;
-			poll->events |= IO_POLL_UNMASK;
+			poll->events |= io_poll_unmask(poll->events);
 		}
 		if (poll_update->update_user_data)
 			preq->cqe.user_data = poll_update->new_user_data;
-- 
2.53.0



