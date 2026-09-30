Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CD25187C6;
	Wed, 30 Sep 2026 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791007; cv=none; b=DUZHvUKOYszeH/LNwJcnj8HJEDUB2VkCNepSfJddKa8H0S4vI55Bi/G4Xo5u7G6x5XxoiqwvNCI5R47iQToh0Kcle4+oQx3vKAESULqkkCaeSN6ihq2CR6CXZZ2ij+BJZ210WikqmXlRsYpFvch2cG3B6v/aQYZm4HR1Q2mJ+0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791007; c=relaxed/simple;
	bh=SYyN9NWdnt42dZLICWO+huysr5zVOvSNuFvxCNsXfEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkLhfs7GLs8p+DOi1tfbLL/wqfXwyzYDOWV63sNnaqKEAkR2VDGWE2KihxKbQQHw8iTa+LCGLuDCY4F13xccc8O0bGdccrMOkqD7iH8N5YqDEdFIf0bQDnWhdDAL3eQ8ORZC35a+v/FZ2HuVsA2sWHJbb/YMZn+a86+Qv9UoBhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D30EhFFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D30EhFFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CC11F000FF;
	Wed, 30 Sep 2026 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791005;
	bh=E9cedTrb1wwWR4D8uwS5ZX+sljGDd8kVlDaxiOBvGW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D30EhFFyp4KfmBFcsJ51DyJz7fb0FEk3C47ktqA7v+MfOvaTJSRUQ3prkhLee/f9I
	 zkVSdUqe/4zbz8yVaxkIFZh4ftr2PYsTnMhqnu1dYclo4hU02Z5W6Gy4wq8TLtNEet
	 jrxWCzPYQBCK7ZNHHZ9KwY7DpekCNn8EEHPr1mSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/752] net/sched: act_csum: dont mangle UDP tunnel GSO packets
Date: Wed, 30 Sep 2026 17:20:21 +0200
Message-ID: <20260930152401.452513942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit 9bcb30b389ec5888590cb6ec58c7a3b80fe49a11 ]

Similar to commit add641e7dee3 ("sched: act_csum: don't mangle TCP and
UDP GSO packets"), UDP tunnel GSO packets going through act_csum
shouldn't have their checksum calculated at this point, because it will
be done after segmentation. Setting the checksum in act_csum modifies
skb->ip_summed and prevents inner IP csum offload from kicking in,
resulting in a packet with a bad checksum.

Add UDP tunnel GSO packets to the exceptions, and also add UDP GSO
(SKB_GSO_UDP_L4), as the same logic as in the commit mentioned above
applies to UDP GSO too.

Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260611192955.604661-2-alice.kernel@fastmail.im
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_csum.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 277f6a93cc66e..fb6f49ce1ee00 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -257,7 +257,9 @@ static int tcf_csum_ipv4_udp(struct sk_buff *skb, unsigned int ihl,
 	const struct iphdr *iph;
 	u16 ul;
 
-	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP)
+	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type &
+	    (SKB_GSO_UDP | SKB_GSO_UDP_L4 |
+	     SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM))
 		return 1;
 
 	/*
@@ -313,7 +315,9 @@ static int tcf_csum_ipv6_udp(struct sk_buff *skb, unsigned int ihl,
 	const struct ipv6hdr *ip6h;
 	u16 ul;
 
-	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP)
+	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type &
+	    (SKB_GSO_UDP | SKB_GSO_UDP_L4 |
+	     SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM))
 		return 1;
 
 	/*
-- 
2.53.0



