Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8FCCA40;
	Tue, 16 Jul 2024 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144195; cv=none; b=TPHJQrVgr8PMC26HQgqzCz/x65RWcW4yxBs3POJaDxJICbPq2BTuxe7naf2ZeNrp9Sd4fWohhh7XbCOlV13QF9w/oU+6yu490aslM8K88898IhEdtXjKzykataPQ5ZLUi1uPMqb9OdbtgeH03XjXUpOnUpw/IB8NutJQqLjfVk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144195; c=relaxed/simple;
	bh=SrDPNaoU0aQYiWy5UJbwj19a5kNUGoPeSiKEyguVSE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqPxeCiQysrzC3PF/J1DUysqFuzy9uGYKBBvKbUZjacc5MhsVAVW8y0hguu16NMVYZknKQgoaS3/Ny5NIq2MAfW5RkT9GnlmCtXBWP90DMCzxYitIFBAx4p1wyyBTT3fxbN/LguMo9RUe6B7M3MzzOsUQrx2/TzLmGzqQXbar8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBguoPeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBguoPeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034E5C116B1;
	Tue, 16 Jul 2024 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144195;
	bh=SrDPNaoU0aQYiWy5UJbwj19a5kNUGoPeSiKEyguVSE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBguoPeOOPRhXpdu4/ZeEGlJJl8wvaR8YMhW1klTVz2s/g0w1eJ3MjLgpvQ72c4J4
	 48aW1SKmJSsUdTtt8aaa5/ZPF8XK+cJwOeLrEyOZuhEf0XHB1IghIpdw9qxuqcIvW3
	 ozZ6cjHD7itGdpEpTQB3rTadqYcbFUn/G2nqgQUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 60/66] tcp: refactor tcp_retransmit_timer()
Date: Tue, 16 Jul 2024 17:31:35 +0200
Message-ID: <20240716152740.450356174@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 0d580fbd2db084a5c96ee9c00492236a279d5e0f upstream.

It appears linux-4.14 stable needs a backport of commit
88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")

Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()

I will provide to stable teams the squashed patches.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -428,6 +428,7 @@ void tcp_retransmit_timer(struct sock *s
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct sk_buff *skb;
 
 	if (tp->fastopen_rsk) {
 		WARN_ON_ONCE(sk->sk_state != TCP_SYN_RECV &&
@@ -438,7 +439,12 @@ void tcp_retransmit_timer(struct sock *s
 		 */
 		return;
 	}
-	if (!tp->packets_out || WARN_ON_ONCE(tcp_rtx_queue_empty(sk)))
+
+	if (!tp->packets_out)
+		return;
+
+	skb = tcp_rtx_queue_head(sk);
+	if (WARN_ON_ONCE(!skb))
 		return;
 
 	if (!tp->snd_wnd && !sock_flag(sk, SOCK_DEAD) &&
@@ -470,7 +476,7 @@ void tcp_retransmit_timer(struct sock *s
 			goto out;
 		}
 		tcp_enter_loss(sk);
-		tcp_retransmit_skb(sk, tcp_rtx_queue_head(sk), 1);
+		tcp_retransmit_skb(sk, skb, 1);
 		__sk_dst_reset(sk);
 		goto out_reset_timer;
 	}


