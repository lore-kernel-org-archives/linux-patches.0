Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590995;
	b=db9rMCOSBSYs0w/qlDCgKfmtSeq9zDz1cjqH5hUrGqa/4Z0Fg2GrJy5sce/il8vpQcnB
	 9AzbA1ORC0BAvPyPwOuDnMbTHNde+J39Pc0GU8tFFvNzQVbfpgASSXRIKeSPk2E4KPCta
	 ofXY1PdX7erPq/HX6Hl4IUZudtsW5rvQ+q++suX8tD4t1gBZw3+PfPOays52esyQmC01v
	 4E8oC5UnzpjeeTT/aJNnfNylEfYXcexB8rqvlYWGzH2ttHHL1n6a3yiJPBGtR29GvHBk4
	 DR4c6YG9MWB/2Tr4VH+ReJFfb2cp7YN23XcOBVsp4I6CZqykS6QPkYXupIk6xennsVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oQPyvq/X6VL8YxujpbV2A5EV9TGwIZT8ftwwY4LJnqg=;
	b=S3SZajY6IGcjEv9lDE4SFxl42B1pmOj0aW08lXVVSZVSSDJ8FmGvTU33pq6XRoE5XX4f
	 53McZ/oRwALam8xCl33FH4hPBuiRa551MXY43vE6c/7habIkV0eg/LD1k9N6iSsa1pUg7
	 K0t2/vXuisEt6aIU1Gd01erirNO2YxArWBdBryCEwn6ucUjiEazxlrJCllAt/4Oxa3d4k
	 37+7InbY8mouCrm8AVpao79Kl5BM+2Upwu+z+r2vz6mY6w9AThl69yCnGOdtP06wx07Ee
	 fIJSAvohJ8MoUXBXjqCpUYb+684pMSSOZTvOpVUIjYa2g8WYfgmNGlCu7aj9PUQnOcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpI2AMtC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BD860703F9;
	Fri, 13 Nov 2026 17:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpI2AMtC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF081F000C4;
	Fri, 13 Nov 2026 17:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590995;
	bh=oQPyvq/X6VL8YxujpbV2A5EV9TGwIZT8ftwwY4LJnqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpI2AMtCf7BFsAhudCgtFOM4lv/LCu10MvIU5jryort1kpC98qm04miSqh9kqovpr
	 VRZ5l0hijEAwvNipBvDjMoXSmPu+JwI50kwoSmoyNDJWukBysAmf1hsu00VjjVEwD/
	 BCDRztTQBxBu2RlMoTf5TAztj4wIJWEfv1Mg5/kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/670] xfrm: retry inexact policy lookup after node reinsertion
Date: Fri, 13 Nov 2026 10:45:33 -0500
Message-ID: <20261113153817.797727788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e033390e77855..106e2f5cc5865 100644
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



