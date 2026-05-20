Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F392400E02;
	Wed, 20 May 2026 18:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301411; cv=none; b=uQdbV2uEbhDyBIfBSLKhbun1UbCtActfnAadekM51rKRhch6Ttsr9myLNma9cGhLWLAGwVFGAsvigk+8Fx4LMLFpKedAMvkGFQhmIhqZa24vcZaIrEpKWGWj8yw/4xq0IrQeVFqlOpGNNhxpJ0fujgIdUsBUPG/rfEqMES+npFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301411; c=relaxed/simple;
	bh=ILPQK2T8roAdwGZcHh3GvPgbmD4zpi7RisekRsbTbpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EI+99KWOXQzOCDotlaDzOuRSyrEiiPQ71ga4vpQpvAoW6ySgC0pN5Z157ZaQqa2xXZU8XEcUCk3yFacYLCNuLrN508BGQReo9JU3gXwnWh0DuLsBi3GjtvVn0D+zfHkaG9rmvtED5w8M/WBt+sHEVAHsYj6mIdnyNBZdxt9zVL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwKAbTo9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwKAbTo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D071F000E9;
	Wed, 20 May 2026 18:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301409;
	bh=oHWUTkVGmdVjsKk8OdNzi8wVuuTi/Xl+Ytb8B2Ng0fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwKAbTo90C3ZOTNWFWEMpkeX9jPGUUu+GOfyH11takaB8zE5pZ95/Vdp++G+74FO0
	 5p2YdKJJCGcaB5dUxV8qNIcfXcKzjF8hXnqGTiUQwJcD/y6jsVUkuOTB2hK28H+hpG
	 7GrYOQhuijHUFpyzkrs1O6F9JovGKdAVFtP6gya0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 544/666] neigh: let neigh_xmit take skb ownership
Date: Wed, 20 May 2026 18:22:35 +0200
Message-ID: <20260520162123.061211995@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4438113be604ee67a7bf4f81da6e1cca41332ce4 ]

neigh_xmit always releases the skb, except when no neighbour table is
found. But even the first added user of neigh_xmit (mpls) relied on
neigh_xmit to release the skb (or queue it for tx).

sashiko reported:
 If neigh_xmit() is called with an uninitialized neighbor table (for
 example, NEIGH_ND_TABLE when IPv6 is disabled), it returns -EAFNOSUPPORT
 and bypasses its internal out_kfree_skb error path.  Because the return
 value of neigh_xmit() is ignored here, does this leak the SKB?

Assume full ownership and remove the last code path that doesn't
xmit or free skb.

Fixes: 4fd3d7d9e868 ("neigh: Add helper function neigh_xmit")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260424145843.74055-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 96786016dbb4e..bf07438d6dfa5 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3161,8 +3161,10 @@ int neigh_xmit(int index, struct net_device *dev,
 
 		rcu_read_lock();
 		tbl = rcu_dereference(neigh_tables[index]);
-		if (!tbl)
-			goto out_unlock;
+		if (!tbl) {
+			rcu_read_unlock();
+			goto out_kfree_skb;
+		}
 		if (index == NEIGH_ARP_TABLE) {
 			u32 key = *((u32 *)addr);
 
@@ -3178,7 +3180,6 @@ int neigh_xmit(int index, struct net_device *dev,
 			goto out_kfree_skb;
 		}
 		err = READ_ONCE(neigh->output)(neigh, skb);
-out_unlock:
 		rcu_read_unlock();
 	}
 	else if (index == NEIGH_LINK_TABLE) {
@@ -3188,11 +3189,10 @@ int neigh_xmit(int index, struct net_device *dev,
 			goto out_kfree_skb;
 		err = dev_queue_xmit(skb);
 	}
-out:
 	return err;
 out_kfree_skb:
 	kfree_skb(skb);
-	goto out;
+	return err;
 }
 EXPORT_SYMBOL(neigh_xmit);
 
-- 
2.53.0



