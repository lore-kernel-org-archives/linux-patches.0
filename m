Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E59A34E779;
	Wed, 20 May 2026 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296410; cv=none; b=uLG0QJJrynnAsXpL+KCc1/PlBXiyQT65pN0+0YgxPjp9Nd6IUwWdB6rVftotRoH1Z6lc4hMnyfyrgNeCNlqRK/ks0oSZ3VuxD4s3CDIphDVoW6ftee6FTGMHDqrKtoojIWSlz89Eb5ythLkwRL2Ni0XgDUawo/KNflT9Ih5fnFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296410; c=relaxed/simple;
	bh=3rVhBCemI8iAOH3acHn2gv1fL+upfuvLnd6ee0m/wYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Apj3M3VMRGj1SqAMw2QMXuglrhHs8dV04s+CCpLgkLck260nF3Q0NgeJl5qdrqoPhyAwx/ZvxYJRO5ZWOQ4VzEbEDILFRXdz2t7ajzPjM0RcOL/zTxJeOjWyF+BjsP8v/nIyDeyg72WXRMt88YZMb8GbR2j96LdbqwpJWW8eIX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrRfDVUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrRfDVUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E991F000E9;
	Wed, 20 May 2026 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296408;
	bh=Cr8RJDKLCyHOkGd1pos/UMEECrKh0gTubdyNEYD/I/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrRfDVUmWfC2PkH0YQ1gawGaGDBStMczLEXNTjp6nRmCtWtVqHpeU8TU9jLWuiRyy
	 OsMWmY2pyLsPXgsIzbzaveFuUOEcudAOFDOgjafj0rp0uA51qtMyr0DhY+rALv8TxT
	 S5o4WqQ0w3hzCyGGDIBMKGI/LGnZQieuIr2vLawY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0789/1146] tcp: annotate data-races around tp->reord_seen
Date: Wed, 20 May 2026 18:17:19 +0200
Message-ID: <20260520162206.079963604@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 62585690e6b2a112c408fe25f142b246ac833c42 ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: 7ec65372ca53 ("tcp: add stat of data packet reordering events")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-11-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c       | 2 +-
 net/ipv4/tcp_input.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a5231c685f90b..80274554eaa12 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4500,7 +4500,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u64_64bit(stats, TCP_NLA_BYTES_RETRANS,
 			  READ_ONCE(tp->bytes_retrans), TCP_NLA_PAD);
 	nla_put_u32(stats, TCP_NLA_DSACK_DUPS, READ_ONCE(tp->dsack_dups));
-	nla_put_u32(stats, TCP_NLA_REORD_SEEN, tp->reord_seen);
+	nla_put_u32(stats, TCP_NLA_REORD_SEEN, READ_ONCE(tp->reord_seen));
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 285baeb060a06..eee460d19e254 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1300,7 +1300,7 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
 	}
 
 	/* This exciting event is worth to be remembered. 8) */
-	tp->reord_seen++;
+	WRITE_ONCE(tp->reord_seen, tp->reord_seen + 1);
 	NET_INC_STATS(sock_net(sk),
 		      ts ? LINUX_MIB_TCPTSREORDER : LINUX_MIB_TCPSACKREORDER);
 }
@@ -2444,7 +2444,7 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 	WRITE_ONCE(tp->reordering,
 		   min_t(u32, tp->packets_out + addend,
 			 READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering)));
-	tp->reord_seen++;
+	WRITE_ONCE(tp->reord_seen, tp->reord_seen + 1);
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRENOREORDER);
 }
 
-- 
2.53.0



