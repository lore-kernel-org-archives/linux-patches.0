Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621919;
	b=DmVf2s0fDiWB6V5BbIDuRn4Hga3jvooMrL0bjZDt8AQA2Fpemhgy7OScoE7vTw/utnpg
	 y63uVGR83+/Mf0HbT6W6zR4G/V2pDtt4hlBC7Jw/QJtMs2n2URD9X7zISwvEb83ZtbEAT
	 WffDQn+3Vd2Q/UBkfbwvMuE1MqWQyeOL+8Rh6PMjv0vGqa5aFJLP3Px8jdF3r0X9d8rKj
	 5Oy4wPneS2hHodvbFs7AUYDQZcvWrEUz24AbPxCxwpvmGn60Cin3wi/4jgSxjPeoV4osi
	 yM8MaAqk8aKkIxd7jhkTc9/kTETjsRBGk3lWq0oGSwVteM53mqQl0kYYzFnyCGy2+xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zeuqv+xv3B2DVdRRqya6SrndWLkTAEN52yYkZN3wroo=;
	b=1iHyCv6EyUtfF81EKTDdLZn/vWYnqw0RK/zKGPDNNWAchyf0v2GPUPKgHW5/lrzjgx7W
	 JsnsWszBqnW8syCKDe7x2y+lvuLMcMI78bccVh9+OWrgj41Dv79MmQIlgRZ+U9YgtzNuC
	 w3dKdDkqCd0yoH8v4c3y2w+nf9GkReuExsoJZ5KpXmjPJvE6SG83URiEqckeRy3yVCLk/
	 QaQ6vVGp7pu8K4qV+PRbbzWeRiYvW53cw2miZT5Bxj3i2+Qv32Px4n4ek3KyuXkI0CEyX
	 un/08Tnu+6Yu4evTINEHRLO68WcRgq7tsHhWzZRVyhKrQRi8OURuROA2S8ly2CcgI1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAqrQra6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E658A606A32C;
	Wed, 25 Nov 2026 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAqrQra6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3F51F000F4;
	Wed, 25 Nov 2026 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621918;
	bh=Zeuqv+xv3B2DVdRRqya6SrndWLkTAEN52yYkZN3wroo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAqrQra6IyTXcJBqRBbGi7wlc27xwMjk636/P0aTdZN+DQ6bQTycBDDRhYlBZfnha
	 FIh7muV1kogc0JmpV1szdYWXHIZV9419F8kmfC1uP59nK2XCZpDfDe886KRHUdynPS
	 2a92pNMhx6BUCKcgDNWymtAw/b4/50gjMkB3l42I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 374/990] tcp: move tp->segs_in and tp->segs_out to tcp_sock_write_txrx group
Date: Wed, 25 Nov 2026 15:29:01 +0100
Message-ID: <20261125143830.853141797@linuxfoundation.org>
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

[ Upstream commit 2b28dd212a8ad67b100137626a3d008b1e40a740 ]

segs_in is changed for each incoming packet, including ACK packets.
segs_out is changed for each outgoing packet, including ACK packets.

