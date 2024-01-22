Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A45131741;
	Tue, 23 Jan 2024 00:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969419; cv=none; b=dOsrL5mB4SrhVXlRulbZPp3KQtK5icpKwjE3fckG8hqMYWe8nIP9HQJUG6cn89yXIooNsuQnf8onHyo2KPH2Bc8YUB27Ezvrh6MzLQ3SkoYWRcbDzEC3cNBsIa5GLKvpnTBIC+hCy7TkXav6UpDvjn8Te5WvWSYdIibLVra02E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969419; c=relaxed/simple;
	bh=MrGB/PxYrKLjdWnbZdYS0Um86Ot/uI7Mzzz+7yYyu4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMWc4c5eC9QRIz/OTbr3Ff/mI9905cqFN6O97IxRWgGmQDJZY6kHiMYlLPnz+bno4QweqBjdDWOpl7MEeFMUjmLgXaUSZv8XfDT+Di9LE3psZpp9lrnIYF8v/mPT0VFtZxXdpdh8Mo5kxYbIAt2JLivwwaA5wQISPfdkh4x1+oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tY4AQHQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tY4AQHQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A10EC433B1;
	Tue, 23 Jan 2024 00:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969418;
	bh=MrGB/PxYrKLjdWnbZdYS0Um86Ot/uI7Mzzz+7yYyu4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tY4AQHQTp+Z4JP1mY15gpyzVFcxTSQL5nNxUJCJw7WAEakPE5irpY1y6UX/oExuYS
	 Es/drA4BvD9JOqGOC+EsUWXY1e/4ZUrVjwHc0b0+XCTFGjc92m07xAK3im+Xb1LU2m
	 hTS04369eqTAh6xqopIuB3fI3WpeNzzUTEPPtkik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 233/641] sctp: fix busy polling
Date: Mon, 22 Jan 2024 15:52:17 -0800
Message-ID: <20240122235825.215196554@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a562c0a2d651e040681b0bfce9b4d229ac3b0b8c ]

Busy polling while holding the socket lock makes litle sense,
because incoming packets wont reach our receive queue.

Fixes: 8465a5fcd1ce ("sctp: add support for busy polling to sctp protocol")
Reported-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5fb02bbb4b34..6b9fcdb0952a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2102,6 +2102,10 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (sk_can_busy_loop(sk) &&
+	    skb_queue_empty_lockless(&sk->sk_receive_queue))
+		sk_busy_loop(sk, flags & MSG_DONTWAIT);
+
 	lock_sock(sk);
 
 	if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED) &&
@@ -9046,12 +9050,6 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags, int *err)
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			break;
 
-		if (sk_can_busy_loop(sk)) {
-			sk_busy_loop(sk, flags & MSG_DONTWAIT);
-
-			if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
-				continue;
-		}
 
 		/* User doesn't want to wait.  */
 		error = -EAGAIN;
-- 
2.43.0



