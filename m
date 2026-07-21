Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D7F33A9FC;
	Tue, 21 Jul 2026 22:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673628; cv=none; b=N5BcbuIOSRjUr6H7EVS4PkZKo429ESVsquZz4/wnf4BboHDCnM9prEnIfkgCZ9yoajOZ1zOa7aevs//6t2w2OlZhBdhwZBz2ZF8vArydGfv0zetfZatZMu9c40mBKvZKjy+xdl2IqM6JAlBN8SZZumWjSrhybpNSoszha4DxVro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673628; c=relaxed/simple;
	bh=VVHQ6OR/Q6bvlCpk2X0kRsJp5bmViXA9sfzy6OQqahk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBSyrQx3gTAInNubMJXbVbvbQjMMO4bRl9wrPhFxReBpGnB02GMIWhNNARH8NsMf2gZBdCdPmTKnA197zyKKNrntDjCqRD47991/JuO6l6ZasKair3+8uakEQRp2evVfGDNV7BEYRGT9Z7mT4wpk0chz6fimWpQbUNVj06b0/20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeAd/sKZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeAd/sKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FF91F000E9;
	Tue, 21 Jul 2026 22:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673627;
	bh=kGx6CoMe+yGdEJldNtm7VS+kWCvdt/t7ibNt67BeGM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeAd/sKZ4PLEoDIfHZ+DFUeyiLLLF4L+XMcVrIPwIE/67mU97EMiOhxAUibzoY2KI
	 21AI3SX/hfBKhliwi2tf8wktc9FLAZK61456U2pY/Avb8GNpev4PyCAYQghRJwpk7+
	 LXYvRn60TKFV126Z26NTMfMJbEZJXC6V2IjzqPRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.huangfu@shopee.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/699] bpf: Update transport_header when encapsulating UDP tunnel in lwt
Date: Tue, 21 Jul 2026 17:19:54 +0200
Message-ID: <20260721152400.999977241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 82d7d0adbc678064543e9d254864f6b4ea4a388c ]

Currently, bpf_lwt_push_ip_encap() does not update skb->transport_header.
When a driver, e.g. ice, reuses the stale skb->transport_header to
offload checksum computation to NIC hardware, VxLAN packets encapsulated
by bpf_lwt_push_encap() helper may be dropped due to incorrect checksum.

Update skb->transport_header in bpf_lwt_push_ip_encap() whenever the
encapsulated packet uses UDP, so checksum offload works correctly.

Fixes: 52f278774e79 ("bpf: implement BPF_LWT_ENCAP_IP mode in bpf_lwt_push_encap")
Cc: Leon Hwang <leon.huangfu@shopee.com>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20260602150931.49629-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index f6c327c7badb4c..8c41532b4fe8fb 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -589,6 +589,7 @@ static int handle_gso_encap(struct sk_buff *skb, bool ipv4, int encap_len)
 
 int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len, bool ingress)
 {
+	bool is_udp_tunnel;
 	struct iphdr *iph;
 	bool ipv4;
 	int err;
@@ -602,10 +603,16 @@ int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len, bool ingress)
 		ipv4 = true;
 		if (unlikely(len < iph->ihl * 4))
 			return -EINVAL;
+		is_udp_tunnel = iph->protocol == IPPROTO_UDP;
+		if (unlikely(is_udp_tunnel && len < iph->ihl * 4 + sizeof(struct udphdr)))
+			return -EINVAL;
 	} else if (iph->version == 6) {
 		ipv4 = false;
 		if (unlikely(len < sizeof(struct ipv6hdr)))
 			return -EINVAL;
+		is_udp_tunnel = ((struct ipv6hdr *)iph)->nexthdr == NEXTHDR_UDP;
+		if (unlikely(is_udp_tunnel && len < sizeof(struct ipv6hdr) + sizeof(struct udphdr)))
+			return -EINVAL;
 	} else {
 		return -EINVAL;
 	}
@@ -627,6 +634,11 @@ int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len, bool ingress)
 	if (ingress)
 		skb_postpush_rcsum(skb, iph, len);
 	skb_reset_network_header(skb);
+	if (is_udp_tunnel) {
+		size_t iph_sz = ipv4 ? iph->ihl * 4 : sizeof(struct ipv6hdr);
+
+		skb_set_transport_header(skb, skb_network_offset(skb) + iph_sz);
+	}
 	memcpy(skb_network_header(skb), hdr, len);
 	bpf_compute_data_pointers(skb);
 	skb_clear_hash(skb);
-- 
2.53.0



