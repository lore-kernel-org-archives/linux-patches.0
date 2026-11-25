Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621102;
	b=iqziQXG9SmIrVA8TnuIDxNO4IFLtyophNncA9xof02FElhltFwjzKDlWDaxMjdaPJtW2
	 7ipoiWLdYT4JV0wZ+LZTtmgT2wA6hmWybS4k2s/h7RkO+84bgDNJc7BNDmEcjAHsEv8ih
	 5lyThq0t+5DjGO9AWT3LB+hzLNiuIbkqkplNN0x/4tAjdn8nbDAcDM7ExLazR5+vx+uak
	 sLMjkHe5wPubUlSQ0A1Pk7OHVsGs+TVYsbamrfy1ktpgz+m0EQwSp6FZoIkyMj/YKyGhY
	 wmCDZkrzsTkYbjiXzTMXYiFSE2Qh1TuCOUMMtlyHd1UlCzGsLuHZkFIn7bDqb8TzWgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zS/YRKHgCNBP6WcTVlNsfAmUSQedBDm8CGbz7ZgNWwE=;
	b=Pnz9WJKfAlwLWVQKjYY3GUs9bpiKEETBxSSV5i6T0NIAq7LAgnhEmD64mxjTDtVX0hQM
	 KKZw7XMlyR5yOtFE18h+Smze5bABqhxj3D9ORQmB2OpOYjanhomTf4fNFX+gpNukWcrch
	 K1MG4AbRTNwkqXeluvyb7z8tbMsyoK/bP0sWkRCbddr1pbgWgDotNQyF8SuXg3hSQyaqg
	 UcYS5v77GTi0M3oI0Hr3+TuPIQX+5/Iv+Sg18qjxHnSNSywLx8BWETIHThc3IwD7iUx07
	 XWsNPvXvVkhtCYU6b6dpCia5/gRvZaLdDV+2V7rkN3/HnQToYIP6Fj4TzREh+FR53jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVnFZKs+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC95606A323;
	Wed, 25 Nov 2026 15:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVnFZKs+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388F51F000C4;
	Wed, 25 Nov 2026 15:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621102;
	bh=zS/YRKHgCNBP6WcTVlNsfAmUSQedBDm8CGbz7ZgNWwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVnFZKs+nEyhlACeN+1nJSashDu050LMWKUC2b8n6lAPwWAXIK1myyHXNHlbB7U3H
	 n4Mdq2FBj5i/CkIiBwaGOT02bu10cDZFVVd7Kt7ttmKOuBYMXevO+bxDMFxXFlVOaT
	 fyse4NwSZFKx5iyNsYjr9yHTB6ZVPbk4McovVsi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/990] bpf: Dont leave a stale MAC header in bpf_lwt_push_ip_encap()
Date: Wed, 25 Nov 2026 15:24:50 +0100
Message-ID: <20261125143824.970332293@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 701ffd202b9e32942c8cfc065c9fe76ceaccc302 ]

With BPF_LWT_ENCAP_IP, bpf_lwt_push_encap() pushes a new IP header. The new
header overwrites the MAC header of a received skb. But skb->mac_header
continues to point to the same bytes. Code that reads the MAC header after
the push, for example netfilter, gets bytes of the new header.

  before the push                        | MAC header  | old IP | payload
                                         ^ mac_header  ^ network_header
  today                            | new header        | old IP | payload
                    network_header ^     ^ mac_header
  this patch, lwt_in | MAC header  | new header        | old IP | payload
                     ^ mac_header  ^ network_header
  this patch, lwt_xmit             | new header        | old IP | payload
                    network_header ^     mac_header is not set

For lwt_in, move the MAC header in front of the new header before the
memcpy(), as __seg6_do_srh_encap() does. skb_cow_head() already reserves
len + skb->mac_len bytes.

For lwt_xmit, the output path makes a new MAC header. Thus mark
skb->mac_header as not set. This is the state of a locally generated skb.

Fixes: 52f278774e79 ("bpf: implement BPF_LWT_ENCAP_IP mode in bpf_lwt_push_encap")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-22-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 953237bca36b6..7e011fd3a60ff 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -645,6 +645,14 @@ int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len, bool ingress)
 	if (ingress)
 		skb_postpush_rcsum(skb, iph, len);
 	skb_reset_network_header(skb);
+	/*
+	 * The new header goes over the MAC header. On ingress move it first.
+	 * On egress the packet gets a new one, so forget the old one.
+	 */
+	if (ingress)
+		skb_mac_header_rebuild(skb);
+	else
+		skb_unset_mac_header(skb);
 	if (is_udp_tunnel) {
 		size_t iph_sz = ipv4 ? iph->ihl * 4 : sizeof(struct ipv6hdr);
 
-- 
2.53.0



