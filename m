Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D9FB641;
	Tue, 16 Jul 2024 15:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144441; cv=none; b=annsN/KhmHOXnpRi400s1V8bRLfSVVc7tv+/fIizh12oJW/kPIaxRsAb56IURuRdzYLS3WdeU9z7DL0V7f4I62YrTIUPB7seHpf05Wp1y9zd1NOsvEPtJxwAJxd2BdsuuSEWq5g5FvoQDN//yWemYq8VIEfDkusEY2pVQkky4Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144441; c=relaxed/simple;
	bh=9tXbk/NT760stJ68JuYgmfH8KRcdc6HTw/NaG0Y8Z3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAitNettseXFUW4FUvB6QScW67OHXOpwzbULus1xZYY7JprEq7tOyLpTl99XTzRyoOPadsQ7ryaVVY5lxzOH2nhQJZe2nawih/LHgLU1VF4oALaU5mqytRy4byY1ztYDd/+nDhRWrQrh3G5HI7PEkYU0ajvlbauxuQOnG3FjV7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/yGHjfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/yGHjfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D59C116B1;
	Tue, 16 Jul 2024 15:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144441;
	bh=9tXbk/NT760stJ68JuYgmfH8KRcdc6HTw/NaG0Y8Z3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/yGHjfdYsw1EQMBkqHcHafzI/ZGhbQu89eqkuGVvb0M6JnzTb9lopqNzgMxm6ZpF
	 CCTghipOAb4+4qjqYPkcGGQSbTNlG6emBmIdsCId/EDBVf+1WBmbtjAuuVelHffa/m
	 sdCW4R+nMg1DD9D+wzireIxwrxl8WBtmI0vyXtzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 73/78] tcp: refactor tcp_retransmit_timer()
Date: Tue, 16 Jul 2024 17:31:45 +0200
Message-ID: <20240716152743.462711905@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -452,6 +452,7 @@ void tcp_retransmit_timer(struct sock *s
 	struct net *net = sock_net(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct request_sock *req;
+	struct sk_buff *skb;
 
 	req = rcu_dereference_protected(tp->fastopen_rsk,
 					lockdep_sock_is_held(sk));
@@ -464,7 +465,12 @@ void tcp_retransmit_timer(struct sock *s
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
@@ -496,7 +502,7 @@ void tcp_retransmit_timer(struct sock *s
 			goto out;
 		}
 		tcp_enter_loss(sk);
-		tcp_retransmit_skb(sk, tcp_rtx_queue_head(sk), 1);
+		tcp_retransmit_skb(sk, skb, 1);
 		__sk_dst_reset(sk);
 		goto out_reset_timer;
 	}


