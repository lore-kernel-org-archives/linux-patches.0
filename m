Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624175;
	b=fsBE3D18hR3ksGlGNfQmRHQeJQN8Y9VcD2IvH2tj63iCq5AKJI0Fb/ot2k+3PFN3uQmA
	 uiEZhDk6LqlJVx0wA+kIoatqcgizz+7YPt/S5ftAQ4Y7/gbAI/HmziM2UlyPNkqafL5WS
	 ToYPyq0QIXg1iDmp56joISCgftNBr42jn91A6jstdmWH1USQdSNbE6w/xxBO5iaUIj9dJ
	 SGYi1rui9GKA4JFgxILBsZqN5Pb4aOK38tFgXjHjisfpEItglCLLbc7QyOZCM3JN5Bz5Y
	 KV2pkFDzzt48/OPiRrjqqK/Zn2+tcyAQxBthLJcB9Cbe2QieabDZAED9K6DP6ceD50g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NPFKpfN4z9gSQ2j0QNxQyB8j/RoxHUU8svrgs3WQSz8=;
	b=T65z4Rq/3qGfdqEr80+R4aDspyWOzrBEPX1yWbZFTk7B92mYnhKTdtLvQSsmOJlrB+bC
	 IbYlPxRlV82Z0/VVK8huznEFAxfmfA41HbkkNrbT8mrfr5lh6/UBP5JRt/mSZhUv8HQCm
	 cXJHYOHRqtVsIaj712KWUM3wQ98G2wBdDrOWkZqytY/tE0KVFybBICSalrCvilVI9PmtO
	 SCjhN+VtjwZ4FaTn7i4CbXm11zOYslva/87XotOwbC2B/m1Vvd1iOzG7JXkrwropPSiwq
	 j6ztZqldJFEtkDyfHP/rdLKfXnOmmmsRbBeCcP9q+m+D1mQy+fc4WwkhEWLOPN3G3qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jC/at/Ia";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94DC606A326;
	Wed, 25 Nov 2026 16:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jC/at/Ia
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA371F000D3;
	Wed, 25 Nov 2026 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624175;
	bh=NPFKpfN4z9gSQ2j0QNxQyB8j/RoxHUU8svrgs3WQSz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jC/at/IahWABn/Nl3MVDYj8BGMhDClkQItspnTU66ovzk/LVj/UbQ6Su1f6aC03b/
	 fvv2ADhmVvXCateQxBBzzCvTDQMcUGQAoNDn10z6W9PhpL7W7Rekn+5/WieJ7kFG8d
	 hHr1Aq0uDz8JnyoJyC5z+59EiLxmpMxuX2ClZ0mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/816] bpf: Reset skb->cb after an lwt prog pushes an IP header
Date: Wed, 25 Nov 2026 15:27:36 +0100
Message-ID: <20261125143851.713609997@linuxfoundation.org>
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
index 58bf664d99ebd..7b669f206abd7 100644
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
 	int err = -EINVAL;
@@ -118,6 +144,8 @@ static int bpf_lwt_input_reroute(struct sk_buff *skb)
 static int bpf_input(struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
+	__be16 proto = skb->protocol;
+	unsigned int len = skb->len;
 	struct bpf_lwt *bpf;
 	int ret;
 
@@ -126,6 +154,9 @@ static int bpf_input(struct sk_buff *skb)
 		ret = run_lwt_bpf(skb, &bpf->in, dst, NO_REDIRECT);
 		if (ret < 0)
 			return ret;
+		/* An lwt_in prog can change the length only with a push. */
+		if (skb->len != len)
+			bpf_lwt_reset_cb(skb, proto);
 		if (ret == BPF_LWT_REROUTE)
 			return bpf_lwt_input_reroute(skb);
 	}
@@ -305,6 +336,8 @@ static int bpf_xmit(struct sk_buff *skb)
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



