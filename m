Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621925;
	b=yzimda3XzT/9iOi8uzOlq/s40gPUWDYWSJvb5Ma2xWXPsYltbnQheSCr3G0ciO4eKiGu
	 H+VRTMtN2e5kT6sB73B2/DUapFV6i/eDtYCaNKndIz14H6MStaVNGyKGlJ2l9KgZ+f/zb
	 2OjPWIWzTJbIYCwoajzMoDbS1F4IUGJKR6jv+lck9t2f1b9af2GU3M9hSszcQLYlzQJy5
	 Z5RofHd8xp5lBm5jp+QOucHJOobqaO93QXOuvzRrKR95bpBfk4zHgeC4rTMSVJV93jPrG
	 fpfSO7pyhSkXiwQ2XPCPQ8p9F7lRS6VjW+uiuz8sGx/qePXWRpRo3Uw1SFxWb+WSMQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D6aug/m5jiMfG4nDpizEgSBnvCJ6kUyE2nIrDfA9v/Y=;
	b=BcMFdlarknG3mjjn+hzkoErthRidzmZsa1QJyg3kUa17B1QhPTIEfUJlNL/WjBBYqLb6
	 OrVae0jAkP2+mNPrwLX9rwTEUfyp8SEk/yKIZVymp30hTKhhSfeJHnqI32CEUQUqiES+1
	 tHSfYUZc/fXoPqE/C9HiNyYytbcWtIgKY/3IK4L1KsFZvu0vttSrnpZ//4Y4EV3+OMRIJ
	 02NBdSYVXeuPN9O80tKeSbUqwqOLh0/9HnimKyg4y8ZLoG5GcfWM6zVpymLRIzMsmjQV0
	 zPZnrlLRq0ST2K12Lt0c81klOm3Yy53CV7/qMS7ji7xOT1jDnkijhCDMGqQbbanYWLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MBhTy5Lh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F202606A321;
	Wed, 25 Nov 2026 15:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MBhTy5Lh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EA91F000C0;
	Wed, 25 Nov 2026 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621925;
	bh=D6aug/m5jiMfG4nDpizEgSBnvCJ6kUyE2nIrDfA9v/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBhTy5Lh3twBvJVew8BjxNiqIcHMophu0PxTDROk6/QvlqFc25yh+LqOsNf7McTk/
	 4Dar0+8PKAdtTETNNFf5qeNEIrWwLtq/qzpiu3dGSMazcVNTNOJTbfoY39bpWGXraB
	 r7IJjkExo6Ou7sZ12tJJAV2oSxxdXx2SXrzDX1Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 376/990] tcp: move tp->bytes_acked to tcp_sock_write_tx group
Date: Wed, 25 Nov 2026 15:29:03 +0100
Message-ID: <20261125143830.901958170@linuxfoundation.org>
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

[ Upstream commit dd033ec406b4d9eade3e0fd998ec9bfa50db42ba ]

tp->bytes_acked is touched in TX path only.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260430100021.211139-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c2213d9b61c1 ("tcp: rate limit receive queue collapsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/net_cachelines/tcp_sock.rst | 2 +-
 include/linux/tcp.h                                  | 8 ++++----
 net/ipv4/tcp.c                                       | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/net_cachelines/tcp_sock.rst b/Documentation/networking/net_cachelines/tcp_sock.rst
index f03ee3c804a23..430317cdb8f64 100644
--- a/Documentation/networking/net_cachelines/tcp_sock.rst
+++ b/Documentation/networking/net_cachelines/tcp_sock.rst
@@ -22,7 +22,7 @@ u32                           snd_nxt                 read_write          read_m
 u32                           segs_out                read_write          read_write          __tcp_transmit_skb
 u32                           data_segs_out           read_write                              __tcp_transmit_skb,tcp_update_skb_after_send
 u64                           bytes_sent              read_write                              __tcp_transmit_skb
-u64                           bytes_acked                                 read_write          tcp_snd_una_update/tcp_ack
+u64                           bytes_acked             read_write                              tcp_snd_una_update/tcp_ack
 u32                           dsack_dups
 u32                           snd_una                 read_mostly         read_write          tcp_wnd_end,tcp_urg_mode,tcp_minshall_check,tcp_cwnd_validate(tx);tcp_ack,tcp_may_update_window,tcp_clean_rtx_queue(write),tcp_ack_tstamp(rx)
 u32                           snd_sml                 read_write                              tcp_minshall_check,tcp_minshall_update
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 37511ef31888e..db348f06ec3e0 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -261,6 +261,10 @@ struct tcp_sock {
 	__cacheline_group_begin(tcp_sock_write_tx) ____cacheline_aligned;
 	u32	delivered;	/* Total data packets delivered incl. rexmits */
 	u32	delivered_ce;	/* Like the above but only ECE marked packets */
+	u64	bytes_acked;	/* RFC4898 tcpEStatsAppHCThruOctetsAcked
+				 * sum(delta(snd_una)), or how many bytes
+				 * were acked.
+				 */
 	u64	bytes_sent;	/* RFC4898 tcpEStatsPerfHCDataOctetsOut
 				 * total number of data bytes sent.
 				 */
@@ -351,10 +355,6 @@ struct tcp_sock {
 	u32	rcv_rtt_last_tsecr;
 	u32	delivered_ecn_bytes[3];
 	u16	pkts_acked_ewma;/* Pkts acked EWMA for AccECN cep heuristic */
-	u64	bytes_acked;	/* RFC4898 tcpEStatsAppHCThruOctetsAcked
-				 * sum(delta(snd_una)), or how many bytes
-				 * were acked.
-				 */
 	struct {
 		u32	rtt_us;
 		u32	seq;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6cd8670d5e96c..fb571e0dd40c9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -5199,6 +5199,7 @@ static void __init tcp_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, data_segs_out);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, delivered);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, delivered_ce);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, bytes_acked);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, bytes_sent);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, first_tx_mstamp);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, delivered_mstamp);
@@ -5247,7 +5248,6 @@ static void __init tcp_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcv_rtt_last_tsecr);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, delivered_ecn_bytes);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, pkts_acked_ewma);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, bytes_acked);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcv_rtt_est);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcvq_space);
 }
-- 
2.53.0



