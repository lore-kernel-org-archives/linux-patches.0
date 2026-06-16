Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93D444DB64;
	Tue, 16 Jun 2026 16:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626805; cv=none; b=AI3XrRXdvoNFZ+VwXtMocf+tRzRDFGw9+3dr/x4/cvx9HMfY6E+vRyi+Hbt1wkVWHZuQ5wZcjCxXJiIcf/gHhEez08tf+YyYDiXq8CMV0GnGAyHlwWmeCFTC069wjVva8y27R6GLBriC47nqbHTIMM+V1XEZ+Yu9TLmJd6qGtAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626805; c=relaxed/simple;
	bh=+1AgAVoH1zsMQFw2fZRRFYlnG9wfsbrGO6GqzAqRM/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVFCDosZO/gOdrlKAOYGQ2XgLpXzgWetvywokIj839lKyBRU5BKYwPxvtZGLB7Vaiiv6e1bE7hXHuROxfzaUmX7Nr2A16nOsp9YFjIU2vjErKJFKgt7Mr4dxlX9NDOmsW/4Xa5xd4jsUu1C4bmTpAGstInA8MA3eTsC4yxIeBWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTe0kllk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTe0kllk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E923B1F00A3A;
	Tue, 16 Jun 2026 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626803;
	bh=Q+Ky/aV3F0O2kuWwLp+kkjFux8UItrAT5UKDU9nCYpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTe0kllkpuN9wjEMfE+zlVWKZ+f+AdfGXb52G5NCpLxoi+ZTirT6AilovtUJQomzM
	 OUWPSrTQcPT/2u2NPI4HbJo42a/W0iz339XEyNXC0r18H5sNrmePjwvOZgPUTk3ROp
	 CupMqQm/Y9BMDsWaDVRAahhSG6yvTnyY0kblwUIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/261] xfrm: policy: fix use-after-free on inexact bin in xfrm_policy_bysel_ctx()
Date: Tue, 16 Jun 2026 20:28:32 +0530
Message-ID: <20260616145048.537913955@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Sanghyun Park <sanghyun.park.cnu@gmail.com>

[ Upstream commit 7f2d76c9c03257c0782afef9d95321fa04096f60 ]

Fix the race by pruning the bin while still holding xfrm_policy_lock,
before dropping it. Use __xfrm_policy_inexact_prune_bin() directly since
the lock is already held. The wrapper xfrm_policy_inexact_prune_bin()
becomes unused and is removed.

Race:

  CPU0 (XFRM_MSG_DELPOLICY)           CPU1 (XFRM_MSG_NEWSPDINFO)
  ==========================          ==========================
  xfrm_policy_bysel_ctx():
    spin_lock_bh(xfrm_policy_lock)
    bin = xfrm_policy_inexact_lookup()
    __xfrm_policy_unlink(pol)
    spin_unlock_bh(xfrm_policy_lock)
    xfrm_policy_kill(ret)
    // wide window, lock not held
                                       xfrm_hash_rebuild():
                                         spin_lock_bh(xfrm_policy_lock)
                                         __xfrm_policy_inexact_flush():
                                           kfree_rcu(bin)  // bin freed
                                         spin_unlock_bh(xfrm_policy_lock)
    xfrm_policy_inexact_prune_bin(bin)
    // UAF: bin is freed

Fixes: 6be3b0db6db8 ("xfrm: policy: add inexact policy search tree infrastructure")
Signed-off-by: Sanghyun Park <sanghyun.park.cnu@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index dab782dcc829de..5a7ec72e17b0e5 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1156,15 +1156,6 @@ static void __xfrm_policy_inexact_prune_bin(struct xfrm_pol_inexact_bin *b, bool
 	}
 }
 
-static void xfrm_policy_inexact_prune_bin(struct xfrm_pol_inexact_bin *b)
-{
-	struct net *net = read_pnet(&b->k.net);
-
-	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
-	__xfrm_policy_inexact_prune_bin(b, false);
-	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
-}
-
 static void __xfrm_policy_inexact_flush(struct net *net)
 {
 	struct xfrm_pol_inexact_bin *bin, *t;
@@ -1707,12 +1698,12 @@ xfrm_policy_bysel_ctx(struct net *net, const struct xfrm_mark *mark, u32 if_id,
 		}
 		ret = pol;
 	}
+	if (bin && delete)
+		__xfrm_policy_inexact_prune_bin(bin, false);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 
 	if (ret && delete)
 		xfrm_policy_kill(ret);
-	if (bin && delete)
-		xfrm_policy_inexact_prune_bin(bin);
 	return ret;
 }
 EXPORT_SYMBOL(xfrm_policy_bysel_ctx);
-- 
2.53.0



