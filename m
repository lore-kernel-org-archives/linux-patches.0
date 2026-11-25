Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621105;
	b=g4qchhzy8sSCqQjsQ7xwhJ6KYMZLxgAO53PNwL5+ywsuhtyLG+35fpAeam70WARFiaFv
	 dbVIxBIJVMNB1DFsbGm1lZF53Q92GXPQC83H+YkI4hXplCRFiqFn5NKeTH+/IFuhDasjO
	 qeADsDE/X07lw0BA5xGSeMvoq4pt77yNS5J0jJRUn2LwzVtiRRjBRfS0owmWyNSM99Ncg
	 63brzEb23Z1kD9RBmR4QQoZU67Fv4L+2UinaW6LFYTNrEmoKgZTvDxoRrARLjdYpbUIJZ
	 GU02OZgePZ58LGK2vQ8ghqynzQ8yrjorI80i+GBtoWmXbOuNGhCoOlpdWfObLokLIkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AX2VK8Br1R7BbmK/Qggqwkn18wdTbh3EJw2EW3oJH2s=;
	b=rXwHWVTcWG+JHJxqL0Zp5vE4pZPg1Ylyzx5oa+d/sS5jSs6wznvPFaLIdIPEry65FFL4
	 oc1JVo9MEH+Kt1JUDXh3DSiZwGac9kPtdyk6YP1ZI6vbABP6lpQ213eHHf7UN8bZAdWv5
	 mpNYXb8yKvdrcKl10hm2WvEnQ2VVxjXSyMBxcPt78m7ql0DtA+gznYKUpmd6jSDGob807
	 zIEAHpUPtio1tDSsGWIYMTXD9i8vUQtZJ6s0yRJgScmrdiX4wq7+Bras2ys1vEwUSMYnT
	 PByWnNb3PtJL3REX1cnc9MgSh+AcKhk6jAAGZM4wJKsQwRe9e+OnHjxBlOLTpdoKLKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08xtOn1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB850606A31E;
	Wed, 25 Nov 2026 15:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08xtOn1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CBB1F000C0;
	Wed, 25 Nov 2026 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621105;
	bh=AX2VK8Br1R7BbmK/Qggqwkn18wdTbh3EJw2EW3oJH2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08xtOn1gF+jLY78Xe4mx5HK2zwWN6++HtbJt5JBNtSwVCksbCHvbjqVbjOfGmuji5
	 LEPv9LWUPN+jKlkZ4s5XMcyMtzMsvWb5AUNzMNQXqqpC3kxv9VDovqVFEmBL8TLDaC
	 7k2iIjS4ZSOV/6qFRSVTpGaC/q5LKx3XEwMrrS/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/990] bpf: Reset skb->cb after an lwt prog pushes an IP header
Date: Wed, 25 Nov 2026 15:24:51 +0100
Message-ID: <20261125143824.993645001@linuxfoundation.org>
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

[ Upstream commit b3ad42f6183286ab376389a5d26edf7ee3bdba27 ]

IPCB(skb)->opt holds the offsets from the network header to the IPv4
options. But bpf_lwt_push_ip_encap() moves the network header and does not
change IPCB(skb). Then ip_forward_options() and __ip_options_echo() use the
old offsets on the pushed header. Thus the kernel corrupts the skb and the
stack. If the family changes, the kernel also reads IP6CB(skb) as
IPCB(skb), or the reverse. With CONFIG_IPV6_MIP6, it reads IPSKB_FORWARDED
as frag_max_size and adds a needless fragment header.

Reset skb->cb after the prog. bpf_lwt_push_ip_encap() cannot do it, because
bpf_prog_run_save_cb() can restore skb->cb. For IPv4 in IPv4, clear
IPCB(skb)->opt as ip_tunnel_xmit() does. If the family changes, clear the
cb of the new family but keep iif, because ip6_forward() gets the input
device from it. Behind a VRF, skb->skb_iif is the VRF device and cannot
replace iif. Do nothing for IPv6 in IPv6, as in seg6_do_srh_encap().

Do the reset in bpf_input() only after a push. Without a push,
ip_forward_options() needs the offsets. Do it in bpf_xmit() before each
reroute, because an lwt_xmit prog can also change the options. Thus after a
reroute without a push, ip_options_fragment() leaves the options in all
fragments, and ICMP errors echo none. After BPF_OK or BPF_REDIRECT the skb
goes to a device, thus bpf_xmit() does no reset. The inner IPv4 checksum
can still be wrong after ip_rcv_options() changes an option.

Fixes: 52f278774e79 ("bpf: implement BPF_LWT_ENCAP_IP mode in bpf_lwt_push_encap")
Reported-by: Xiang Mei <xmei5@asu.edu>
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-23-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 7e011fd3a60ff..f215978d10a3b 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -86,6 +86,32 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
 	return ret;
 }
 
+/*
+ * skb->cb still describes the IP header that was the first one before the
+ * prog ran. The option offsets in IPCB(skb)->opt are wrong for a pushed
+ * header, and a header of the other family needs the other layout. iif
+ * stays: behind a VRF skb->skb_iif is the L3 master and not the port.
+ * bpf_lwt_push_encap() cannot do this, because bpf_prog_run_save_cb() can
+ * restore skb->cb after the prog.
+ */
+static void bpf_lwt_reset_cb(struct sk_buff *skb, __be16 proto)
+{
+	int iif;
+
+	if (skb->protocol == proto) {
+		if (proto == htons(ETH_P_IP))
+			memset(&IPCB(skb)->opt, 0, sizeof(IPCB(skb)->opt));
+	} else if (skb->protocol == htons(ETH_P_IP)) {
+		iif = IP6CB(skb)->iif;
+		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
+		IPCB(skb)->iif = iif;
+	} else {
+		iif = IPCB(skb)->iif;
+		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+		IP6CB(skb)->iif = iif;
+	}
+}
+
 static int bpf_lwt_input_reroute(struct sk_buff *skb)
 {
 	enum skb_drop_reason reason;
@@ -120,6 +146,8 @@ static int bpf_lwt_input_reroute(struct sk_buff *skb)
 static int bpf_input(struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
+	__be16 proto = skb->protocol;
+	unsigned int len = skb->len;
 	struct bpf_lwt *bpf;
 	int ret;
 
@@ -128,6 +156,9 @@ static int bpf_input(struct sk_buff *skb)
 		ret = run_lwt_bpf(skb, &bpf->in, dst, NO_REDIRECT);
 		if (ret < 0)
 			return ret;
+		/* An lwt_in prog can change the length only with a push. */
+		if (skb->len != len)
+			bpf_lwt_reset_cb(skb, proto);
 		if (ret == BPF_LWT_REROUTE)
 			return bpf_lwt_input_reroute(skb);
 	}
@@ -307,6 +338,8 @@ static int bpf_xmit(struct sk_buff *skb)
 		case BPF_REDIRECT:
 			return LWTUNNEL_XMIT_DONE;
 		case BPF_LWT_REROUTE:
+			/* An lwt_xmit prog can also write to the options. */
+			bpf_lwt_reset_cb(skb, proto);
 			return bpf_lwt_xmit_reroute(skb);
 		default:
 			return ret;
-- 
2.53.0



