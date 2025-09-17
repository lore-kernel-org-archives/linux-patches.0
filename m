Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBC6302774;
	Wed, 17 Sep 2025 12:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113176; cv=none; b=NW6bSHFSh2Ho6R3qZ3ABc7lbX6U8G2kFjfTm+OmsrUNJPIOqX4/8iUY7vZG5PK2uLcpaLL5w2Sn1pdR5egXjkiC+ZXOmOtYpKpcqnGltTb6AWSoCxYMXGDa2gAPX7awJxHR/jNbPfsfkiCXj8pEj62NKVJ2ZFxBtOGQNLEoyQNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113176; c=relaxed/simple;
	bh=xNvFEaX2BRYW8gx3rhhMNYPyeoVECtjr5YXVwVshtAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFHpckKv53KicUDSBlvkFRPxf7H53FDeb4vuLvJrfekrPMHRDLtYk0lmDPbw7yifcG3wpVR6O7H7BGE9F85oW+MFgEyxoDz08j4hPsQ4+TDWwTZmdqvmvg/b3WxfaFJBiDH2/z374tJDwHfMoQgsxn52ebSXG7k5RK6Tc1f3p7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdgf7u/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdgf7u/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EC8C4CEF0;
	Wed, 17 Sep 2025 12:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113175;
	bh=xNvFEaX2BRYW8gx3rhhMNYPyeoVECtjr5YXVwVshtAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdgf7u/5b7nj5yjS+tpazKlc/Q8i0Ye4VuSDdhmNqsSPSxadPkACMlH8w0G+so5Q/
	 mwP1UI9Vu4Y6+p5tCxpvNBcH/OJGDwen1egPt3t4eTPyEHBP3Z1TSu2TAFiAA30d4F
	 3KoLaM/JDbFcSmD/0a3zfytwklTd8rT/yiATNYUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hanreich <s.hanreich@proxmox.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 158/189] netfilter: nft_set_rbtree: continue traversal if element is inactive
Date: Wed, 17 Sep 2025 14:34:28 +0200
Message-ID: <20250917123355.735438750@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a60f7bf4a1524d8896b76ba89623080aebf44272 ]

When the rbtree lookup function finds a match in the rbtree, it sets the
range start interval to a potentially inactive element.

Then, after tree lookup, if the matching element is inactive, it returns
NULL and suppresses a matching result.

This is wrong and leads to false negative matches when a transaction has
already entered the commit phase.

cpu0					cpu1
  has added new elements to clone
  has marked elements as being
  inactive in new generation
					perform lookup in the set
  enters commit phase:
I) increments the genbit
					A) observes new genbit
					B) finds matching range
					C) returns no match: found
					range invalid in new generation
II) removes old elements from the tree
					C New nft_lookup happening now
				       	  will find matching element,
					  because it is no longer
					  obscured by old, inactive one.

Consider a packet matching range r1-r2:

cpu0 processes following transaction:
1. remove r1-r2
2. add r1-r3

P is contained in both ranges. Therefore, cpu1 should always find a match
for P.  Due to above race, this is not the case:

cpu1 does find r1-r2, but then ignores it due to the genbit indicating
the range has been removed.  It does NOT test for further matches.

The situation persists for all lookups until after cpu0 hits II) after
which r1-r3 range start node is tested for the first time.

Move the "interval start is valid" check ahead so that tree traversal
continues if the starting interval is not valid in this generation.

Thanks to Stefan Hanreich for providing an initial reproducer for this
bug.

Reported-by: Stefan Hanreich <s.hanreich@proxmox.com>
Fixes: c1eda3c6394f ("netfilter: nft_rbtree: ignore inactive matching element with no descendants")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 938a257c069e2..b1f04168ec937 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -77,7 +77,9 @@ __nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
 			    nft_rbtree_interval_end(rbe) &&
 			    nft_rbtree_interval_start(interval))
 				continue;
-			interval = rbe;
+			if (nft_set_elem_active(&rbe->ext, genmask) &&
+			    !nft_rbtree_elem_expired(rbe))
+				interval = rbe;
 		} else if (d > 0)
 			parent = rcu_dereference_raw(parent->rb_right);
 		else {
@@ -102,8 +104,6 @@ __nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
 	}
 
 	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
-	    nft_set_elem_active(&interval->ext, genmask) &&
-	    !nft_rbtree_elem_expired(interval) &&
 	    nft_rbtree_interval_start(interval))
 		return &interval->ext;
 
-- 
2.51.0



