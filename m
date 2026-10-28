Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212396;
	b=cfXhkE6jfZUYKcQKBUCX/upfJGN2zFchwE0tiABJm/z+PKjy8sZdDA6XBLg0OInDHLXf
	 ui29uv1kTbhx7VrWfRDjes6Yw7Q5pEsNpA555eL2K4rwcnd78RrSy5dD7h+3Y+26fSApM
	 IcNibyqaj3EbYWD4EeBKQojVIq+WKnZabFXMLcpl5tu0zsgJaMCsgO2DJ9pshe47b6HTb
	 Rz4GFsT0klux7cmjaFFcTaTOGZJG7C//0hRqEnnfXI+BNVwbwrLb8BTVnRVXBsv7pepDW
	 at4l9g8awSj4yTzI4I/MxQEohMiQEOH3F1Rcp0nGwtWN+Gpo9Ia93BgLkoyz33XpLbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ci3WYJ6gGef8E+5X2WDXyQXFqLakXRgbzxhNPfR1lxw=;
	b=27fRT7OsMMbtcT+A6Oq2iHTnBph9NmyKm9aYI+27lKjbK4QSp3w4Z7UJm597PpCR3qbv
	 TrftYx83L2PMe0xqIcPHUofflk3RDmeuZYeaaf3YMP33wsIJACeUsRuyspLeyK31Pglu5
	 4e0sGRzRhKifzI5BH81Nt17XVeWuvI8ipAul/bgmBLiDGzeBdbtbuobDHqy3sJ4AErjUX
	 ubPwPsqtgOV4KTYBhutlq2nq3+l8mT0dd7JvC7YKWc3lNKPfc0zCxG4O6oTK2Y/AR2B/X
	 A3etPRteYpfLVDnHI9/ngUQH68atU2dX3bZqgmUH3OXykyFU/qu+SByu8Oa9Nm98meQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lQYhde/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED37606A322;
	Wed, 28 Oct 2026 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQYhde/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2251F01828;
	Wed, 28 Oct 2026 18:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212396;
	bh=ci3WYJ6gGef8E+5X2WDXyQXFqLakXRgbzxhNPfR1lxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQYhde/TxL7SX/sFJ35w0Rxcs88gV/7LRkpoNgFz/AQF7o9xARg+0N0V9VaU5NmiD
	 Eqt5tse76rgjno2GIVfYlNnI/HpbUP8y7RoxGgCZGGi3LC6P+WPjgZmkrMUFcPT+Y9
	 0F3arDF82Xjkupzn3VpiKCgcjIokfhTQO9s6uWe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0138/1887] tcp: prevent collapsing skbs across boundary in rtx queue
Date: Wed, 28 Oct 2026 17:37:14 +0100
Message-ID: <20261028170502.374948322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ Applied tcp_write_collapse_fence() changes directly to the existing TLS code blocks because the helper is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h    | 1 +
 net/tls/tls_device.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index c25cd0df7a904..245c522387315 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1019,6 +1019,7 @@ static inline bool tcp_skb_can_collapse(const struct sk_buff *to,
 {
 	return likely(tcp_skb_can_collapse_to(to) &&
 		      mptcp_skb_can_collapse(to, from) &&
+		      !skb_cmp_decrypted(to, from) &&
 		      skb_pure_zcopy_same(to, from));
 }
 
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 753c45ecc3562..74b61318a60ac 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -239,7 +239,7 @@ static void tls_device_resync_tx(struct sock *sk, struct tls_context *tls_ctx,
 	int err = 0;
 	u8 *rcd_sn;
 
-	skb = tcp_write_queue_tail(sk);
+	skb = tcp_write_queue_tail(sk) ?: tcp_rtx_queue_tail(sk);
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
@@ -1181,7 +1181,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	 * SKBs where only part of the payload needs to be encrypted.
 	 * So mark the last skb in the write queue as end of record.
 	 */
-	skb = tcp_write_queue_tail(sk);
+	skb = tcp_write_queue_tail(sk) ?: tcp_rtx_queue_tail(sk);
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
-- 
2.53.0



