Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590171;
	b=j760jmNC6cxpHIHbyRHdbcWLHRwxaVthxHmfmIHdy7fpiIBcLTRN5btTYdYfrFwt6tKc
	 6XPALizq5JMVg5ThwxhJDnKM+fC/+dlDUFsObGEY/36sfAxqfTPLiSjV/GcF7e8j4KS6m
	 9v1PjPf5SPxCiODRbFO0hymhzhAsI3YITdgTsbiyAi/wc7VYmHGw2ah2a+wM7rAjNn+ww
	 w+dAZEItHKgTRyREEeQZWhRKzeW1SYSufwlOAQxg16/JOPazNvikYc1/KFqUR/AmrUkxW
	 +u67Lpj24goFqol3WherQgZAqUY0QDff/pTnwxZx/2vyMRr/Qp53gLH1fHx0m0l/6CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vLq9poV1Fp4ICWXxEO8U8EV8mai+NZuEQRP9HD70VUU=;
	b=hYjB+20zz1kyIlGcIXdBg3e37dw3dCsFG6gOoDdcg3UdmNAkfBHH78AKWMFYNhBjGQWZ
	 7nF8NDIjXQrnWKOHPWhw7G8MFwoTok6QEhpxAD66WDkomcBNOXueBZyIlyEjAUyFATvlM
	 IsYuoxLBoxamYOOw88dxpuQEHjy6LYEYkhC+JbOcXVAP6IZzfDI4PWIFRUT9G1xOpB4nV
	 L/YHaDr+o5g11y05sntgEa3Pgz0K4Fpih7CgWM5y+7a7fC7pCzaFh89GDN7hoOYsy5vuF
	 lHjrU4w1UEc/uX2hz00fSLQ9/dbiOozfmdouenchAtejlnXEcdPSUKREFpKPE0LOgWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WerLvGZp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40182606E65A;
	Fri, 13 Nov 2026 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WerLvGZp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCB11F000CD;
	Fri, 13 Nov 2026 17:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590171;
	bh=vLq9poV1Fp4ICWXxEO8U8EV8mai+NZuEQRP9HD70VUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WerLvGZpvOtxqLILHBwO1RQxwG0aHZE5ExIOWsBzXiZBuvRbfqsioolxCVY9qU25C
	 LtTaI8yA56wLByF6U3IhMuL8a7KA1F43/kJDAOf3w4fbJAFeaUf3g3R8XqX+W4mowq
	 COUUKVaUyFYnxgpjj4k7Ur0ScIPy5BcZi8UwoEyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/686] xfrm: retry inexact policy lookup after node reinsertion
Date: Fri, 13 Nov 2026 10:45:13 -0500
Message-ID: <20261113153827.108554670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 25f9cbd3ce6a4..c13382bcc6582 100644
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



