Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211140;
	b=RbNztLvO6vxl+uUritTDDT+RfFbEEBJp9AKOO+/odU27BdSNZnyLbWQeWp3yAR8iXtkk
	 uPppmQMt+rWTFJC7takLcThqnKsk7fdU7+PwI39nxaxqsUoGhFAsA3ZzDcqnGuD9EaMGw
	 pImdQjWmHiqJbGf0RfwDGcU9aL+GS/+98Ge5XFeknpYoBcPARLSBhrQTJX3kS7gE30T9v
	 ZPF9Oisv/zWLtFhiKMGIjXmjLEXaNJYjMwqH1yeVr2Tgez6phe74g/hHNyazy3ENGriVc
	 NlGVQTTIiuDBbmImJ8akiniLpV6Aw7aKg/HVItVeGR2cfBKUQSAos2hD0DQdKpcmE2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BQG6w4cWXXT+sy6d3xdm/vKGHBRWUI0a5Ww++d9Zcfc=;
	b=txiVPK41UhrjY0paXbxUNNfFJH/53/sSeeT94WiMjzw0kJ5pZALL2Yh6LTUweg2zdCeQ
	 1vyP4MMy5zHlOU8tZE4eHXmYuDbQvSlUGPomST9IsVS2bfD2+rQ2SC0sgVgQd6YNYe/xn
	 8eumEV92fLpgDMdvTibxYdzzyrXmo24T1nYDCFZEp5ArRavnsyk9IGPWRJAZk137HCNXu
	 Fi8r/Xv7yUhrF/rMBQVODPtHuVDJvzSdKbf+hNhFygUIlE2w5EPDVUBx0ZYGkbHT/C0GP
	 S1oCXN+56ZMtgxxl61LMvuCNdBb7xVTPQqasXWO/wOyte2xcZp3CZ7ct2ta0mkoJHTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CTBwXdN5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617D2606A96C;
	Wed, 28 Oct 2026 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CTBwXdN5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04211F01825;
	Wed, 28 Oct 2026 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211140;
	bh=BQG6w4cWXXT+sy6d3xdm/vKGHBRWUI0a5Ww++d9Zcfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTBwXdN5LtSmgBZMjtTJqWY7Xymoc+2ZByVVh2r1KLq2/wgCMTQFKK2R52h3eUqSi
	 eX56b4LyJDX+ksAi0zKDo8NhwP4hu6wjAIz6oK5lpTIeKJWclA3qe2oA6bfJhVQInk
	 Z0w4liTK6MT1VIxoB2QIXDL/HFBmr6GcFhmI5jFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Julian Anastasov <ja@ssi.bg>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/571] ipvs: bound LBLCR and LBLC cache growth
Date: Wed, 28 Oct 2026 17:56:16 +0100
Message-ID: <20261028170013.437359743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 2a3c3de660f96865f303fd25f1285f2ffbfd521d ]

ip_vs_lblcr_new() and ip_vs_lblc_new() create cache entries for
every previously unseen destination address. The table max_size only
tells the periodic collector to reclaim entries after the cache has
already exceeded the limit. It does not reclaim entries that the
attacker continues to use.

Reject new cache entries once either table reaches max_size * 3 / 2.
The extra headroom lets the periodic collector catch up while the
existing scheduler fallback continues to use the selected destination
when cache creation fails. New traffic therefore stays serviceable
without growing the tables further.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ sashal: Retained kmalloc() instead of kmalloc_obj(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_lblc.c  | 3 +++
 net/netfilter/ipvs/ip_vs_lblcr.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 9b0832f56f14e..49ff1f9fe1474 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -207,6 +207,9 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 		ip_vs_lblc_del(en);
 		atomic_dec(&tbl->entries);
 	}
+	if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
+		return NULL;
+
 	en = kmalloc(sizeof(*en), GFP_ATOMIC);
 	if (!en)
 		return NULL;
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 7469547c8a440..6feab18861e16 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -365,6 +365,9 @@ ip_vs_lblcr_new(struct ip_vs_lblcr_table *tbl, const union nf_inet_addr *daddr,
 
 	en = ip_vs_lblcr_get(af, tbl, daddr);
 	if (!en) {
+		if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
+			return NULL;
+
 		en = kmalloc(sizeof(*en), GFP_ATOMIC);
 		if (!en)
 			return NULL;
-- 
2.53.0



