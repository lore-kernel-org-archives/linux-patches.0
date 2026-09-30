Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3A03515DC;
	Wed, 30 Sep 2026 18:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793317; cv=none; b=AeZBTk7oTBPU3bXd1kfDBfkgP7VWiIbKFSdqO1dKuNFZWmIcxelmB9fPfOHJd0Lu2t5gGpEvC6lxBJ3U1ZlNUgAbf2ORsAtmszqAv/ywwBC3iVuBQK8FyM3ySvCAaQ+jjmlX/9cJvCMtjPRuUmysyDCxZNkH+374nAhvLSErLvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793317; c=relaxed/simple;
	bh=gAiA6CrhVIVUwMgQ5uyzxOPOFKhTlkiF7DY8tR3gShc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIJAFl3Ybd8kZAHsiezKxizBygR/qS3DA2u2Ouu9fprXK8+76GTh+aeVqULNNWYWiOqkIv6HAEnm6I6hnfo2s9lxOJgZkFoueoASSQetLTCfLThaJcVnXdg7Rn050tOmeiSnp7aGvFsuaERc5Qk0xduW9eotsCaG0e561fUTZME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6n7N7hi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6n7N7hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47B11F000FF;
	Wed, 30 Sep 2026 18:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793316;
	bh=soKKeJ4mk9kRbnjG73m5+hUmDOKNpVUotF9dDcZKNG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6n7N7higgVPOa5K7rPsJQk/+w3QukQ7jYLbaAqTtx0gcbcfenwIQumUMnaK7TR21
	 zt4C8NhO5b8hvPOPg/nMhB0hlnwqQNsP2wlESeI6W9qpi/s/fLvai8ZqHn0xeY4Mo1
	 i7N7fKALFtLiTHkwiIHD8bLff9MMFJWxhXVan5zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 210/395] tcp: prevent collapsing skbs across boundary in rtx queue
Date: Wed, 30 Sep 2026 17:27:52 +0200
Message-ID: <20260930152345.210784767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

commit fc6d80eb504458d6416b75a94188b268c95c6533 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1151,9 +1151,9 @@ static inline bool tcp_skb_can_collapse_
 static inline bool tcp_skb_can_collapse(const struct sk_buff *to,
 					const struct sk_buff *from)
 {
-	/* skb_cmp_decrypted() not needed, use tcp_write_collapse_fence() */
 	return likely(tcp_skb_can_collapse_to(to) &&
 		      mptcp_skb_can_collapse(to, from) &&
+		      !skb_cmp_decrypted(to, from) &&
 		      skb_pure_zcopy_same(to, from) &&
 		      skb_frags_readable(to) == skb_frags_readable(from));
 }
@@ -2275,7 +2275,7 @@ static inline void tcp_rtx_queue_unlink_
 
 static inline void tcp_write_collapse_fence(struct sock *sk)
 {
-	struct sk_buff *skb = tcp_write_queue_tail(sk);
+	struct sk_buff *skb = tcp_write_queue_tail(sk) ?: tcp_rtx_queue_tail(sk);
 
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;


