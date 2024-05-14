Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5335FDD2;
	Tue, 14 May 2024 11:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686860; cv=none; b=XVq81MApKdAljpErbEoMQf4/JYkbIvWPZh4gcFXr3h6Ej6Q+K4+uUS8kZtFhaoe+55klhdLhfa3YULePsUot3NxhOfKCY5sz8LRNfSmBugSK59IZhlbI3aRha5gJ2gMT8W9oQIvfJ5WYTpz1bysD2craTifkq5zo/1w2vCwhpo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686860; c=relaxed/simple;
	bh=0yeBRcHKPOseRslp6ChI00LVjydI8ki0TMWz4LwGuc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVyrFy3ijwFPt8FaCR9tcQi9csHCOPa1XxF2eXlPwAISaTQ+m4ZetdpxszuDSzm4uFgRPkVQwsb1MeOljOeGzUeNKwxtpdFSxzlcvFXxWLlv7DuwyhQcueILxILQKCLqrK8XdTXg4dIG3buns9UWd/HvfdIURYIHsOmQ06YLh8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlPwdG7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlPwdG7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E12CC2BD10;
	Tue, 14 May 2024 11:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686860;
	bh=0yeBRcHKPOseRslp6ChI00LVjydI8ki0TMWz4LwGuc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlPwdG7+PWU+VSvt5YYJAiV87xRHQYY+fZjleWi9FlCE9+kro+HWU7a0RlxNT4y05
	 cPHYXNadhZoWwksGboRlD8jimFXQaUuJJCIuh3YKGyxvewy0PI1yMJTPkID9vJu1Be
	 sFgasX2R0uR+m/R0ik/j7EywXYHh7cU+To5GvGJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.king@canonical.com>,
	Mukesh Ojha <mojha@codeaurora.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/63] tcp: remove redundant check on tskb
Date: Tue, 14 May 2024 12:20:06 +0200
Message-ID: <20240514100949.716386846@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit d1edc085559744fbda7a55e97eeae8bd6135a11b ]

The non-null check on tskb is always false because it is in an else
path of a check on tskb and hence tskb is null in this code block.
This is check is therefore redundant and can be removed as well
as the label coalesc.

if (tsbk) {
        ...
} else {
        ...
        if (unlikely(!skb)) {
                if (tskb)       /* can never be true, redundant code */
                        goto coalesc;
                return;
        }
}

Addresses-Coverity: ("Logically dead code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 94062790aedb ("tcp: defer shutdown(SEND_SHUTDOWN) for TCP_SYN_RECV sockets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 670804d4c1690..8b78cb96a8461 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3132,7 +3132,6 @@ void tcp_send_fin(struct sock *sk)
 		tskb = skb_rb_last(&sk->tcp_rtx_queue);
 
 	if (tskb) {
-coalesce:
 		TCP_SKB_CB(tskb)->tcp_flags |= TCPHDR_FIN;
 		TCP_SKB_CB(tskb)->end_seq++;
 		tp->write_seq++;
@@ -3148,11 +3147,9 @@ void tcp_send_fin(struct sock *sk)
 		}
 	} else {
 		skb = alloc_skb_fclone(MAX_TCP_HEADER, sk->sk_allocation);
-		if (unlikely(!skb)) {
-			if (tskb)
-				goto coalesce;
+		if (unlikely(!skb))
 			return;
-		}
+
 		INIT_LIST_HEAD(&skb->tcp_tsorted_anchor);
 		skb_reserve(skb, MAX_TCP_HEADER);
 		sk_forced_mem_schedule(sk, skb->truesize);
-- 
2.43.0



