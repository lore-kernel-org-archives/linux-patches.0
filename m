Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5308F36405A;
	Wed, 20 May 2026 17:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299055; cv=none; b=krz9gyzVuvyXpFEpPJr5PMYpGAUVcynZR+sCgOcNqDumaP7mqgyf0lv0mN+7+FWZHHaKb8JvzP/DbWTDrY9Io4kFB9N7LlrJUrQQIVfSbtUBA6Pm5YJtqi5VzgRDqrueQAjo6ktum6JUnUi053EvqRIhoIYxt1gb9QGp3NFBoN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299055; c=relaxed/simple;
	bh=JZ2UvwZE1yK1w5bQTc2P6nqzvD7ysZh2OxQXowdWXzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt8ZfxRgy2ItVZaxHISDJfxtgiFyG+fNnb1Kny3DIvOovWWUog7PJ+coC39Mzxco4z3Z7JMM349TK0uZWoMihPSLtb6qZH6f8zfgu3/L6Ld7LAzdS2t8Fvy7901GX3QEBafHQf/knuoRHaczSN+Km9MahtxfNdCiHPJkzpuO8Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDro5tmk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDro5tmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD9C1F000E9;
	Wed, 20 May 2026 17:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299054;
	bh=xy2OZ2c8Wfg6pKLBB5SJnF+CvCHxcO+5Kfkx/95lcKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDro5tmkvWMD62b968UikkF2YFSg6XiTLIwjrpCpXKm4U6wDb1jPuRzGDFMSvTE9V
	 qwwHwkbPBqSbmOLLkVlhMXuOMNjO9pTPNM131o7LIXylR45NCXoCi2AcoCIHum0F18
	 WVwkIBsBmM3IbWmOJANvJBttv9CewQUfxfxhojTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 645/957] tcp: annotate data-races around tp->plb_rehash
Date: Wed, 20 May 2026 18:18:48 +0200
Message-ID: <20260520162148.516101585@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9e89b9d03a2d2e30dcca166d5af52f9a8eceab25 ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: 29c1c44646ae ("tcp: add u32 counter in tcp_sock and an SNMP counter for PLB")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-15-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c     | 3 ++-
 net/ipv4/tcp_plb.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index fe91675ae5678..2de4748269ca9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4455,7 +4455,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 		nla_put_u8(stats, TCP_NLA_TTL,
 			   tcp_skb_ttl_or_hop_limit(ack_skb));
 
-	nla_put_u32(stats, TCP_NLA_REHASH, tp->plb_rehash + tp->timeout_rehash);
+	nla_put_u32(stats, TCP_NLA_REHASH,
+		    READ_ONCE(tp->plb_rehash) + READ_ONCE(tp->timeout_rehash));
 	return stats;
 }
 
diff --git a/net/ipv4/tcp_plb.c b/net/ipv4/tcp_plb.c
index 4bcf7eff95e39..b7f9b60d8991f 100644
--- a/net/ipv4/tcp_plb.c
+++ b/net/ipv4/tcp_plb.c
@@ -79,7 +79,7 @@ void tcp_plb_check_rehash(struct sock *sk, struct tcp_plb_state *plb)
 
 	sk_rethink_txhash(sk);
 	plb->consec_cong_rounds = 0;
-	tcp_sk(sk)->plb_rehash++;
+	WRITE_ONCE(tcp_sk(sk)->plb_rehash, tcp_sk(sk)->plb_rehash + 1);
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPPLBREHASH);
 }
 EXPORT_SYMBOL_GPL(tcp_plb_check_rehash);
-- 
2.53.0



