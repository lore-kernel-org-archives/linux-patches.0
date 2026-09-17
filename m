Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952C819F40B;
	Thu, 17 Sep 2026 18:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668085; cv=none; b=CWgJepZJrOVGV9wGCb3PBl5sDJNAIbv2JephNml4jOhr+MNA4YHJ5sK0xl1tGibVgPgULIm4lNCmC56K48NLHYx5mv91ob3F6mIHRMC/ELvJbRXdfOGMP2FDzbDzs8iuocKQvVnO/htHp+wHz3oTEaBgWv9rxAO5LgD+LKsmlpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668085; c=relaxed/simple;
	bh=yguuVRf2ByFwy7RlHzCQe3NCKRkuI4coY/AXjxYwYqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzFHJ9U5lnFWbnZ05BzDQzWsiLxI4PEKIVYfr5aMdQW2frEGdzak5vu7lAhar0tQvxM8aozpq9yxZhmbtvmC9QDEco+PUnRx2v+s7UhU+dVzv+yWz2iYpTtQkk0OqueBm9ZIrtbZ6oWKkT51bfgDg4A1O6hxRqezW7T6vH5CvZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYEPdFGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYEPdFGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D00A1F000FF;
	Thu, 17 Sep 2026 18:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668084;
	bh=N8YxGQfzDqVP+BAgaVai0tyq2n6EDGg8snVBzxLDSrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYEPdFGtInUTjCNSd6d3wWXEviCU1KJ/nYuSHDDj6EcQ12KryttWFIn0XFb/By+xt
	 offnODOLdhWOglpr9VMXaBijsTRjSdm6Jn/y/fIS2JucFQw1HXDHzgYxABqQqHytjo
	 jxdCqnNLXdfpsRJ2qvAE01s6uel7+c5YcM1ifnr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0308/1102] net/sched: act_csum: dont mangle UDP tunnel GSO packets
Date: Thu, 17 Sep 2026 16:04:11 +0100
Message-ID: <20260917151547.353847680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 8ea37c2c3c549..653ee0d4c9eea 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -258,7 +258,9 @@ static int tcf_csum_ipv4_udp(struct sk_buff *skb, unsigned int ihl,
 	const struct iphdr *iph;
 	u16 ul;
 
-	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP)
+	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type &
+	    (SKB_GSO_UDP | SKB_GSO_UDP_L4 |
+	     SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM))
 		return 1;
 
 	/*
@@ -314,7 +316,9 @@ static int tcf_csum_ipv6_udp(struct sk_buff *skb, unsigned int ihl,
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



