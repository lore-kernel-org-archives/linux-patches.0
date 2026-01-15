Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62B03B530F;
	Thu, 15 Jan 2026 17:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499115; cv=none; b=PsDVWuQBEtMxImCjClRISdpiK0KUbnU383W6yneL9lXut4yLgS7EniQ2g4+q0m5AB4+LADrBvXoYihUQy4DMmEpcqEXAW2ChcUFXzPAYSMfzQHKv4KyUrDMyKnPOdYwKgbw4p4rb8bJJoAVNAo2RLaZFQufuVlYknQw9cdiojQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499115; c=relaxed/simple;
	bh=eWZJXkaOq+QplhSCuRMdx+QI9ADCWWbjXym2BYHMnDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lX2suQ/DnLg2Ub85qgMjZpzkA1Oo595QW4/3WkDEgd0iZUK/JhVf71ojrF1f0PUZEk+cPL+5fuPKJxRXrDNDd6FGmukT1Ds7bbFU2PU1ozBuqMxB3ZiT+KCY0BgYCSqvqq1HUehYGnyn9dMa1T3NUIyXfPWmHsLjY/1YnKtWwLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCpoMhAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCpoMhAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EB9C116D0;
	Thu, 15 Jan 2026 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499115;
	bh=eWZJXkaOq+QplhSCuRMdx+QI9ADCWWbjXym2BYHMnDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCpoMhAU5/BH4IA7PXmHwl6D+WjM9IvOSxeAG1bSFCJJ+BjxpL9uf3tk0nHSefVMv
	 WXNOM/R8IdKc1k8kcV2BqFBGPBAMVmuNZ90jwlPsBUCBw66r8nWX3wuNxwWxqXemUH
	 q8L4l6J7p1nlBsjbCskqHLV/Ae9+h+MloUem+ja4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/451] netfilter: nft_connlimit: update the count if add was skipped
Date: Thu, 15 Jan 2026 17:45:14 +0100
Message-ID: <20260115164235.009307393@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 69894e5b4c5e28cda5f32af33d4a92b7a4b93b0e ]

Connlimit expression can be used for all kind of packets and not only
for packets with connection state new. See this ruleset as example:

table ip filter {
        chain input {
                type filter hook input priority filter; policy accept;
                tcp dport 22 ct count over 4 counter
        }
}

Currently, if the connection count goes over the limit the counter will
count the packets. When a connection is closed, the connection count
won't decrement as it should because it is only updated for new
connections due to an optimization on __nf_conncount_add() that prevents
updating the list if the connection is duplicated.

To solve this problem, check whether the connection was skipped and if
so, update the list. Adjust count_tree() too so the same fix is applied
for xt_connlimit.

Fixes: 976afca1ceba ("netfilter: nf_conncount: Early exit in nf_conncount_lookup() and cleanup")
Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c  | 12 ++++++++----
 net/netfilter/nft_connlimit.c | 13 +++++++++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 5fdf451f2322c..3e8828bdcd1b3 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -179,7 +179,7 @@ static int __nf_conncount_add(struct net *net,
 	if (ct && nf_ct_is_confirmed(ct)) {
 		if (refcounted)
 			nf_ct_put(ct);
-		return 0;
+		return -EEXIST;
 	}
 
 	if (time_is_after_eq_jiffies((unsigned long)list->last_gc))
@@ -398,7 +398,7 @@ insert_tree(struct net *net,
 			int ret;
 
 			ret = nf_conncount_add_skb(net, skb, l3num, &rbconn->list);
-			if (ret)
+			if (ret && ret != -EEXIST)
 				count = 0; /* hotdrop */
 			else
 				count = rbconn->list.count;
@@ -501,10 +501,14 @@ count_tree(struct net *net,
 			/* same source network -> be counted! */
 			ret = __nf_conncount_add(net, skb, l3num, &rbconn->list);
 			spin_unlock_bh(&rbconn->list.list_lock);
-			if (ret)
+			if (ret && ret != -EEXIST) {
 				return 0; /* hotdrop */
-			else
+			} else {
+				/* -EEXIST means add was skipped, update the list */
+				if (ret == -EEXIST)
+					nf_conncount_gc_list(net, &rbconn->list);
 				return rbconn->list.count;
+			}
 		}
 	}
 
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 35c4698db88dd..698b77a0ba0b4 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -29,8 +29,17 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 
 	err = nf_conncount_add_skb(nft_net(pkt), pkt->skb, nft_pf(pkt), priv->list);
 	if (err) {
-		regs->verdict.code = NF_DROP;
-		return;
+		if (err == -EEXIST) {
+			/* Call gc to update the list count if any connection has
+			 * been closed already. This is useful for softlimit
+			 * connections like limiting bandwidth based on a number
+			 * of open connections.
+			 */
+			nf_conncount_gc_list(nft_net(pkt), priv->list);
+		} else {
+			regs->verdict.code = NF_DROP;
+			return;
+		}
 	}
 
 	count = priv->list->count;
-- 
2.51.0



