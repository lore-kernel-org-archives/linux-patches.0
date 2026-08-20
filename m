Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051973803D7;
	Thu, 20 Aug 2026 17:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247577; cv=none; b=L1yHSvLIuRJ7qXdu+LIjsy5HPE2T5lolG2Sohfh5/AGkmXh7ss+ygGGPX/rLPaW7yp5A3n//H2RIpCgb5OBOtI2DEjdnY98oSSfVWTLZkBPJ6lBCQstPra213qv2vp8NkVVyNE8FLc1wCIuVn189oBsn3xUvXum/dUHuqD6o2J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247577; c=relaxed/simple;
	bh=UztfrYd5wYFWIWnzxekeOWBr4tJ9JPVQAF87+cTnzgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rbSaIP3vqxiaVoSlDEXSYOWzcANEtknX+Iu6y42zA5zTs16lcAce+MOoLbRZ2RD8xoNjDE5SffLZEtNFwQdA0iceNlNHRx5k2zcPBIonEI8JIve0yKvMOyOqNRbM/wACEdIMXqXP8EZs2QY2Jf9EBqe2AA40O5Wc4IjJ4eavSk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylW7SasN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylW7SasN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607DD1F000E9;
	Thu, 20 Aug 2026 17:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247575;
	bh=c2fl+IB7TQTsi7Ka5/5yiD/jkIL36HJEi0gg5MdsCZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylW7SasN+RKpbrqqq5ny4ByfzHTXfiOs/60zrNLalBaaAPQDgpHnsyNp1gD01z+vo
	 gfwNbEOeDW/M6MFWNMfsH7Fd/LSCBXmoATD5ZAYSq0/tfG2ANlzkLUuHP6aeRjNQ37
	 1ICpSIpJKjiT1fSbUTWDyCX6PSVFTEkqNrE7r9U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ij@kernel.org>,
	Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/166] tcp: Pass flags to __tcp_send_ack
Date: Thu, 20 Aug 2026 16:55:53 +0200
Message-ID: <20260820145213.982191695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ij@kernel.org>

[ Upstream commit 9866884ce8ef25338c5b33cbb97c2b5d92088528 ]

Accurate ECN needs to send custom flags to handle IP-ECN
field reflection during handshake.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a28c4fcbf774 ("tcp: challenge ACK for non-exact RST in SYN-RECEIVED")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h     |    2 +-
 net/ipv4/bpf_tcp_ca.c |    2 +-
 net/ipv4/tcp_dctcp.h  |    2 +-
 net/ipv4/tcp_output.c |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -615,7 +615,7 @@ void tcp_send_fin(struct sock *sk);
 void tcp_send_active_reset(struct sock *sk, gfp_t priority);
 int tcp_send_synack(struct sock *);
 void tcp_push_one(struct sock *, unsigned int mss_now);
-void __tcp_send_ack(struct sock *sk, u32 rcv_nxt);
+void __tcp_send_ack(struct sock *sk, u32 rcv_nxt, u16 flags);
 void tcp_send_ack(struct sock *sk);
 void tcp_send_delayed_ack(struct sock *sk);
 void tcp_send_loss_probe(struct sock *sk);
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -128,7 +128,7 @@ static int bpf_tcp_ca_btf_struct_access(
 BPF_CALL_2(bpf_tcp_send_ack, struct tcp_sock *, tp, u32, rcv_nxt)
 {
 	/* bpf_tcp_ca prog cannot have NULL tp */
-	__tcp_send_ack((struct sock *)tp, rcv_nxt);
+	__tcp_send_ack((struct sock *)tp, rcv_nxt, 0);
 	return 0;
 }
 
--- a/net/ipv4/tcp_dctcp.h
+++ b/net/ipv4/tcp_dctcp.h
@@ -28,7 +28,7 @@ static inline void dctcp_ece_ack_update(
 		 */
 		if (inet_csk(sk)->icsk_ack.pending & ICSK_ACK_TIMER) {
 			dctcp_ece_ack_cwr(sk, *ce_state);
-			__tcp_send_ack(sk, *prior_rcv_nxt);
+			__tcp_send_ack(sk, *prior_rcv_nxt, 0);
 		}
 		inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
 	}
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4098,7 +4098,7 @@ void tcp_send_delayed_ack(struct sock *s
 }
 
 /* This routine sends an ack and also updates the window. */
-void __tcp_send_ack(struct sock *sk, u32 rcv_nxt)
+void __tcp_send_ack(struct sock *sk, u32 rcv_nxt, u16 flags)
 {
 	struct sk_buff *buff;
 
@@ -4127,7 +4127,7 @@ void __tcp_send_ack(struct sock *sk, u32
 
 	/* Reserve space for headers and prepare control bits. */
 	skb_reserve(buff, MAX_TCP_HEADER);
-	tcp_init_nondata_skb(buff, tcp_acceptable_seq(sk), TCPHDR_ACK);
+	tcp_init_nondata_skb(buff, tcp_acceptable_seq(sk), TCPHDR_ACK | flags);
 
 	/* We do not want pure acks influencing TCP Small Queues or fq/pacing
 	 * too much.
@@ -4142,7 +4142,7 @@ EXPORT_SYMBOL_GPL(__tcp_send_ack);
 
 void tcp_send_ack(struct sock *sk)
 {
-	__tcp_send_ack(sk, tcp_sk(sk)->rcv_nxt);
+	__tcp_send_ack(sk, tcp_sk(sk)->rcv_nxt, 0);
 }
 
 /* This routine sends a packet with an out of date sequence


