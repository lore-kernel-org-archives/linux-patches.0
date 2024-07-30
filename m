Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6853C1898F4;
	Tue, 30 Jul 2024 16:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356984; cv=none; b=D/0qUIqkqWys63Zm3sZiauZXz9BERhuZ2+6EuUSjw5C6a4cqTqYt9gnW0uV323EmPPoccN7BqPjZjvxXBOvdkJtd7u4FQkEA74xC8p4q/tgk0XuAi5cPMMzT7msy3+pG5gZbAJcL9EDpAXalk3NGMTX241v692Zd3iwLEy8PK9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356984; c=relaxed/simple;
	bh=MZbMUySNdxBZogDu+vLZGky1hlcMjVy34LzXR3x5VY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKn1v+tCWEgkVSDSuug+q1bav2wdVNLyP94UTv0QLnJzyxwLQmR4O7tM+UBO/y83PhqAx6JJR/Fca5+Po3MbM63hVz2Wb/amUpPgr+oL2vvVbt2YRt4tXc/78ZWfaS1q/YX+4+cAS+tMCLi0M08OQ20eHalOJ9Zi+jj75WZ4U9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqJ5RJwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqJ5RJwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D66C4AF0E;
	Tue, 30 Jul 2024 16:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356983;
	bh=MZbMUySNdxBZogDu+vLZGky1hlcMjVy34LzXR3x5VY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqJ5RJwWv1xBeBnp+gg3cJv1KKZF7j32nbB30k6GL13AkVyYqbsj/fsHKUAbmMsj8
	 QgoH8kNp3CLOioBYM2kiqublkvEX6bVmJGmIyz/1GqnjUwyq2SwCZ0BAgrx5T88foC
	 sOIQwphFKUbzrdSupFYhDUpnSuHT29Zgj39A3md8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismael Luceno <iluceno@suse.de>,
	Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 207/809] ipvs: Avoid unnecessary calls to skb_is_gso_sctp
Date: Tue, 30 Jul 2024 17:41:23 +0200
Message-ID: <20240730151732.782882870@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ismael Luceno <iluceno@suse.de>

[ Upstream commit 53796b03295cf7ab1fc8600016fa6dfbf4a494a0 ]

In the context of the SCTP SNAT/DNAT handler, these calls can only
return true.

Fixes: e10d3ba4d434 ("ipvs: Fix checksumming on GSO of SCTP packets")
Signed-off-by: Ismael Luceno <iluceno@suse.de>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_proto_sctp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index 1e689c7141271..83e452916403d 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -126,7 +126,7 @@ sctp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	if (sctph->source != cp->vport || payload_csum ||
 	    skb->ip_summed == CHECKSUM_PARTIAL) {
 		sctph->source = cp->vport;
-		if (!skb_is_gso(skb) || !skb_is_gso_sctp(skb))
+		if (!skb_is_gso(skb))
 			sctp_nat_csum(skb, sctph, sctphoff);
 	} else {
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -175,7 +175,7 @@ sctp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	    (skb->ip_summed == CHECKSUM_PARTIAL &&
 	     !(skb_dst(skb)->dev->features & NETIF_F_SCTP_CRC))) {
 		sctph->dest = cp->dport;
-		if (!skb_is_gso(skb) || !skb_is_gso_sctp(skb))
+		if (!skb_is_gso(skb))
 			sctp_nat_csum(skb, sctph, sctphoff);
 	} else if (skb->ip_summed != CHECKSUM_PARTIAL) {
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.43.0



