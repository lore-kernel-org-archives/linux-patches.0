Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621915;
	b=HLgvcYGGHN4pLi/x6PiaA8x+8jfIk29OycSu1Lbq2SD0ZWs/GtjrC/48M2oYHdGSlZBE
	 cHivGPwOql+Hp6S9KDlc3vgNUBe7bRmRHkmbKoL7W1ZIADFdoGMM88xVdXARgvl2OnsM9
	 qSpjLbRkifA9Xke3xqQlctyphBSLMVGLt/79zrsXL/7+Csu3rJbyuRixGf3XWswKm6nsc
	 Qxq3EwGyUm4uYM+8O+PaHVySRXEI7gf5B1+5Rnxu6e1UGKwiPYsQroTuY77yG0H8d0nha
	 aAqeh0TgVvHhJKQmDm1O7isT75A6GmkN76eLVUqIh9ZAYluxJy7uZq9l4oJIAKxY0Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lvDwZZuwr5I/hhAvCivf9y5NcowWdGVSN//xqsCqJ2M=;
	b=EwSHuIFVnqCXh4Ot9UpHd8EzA3qS2r1h87Et+IhBzfGIR02cvvB6Ldu6tUPk/5+hiRId
	 0BtXidQsgWDLMS4AwwlCtdfT3fxoRGjknQRssV/6NLojJI7p+g0jodCKg9rhnab0iz8mi
	 yBe8y3FfOo/ZX+y/xNNoLBFsr4GBtg/kUvR43JsOKf225K3cz5SFdPy8K53XVL405YzQW
	 lLYekLTwRE8fCF0Nh0+eTvTe3IIlHaXzTtrn1PuA02oJNvwyuP5aEa6VtsowfNs8VoJNm
	 /qpckTe/gc8dkzzu+TYhF935rXYXDzFBQSmlXBF1WEgW0qIhsJ3NS9odUjx/NaDTs3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VWC24UHS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68583606A32E;
	Wed, 25 Nov 2026 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VWC24UHS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824041F000E6;
	Wed, 25 Nov 2026 15:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621915;
	bh=lvDwZZuwr5I/hhAvCivf9y5NcowWdGVSN//xqsCqJ2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWC24UHShyqMfmO+oA5TCIh8qOL5rJkAtP0Pb73997PIWeVtpmfcPkXkY+ko6WZ27
	 55zlMrr1vUOqS8Yj02MabkDIq3Bq8KZp8WSlkIHGIHMoBL1ddNcmfzkJOCwNUrzFLx
	 WZr5it46Cd4TIEDzsfFE7N087TniuAixbs6H3CSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 373/990] tcp: move tp->delivered and tp->delivered_ce to tcp_sock_write_tx group
Date: Wed, 25 Nov 2026 15:29:00 +0100
Message-ID: <20261125143830.829224912@linuxfoundation.org>
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

[ Upstream commit 9f810527a343fd72671fe7661ebb3694396f45ed ]

These counters are changed whenever sent data is acknowleged.

They do not belong to tcp_sock_write_txrx group, because TCP receivers
do not touch them.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260430100021.211139-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c2213d9b61c1 ("tcp: rate limit receive queue collapsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/net_cachelines/tcp_sock.rst | 4 ++--
 include/linux/tcp.h                                  | 4 ++--
 net/ipv4/tcp.c                                       | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/net_cachelines/tcp_sock.rst b/Documentation/networking/net_cachelines/tcp_sock.rst
index 563daea10d6c5..3e1851e5e6e77 100644
--- a/Documentation/networking/net_cachelines/tcp_sock.rst
+++ b/Documentation/networking/net_cachelines/tcp_sock.rst
@@ -99,8 +99,8 @@ u32                           snd_cwnd_stamp
 u32                           prior_cwnd
 u32                           prr_delivered
 u32                           prr_out                 read_mostly         read_mostly         tcp_rate_skb_sent,tcp_newly_delivered(tx);tcp_ack,tcp_rate_gen,tcp_clean_rtx_queue(rx)
-u32                           delivered               read_mostly         read_write          tcp_rate_skb_sent, tcp_newly_delivered(tx);tcp_ack, tcp_rate_gen, tcp_clean_rtx_queue (rx)
-u32                           delivered_ce            read_mostly         read_write          tcp_rate_skb_sent(tx);tcp_rate_gen(rx)
+u32                           delivered               read_write                              tcp_rate_skb_sent, tcp_newly_delivered(tx);tcp_ack, tcp_rate_gen, tcp_clean_rtx_queue (rx)
+u32                           delivered_ce            read_write                              tcp_rate_skb_sent(tx);tcp_rate_gen(rx)
 u32                           received_ce             read_mostly         read_write
 u32[3]                        received_ecn_bytes      read_mostly         read_write
 u8:4                          received_ce_pending     read_mostly         read_write
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 98e626bde8d61..64f5a09f4c47b 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -265,6 +265,8 @@ struct tcp_sock {
 	u32	data_segs_out;	/* RFC4898 tcpEStatsPerfDataSegsOut
 				 * total number of data segments sent.
 				 */
+	u32	delivered;	/* Total data packets delivered incl. rexmits */
+	u32	delivered_ce;	/* Like the above but only ECE marked packets */
 	u64	bytes_sent;	/* RFC4898 tcpEStatsPerfHCDataOctetsOut
 				 * total number of data bytes sent.
 				 */
@@ -312,8 +314,6 @@ struct tcp_sock {
 	u32	srtt_us;	/* smoothed round trip time << 3 in usecs */
 	u32	packets_out;	/* Packets which are "in flight"	*/
 	u32	snd_up;		/* Urgent pointer		*/
-	u32	delivered;	/* Total data packets delivered incl. rexmits */
-	u32	delivered_ce;	/* Like the above but only ECE marked packets */
 	u32	received_ce;	/* Like the above but for rcvd CE marked pkts */
 	u32	received_ecn_bytes[3]; /* received byte counters for three ECN
 					* types: INET_ECN_ECT_1, INET_ECN_ECT_0,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d41a94bf29ddf..a130fc5e033c9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -5198,6 +5198,8 @@ static void __init tcp_struct_check(void)
 	/* TX read-write hotpath cache lines */
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, segs_out);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, data_segs_out);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, delivered);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, delivered_ce);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, bytes_sent);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, snd_sml);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, chrono_start);
@@ -5224,8 +5226,6 @@ static void __init tcp_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, srtt_us);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, packets_out);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, snd_up);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, delivered);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, delivered_ce);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, received_ce);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, received_ecn_bytes);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, app_limited);
-- 
2.53.0



