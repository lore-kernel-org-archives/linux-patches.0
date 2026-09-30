Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932E35111A7;
	Wed, 30 Sep 2026 16:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784548; cv=none; b=ZskZnRgqYQe0xYYWt6woPe12WedcBeTQrx5VvN7Wi2qRSzoUmvFRzynXVaNXA9Nm5H5KitYSkiPRZcHLOafrAK+nWagCuCg77zRFLP6//7Rwlr8956Vk2ZcQzbKXQHiXz0oFi8VdrOfvp0sovHZxMqgzPTiRjCTrzhIkIhwf1cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784548; c=relaxed/simple;
	bh=SOE8t3eDUqfEpyf9bBRuyPQheSAMo9TVFJwBby8gqPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3o0o8+UqaGplgtXI+OxFdxqSH3sNmWSTiaoQTpykHk7hNzYelxWpqqQUS2/zxpuPZWSTyIExRpH1+FhIHTaA6LHvkHPYA92ZeNQ5O4FoqheFZ5xu8l1P0qbJVz02+a3w+65TC9zmw6HUhvZrekB5PRNqioTj7IDg5mC9rH3+F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4V9gdJu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4V9gdJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8901F008A7;
	Wed, 30 Sep 2026 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784544;
	bh=xKnfUPEIr4Rt2JrjFVnDNEq+ksMW6Ky/vXer6k5U0r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4V9gdJumVvWcgZexrVPwtoyQF8HoOF87nSu4zc8EabMvmDZRIeEmP72AxKNhAWE9
	 h+GCN7/o97kVCw6f/HhQkJ1Ajkfmz2YwdpN0viR2DEtbICGmDHu0Z1YddYvexyzCnu
	 qPmiH4Ubr4K75/iNt9gz9f94QyRuwfFOsshXX6Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/982] net/sched: act_csum: dont mangle UDP tunnel GSO packets
Date: Wed, 30 Sep 2026 17:15:29 +0200
Message-ID: <20260930152420.960619923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bcef42a3ad645..4e4cf29f0c069 100644
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



