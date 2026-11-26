Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704208;
	b=vXzq+AWBVtv/WTRhMKKi7tDLFecGoagdCW/UCN4DOYUZyWcH9VJnz0OFoNKYT+u8c1+y
	 YaMX71ZQ/6b+xeOvsmg7pPnhPQmLyzkP1/VlIk2sxtIAKbI87ZWfqdj7HqK0VSt2/pw/a
	 3K6J4XCvywNT6dOvoe6lw9UTOVKvkP7sbwADqQ9Ordnwe4xLpR5fKwM3YqpqDJ6CtHcTY
	 Fvac83eay+jmzV5oSC9TGWqqvGjCyFGdgmLs3/7JjHKEOgf9VFWCz7rewVWOfodmb45Go
	 QgK/yEScA47bXW4EL9Ws9axs7moFBCifu27ciPJYB+y7qmu3qsMWcOtoo3BG93+AGyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HYm/NbhLNYbWJzVJMoboxxTyMEfyKINekozEexfKtoI=;
	b=4snw7a0q9LJWWGuLt98lnDHDIyzDfp8NsqDp4ovJrB1kCrL/3b6TXN7P52n6f9eMVetI
	 8+kjrpqVZfXcxKEBz1WhHLJ1kkHiBI70xvpMElV7vPmCmU+gcvsTH/qxNVwGMwWr8v4B7
	 sMOLEjYIaPSMvTQ6aPyyDaxEYjSn4ZfhshPS+staYSrIYjLz+YkYNtT314HYfaY7MODoq
	 WmS7FN8QwkSWSHLrVxuQ85Yjp4DJbeVWFX9SYFbAIc8HIt6Fyg9s3tJKlQ0DkemwpSA8t
	 eDS/JXNfigD30XlPaUcVSEqA0kJ048TYhGqaiMc0KZWe60pMe7JDyiQTd5J1G9XowmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RzlPAWW+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF98606A31E;
	Thu, 26 Nov 2026 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RzlPAWW+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEB31F000CF;
	Thu, 26 Nov 2026 14:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704207;
	bh=HYm/NbhLNYbWJzVJMoboxxTyMEfyKINekozEexfKtoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzlPAWW+GXkRpPTdexcN6oii+nVttGAVgXjmZXqYi1d9dj4Fw7E53aO/u3mgYDaUj
	 oMdbdGczmzIn8KtE63ghhE2T1C3MpMVpGKQr0BgmYoH2Z3u2A1+m0bX1S8zIeKyWBj
	 u73KjDq9kt2Em2jrLNB3yf4UexlXfxQqiOk6dvlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuqiang Sun <izaiahsun@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/265] bpf: lwt: Free the skb when bpf_xmit() fails to expand the headroom
Date: Thu, 26 Nov 2026 15:36:11 +0100
Message-ID: <20261126143607.995421082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Yuqiang Sun <izaiahsun@gmail.com>

[ Upstream commit 5e96760b25fdedbbf9312827f1f237d6b18b03e8 ]

When an LWT xmit program returns BPF_OK, bpf_xmit() makes sure that
the skb still has room for the link layer header. If
pskb_expand_head() fails there, bpf_xmit() returns -ENOMEM without
freeing the skb. Its callers, lwtunnel_xmit() and then
ip_finish_output2() or ip6_finish_output2(), take any return value
other than LWTUNNEL_XMIT_CONTINUE to mean that the skb has been
consumed, so nothing frees it.

Each such failure leaks the skb, together with what it holds: its dst
and its charge to the sending socket, so the socket is never freed
either. The other error paths of bpf_xmit() (BPF_DROP, an illegal
return code, a changed protocol, a failed reroute) all free the skb.

Free it here too.

The leak was found with kbound, a static analysis prototype for
ownership mismatches at kernel interfaces, on v7.2.12; it is present in
mainline.

Build-tested with x86_64 and arm64 allmodconfig (W=1, sparse): no new
warnings. Run-tested on QEMU (x86_64, KVM) with KASAN: a route through a
dummy device with an LWT xmit program that pushes one byte with
bpf_skb_change_head(), so the headroom check has to expand the head, and
failslab limited to allocations under bpf_xmit(). Each of 10 pings then
fails with ENOMEM. Without this patch each leaves a raw socket behind
(RAW slab objects 6 -> 16); with it none does (6 -> 6), and nothing else
is reported. Without injection both kernels go from 6 to 6.

Fixes: 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101182343.17991-1-izaiahsun@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 548a13052e1fe..efec218bbe157 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -294,8 +294,10 @@ static int bpf_xmit(struct sk_buff *skb)
 			 * made before LWT xmit.
 			 */
 			ret = xmit_check_headroom(skb, hroom);
-			if (unlikely(ret))
+			if (unlikely(ret)) {
+				kfree_skb(skb);
 				return ret;
+			}
 
 			return LWTUNNEL_XMIT_CONTINUE;
 		case BPF_REDIRECT:
-- 
2.53.0



