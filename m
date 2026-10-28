Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210666;
	b=Yt4C/F5MXlACgQ6ARGSVx1QAOFiGhr/cK20A0FPo5kqMIhP/vyFl5q9WbVj3cDTCisHu
	 5UiHUs2r0R23XGzy2697JmgOUF1LvkkK6nf0p8FplSR0qL9NC6lVytnHXS1ZV6fI5lb0k
	 GGytUSjpfxEeA9Cgj88WLE0jCjLUHY1s6TJQ+6HDXIHeRK4GGCWt88NyimViVv5QBxmLa
	 GGEjz5r3d5TAnllko1qwslNTtSadcZTwhyvuIb8FD4io0SDz356Q1ztxslzeLkjIR5HAX
	 QddqSMVcEUBbTTasovgnubS4NkcpMSV0N5WLrZXeHSfohCuWjQf31FK7kteX4j5nTng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7XvYymiHaJb04F9d1qag4vsE+SpN9aJT7styrDbH4Eg=;
	b=C3IalOZo9Lw8n0+pSCV4Ya7hk9jqeGBKfDAuBeTS5GQhHD54SRonxrX7b8qKUSJozzT8
	 ytBwhrug7PVavELRWWuI1u5mDW2LSC+PGfd/o92rYuhvOdZPYennCJxV+CQwrka6riyV0
	 XNKoCCEGnJNLxCjtJh9BA6FjcCdjpi5fk4KNtvxX2/rz0/MQwaGrsZkAGtotwWmp6fWkt
	 Gliq381LtTtor74UXkspLF92hWxppLsSEs1fNUPkJRA+KqDtLlI+8O2o31YRKQ46PwI5X
	 /QQ1XZDnwwgRdgwLilxmRMQQXx77tMhsiFGGFnRFqiNdf+tzhXx2YR067UbfockaPMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYMWlVN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81652606A321;
	Wed, 28 Oct 2026 18:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYMWlVN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D371F01825;
	Wed, 28 Oct 2026 18:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210666;
	bh=7XvYymiHaJb04F9d1qag4vsE+SpN9aJT7styrDbH4Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYMWlVN1MKpHz/iRRf3UH+9cRIgrEgHSBJpJD7Vp4mdo3crJWB0Tg45MRnxG9f3XX
	 QyldetQUomBGPTRfWwT+Q0N7yYR/RuOnpTq6Kvusvt+nTjjjBFpXIudZq5AF/WNnnh
	 /QOicxeikRfBYXK8ZcbS9E7f0NdZE9OQcM8vciJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/571] tcp: prevent collapsing skbs across boundary in rtx queue
Date: Wed, 28 Oct 2026 17:54:13 +0100
Message-ID: <20261028170010.537087953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit fc6d80eb504458d6416b75a94188b268c95c6533 ]

tcp_write_collapse_fence() sets TCP_SKB_CB(skb)->eor = 1 on
tcp_write_queue_tail(sk) to prevent skbs queued after a switch to
device encryption from being collapsed into earlier skbs.

The fence is a no-op if all earlier data has already been transmitted
when the switch happens: sk->sk_write_queue is empty. The not yet
acknowledged earlier skbs wait in sk->tcp_rtx_queue with eor 0.

On a subsequent retransmit or SACK shift, tcp_retrans_try_collapse() or
tcp_shift_skb_data() can then merge an skb queued after the switch into
one queued before it.

Both users of the fence are affected:

- psp: devices only encrypt skbs with skb->decrypted set. The merged skb
  keeps decrypted = 0 from the earlier skb, so merged data sent after
  psp_sock_assoc_set_tx() is retransmitted in cleartext.

- tls device offload: the merged skb straddles the start marker set in
  tls_set_device_offload(). The software fallback (fill_sg_in() returns
  -EINVAL) and the mlx5, nfp and funeth drivers cannot handle such an
  skb and drop it. Every retransmit rebuilds the same skb, so the
  connection stalls.

Fix this in two places, for defense in depth:

1. Fall back to tcp_rtx_queue_tail(sk) in tcp_write_collapse_fence()
   when tcp_write_queue_tail(sk) is NULL.

2. Check !skb_cmp_decrypted(to, from) in tcp_skb_can_collapse(), as
   tcp_skb_can_collapse_rx() does on receive. skb_shift(), which both
   collapse paths call, already has a DEBUG_NET_WARN_ON_ONCE() for this
   condition.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20260924154427.953800-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ inlined logic for missing skb_cmp_decrypted() and tcp_write_collapse_fence() helpers into existing functions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h    | 4 ++++
 net/tls/tls_device.c | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a0f3dd3faf60c..0dec2857f5b5d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -974,6 +974,10 @@ static inline bool tcp_skb_can_collapse_to(const struct sk_buff *skb)
 static inline bool tcp_skb_can_collapse(const struct sk_buff *to,
 					const struct sk_buff *from)
 {
+#ifdef CONFIG_TLS_DEVICE
+	if (from->decrypted != to->decrypted)
+		return false;
+#endif
 	return likely(tcp_skb_can_collapse_to(to) &&
 		      mptcp_skb_can_collapse(to, from));
 }
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 2060380265a75..636e106679056 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -224,7 +224,7 @@ static void tls_device_resync_tx(struct sock *sk, struct tls_context *tls_ctx,
 	int err = 0;
 	u8 *rcd_sn;
 
-	skb = tcp_write_queue_tail(sk);
+	skb = tcp_write_queue_tail(sk) ?: tcp_rtx_queue_tail(sk);
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
@@ -1108,7 +1108,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	 * SKBs where only part of the payload needs to be encrypted.
 	 * So mark the last skb in the write queue as end of record.
 	 */
-	skb = tcp_write_queue_tail(sk);
+	skb = tcp_write_queue_tail(sk) ?: tcp_rtx_queue_tail(sk);
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
-- 
2.53.0



