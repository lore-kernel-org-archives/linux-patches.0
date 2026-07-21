Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ABC46D081;
	Tue, 21 Jul 2026 17:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656380; cv=none; b=mU8dOwn1XUJmZ+K4GrFnoq0I/Lcx1pUrf4rLfwNpe9KuziL5v40/okh1jcq3KdZMsgaJ21z7lujjGCDH9tfhzWn8viaTkmpBpGn/yU2uoBoMGRDzibi98Iw3dLsbsqtB19YIrNcb9juAFXRvNNfztexJkjUdJju0k8YVVblhA8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656380; c=relaxed/simple;
	bh=UAKgfBcNbz/56rU1bZYF/WH/fwD1FSvarAnbtogswKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sO9vtFLSVLeRTz4At+p1EyeLGXdt2q2A0g8emeLA6DP8HVFFoEW8UhE0c/GLMi2+3I6+fbAinYc8Nw/Fo28hsOf2J+KsSfmZOvhthqrkWE6VK8C4My2RpXRamoxg+hpnA8IrseNH4J6pee6HQB3ghCViJAGKEAZkfvOBKkGgjkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVy39ynG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVy39ynG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1E11F0155C;
	Tue, 21 Jul 2026 17:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656379;
	bh=x+z+rEluuHdQYJqwoJ4QS1X0y1gaXSdIkDRXmleMsuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVy39ynGeYIYT7dQokjpHp6SmpFnftnXmLDGYG5LfNDSuIKjkg73+29oiJLqJJSYl
	 ZXN4Z9ybRZ8JtfuXw+lspuy5ds7E0fIQ90636lDk6KZrFdXDCORliFKjVdozfPjHhM
	 rI+8uMeF9RBG4/Qxgd3qax0aMOlpTJLWhhDWOdvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.huangfu@shopee.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0364/1611] bpf: Update transport_header when encapsulating UDP tunnel in lwt
Date: Tue, 21 Jul 2026 17:08:00 +0200
Message-ID: <20260721152523.346450069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 9f40be0c3e71dd..2efcda93d1397d 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -595,6 +595,7 @@ static int handle_gso_encap(struct sk_buff *skb, bool ipv4, int encap_len)
 
 int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len, bool ingress)
 {
+	bool is_udp_tunnel;
 	struct iphdr *iph;
 	bool ipv4;
 	int err;
@@ -608,10 +609,16 @@ int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len, bool ingress)
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
@@ -633,6 +640,11 @@ int bpf_lwt_push_ip_encap(struct sk_buff *skb, void *hdr, u32 len, bool ingress)
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



