Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624166;
	b=jca5j6+z6w98YRU5P6jExzsSQ4mTasSV/lHWeMzHunPz/5TEUYNJFTXjdbu59KeKGc/T
	 QOtE/voP6EfbWg6ryQ1BValoHYhPXq2gve59CE2708cl1c7kIiLIFo+kKiuiX1A7dpm0K
	 BJjBbBmuVmWtLpMiZUCdn7FtAH/+tqSXY4GlF6ydx4imjP6/yrmutGomrQdbxUA/H1NPd
	 l5vay/ceTXAFBff9ewIWP3hcOD+tHd9D2N4rhYyVs9Y/a4sQKukrux+OiZyt1UnRoi8JP
	 pd8EPTisQ/NkyGwp0SM/NA5BPqV2HowRuVVz+pLzLiTotLm6aUlIYX01qKwj/g7ozDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CZH2wT9vqabgS3h22RxQPZ/Hpap+6AR52tTQ+e75Lqs=;
	b=CGP3ie/PBaWS3HHuY0enPsDh3qgZXmrR1YWhUpo0jzUoQyUXb5phW5e69cJhBrRLByQh
	 pkn0Iu0vEjo0kcB6DAcD1S+XrA64P21x3QXI0crszKs+JApBtvF+kXRP/nSISdrM8MbMe
	 c4lG1QXo6yOGJR6XjnhLrpWwr91uyiY4wBRBDkG/oEsAgTSZMfNU6ZjGwPfz0cFZlvrFu
	 44VGZ2O4WxdLmRmuORBEVWxkmlQKUIk9tj67Ic6tc+V1IvWwGUtPVZPSPTWTpVCD3jM8B
	 LfvFedpuhNtJQ+6DeXgriUBT5+lDxhOG9dMPhcwA9CYKOPP4vVMdrSwCuqXpump7jhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzDnCUs8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E465606A326;
	Wed, 25 Nov 2026 16:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzDnCUs8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276E01F000D1;
	Wed, 25 Nov 2026 16:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624165;
	bh=CZH2wT9vqabgS3h22RxQPZ/Hpap+6AR52tTQ+e75Lqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzDnCUs8v7Rqq8feZNdnkBPHCn+Nr5THrqeYIKRMTyOuZchuDM5gmtXbV9pAyJMmw
	 e5CeFipq1i2HaicQ+wRAQuHGbG6NL+JWiV/DI5kS/6a2bkoYrrNo8Ph0VQwqCLue48
	 wVDm9L5k5RwTuNkDDVxukoYjiI1wKPhNT1cYcNtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/816] bpf: Dont leave a stale MAC header in bpf_lwt_push_ip_encap()
Date: Wed, 25 Nov 2026 15:27:34 +0100
Message-ID: <20261125143851.667718541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d80899233441d..4978dcf6ffc1d 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -642,6 +642,14 @@ int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len, bool ingress)
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



