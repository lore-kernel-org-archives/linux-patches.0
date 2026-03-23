Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5375321D00A;
	Mon, 23 Mar 2026 14:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275086; cv=none; b=b+/Iq8L1ncYtdaUqxno7Uy2JCsZvklcc4OwlZz9il6Vf0DmDs+2rR+ci/IaPtVhbr38v86o2rVG1SPX1ljPLzZqZF+avzEVFjIXDPoisyDH78pGAs5PCGDD92MCl48Q956SUufGPXpwSYNbLw70+/GwpdKKfSHCRg5E0xrDGLZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275086; c=relaxed/simple;
	bh=2h3mX10Fgfs2Jwmrjqhf03pQjaN6+g1X26YuxDsEqQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/DP9QQ3TstJon1j95B/+ZD+yh69VpSC3wTnLsumz8savmPDYhUZ2zkL+rSqkClb2kPJ+UPHq4q0afJIbln90YktPEVYIZD2LwpNptgilqY3ffQuy3CecgsM3M69Ac8/ZgOiYreq0Sro5dOU9eigsZ3j+I5gpmN3HaepPBUba4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFApTyXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFApTyXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B593EC4CEF7;
	Mon, 23 Mar 2026 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275086;
	bh=2h3mX10Fgfs2Jwmrjqhf03pQjaN6+g1X26YuxDsEqQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFApTyXgtFXZXELZnreORm009oK/wRDY9DhhSC+kgcVnekKXbz3Hh8ggrocVhb113
	 QxUvSevI7CsGTQn/oJx+NOvlP2NY2XPaioj8bH3jsw36+hD+MS0je5RhtqihmnkFO4
	 Bcy9qTydspVk2r2EPYRm0saXSjggBW1S5rlsrRk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/212] net: shaper: protect late read accesses to the hierarchy
Date: Mon, 23 Mar 2026 14:46:36 +0100
Message-ID: <20260323134509.293932794@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0f9ea7141f365b4f27226898e62220fb98ef8dc6 ]

We look up a netdev during prep of Netlink ops (pre- callbacks)
and take a ref to it. Then later in the body of the callback
we take its lock or RCU which are the actual protections.

This is not proper, a conversion from a ref to a locked netdev
must include a liveness check (a check if the netdev hasn't been
unregistered already). Fix the read cases (those under RCU).
Writes needs a separate change to protect from creating the
hierarchy after flush has already run.

Fixes: 4b623f9f0f59 ("net-shapers: implement NL get operation")
Reported-by: Paul Moses <p@1g4.org>
Link: https://lore.kernel.org/20260309173450.538026-1-p@1g4.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260317161014.779569-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index 318a0567a6981..081dac917dc2d 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -65,6 +65,21 @@ net_shaper_hierarchy(struct net_shaper_binding *binding)
 	return NULL;
 }
 
+static struct net_shaper_hierarchy *
+net_shaper_hierarchy_rcu(struct net_shaper_binding *binding)
+{
+	/* Readers look up the device and take a ref, then take RCU lock
+	 * later at which point netdev may have been unregistered and flushed.
+	 * READ_ONCE() pairs with WRITE_ONCE() in net_shaper_hierarchy_setup.
+	 */
+	if (binding->type == NET_SHAPER_BINDING_TYPE_NETDEV &&
+	    READ_ONCE(binding->netdev->reg_state) <= NETREG_REGISTERED)
+		return READ_ONCE(binding->netdev->net_shaper_hierarchy);
+
+	/* No other type supported yet. */
+	return NULL;
+}
+
 static const struct net_shaper_ops *
 net_shaper_ops(struct net_shaper_binding *binding)
 {
@@ -251,9 +266,10 @@ static struct net_shaper *
 net_shaper_lookup(struct net_shaper_binding *binding,
 		  const struct net_shaper_handle *handle)
 {
-	struct net_shaper_hierarchy *hierarchy = net_shaper_hierarchy(binding);
 	u32 index = net_shaper_handle_to_index(handle);
+	struct net_shaper_hierarchy *hierarchy;
 
+	hierarchy = net_shaper_hierarchy_rcu(binding);
 	if (!hierarchy || xa_get_mark(&hierarchy->shapers, index,
 				      NET_SHAPER_NOT_VALID))
 		return NULL;
@@ -778,17 +794,19 @@ int net_shaper_nl_get_dumpit(struct sk_buff *skb,
 
 	/* Don't error out dumps performed before any set operation. */
 	binding = net_shaper_binding_from_ctx(ctx);
-	hierarchy = net_shaper_hierarchy(binding);
-	if (!hierarchy)
-		return 0;
 
 	rcu_read_lock();
+	hierarchy = net_shaper_hierarchy_rcu(binding);
+	if (!hierarchy)
+		goto out_unlock;
+
 	for (; (shaper = xa_find(&hierarchy->shapers, &ctx->start_index,
 				 U32_MAX, XA_PRESENT)); ctx->start_index++) {
 		ret = net_shaper_fill_one(skb, binding, shaper, info);
 		if (ret)
 			break;
 	}
+out_unlock:
 	rcu_read_unlock();
 
 	return ret;
-- 
2.51.0



