Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DD11B81DC;
	Mon,  2 Jun 2025 14:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875089; cv=none; b=pL8bgbWdAlGIzlekbJ+r0fXCgiq+hna1W+ynAQfo/57Er9bxcPeKPPHmCeRvuhtI90Cw/+GQ5tnD+ba+3mWdsOEoSVnzJ6vVm6Pe5302Zq0OzMJfdKlsOEGFMmgvW6YDDFj7vfthJupOaB8i3LYaVfa2mfGjysFY7p8VjULmE/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875089; c=relaxed/simple;
	bh=qeHGn7k4T3Fw+GU2J73t1Ycrl0v3Srj5cm0E4K2ivzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UR6IUd+kiKI8GcgtlysTLShBhI8OcwpM+gpwx2NijIhPfBRgyIsLrK3LFPnNw3FqqBg1faMtLKCUOgW9FnWae5tfGFBhKn8RHSOPIchUh3k9I4DVDW5n0ueu2EhWQVHPPr0Z89R5NpLtnr9ADU8aYY6SyDxU0+oqKFvZFe1q0Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoNvlkSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoNvlkSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6014CC4CEEB;
	Mon,  2 Jun 2025 14:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875088;
	bh=qeHGn7k4T3Fw+GU2J73t1Ycrl0v3Srj5cm0E4K2ivzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MoNvlkShs3vPR3MaUC8+MzYccPaDccHhkbq2CurPO5K3+O/SQfBuPRx2gyGKQP8FG
	 myzpn3YOWl3TVGR8p48BN9H17+sSTLPoH2fpc+tQfHuwItd+QTyIP9TajK0i6EerDj
	 gp6erv59yR/u+dcKQp7Yh8VUl2sHNyWFtDw5UPzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/270] net: ipv6: fix UDPv6 GSO segmentation with NAT
Date: Mon,  2 Jun 2025 15:45:09 +0200
Message-ID: <20250602134308.187284265@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit b936a9b8d4a585ccb6d454921c36286bfe63e01d ]

If any address or port is changed, update it in all packets and recalculate
checksum.

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250426153210.14044-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 61 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index b6952b88b5051..73beaa7e2d703 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -242,6 +242,62 @@ static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
 	return segs;
 }
 
+static void __udpv6_gso_segment_csum(struct sk_buff *seg,
+				     struct in6_addr *oldip,
+				     const struct in6_addr *newip,
+				     __be16 *oldport, __be16 newport)
+{
+	struct udphdr *uh = udp_hdr(seg);
+
+	if (ipv6_addr_equal(oldip, newip) && *oldport == newport)
+		return;
+
+	if (uh->check) {
+		inet_proto_csum_replace16(&uh->check, seg, oldip->s6_addr32,
+					  newip->s6_addr32, true);
+
+		inet_proto_csum_replace2(&uh->check, seg, *oldport, newport,
+					 false);
+		if (!uh->check)
+			uh->check = CSUM_MANGLED_0;
+	}
+
+	*oldip = *newip;
+	*oldport = newport;
+}
+
+static struct sk_buff *__udpv6_gso_segment_list_csum(struct sk_buff *segs)
+{
+	const struct ipv6hdr *iph;
+	const struct udphdr *uh;
+	struct ipv6hdr *iph2;
+	struct sk_buff *seg;
+	struct udphdr *uh2;
+
+	seg = segs;
+	uh = udp_hdr(seg);
+	iph = ipv6_hdr(seg);
+	uh2 = udp_hdr(seg->next);
+	iph2 = ipv6_hdr(seg->next);
+
+	if (!(*(const u32 *)&uh->source ^ *(const u32 *)&uh2->source) &&
+	    ipv6_addr_equal(&iph->saddr, &iph2->saddr) &&
+	    ipv6_addr_equal(&iph->daddr, &iph2->daddr))
+		return segs;
+
+	while ((seg = seg->next)) {
+		uh2 = udp_hdr(seg);
+		iph2 = ipv6_hdr(seg);
+
+		__udpv6_gso_segment_csum(seg, &iph2->saddr, &iph->saddr,
+					 &uh2->source, uh->source);
+		__udpv6_gso_segment_csum(seg, &iph2->daddr, &iph->daddr,
+					 &uh2->dest, uh->dest);
+	}
+
+	return segs;
+}
+
 static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
 					      netdev_features_t features,
 					      bool is_ipv6)
@@ -254,7 +310,10 @@ static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
 
 	udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
 
-	return is_ipv6 ? skb : __udpv4_gso_segment_list_csum(skb);
+	if (is_ipv6)
+		return __udpv6_gso_segment_list_csum(skb);
+	else
+		return __udpv4_gso_segment_list_csum(skb);
 }
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
-- 
2.39.5



