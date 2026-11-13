Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585369;
	b=tUA7+Q+5dCQc545gyHKfLZCHuYLIoeanvTwyeiz2HOFOZFx/cDKb46qub/8QPqQPvFfF
	 WYXBOfaAPTglPrSLYS5k4NpnCBfHDotd/uLPhifDYFRfdtN1VHyh/Psee+rdwvCl2Rrh5
	 U74LYb75QqbrtmfVyRcWYmKnYm/NBfiKHgorv1GTLjtkN1Cb0fVf/WNsBR3TSh1AefXaq
	 UVUSq7ppGg7e2kRmXEYQ+GAoT+NSOGVivSp/ZZj+RsvNQ/piVTxfR4kGinJaKRRTU2zrV
	 zJT+lmcUJIKQtN1G7ONvE6nX7IA+U2RhAxCDHhT4oijHHHg8FPKiYBgf+Lh6osDTTwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1wJalXhX2XBoBQZXlA/NIA7nqgus6Z2cDcGVT5KKqds=;
	b=TlQQ3shp5fXSuuT/39NZSoPtA2qOiOipFsd4vV+n76FWW5/VezfPAoNZaFtdjdGUiPfg
	 YhCPzpCY8zJNLzvJ96JKVgrBRLLD/8gHkk6BaweWBgegbVZx1m6JiF9Fw5H1/QT3jzxpk
	 k9XLM0xe79sf9L+GTDdeJwKi2L3IcYdrOjT2cpjoguLQov+vhZDr/dJQ46uGNElMNyfvs
	 uyf7uqAGI0Gkzv1N0FBXIH5jIT9eRfzh3YCI3YxxzDB67SjKoCmlSrcOCLzu+bHHq1EtW
	 4id11PMbRMnDF2766a0/NHf7PweOWOCkwNuEicOQWd3AIgIF548m02CyrFzYIABBExQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NnVa0dSV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5647F606AE02;
	Fri, 13 Nov 2026 15:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NnVa0dSV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D711F000D4;
	Fri, 13 Nov 2026 15:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585369;
	bh=1wJalXhX2XBoBQZXlA/NIA7nqgus6Z2cDcGVT5KKqds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnVa0dSVzGs5coFS9wqlWEl1cE2lK1zD3ZyceSOq/2TJXZD0R3iJX3TPNpHbclqVW
	 ZfLAgs1x5ls4tmS+1QTrN2GJkkJboHl2Hd80JjWN86RpD2Zh+KvgGZKun+wv3uFHcc
	 agNeR1v0ddzuxUadzipZmwKp8DNQOGq9fo1HPwT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 045/507] xfrm: retry inexact policy lookup after node reinsertion
Date: Fri, 13 Nov 2026 10:45:49 -0500
Message-ID: <20261113153755.082320664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit 868f63c8bfafa9b827168c9126f85264c39c02ec ]

An inexact policy lookup first records pointers to candidate hlist heads
and then traverses the lists.  A concurrent policy insertion can merge
inexact tree nodes between those operations:

  lookup                         policy insertion
  ------                         ----------------
  find inexact candidates
    save obsolete hlist head
                                 write_seqcount_begin(&bin->count)
                                 merge inexact tree nodes
                                   hlist_del_rcu(&policy->bydst)
                                   reinsert policy->bydst in survivor
                                 write_seqcount_end(&bin->count)
  evaluate saved candidate list
    miss the moved policy

The merge immediately reinserts the same hlist node into the surviving
tree node.  RCU keeps the policy alive, but it does not provide a
consistent view while its list node is moved.  A lookup that selected the
obsolete list can observe it empty.  A lookup already traversing a moved
policy can instead follow the next pointer rewritten by the reinsertion.
Either case can return an incorrect IPsec policy result.

The per-bin sequence counter already brackets calls to
xfrm_policy_inexact_insert_node(), including node merges.  The read side,
however, currently validates the counter only while searching an
individual rb-tree.  A successful search returns without validation, and
the later candidate-list traversal is outside that read-side section.

Snapshot the per-bin sequence before discovering candidate heads and
validate it after evaluating all candidate lists.   Retry the lookup if
the inexact policy tree changes while it is being searched.

Fixes: 9cf545ebd591 ("xfrm: policy: store inexact policies in a tree ordered by destination address")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 513c9f2283347..f6f40ba713d5a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2157,6 +2157,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 	struct xfrm_pol_inexact_bin *bin;
 	struct xfrm_policy *pol, *ret;
 	struct hlist_head *chain;
+	unsigned int inexact_sequence;
 	unsigned int sequence;
 	int err;
 
@@ -2191,12 +2192,18 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 		goto skip_inexact;
 
 	bin = xfrm_policy_inexact_lookup_rcu(net, type, family, dir, if_id);
-	if (!bin || !xfrm_policy_find_inexact_candidates(&cand, bin, saddr,
-							 daddr))
+	if (!bin)
+		goto skip_inexact;
+
+	inexact_sequence = read_seqcount_begin(&bin->count);
+	if (!xfrm_policy_find_inexact_candidates(&cand, bin, saddr, daddr))
 		goto skip_inexact;
 
 	pol = xfrm_policy_eval_candidates(&cand, ret, fl, type,
 					  family, if_id);
+	if (read_seqcount_retry(&bin->count, inexact_sequence))
+		goto retry;
+
 	if (pol) {
 		ret = pol;
 		if (IS_ERR(pol))
-- 
2.53.0



