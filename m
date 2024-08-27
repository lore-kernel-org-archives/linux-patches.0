Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C7E1C4EE6;
	Tue, 27 Aug 2024 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772051; cv=none; b=iAEsgGnJNCVSGqte2eMeDxDFG0McqKkL60GNjkn62IeYwc/2XLiH1dKmQLdgZOa5ccW6Su/rS5aAUHfRJtB0ZT5vNOokloq0Gpb+hlmRUWKHjeUo7wbUvzk3f6COR019oGqlDFDNXSBFBTB3z0A1VHz4CHP0quTYoUgCoKvnrAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772051; c=relaxed/simple;
	bh=y8pCksCa944XqTNFUeOJEma3oOtmYl1Tj9ExpF4u9E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PF0Cj2Ah3cf7HFANyyuV8IGtsKqz+NtnF+O6m6eulkedLDdDfYi3EGn6P0t397sQymSlJt+/kjCPO9ONP5S1H6TyEu5fMp29d7fRCiLXU4aV3/1MX3MracotZ+ERgp0ajx0ndjTbgE4CI22SNwB8Ya2BIn7pBOicDsAFMrtmFvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKXv2twK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKXv2twK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766D7C4DE1E;
	Tue, 27 Aug 2024 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772050;
	bh=y8pCksCa944XqTNFUeOJEma3oOtmYl1Tj9ExpF4u9E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKXv2twKRafyaMniFyl0ryaHQNbvhFqANJxCSJ5RL+aIuUdtXXpOuRbFJ/AeI0+cq
	 2X+dkYu4eHqSlCJHYRjmwaPrdg3X5vDbVbtRssBO81W2DHnZdbaP6Dtz34UeUz43d1
	 r5drkRtgH2CGw1/OJjI9w5fhbmm2x+ZY+cfuGJvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/321] netfilter: nf_queue: drop packets with cloned unconfirmed conntracks
Date: Tue, 27 Aug 2024 16:36:45 +0200
Message-ID: <20240827143841.932496369@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7d8dc1c7be8d3509e8f5164dd5df64c8e34d7eeb ]

Conntrack assumes an unconfirmed entry (not yet committed to global hash
table) has a refcount of 1 and is not visible to other cores.

With multicast forwarding this assumption breaks down because such
skbs get cloned after being picked up, i.e.  ct->use refcount is > 1.

Likewise, bridge netfilter will clone broad/mutlicast frames and
all frames in case they need to be flood-forwarded during learning
phase.

For ip multicast forwarding or plain bridge flood-forward this will
"work" because packets don't leave softirq and are implicitly
serialized.

With nfqueue this no longer holds true, the packets get queued
and can be reinjected in arbitrary ways.

Disable this feature, I see no other solution.

After this patch, nfqueue cannot queue packets except the last
multicast/broadcast packet.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netfilter_hooks.c |  6 +++++-
 net/netfilter/nfnetlink_queue.c | 35 +++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 9ac70c27da835..9229300881b5f 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -618,8 +618,12 @@ static unsigned int br_nf_local_in(void *priv,
 	if (likely(nf_ct_is_confirmed(ct)))
 		return NF_ACCEPT;
 
+	if (WARN_ON_ONCE(refcount_read(&nfct->use) != 1)) {
+		nf_reset_ct(skb);
+		return NF_ACCEPT;
+	}
+
 	WARN_ON_ONCE(skb_shared(skb));
-	WARN_ON_ONCE(refcount_read(&nfct->use) != 1);
 
 	/* We can't call nf_confirm here, it would create a dependency
 	 * on nf_conntrack module.
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 5bc342cb13767..f13eed826cbb8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -647,10 +647,41 @@ static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	static const unsigned long flags = IPS_CONFIRMED | IPS_DYING;
-	const struct nf_conn *ct = (void *)skb_nfct(entry->skb);
+	struct nf_conn *ct = (void *)skb_nfct(entry->skb);
+	unsigned long status;
+	unsigned int use;
 
-	if (ct && ((ct->status & flags) == IPS_DYING))
+	if (!ct)
+		return false;
+
+	status = READ_ONCE(ct->status);
+	if ((status & flags) == IPS_DYING)
 		return true;
+
+	if (status & IPS_CONFIRMED)
+		return false;
+
+	/* in some cases skb_clone() can occur after initial conntrack
+	 * pickup, but conntrack assumes exclusive skb->_nfct ownership for
+	 * unconfirmed entries.
+	 *
+	 * This happens for br_netfilter and with ip multicast routing.
+	 * We can't be solved with serialization here because one clone could
+	 * have been queued for local delivery.
+	 */
+	use = refcount_read(&ct->ct_general.use);
+	if (likely(use == 1))
+		return false;
+
+	/* Can't decrement further? Exclusive ownership. */
+	if (!refcount_dec_not_one(&ct->ct_general.use))
+		return false;
+
+	skb_set_nfct(entry->skb, 0);
+	/* No nf_ct_put(): we already decremented .use and it cannot
+	 * drop down to 0.
+	 */
+	return true;
 #endif
 	return false;
 }
-- 
2.43.0



