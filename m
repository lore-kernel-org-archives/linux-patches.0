Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42AA12C47A;
	Tue, 30 Apr 2024 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476473; cv=none; b=TImDWvcqANlax3Ll7SYB5lc01JqPN2loa2kdLAvYbVJvQ5cp3NHbly8HMhZzCJ+4hgggnmphkKuAIrqk946DKQj4N1azjqEHPWEZHmiK5AC2yfeGr+/OypuJ4BHjpD1d90p3jWz6MGJ8bav6/j5UUjTjd5cji5XG/ZAOcp6kMkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476473; c=relaxed/simple;
	bh=CaFkkvnNE8XQgNgFRSLM2uCFCHzHdKzZtNdxmt+MgpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfBKX0SbQYKw0zwqAMQNA4/xEgo4IG7UIMrnuoInmUtZDV0cIf5aM49ZLLg82uItYNwW/1LHiGhiRNbPX18nnerycfM0HghYqc8fqJ6aobM7wHqULZb0y5Al0YsTzmlf/BqUxFlXfDwQsyD8CL4C8dRGfAN1ty5/lbxAFl9+GZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHhK1SlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHhK1SlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFA9C2BBFC;
	Tue, 30 Apr 2024 11:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476473;
	bh=CaFkkvnNE8XQgNgFRSLM2uCFCHzHdKzZtNdxmt+MgpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHhK1SlSpfwB4lHleKM8p03RaCOwhaD3UdB4MxA1Fwo7wL/zehBgtz0Xtn0FA+A35
	 6v6ojJ2GXV50BOVVvF57pY8PV7VDA74vI/KCPo5WKu94ljMHG8kx+ZUMlXakdvUOLq
	 uPVRoS0S2oH1OctPgHMdGr2Gfz+f6F9hN/Vg/gEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismael Luceno <iluceno@suse.de>,
	Andreas Taschner <andreas.taschner@suse.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	Firo Yang <firo.yang@suse.com>
Subject: [PATCH 6.1 042/110] ipvs: Fix checksumming on GSO of SCTP packets
Date: Tue, 30 Apr 2024 12:40:11 +0200
Message-ID: <20240430103048.809351402@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ismael Luceno <iluceno@suse.de>

[ Upstream commit e10d3ba4d434ed172914617ed8d74bd411421193 ]

It was observed in the wild that pairs of consecutive packets would leave
the IPVS with the same wrong checksum, and the issue only went away when
disabling GSO.

IPVS needs to avoid computing the SCTP checksum when using GSO.

Fixes: 90017accff61 ("sctp: Add GSO support")
Co-developed-by: Firo Yang <firo.yang@suse.com>
Signed-off-by: Ismael Luceno <iluceno@suse.de>
Tested-by: Andreas Taschner <andreas.taschner@suse.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_proto_sctp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index a0921adc31a9f..1e689c7141271 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -126,7 +126,8 @@ sctp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	if (sctph->source != cp->vport || payload_csum ||
 	    skb->ip_summed == CHECKSUM_PARTIAL) {
 		sctph->source = cp->vport;
-		sctp_nat_csum(skb, sctph, sctphoff);
+		if (!skb_is_gso(skb) || !skb_is_gso_sctp(skb))
+			sctp_nat_csum(skb, sctph, sctphoff);
 	} else {
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
@@ -174,7 +175,8 @@ sctp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	    (skb->ip_summed == CHECKSUM_PARTIAL &&
 	     !(skb_dst(skb)->dev->features & NETIF_F_SCTP_CRC))) {
 		sctph->dest = cp->dport;
-		sctp_nat_csum(skb, sctph, sctphoff);
+		if (!skb_is_gso(skb) || !skb_is_gso_sctp(skb))
+			sctp_nat_csum(skb, sctph, sctphoff);
 	} else if (skb->ip_summed != CHECKSUM_PARTIAL) {
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
-- 
2.43.0



