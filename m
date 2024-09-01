Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782DA17C;
	Sun,  1 Sep 2024 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210043; cv=none; b=gkCljLzXi2r8IdyFPAsMEnIb6YQo7y5oEYMyluF1gCE8LCaKoKrQACh4Rx9jlp3RR5kQNdjiAULSDEl9NpfMYnwV30VEtz1nwT4V/FH6y5PA1nnsT1PGUh+48PFyOR7dhRWljhNi1jW1sOUG3NPyD0W0mVoWDRfGd72vRQK3Wrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210043; c=relaxed/simple;
	bh=3fofLDEFyII+w/Ex2tMX0s43KdG8wgAvxI+BKifWsiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPu5CzGNPqU675LM+3hqAZ9NeJjKdNR3DYLtmO9MKhvkFM0PSHezsWI/Rf4znLV9f0YCgDmlEiOdTUr46VwQAAnI//nkapyiCMODASTkR88Ws5jGfuty+CuZ1wj3bJKc/b7owD2IDmrkmsDG49LyoQj2GwEBFMhw3J/TKgLo/vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3tBo/2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3tBo/2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B787C4CEC3;
	Sun,  1 Sep 2024 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210043;
	bh=3fofLDEFyII+w/Ex2tMX0s43KdG8wgAvxI+BKifWsiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3tBo/2n9ytfi3k3hkfcoZR0C/hgkYhl4/SknV8Cgclb5iZFLtiSTEYUzVeI81WQk
	 PjKz4IeNRbb+0KWxA8CO4t9cXAmUyAz+9p0UtKE9xFxjitgn687GgVCSEvkhHoZTWw
	 alJ8o7zqh++W9gQvO/GBoVdj40Bjr0R2OVIDBgCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/215] netfilter: nf_queue: drop packets with cloned unconfirmed conntracks
Date: Sun,  1 Sep 2024 18:15:51 +0200
Message-ID: <20240901160824.823243815@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9981e0dfdd4d3..d0d41dbbfe382 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -602,8 +602,12 @@ static unsigned int br_nf_local_in(void *priv,
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
index 89b16d36da9cf..d5f5b93a99a08 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -640,10 +640,41 @@ static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry)
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



