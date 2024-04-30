Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B877712B176;
	Tue, 30 Apr 2024 11:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474965; cv=none; b=l9vHmCtG+xH8vR7Mztz702MPv5x3OVv1/SF87552sm4r4LCehQIa4dL3WIl/8uOnmzfSBNAZlFE9CV3o36icVa1oMXZg4Ud4ZNUPIXeBb4/wZOCobP66PRvM6UxSVjHh20th1kY39Sq2IeCfoG/J1aJzosL1JbjoVtC7mkqBvlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474965; c=relaxed/simple;
	bh=mWcrr9HsUxegn5ZoR+IdTjdDpyKIL81x+I4fhSUmOmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/Xo6/xWhrhdVMZ3Li+eN5mpm3iNBZL9wy0Yu9E/YnCG3sIEie6yY+WVPw6jX2mLR9F09GniGj0r4dm1UHfKaHxW6T7YVi+nmVQgnrZjNpqyoX2SUOQCD5Z3J65ijdeYGQFBkG2l81aRx6QqWWmiVnkPNdpiQxAG34QhkB5U2Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGlzX6gW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGlzX6gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D05C2BBFC;
	Tue, 30 Apr 2024 11:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474965;
	bh=mWcrr9HsUxegn5ZoR+IdTjdDpyKIL81x+I4fhSUmOmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGlzX6gWZmmjkmUJPc3ttObp6gMePBxzbRGt19Ql8KYQlYP6E2X2BtEVkf7lQUHf6
	 PiRQiwtG7rns/hS5yXxrFR9F5UB8/xmpmHDz+rrw/mPz+NLl9d70E9lV5JxkR5tmJn
	 q5rjMX9Xg8kDG/nhsSTDQ058qAe2fIvZ3njem2Tk=
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
Subject: [PATCH 5.10 091/138] ipvs: Fix checksumming on GSO of SCTP packets
Date: Tue, 30 Apr 2024 12:39:36 +0200
Message-ID: <20240430103052.098134575@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



