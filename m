Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FA44F391B;
	Thu, 17 Sep 2026 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661090; cv=none; b=oDdJWH9UsoP0MTCjcS5ra8Pa2hUj9TLKIk1Mcl0JMulvXQR75n+9EPeM21UnB4WZ8WoHzDEVJhKhZOFX2n0t1+lGXZcM8iLQ777QtCrs4fa+ILWnq1iew1LQh55/g6+ZVxnBgLynPdEDL4bs4A2oqJOXxYuoFIANNrQtmqcK6DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661090; c=relaxed/simple;
	bh=1LsmVAh/whLBTWtV3SaNJqvbfLkrQQoTlvqenhaJ/s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zbvvz3ieYzyMEy1+WIxEaCHLdbuDuaYciOBoW7zKXcrmZTvr/wwo37/n1sfJgYVbjWFCy0afvTXnoEJxILa7e1HGKIcXSf97iWuNGXUJVZG4Q72Plu7TWRCP27ZWGc2qWvb/y0iLWtNj9rLz5LOpvw9aDMiJE2Ni2LKkPeXrDl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFQGby+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFQGby+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E840D1F000FF;
	Thu, 17 Sep 2026 16:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661089;
	bh=lpq8b7QdIoE0O0m4ibl+SZ8lI1r2atBsksQ+OCmQtiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFQGby+s4RAJZzQ1tIxin86AGeoeznsI11JB09EXNO+MTE44iW4eE4q2vyrFas9R/
	 ooE2ity4zarirgXqKUp98/ja/dS10Vby7AkVgGnVj2TuhEFLZOZRUKMzV7iSgO84aT
	 m2v70mk34+qm93f4IJsnttq9Tnwmi4uTWUSAi4Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0038/1250] psp: validate IPv4 header fields in psp_dev_rcv()
Date: Thu, 17 Sep 2026 15:57:13 +0100
Message-ID: <20260917151552.967458351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c2b22277ad897d21341f502f87fccd905ff4e207 ]

psp_dev_rcv() is called from the NIC driver's RX completion path
before the frame reaches ip_rcv_core(), so the IP header has not
been validated in SW, yet. We expect that the device has done
all this validation, but let's also add the SW checks, to avoid
surprises.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260428205352.1247325-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/psp/psp_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
index e35c31977479c..afda9cb660275 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -294,6 +294,9 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
 	if (proto == htons(ETH_P_IP)) {
 		struct iphdr *iph = (struct iphdr *)(skb->data + l2_hlen);
 
+		if (unlikely(iph->ihl < 5))
+			return -EINVAL;
+
 		is_udp = iph->protocol == IPPROTO_UDP;
 		l3_hlen = iph->ihl * 4;
 		if (l3_hlen != sizeof(struct iphdr) &&
@@ -347,6 +350,9 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
 	if (proto == htons(ETH_P_IP)) {
 		struct iphdr *iph = (struct iphdr *)(skb->data + l2_hlen);
 
+		if (unlikely(ntohs(iph->tot_len) < l3_hlen + encap))
+			return -EINVAL;
+
 		iph->protocol = psph->nexthdr;
 		iph->tot_len = htons(ntohs(iph->tot_len) - encap);
 		iph->check = 0;
@@ -354,6 +360,9 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
 	} else {
 		struct ipv6hdr *ipv6h = (struct ipv6hdr *)(skb->data + l2_hlen);
 
+		if (unlikely(ntohs(ipv6h->payload_len) < encap))
+			return -EINVAL;
+
 		ipv6h->nexthdr = psph->nexthdr;
 		ipv6h->payload_len = htons(ntohs(ipv6h->payload_len) - encap);
 	}
-- 
2.53.0



