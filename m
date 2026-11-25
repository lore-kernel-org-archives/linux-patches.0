Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621922;
	b=uYI2o1SvOFbe2YmWy+JZYgREmgNVqwJ6rJJ55CR+Q2BxW88D+T3g5olwnz1qzJJpuxvz
	 I7iTaE0NR6w3bA1/SlKa0csStOrXdeR4Tw20AVlHRFKMdZ/crOJSP0xKvYvU2LXPJ971L
	 HjItSm2kBMia7VrMik+ZaioCqgILlkhmxop2k2YcQgeT4o34sGRazTjQVpAEki3FxGIJx
	 oF9OpuKMzFmBnpF4HOaO8FCVJkXloy0iaXDoPJwVx+o6v6/9nm/0rbVJGnUhSbY5JlXzu
	 Q5zDQ2oIqpslQqhefkqnMzyXPAPWlzk96Pwrf4p0joKn2xy+0iHHUEo8NWKUgSavq/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eK20mZWwPyLRD+P3fXgsrYoCSNkPxnUmXBjqmFgjMvk=;
	b=d0p646PxtBn3wPG2CM5hu8+vnxWnTzNXD6uQq1u3sfWDzBjWD64cfkzh30I+MhAV3UIS
	 /Fiwp/FCGI58josKI4r2Bw11OJA06vjXtdcBdick+ZFGr9SqqxOWGOJmS62GCyHm4VrRa
	 ezRR8M8Li6/CdQQr1HgqRP5IMg8YP89C6xV1xOTcBXSah3Jsh5QSQeZwpuusJz+toZCl1
	 mM5fTcBwCtzbSRouRWWLJKgD3dMnDixKiuP41MAllTykuNv9TNSXTE5y2YLvlB29zxxAB
	 Nw8QBfpPboYg9RJfZNtIxNtMd7yG9jt4O9Qcovc8WPqonkPs60eBssMP6CJnB38dODA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSEPADne;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F4D606A326;
	Wed, 25 Nov 2026 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSEPADne
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2AB1F000EB;
	Wed, 25 Nov 2026 15:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621921;
	bh=eK20mZWwPyLRD+P3fXgsrYoCSNkPxnUmXBjqmFgjMvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSEPADnerJuNYLpVuBDozpzM36YIiWkqNPNlC+2hGEZESyH83gFy64sC8fnbjBMyG
	 p0fdis8FxhVPjOEOuzd4qqeXx8cMo2ZQ6m+JnDoKPCiXre1Ru1zEgmYhJU7UpCPoYA
	 w4KeKNm4X0Vr/3VOam1PMCU7lLZYJP3wD4T4rtGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 375/990] tcp: move tp->first_tx_mstamp and tp->delivered_mstamp to tcp_sock_write_tx
Date: Wed, 25 Nov 2026 15:29:02 +0100
Message-ID: <20261125143830.878519152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 07db42c4b3eb60a21645ad88211b69933eab0a03 ]

These fields are touched in when payload is sent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260430100021.211139-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c2213d9b61c1 ("tcp: rate limit receive queue collapsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tcp.h | 4 ++--
 net/ipv4/tcp.c      | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 492b9bfe6b1d2..37511ef31888e 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -264,6 +264,8 @@ struct tcp_sock {
 	u64	bytes_sent;	/* RFC4898 tcpEStatsPerfHCDataOctetsOut
 				 * total number of data bytes sent.
 				 */
+	u64	first_tx_mstamp;  /* start of window send phase */
+	u64	delivered_mstamp; /* time we reached "delivered" */
 	u32	data_segs_out;	/* RFC4898 tcpEStatsPerfDataSegsOut
 				 * total number of data segments sent.
 				 */
@@ -349,8 +351,6 @@ struct tcp_sock {
 	u32	rcv_rtt_last_tsecr;
 	u32	delivered_ecn_bytes[3];
 	u16	pkts_acked_ewma;/* Pkts acked EWMA for AccECN cep heuristic */
-	u64	first_tx_mstamp;  /* start of window send phase */
-	u64	delivered_mstamp; /* time we reached "delivered" */
 	u64	bytes_acked;	/* RFC4898 tcpEStatsAppHCThruOctetsAcked
 				 * sum(delta(snd_una)), or how many bytes
 				 * were acked.
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bb918059224e4..6cd8670d5e96c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -5200,6 +5200,8 @@ static void __init tcp_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, delivered);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, delivered_ce);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, bytes_sent);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, first_tx_mstamp);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, delivered_mstamp);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, snd_sml);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, chrono_start);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, chrono_stat);
@@ -5245,8 +5247,6 @@ static void __init tcp_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcv_rtt_last_tsecr);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, delivered_ecn_bytes);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, pkts_acked_ewma);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, first_tx_mstamp);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, delivered_mstamp);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, bytes_acked);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcv_rtt_est);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcvq_space);
-- 
2.53.0



