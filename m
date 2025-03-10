Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF18374EA;
	Mon, 10 Mar 2025 18:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630723; cv=none; b=W79dORC1cB7RsE8iE8aH0a6PQEk7F3mSqx0skMLEPNoL5sLvfuGfedhaZ0VUSgNH/3wjM/8r5k/uvdAybmz0S1wXW3YShTtIgEemvFPMu9LNiFRln2J9VkFjv79hAF+PtbQLwayB6qt3q2K4J2W0C0J4GumAtUJUAV0IjrVjjEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630723; c=relaxed/simple;
	bh=qKZDy3R4q4b5KdIGbfznYc6HOFzZORk+K/Qm8NmwgZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hys+4RkiNERIBbYkCEQwVPztoW0dbgr0bef/BiEWfX+BYpa/h3G+8v5UsEXKsWCNwSphbYkIisf1uJx0bKXid/N07n5KTTSk1uY2DpGW+v82dbFr0uuhl8qWiLvHMZ3bHxVOoainWejlxRmpQ0LpjKMKAxCvuy2IE4rb7RD0ZAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xk5OohmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xk5OohmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED26C4CEE5;
	Mon, 10 Mar 2025 18:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630722;
	bh=qKZDy3R4q4b5KdIGbfznYc6HOFzZORk+K/Qm8NmwgZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xk5OohmGzAkmWT5MHp9e+0rO5VK0M9TEWUPyB1YPPtA1sawUaHT5DUH++uUXVeoPx
	 L14a44ZCHB2xthrKqbsYUz4WH7zhUy+wY48mxJa3s6864XRDQbwK7aNY5IiZvdPRKN
	 R613uDreGFKGrNeqKS4IpeOco24qQnn+HY5jF4P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <alex.aring@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 512/620] net: ipv6: fix dst ref loop on input in rpl lwt
Date: Mon, 10 Mar 2025 18:05:58 +0100
Message-ID: <20250310170605.766496375@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 13e55fbaec176119cff68a7e1693b251c8883c5f ]

Prevent a dst ref loop on input in rpl_iptunnel.

Fixes: a7a29f9c361f ("net: ipv6: add rpl sr tunnel")
Cc: Alexander Aring <alex.aring@gmail.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/rpl_iptunnel.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index 69b9bd90140dd..862ac1e2e191c 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -259,10 +259,18 @@ static int rpl_input(struct sk_buff *skb)
 {
 	struct dst_entry *orig_dst = skb_dst(skb);
 	struct dst_entry *dst = NULL;
+	struct lwtunnel_state *lwtst;
 	struct rpl_lwt *rlwt;
 	int err;
 
-	rlwt = rpl_lwt_lwtunnel(orig_dst->lwtstate);
+	/* We cannot dereference "orig_dst" once ip6_route_input() or
+	 * skb_dst_drop() is called. However, in order to detect a dst loop, we
+	 * need the address of its lwtstate. So, save the address of lwtstate
+	 * now and use it later as a comparison.
+	 */
+	lwtst = orig_dst->lwtstate;
+
+	rlwt = rpl_lwt_lwtunnel(lwtst);
 
 	local_bh_disable();
 	dst = dst_cache_get(&rlwt->cache);
@@ -277,7 +285,9 @@ static int rpl_input(struct sk_buff *skb)
 	if (!dst) {
 		ip6_route_input(skb);
 		dst = skb_dst(skb);
-		if (!dst->error) {
+
+		/* cache only if we don't create a dst reference loop */
+		if (!dst->error && lwtst != dst->lwtstate) {
 			local_bh_disable();
 			dst_cache_set_ip6(&rlwt->cache, dst,
 					  &ipv6_hdr(skb)->saddr);
-- 
2.39.5



