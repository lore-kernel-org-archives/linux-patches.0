Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD48E60DE3;
	Tue, 23 Jan 2024 00:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970960; cv=none; b=ceQS5js71VuI6ABAsU49a/zmLb3gdMujEgIj6Onu6/fwp031Yh42ceU66rYYbVvNs+8GnT2CWfAtmhCLfHoUfL7uob/V3V79hj227c5Zua7lg4e+NgcOpgx1tQkBrGpi+/KL1iMjHCozMouCC7KJpIxlhjM5y1Jmm7p10WUlszM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970960; c=relaxed/simple;
	bh=BJvDOAzy8/BWztnV6Axb40uBFEUW+MwP550UfFhGtPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ft+6OWtZdIQe2rIkQUIdcEbiFNbVDV2QMt8i6aBcWnPVQCYhY2zPO/tmBnS9F8O4JLDGi0eXfZ6iCnVD+J2dMWNbzt4xwvyH05HfotKEn6iG19E/5wf4om8+6J5d8q2+8mXgwEKQ2QkNr1zWKWpUIfDORWvZchlcqIJ4zZRFD9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZPLnofK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZPLnofK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D75FC433C7;
	Tue, 23 Jan 2024 00:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970960;
	bh=BJvDOAzy8/BWztnV6Axb40uBFEUW+MwP550UfFhGtPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZPLnofK1JHD4q8j03QpscoOgxAbin4dsWPw5UpS/c08WfVMSu+5p4MWc5Y1KCkMT
	 GZlKeuCv85PAx4Q+ki6mD8RPjpSi9Z8yB9myyfFIJ4Eyi4SMm+ElfVok85YSCkH4xd
	 HS2vLUNsa/20/XEBdNEIiBNjnTzVc9jTJQ3187Fs=
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
Subject: [PATCH 6.1 150/417] sctp: fix busy polling
Date: Mon, 22 Jan 2024 15:55:18 -0800
Message-ID: <20240122235757.025379683@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index da56832179f0..237a6b04adf6 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2101,6 +2101,10 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (sk_can_busy_loop(sk) &&
+	    skb_queue_empty_lockless(&sk->sk_receive_queue))
+		sk_busy_loop(sk, flags & MSG_DONTWAIT);
+
 	lock_sock(sk);
 
 	if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED) &&
@@ -9041,12 +9045,6 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags, int *err)
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



