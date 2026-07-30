Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F214450414;
	Thu, 30 Jul 2026 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427608; cv=none; b=SmAu9RnygXJnaBU/8OFAOAXPJD4qcQhNTFgg1EzLRfAqrKHMJPLeySc/hDwcuiXvjrPEWT2PtWjYWimHPUMvfFBlxd5VTVdZkCYtJ0An6bWNEOgMAxvNw+vL8PkTJxbOqt6dUSe290ohTn1DMrSN/yv0EN7YIqSzXi4pH5S7f9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427608; c=relaxed/simple;
	bh=KaAYwVjdDjeL/FzAbag/FiQFscyiJprb0xCOf2YhNCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RG5LVFjPvQ/j1nX5UwIs9ccLcntOafHAD+ikbPp7zdloL/MROtnjd8JcsC6CLteDbgQ/j5tYrg4kK1JL6HtQcTtVrgpS9uMw+2p7O3Xg3zIqmR+Aw+oYhLE+E3RsWxAbk30EI7lHF/5ZGEYkkqh3k5ENaMk+Mhx2Eohl0IKI+P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVM53Hrn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVM53Hrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D3F1F000E9;
	Thu, 30 Jul 2026 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427607;
	bh=AStxKpjYGjOig59BUjbrNPFxpPeYPktu9vXIRxI+bt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVM53HrneZ+bDisXtPJ8oyPcS+3iAun/LL8WRrF9f/8Uy8u/Wmyqr7jYynBFsqTVr
	 cQPmHONqnImyb0A6qyYoP05ZfJC1oNvRW+z/Tjo6AjKukcDVjZNlMAMYFv6mVh1UvN
	 Sd2cOxKunyYTXOiHmFSDd+RCnEgwmJDTvMuHEh9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshaka Narayana <harshaka.narayana@broadcom.com>,
	Ronak Doshi <ronak.doshi@broadcom.com>,
	Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/484] vmxnet3: fix BUG_ON in vmxnet3_get_hdr_len() for Geneve packets
Date: Thu, 30 Jul 2026 16:11:22 +0200
Message-ID: <20260730141427.484978174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshaka Narayana <harshaka.narayana@broadcom.com>

[ Upstream commit 34a71f5361fc3adb5b7138da78750b0d535a8252 ]

vmxnet3_get_hdr_len() assumes gdesc->rcd.v4/v6/tcp always describe the
outer header, but for a Geneve-encapsulated packet the device can set
them based on the inner header instead, signalled by the
VMXNET3_RCD_HDR_INNER_SHIFT bit in the completion descriptor. Since the
function never skips the outer encapsulation, this mismatch triggers:

- BUG_ON(hdr.ipv4->protocol != IPPROTO_TCP), because the outer
  protocol is UDP (Geneve), not TCP.
- BUG_ON(hdr.eth->h_proto != ...), when the tunnel's outer and inner
  IP versions differ (e.g. outer IPv6/inner IPv4 or vice versa).

Check VMXNET3_RCD_HDR_INNER_SHIFT up front and bail out, since the
function cannot locate the inner header it would need to parse. Also
convert the remaining BUG_ON()s in this function to return 0
defensively.

Fixes: 45dac1d6ea04 ("vmxnet3: Changes for vmxnet3 adapter version 2 (fwd)")
Signed-off-by: Harshaka Narayana <harshaka.narayana@broadcom.com>
Reviewed-by: Ronak Doshi <ronak.doshi@broadcom.com>
Reviewed-by: Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260713140915.3381715-1-harshaka.narayana@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 68b8e458a88f6a..16af7c4f8eda59 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1457,7 +1457,11 @@ vmxnet3_get_hdr_len(struct vmxnet3_adapter *adapter, struct sk_buff *skb,
 		struct ipv6hdr *ipv6;
 		struct tcphdr *tcp;
 	} hdr;
-	BUG_ON(gdesc->rcd.tcp == 0);
+
+	/* v4/v6/tcp then describe the inner header, which we can't locate. */
+	if ((le32_to_cpu(gdesc->dword[0]) & (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)) ||
+	    gdesc->rcd.tcp == 0)
+		return 0;
 
 	maplen = skb_headlen(skb);
 	if (unlikely(sizeof(struct iphdr) + sizeof(struct tcphdr) > maplen))
@@ -1471,15 +1475,21 @@ vmxnet3_get_hdr_len(struct vmxnet3_adapter *adapter, struct sk_buff *skb,
 
 	hdr.eth = eth_hdr(skb);
 	if (gdesc->rcd.v4) {
-		BUG_ON(hdr.eth->h_proto != htons(ETH_P_IP) &&
-		       hdr.veth->h_vlan_encapsulated_proto != htons(ETH_P_IP));
+		if (hdr.eth->h_proto != htons(ETH_P_IP) &&
+		    hdr.veth->h_vlan_encapsulated_proto != htons(ETH_P_IP))
+			return 0;
+
 		hdr.ptr += hlen;
-		BUG_ON(hdr.ipv4->protocol != IPPROTO_TCP);
+		if (hdr.ipv4->protocol != IPPROTO_TCP)
+			return 0;
+
 		hlen = hdr.ipv4->ihl << 2;
 		hdr.ptr += hdr.ipv4->ihl << 2;
 	} else if (gdesc->rcd.v6) {
-		BUG_ON(hdr.eth->h_proto != htons(ETH_P_IPV6) &&
-		       hdr.veth->h_vlan_encapsulated_proto != htons(ETH_P_IPV6));
+		if (hdr.eth->h_proto != htons(ETH_P_IPV6) &&
+		    hdr.veth->h_vlan_encapsulated_proto != htons(ETH_P_IPV6))
+			return 0;
+
 		hdr.ptr += hlen;
 		/* Use an estimated value, since we also need to handle
 		 * TSO case.
-- 
2.53.0



