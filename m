Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208403;
	b=OH5qWYjBNd1f35jmcQ8wZlCKsK10EGLXvgWgW2/zeVs6OsdKo4vtC9R2Kkpbwzsqce2o
	 2cC5R87GpH9BA2HAhiw84W2N8oG3ecCeWGTWtOVd4yXhMYPL3RHSgBAFIpadIbTeJjMxm
	 F80jUi1H51Z7tUHODpX4DTZOMIb6zwanhZBXalGi6qTiyt/yWM4hswTRfVRFyujaqJUW0
	 4WXdCFEThkN7Qz3hFLog7CqFD6Rix6liHfG5nrnCh5lejCnIdDxP0td38I77Sr3md+Whr
	 QmNII2YwNBZqHbAJ5b67jezmx4zB+hXdZmhYKEfKTF0LtYyusL3Bv07MAuPkvK7ZHdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UFZ2OEnDizFYxVM4QXcyRCr0+4jT8t+ZXOlcc7CnRyc=;
	b=pI2pP3hDzPeF0WTwku1/ncUo3kdVTGllGNmGZrTnoPmQIImeqhVsrq5khaRTSkd7s7GH
	 WcJG55+MMrEqZayBDtzYRKBHyVTr7kxCdXWkBQ5Y2YLXPMJ9Fwnn9zbJDQRQhsPyw6ORA
	 2Up2mdRXiU5kgcarPg/nb2lWzte+tnhKuuZqcimigf85Ru/o3ibd/H1J7T4QhUz25jk+G
	 8UGZN82Kmf6WEKi57qMPXyuypYKPIZzgK+vyjEgIlwmLq89Jqu3I1OQCMXD6gN/R9qUoE
	 9QYHAfp2X3f7XQXL5ehsID5TK734r7SjbLPqdjr6FPGGZfDB10eyHz0a0HneGVaEC5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R4bXDPOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3C4606A31A;
	Wed, 28 Oct 2026 17:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R4bXDPOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9583C1F01825;
	Wed, 28 Oct 2026 17:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208403;
	bh=UFZ2OEnDizFYxVM4QXcyRCr0+4jT8t+ZXOlcc7CnRyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4bXDPOdGoYdxgWSTuUiD57Oqcs2qlPMSlfDLGcmT+Ds5eAhYPvJQz4UBXRX/gxaR
	 MsjVi1WLFQxZry8aSHzeCwQA1I+wr//u2mjx5jOy/puvGPkAnfagctR7+VorCL7F5E
	 PpYLg2vopXlst4+AaD0GDZJQ94hK/5KxqfNY87+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/516] tcp: prevent collapsing skbs across boundary in rtx queue
Date: Wed, 28 Oct 2026 17:54:20 +0100
Message-ID: <20261028170006.076710296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2bd38e319c201..d5a8843587535 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -988,6 +988,10 @@ static inline bool tcp_skb_can_collapse_to(const struct sk_buff *skb)
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
index d5fdea2af423b..943378e075cfb 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -225,7 +225,7 @@ static void tls_device_resync_tx(struct sock *sk, struct tls_context *tls_ctx,
 	int err = 0;
 	u8 *rcd_sn;
 
-	skb = tcp_write_queue_tail(sk);
+	skb = tcp_write_queue_tail(sk) ?: tcp_rtx_queue_tail(sk);
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
@@ -1119,7 +1119,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	 * SKBs where only part of the payload needs to be encrypted.
 	 * So mark the last skb in the write queue as end of record.
 	 */
-	skb = tcp_write_queue_tail(sk);
+	skb = tcp_write_queue_tail(sk) ?: tcp_rtx_queue_tail(sk);
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
-- 
2.53.0



