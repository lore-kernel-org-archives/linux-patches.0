Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054525;
	b=JjNYQD0hnEP3+46tkRFtaIsRJNTb7QZ6lF/xHxtYKkZuu9GOLi5aCzHovltAI7TOqYIo
	 sN8s9qzL7Ys+fVYEYrjzBXfOaDWWT9+NuqdQHXTuO5d6LASxOkxJcTgm1OCASkFGcZxYC
	 K16bAgqxYpOt9GfPbwLSnAb9zNAx5LQERnH9n4o7ph2w3yUYiQs/oznWqSjzeSYEOIiO1
	 VKojA+S34b0oEnZZP6m+6oV/2IjoQHfK7hu72Xdv7dUA6mL/VF4x1aVWDGbUCKFwzyeKR
	 zi6LIyl5+25J37gSWrXNpk/x8r6Mx2AqMSNQ7DC9O/AD/ZMQjwN1kJNmHTF04VxYDFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6zYlWqk6rANDA7khZ1xvZbE4DBLQ0eDdO1YusBhdNLw=;
	b=BpqCWSgme0ERtLxoSaDh0IlUNrM4zJskzJZolu6FdCJaKNGLkYUElbGyMe0sTjnPiG8F
	 m0Ks3ZEVJBqJvFBQBHIPGzav6rPZqPplruNv01Y74ncbDDID5S2/vdkecGdAlReYgzKZy
	 wbDRPhRnbNINocRPfyHeXIALh11hV9RykduxJKSq7zKsSqKdvNaXsx09rVMQ8N8FYsZK6
	 iCXq7iqLPzQab2drG0Nj1SsiqR4xxjqYPbixF/ZCMVvcTGuQxK8RRLt7reCUryIf11b7h
	 FIt9v56ID1Bm/rbTp1eexgdhGXHgM2djBjrfyXh4vhI5y0J/ZCGFfhAAPBjVBWkuM0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uaG1uo3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AEF606A325;
	Thu, 19 Nov 2026 02:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uaG1uo3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854A21F000C4;
	Thu, 19 Nov 2026 02:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054525;
	bh=6zYlWqk6rANDA7khZ1xvZbE4DBLQ0eDdO1YusBhdNLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uaG1uo33WDxJaXmiebOXcBrvwimjpWbBHksvL1BrA22lO6OVNuccqrdBhbvuF3Sl
	 TK7lEiN1wb0bsNH8KgCY1vv8jUnhDL1GjfwbW6fORAJad+1tLDHr63zFqQ+xw4EWR2
	 qsfnRybme8mIJX7UW5DW9b2PUSmEFRginJXwSwJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1306/2214] xfrm: retry inexact policy lookup after node reinsertion
Date: Wed, 18 Nov 2026 15:49:42 +0100
Message-ID: <20261118150103.747155249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 9e18e8d2c1c5c..c48315afead13 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2102,6 +2102,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 	struct xfrm_pol_inexact_bin *bin;
 	struct xfrm_policy *pol, *ret;
 	struct hlist_head *chain;
+	unsigned int inexact_sequence;
 	unsigned int sequence;
 	int err;
 
@@ -2133,12 +2134,18 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 		}
 	}
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



