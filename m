Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7AC4315A;
	Sun,  7 Sep 2025 20:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277526; cv=none; b=rgaZOpIfOqexouWfBXGH8LWCyDpZqtvVwsbf2KOkRaNumtx5nxVWg5UZu9+30qLDYFymEatRykTFCFtNw2SXmZcCtj96vBZr6BzPrTlLc8nPwFjZ4Ez8lWMqneXaFDtMgH8/CeoklaADXG0ekryFCIKnESA4qpbw7N3tZ5I1Jnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277526; c=relaxed/simple;
	bh=/uPlkbJrUVezFx9CZYR147VTBxG0GyvAnrXp5nu7wFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAP9gjDl5XSg2vzFhUKFbQNEYzXVmvihEfEbz1ycR+mxVuEhpIS5eN9GQ6qx4CjC0yli/S64eIRj93gn2j0+byDYZ1N5E1Mrty6NLYQd1ROVMyiXL/bivZYCZJRF5Oa8Tpkzc122YExlyD5FiQ7Ak+HghGEH6RBi/DWGAwfknSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPxzD7nB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPxzD7nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AACC4CEF0;
	Sun,  7 Sep 2025 20:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277526;
	bh=/uPlkbJrUVezFx9CZYR147VTBxG0GyvAnrXp5nu7wFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPxzD7nBkK1/Xfu2Ewhtf3VYXz7BDpr7tsFS9rkvpJoTMyYB8H8AbN1fMI5muK4ka
	 014KMjZs4Xyf5L2zqOE+pWd4Zx4cOFEBAhsMrRiCJXUs8mlhB078UvNmPt1r/VQy4W
	 Smb5HLbz9tbWo0t7tFlGRmAx0jVX3hyqOmnHHZSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 042/183] netfilter: conntrack: helper: Replace -EEXIST by -EBUSY
Date: Sun,  7 Sep 2025 21:57:49 +0200
Message-ID: <20250907195616.776872043@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 54416fd76770bd04fc3c501810e8d673550bab26 ]

The helper registration return value is passed-through by module_init
callbacks which modprobe confuses with the harmless -EEXIST returned
when trying to load an already loaded module.

Make sure modprobe fails so users notice their helper has not been
registered and won't work.

Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 4ed5878cb25b1..ceb48c3ca0a43 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -368,7 +368,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 			    (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
 			     cur->tuple.src.l3num == me->tuple.src.l3num) &&
 			    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto out;
 			}
 		}
@@ -379,7 +379,7 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 		hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
 			if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple,
 						     &mask)) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto out;
 			}
 		}
-- 
2.50.1



