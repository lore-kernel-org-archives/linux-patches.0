Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704198;
	b=qF/45KurnepBLqNaSD8/s+T95ii2NfcBTIpFL8NpDSt7OLTjwINJH9wtOu+ae8omP6dj
	 83Aww0/zNocgOkuUkj92w8vOn6ARW/YqLRBVen/eu7+w8rQgQr+zcPIDEc6oSnS6RxKEl
	 DySGf1d+BMjN3dPN8Q7YzGt31zX4iq7e5p/TcX/ogIK5tZfCzKlyQK644LO1S4LUxZxQ/
	 sbizs2ctkE1mHFqqGz9MRRNmVujPlavEzxq9H0cEeRO4dkyLmFKmFCZ9FweJhWM0IqPkJ
	 028XekbiHuHJaKPJY1lC7W3/biy5RhNxQIofDc3XmlFNa+mCnROsgzRgChepwAnW5Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nUXdRhdJMdX/OrWsGlEtH71yxS0Paq7EmhHBkhfgE6o=;
	b=LUhRye/CVP3ZUo6L+wNS5DJZWhiB3Tm1f9BG6VnX77BSJWiRBFacSDPrxngrK8Bj6UzS
	 Je4WIaUbRr/7WW47oOVoRaWjD81crz8RjI+sk0fNVx5bhcpVc/WRfBau1zy37De5qWnls
	 wdM/MSZ2g28j9fRKCmlmGe0a+Qd68UFHeaLXMgSAHD/AvF0Ch8hW0QJXALN6EPujY5P6o
	 +8ip3K5RFSpD4mKAt6otrOXOEpm+CkckOmpCYXjtPHMZ30hoLya4FWBMoT+ODeGr1JRaH
	 TFUA9a8yi40vpzoIPpOnjs3lME1DNFkpqe+0Nb3sWAxoGmaumXsG7SLnSscakebkclA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1MLauk4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D378A606A31C;
	Thu, 26 Nov 2026 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1MLauk4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA041F000C4;
	Thu, 26 Nov 2026 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704198;
	bh=nUXdRhdJMdX/OrWsGlEtH71yxS0Paq7EmhHBkhfgE6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1MLauk4yObW7il8UqvCv3cqVyCoQt9EJso6qQBxw0ret9Lgq75NyQLW7lXjQ1EOLP
	 4s4SAHRX0SzqVdMgc2LUvP/yytaQrPJCz1rnbMPYULSRZm3WpI6+6s1Cxu5AoBQMta
	 qQTMWrBWxUKVXEtPzcHlXkMKHQ14nyVlWlXdF780=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/265] bpf: Dont leave a stale MAC header in bpf_lwt_push_ip_encap()
Date: Thu, 26 Nov 2026 15:36:09 +0100
Message-ID: <20261126143607.853977671@linuxfoundation.org>
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
index 7953a3d0f94e9..548a13052e1fe 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -639,6 +639,14 @@ int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len, bool ingress)
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