They belong to tcp_sock_write_txrx group.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260430100021.211139-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c2213d9b61c1 ("tcp: rate limit receive queue collapsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../networking/net_cachelines/tcp_sock.rst     |  4 ++--
 include/linux/tcp.h                            | 18 +++++++++---------
 net/ipv4/tcp.c                                 |  4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/networking/net_cachelines/tcp_sock.rst b/Documentation/networking/net_cachelines/tcp_sock.rst
index 3e1851e5e6e77..f03ee3c804a23 100644
--- a/Documentation/networking/net_cachelines/tcp_sock.rst
+++ b/Documentation/networking/net_cachelines/tcp_sock.rst
@@ -13,13 +13,13 @@ u16                           tcp_header_len          read_mostly         read_m
 u16                           gso_segs                read_mostly                             tcp_xmit_size_goal
 __be32                        pred_flags              read_write          read_mostly         tcp_select_window(tx);tcp_rcv_established(rx)
 u64                           bytes_received                              read_write          tcp_rcv_nxt_update(rx)
-u32                           segs_in                                     read_write          tcp_v6_rcv(rx)
+u32                           segs_in                 read_write          read_write          tcp_segs_in(),tcp_v6_rcv(rx),tcp_v4_rcv()
 u32                           data_segs_in                                read_write          tcp_v6_rcv(rx)
 u32                           rcv_nxt                 read_mostly         read_write          tcp_cleanup_rbuf,tcp_send_ack,tcp_inq_hint,tcp_transmit_skb,tcp_receive_window(tx);tcp_v6_do_rcv,tcp_rcv_established,tcp_data_queue,tcp_receive_window,tcp_rcv_nxt_update(write)(rx)
 u32                           copied_seq                                  read_mostly         tcp_cleanup_rbuf,tcp_rcv_space_adjust,tcp_inq_hint
 u32                           rcv_wup                                     read_write          __tcp_cleanup_rbuf,tcp_receive_window,tcp_receive_established
 u32                           snd_nxt                 read_write          read_mostly         tcp_rate_check_app_limited,__tcp_transmit_skb,tcp_event_new_data_sent(write)(tx);tcp_rcv_established,tcp_ack,tcp_clean_rtx_queue(rx)
-u32                           segs_out                read_write                              __tcp_transmit_skb
+u32                           segs_out                read_write          read_write          __tcp_transmit_skb
 u32                           data_segs_out           read_write                              __tcp_transmit_skb,tcp_update_skb_after_send
 u64                           bytes_sent              read_write                              __tcp_transmit_skb
 u64                           bytes_acked                                 read_write          tcp_snd_una_update/tcp_ack
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 64f5a09f4c47b..492b9bfe6b1d2 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -259,17 +259,14 @@ struct tcp_sock {
 
 	/* TX read-write hotpath cache lines */
 	__cacheline_group_begin(tcp_sock_write_tx) ____cacheline_aligned;
-	u32	segs_out;	/* RFC4898 tcpEStatsPerfSegsOut
-				 * The total number of segments sent.
-				 */
-	u32	data_segs_out;	/* RFC4898 tcpEStatsPerfDataSegsOut
-				 * total number of data segments sent.
-				 */
 	u32	delivered;	/* Total data packets delivered incl. rexmits */
 	u32	delivered_ce;	/* Like the above but only ECE marked packets */
 	u64	bytes_sent;	/* RFC4898 tcpEStatsPerfHCDataOctetsOut
 				 * total number of data bytes sent.
 				 */
+	u32	data_segs_out;	/* RFC4898 tcpEStatsPerfDataSegsOut
+				 * total number of data segments sent.
+				 */
 	u32	snd_sml;	/* Last byte of the most recently transmitted small packet */
 	u8	chrono_type;	/* current chronograph type */
 	u32	chrono_start;	/* Start time in jiffies of a TCP chrono */
@@ -326,6 +323,12 @@ struct tcp_sock {
  *      Options received (usually on last packet, some only on SYN packets).
  */
 	struct tcp_options_received rx_opt;
+	u32	segs_in;	/* RFC4898 tcpEStatsPerfSegsIn
+				 * total number of segments in.
+				 */
+	u32	segs_out;	/* RFC4898 tcpEStatsPerfSegsOut
+				 * The total number of segments sent.
+				 */
 	__cacheline_group_end(tcp_sock_write_txrx);
 
 	/* RX read-write hotpath cache lines */
@@ -335,9 +338,6 @@ struct tcp_sock {
 				 * sum(delta(rcv_nxt)), or how many bytes
 				 * were acked.
 				 */
-	u32	segs_in;	/* RFC4898 tcpEStatsPerfSegsIn
-				 * total number of segments in.
-				 */
 	u32	data_segs_in;	/* RFC4898 tcpEStatsPerfDataSegsIn
 				 * total number of data segments in.
 				 */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a130fc5e033c9..bb918059224e4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -5196,7 +5196,6 @@ static void __init tcp_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_read_rx, snd_ssthresh);
 
 	/* TX read-write hotpath cache lines */
-	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, segs_out);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, data_segs_out);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, delivered);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_tx, delivered_ce);
@@ -5232,10 +5231,11 @@ static void __init tcp_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, rcv_wnd);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, rcv_tstamp);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, rx_opt);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, segs_in);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_txrx, segs_out);
 
 	/* RX read-write hotpath cache lines */
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, bytes_received);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, segs_in);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, data_segs_in);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, rcv_wup);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct tcp_sock, tcp_sock_write_rx, max_packets_out);
-- 
2.53.0



