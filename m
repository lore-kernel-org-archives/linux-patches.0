Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585345;
	b=TMEefeINO/X4UrkUlZq5sp9MzTA819Zx0EBp5Mk5Wyt2c3dA2LRhWJxvnsXE4hNBQV0n
	 5lFVJ6lM4O4utsMX1qaU2frgC+qP+s15tsCOrb7xo8X3C2z36bJ2VdPNu/tTtYAYJzBim
	 KexHnZMWbpir342PSpi9XVwjKhVzB8+gsg48Lqu4lWx5OugN5pGbsKFWfOW3F/uGK+p40
	 sDloxvFwmKRdMkJW9Gm4WMfAMIivt9hdqyGTefl+7gY1tUiTqOYHKrafHNHdclP6FI+yE
	 zzKGM8InaRTBTt82Gr2nsiIdcsdmbj8fq3MUaWI7jkZQ60k0kcX7+Fc9XiCXqCwQOpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0PNTPohQ6IXJ1n0xkqcDRberDcJD4Q7JZFr/EgVD2lY=;
	b=UhYYY8MqtJJBTT0ntJpUx0eZRszP93C6ef+Nf3AYEOPlLG14Zh4SH1/i+Yl1rtsZ9BEh
	 hIlrRamKnnrbST9hs8XVmH5G5ZItP8ApvUf2XJH8GiRQzGhTu0TWUc90TcvMOMRCImoAm
	 GTpoRkqqGNsVDr3CxNRp52GecpUs0R8anHRt/kdiZRToSEsQXEghEY02rJbDjTgfZHdiu
	 HtJ7eOimOFHc1CeQHgxyYa+aIKwMiss23CQQQZ1QsQ3tdm/mQIbiYSWwrwBCTNdY7954v
	 BiHWADPPD9KHYzkMbrOZSlZ2ApgT52ysvOF03CrxN9DkWaGaiYKEwRTdIQLtDF+7oHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="djgpaA/S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5890B60A380A;
	Fri, 13 Nov 2026 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djgpaA/S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42A61F000C5;
	Fri, 13 Nov 2026 15:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585344;
	bh=0PNTPohQ6IXJ1n0xkqcDRberDcJD4Q7JZFr/EgVD2lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djgpaA/SjcoSShJHwSVuf5pL+mw5VNNPO1PhibAUa76JiTRPBobOiG832Zt3tpW2v
	 0n/3I5w0oeVu9xvT3dWbCJjIWrE2VYqJIVI/Mz9sNvaxY8tlR/Y/1Oy/Za8QGwsaSa
	 Gtg0b2+u5V4c7acMzCDaGTbG+KLp1DQxX9Oii9GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 028/507] io_uring/poll: dont poll a writer for a read side hangup
Date: Fri, 13 Nov 2026 10:45:32 -0500
Message-ID: <20261113153754.330021315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9b73b0d88a0ee..9703a2fdfb44a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -128,12 +128,24 @@ static void io_poll_req_insert(struct io_kiocb *req)
 	hlist_add_head(&req->hash_node, &table->hbs[index].list);
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
@@ -1006,7 +1018,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 			poll->events &= ~0xffff;
 			poll->events |= poll_update->events & 0xffff;
-			poll->events |= IO_POLL_UNMASK;
+			poll->events |= io_poll_unmask(poll->events);
 		}
 		if (poll_update->update_user_data)
 			preq->cqe.user_data = poll_update->new_user_data;
-- 
2.53.0



