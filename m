Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1640635292A;
	Tue, 16 Jun 2026 18:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634002; cv=none; b=PkjjRTxQvAWIrX5MAoPgw2PaIlGWU0eW5qQZ1IKCtckfjsqg3uSvdIfLXRFrk1yFv0fdvwgNQ01utWk30lIMD15qOkjtBWinKX6bsq2d/mcuq7Nb5uNTio2He6pBVbmX1E4MSDZQK7vCc6cQJswbs6U3ScVqZTAa+wVcnUXz++E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634002; c=relaxed/simple;
	bh=CV+rmVPWUBw0P2fcTO5vF+fRCav0W/N2v/kNVXCssio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGCCZ2ghqVX7SlelsWo5EgyfeVkFk6JIBz+OsW5RDyBVVAgGTmFlT1aiu6j36q9/vxMc1g/56wITzyn2Z1K3sJbWg+AhFg3cWNeVsHDjFBGIay/glB3MuXVrsnPS/ads3nAdZhbuCFLM0zx5DhAZBit9oJa/EQEL99HVL9oc48Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzYur/S+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzYur/S+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230821F000E9;
	Tue, 16 Jun 2026 18:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634001;
	bh=9KZEdTH3mEwQll4AmXWpP6i5TnckFvne18H4rDUk6go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzYur/S+9MNweu14Sg6gDJ+tAxj1mSsOBNUsPNZPEu2bUWGyGaGtKhSPvuUu6qhej
	 6b8UwPCEgtHvbgBrJ7GeGLj1PSgebeKmE3ZJTEeYv7l1MRCFrRNJLWE2iJEc7O7bzn
	 /D9C96NdKzunHnPDnmPintbI3gCvtViIHnumaLZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/411] xfrm: policy: fix use-after-free on inexact bin in xfrm_policy_bysel_ctx()
Date: Tue, 16 Jun 2026 20:27:00 +0530
Message-ID: <20260616145110.371716154@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6c52ba6cbb5b7e..d8348730e2d0e6 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1124,15 +1124,6 @@ static void __xfrm_policy_inexact_prune_bin(struct xfrm_pol_inexact_bin *b, bool
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
@@ -1720,12 +1711,12 @@ xfrm_policy_bysel_ctx(struct net *net, const struct xfrm_mark *mark, u32 if_id,
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



