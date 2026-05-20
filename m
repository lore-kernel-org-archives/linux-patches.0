Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD38E3F20FA;
	Wed, 20 May 2026 17:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299049; cv=none; b=FjQkXshR2FJlTo4rlyc53O5MeRv7i1PIbuZKat65MhY1BVV8z8xyRoFeP2AivjgjFqvpsQ6UfQ+4ZvQMMly8PbMiZmd5OnznZ9AU687STiDBpGBL2x7FKKhvZHYaqRTkcIR15KMKSJ9qxeOipNoBCoaZnMqrczbKsV5tv3mIfHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299049; c=relaxed/simple;
	bh=Nc/m82iZGAD+u0kKzPTyuO0REDI3BFMXzid6ufxLang=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNmC9gpQbnM7/e3saAow35Zd14Bps9Xe9+TQJ1JbdlCoVIQywmxNm7iEvnkqiC5eEvhtjXG9Z2y33JD8UKV/ZQe4nVLPyVyNCZpsw8Cgu3QQw2iXgL0+PFSH8jktGCQ1y8/jEasBvvPscHBLsmboG1sRSLTWPVvxcKl9jXJtxK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hKCjbI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hKCjbI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E18B1F00893;
	Wed, 20 May 2026 17:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299048;
	bh=pc/OIFDBrEetn5wZOLZZTcmZSGw9BIDdXzulv73FKwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hKCjbI2/z3iWq04WkkzBCzk4jXfi/tDAXTkNbjKLWKNHUOGtbSZ/JFIlHaC4i0co
	 f/q8dQ2JBYUE14AJ6e7TRVVuFm8AwjInLW1yDE7Mf0vrsKslMFiVK0lV7nXPsHOxi1
	 p7M661xU3YMcr09MArQVSKXBtEkbROrVx4O/3EGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 643/957] tcp: annotate data-races around tp->timeout_rehash
Date: Wed, 20 May 2026 18:18:46 +0200
Message-ID: <20260520162148.472284608@linuxfoundation.org>
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

[ Upstream commit 71c675358b711bbfd8528949249419dc2dfa4ce1 ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: 32efcc06d2a1 ("tcp: export count for rehash attempts")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-13-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c       | 3 ++-
 net/ipv4/tcp_timer.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a799329281532..888fe31e42f0b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4444,7 +4444,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u32(stats, TCP_NLA_DSACK_DUPS, READ_ONCE(tp->dsack_dups));
 	nla_put_u32(stats, TCP_NLA_REORD_SEEN, READ_ONCE(tp->reord_seen));
 	nla_put_u32(stats, TCP_NLA_SRTT, READ_ONCE(tp->srtt_us) >> 3);
-	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
+	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH,
+		    READ_ONCE(tp->timeout_rehash));
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
 		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
 	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->skb_mstamp_ns,
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 2dd73a4e8e517..b2e5848b6980a 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -296,7 +296,7 @@ static int tcp_write_timeout(struct sock *sk)
 	}
 
 	if (sk_rethink_txhash(sk)) {
-		tp->timeout_rehash++;
+		WRITE_ONCE(tp->timeout_rehash, tp->timeout_rehash + 1);
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPTIMEOUTREHASH);
 	}
 
-- 
2.53.0



