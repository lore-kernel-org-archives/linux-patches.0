Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271F819F485;
	Tue, 27 Aug 2024 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771159; cv=none; b=UbkQBESowXZ4hgrpytPACSOdf2keg9t8OWlekNLmyZycu5HPzKX39jCjD2jKMa5e+nj9cjcYlGMNlTwP8kutXmE8XFh8xa73DSPklxFI67f8d8svg17DJ/WzI79OIDxXC+4uKv0vhy/tK5n5wlQvIKoEFGbJaztb5OEiWQPN5mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771159; c=relaxed/simple;
	bh=Ed+h21nICLvSnDN1BGXRT/NrNjRol82p0TJouatyf1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrBoPwrJBZh+4Y8Y6qDBDdliXdm8NUH4xlBpNAZHloSdMps2n4Iwo9DhrE2jOtiIkaiQpuaOgdEqRc6GaQaP4cCFpNQc4jYT0XW0lPdpQk43sPBRnvLsj8sICwYCgPxLO6ux7Nt1xhIkk9L23jTqBMk36nhcXDdz9lVr8Vflchs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJL5/Nyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJL5/Nyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89911C6107C;
	Tue, 27 Aug 2024 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771159;
	bh=Ed+h21nICLvSnDN1BGXRT/NrNjRol82p0TJouatyf1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJL5/NyvD5Rqf+d6Ojz0G/9B5zH36dSHoAdBcpM+54XP0HnU/9XSPVwr5RL6Ee+2c
	 0g056/aTogtYY4gA0IGRzTVO/P2K3K1r2ng/XbbqDs9TjbfkMsqcZ6zTBDmTXX/diw
	 11Lh31AI1/1UAdOOTcmxfxMu9333KAj6ajmffcxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 105/273] netfilter: nf_queue: drop packets with cloned unconfirmed conntracks
Date: Tue, 27 Aug 2024 16:37:09 +0200
Message-ID: <20240827143837.404898324@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index bf30c50b56895..a9e1b56f854d4 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -619,8 +619,12 @@ static unsigned int br_nf_local_in(void *priv,
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
index 55e28e1da66ec..e0716da256bf5 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -820,10 +820,41 @@ static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry)
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



