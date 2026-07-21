Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB23305E3B;
	Tue, 21 Jul 2026 22:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671602; cv=none; b=BuP1PMeFY/g+0AXdtvAomhO/9HkFKtHNK1qlukj/+y0svkc9iAfw6MzrvDu8Ck1xYk46yJnn+iBQhfLYLzDfN0xmPkpW2aLutVuxtCVz+xqxMORqnodi0gy5DKTc4lDu+jaXThbq8gEwBxCvIMRc+Le2SuMIJb2JVpyPR3+SpxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671602; c=relaxed/simple;
	bh=gHHIPdzbWx9T1YimfijdkoJTTCCk3vgocDOuJola1lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LN4d0u75nKDZR0CF12Jvii3XPK8/zVrycajMOFOrvJ0yCsI7LVXh9JaSt6BkjGNqLFU3CEPmT/gAx6VBlZxEkQdVm8i4d9p1mYmhIRLIqICbAAR+lzh/eMZVEA92Gk6LB6p5u2nsdBM0mXxOSS9KeAUZvIwz6tJ2s+U8RySd7J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WssRfx+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WssRfx+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFAE1F000E9;
	Tue, 21 Jul 2026 22:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671600;
	bh=IyTJDRsfLn5pN4Q4vJoobeNyLBAUBtnVz/WKBDvD/Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WssRfx+gyzwEsBV4zTFdSAjVEP2LTqW6iXSWxvi39vciizjjo22cQ/myrtuu4B/Tr
	 Jl3dDJ35IA096Vgej7LEcO0hH3CEipxSTsl9QEOne84LPbisthfSwXc75j7Y3NulfD
	 NPdYUAmQbdm9A6wSeUsPi7DQjaR73PSu44xwFFio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.huangfu@shopee.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 306/843] bpf: Update transport_header when encapsulating UDP tunnel in lwt
Date: Tue, 21 Jul 2026 17:19:01 +0200
Message-ID: <20260721152412.910615645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



