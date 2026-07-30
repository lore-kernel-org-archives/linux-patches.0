Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B8B299929;
	Thu, 30 Jul 2026 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425873; cv=none; b=ax4J1/IKutj8dtfVEvRiLELPkAH1Dshy3ggjE3MApaBj7hgu4k2bDSxwQi4d2VakI7QQ80hozfiDRcecbQr/YhAOBxDBK4NvjtI/u1bVYVWf1GfeRs2PQ9fZC8F6yEGukatzVmEfCZdlkF6HJ1AlZXrvLvKv/tDuT5Y6S5Dpmq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425873; c=relaxed/simple;
	bh=ySm3CIQ/VVQ+xC5d/IJEsoFIW6+5AFJwmKFzH/CdS3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFCQKdu1ntcQXpvSfMmr91tSX2PwQNPY+eEMRsGqbFQYm3f8oUHSL+pDcWRjKHaUgaOD5OGxy4/T6lMzqYoS78y0ANXAmmMvIJpKw891WvN9V03Pn2zPE6KFo0gEZrOhOioanCJAD2wu5s8dGUiN1GoIpxzRN0DJEKK3pVf0Z70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHg24acu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHg24acu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90201F000E9;
	Thu, 30 Jul 2026 15:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425872;
	bh=zaAGhkEfIw4AwyP9D4gHKUBv7O1E2BM1P997DasYwFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHg24acuJsSR1lqKUkuGBrgCQ6oLEz+Deu5uquTsAMBs2zqVjETdc6ycG5RBaequI
	 uLyqr3kt5F14EoY07rPE2BYa8Y68evf3tsQfu6afgbqKNtZrSgEQ3WK3e1pCi0q+11
	 ot7odaXfYzNG2/eIY7KkPLOXep/gJ77iCNi1r3r4=
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
Subject: [PATCH 6.12 220/602] vmxnet3: fix BUG_ON in vmxnet3_get_hdr_len() for Geneve packets
Date: Thu, 30 Jul 2026 16:10:12 +0200
Message-ID: <20260730141440.579093193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e1e472b3a301ef..538738231a5a95 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1518,7 +1518,11 @@ vmxnet3_get_hdr_len(struct vmxnet3_adapter *adapter, struct sk_buff *skb,
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
@@ -1532,15 +1536,21 @@ vmxnet3_get_hdr_len(struct vmxnet3_adapter *adapter, struct sk_buff *skb,
 
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



