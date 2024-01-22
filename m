Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CC164CCD;
	Tue, 23 Jan 2024 01:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975053; cv=none; b=Jd1w6tjiyCwCH4NTa3HgJQ6XXsVu6rLA815q5VftrTscV2C7l9PNpEbauaZxOyQ2W9jD+UISvWpTuMf8Sgonvaq/sKduLsKYdbU5CfdJHKI47XhxN9l4MdRCdMOH1FhdZOS084tR0CdEnKel+YM1IVHKkrFLDJqH0t4ygGMbO6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975053; c=relaxed/simple;
	bh=W0RuJ5gLyaI9g3ASYIRVk08wbEx5nCs7Asr5E+s5Ly4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKKHiO0PUHF40twIWM0OqlGP025HST3CIIK+lU71msBVNImU/nVQgSz97PJELXYeK7c8mxa5WBT8PUSAEf0eo8CDtW9KB2DDAtkeswIQ40aPivJB2pkh58OY17+N/DSAUgbdHG2F0hsB1qMdF+wSIXsgvnRWp7tN6MSXgDt5hNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vr5ZPqno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vr5ZPqno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9C9C433C7;
	Tue, 23 Jan 2024 01:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975052;
	bh=W0RuJ5gLyaI9g3ASYIRVk08wbEx5nCs7Asr5E+s5Ly4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vr5ZPqno9cBc4gT9iSYO6JjE28K6XC1l0R7GDbzp9kqv451FMGCZVbhzDTIEEXf6W
	 4ujxfdZ4Lr8JsqvQPonbCeHX+x4vRdCR7R3cRbiIaZXxWJ+2F37HJWdbIX0JmjWatI
	 FI3h8lW9BqEkgbagfQLYsluSNQ/xA4EIOBx1HNCM=
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
Subject: [PATCH 6.6 214/583] sctp: fix busy polling
Date: Mon, 22 Jan 2024 15:54:25 -0800
Message-ID: <20240122235818.557158913@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



