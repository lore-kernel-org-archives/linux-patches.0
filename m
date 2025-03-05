Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C533250C1F;
	Wed,  5 Mar 2025 18:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198095; cv=none; b=if/PgMGrM4IN9KxU0mas3Ka1rFnkaoAjKZebODgb6WwMhVH+6dCHaaaanvjEBQj5k3Qp9ZOyB6ZzD3HiHwhJFYFXUXVHDUQIqmDYPk7Ksd2UDtbvwQVlYyVQMpEQPbF28bRH1ae/sfTqUfIrXV4zWEu03oyBBd1puYk67/1Dzr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198095; c=relaxed/simple;
	bh=Z2T/PuGoV0eQAWcLlxj8Zz5Bky5Q+U1OJsCVJVQACHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3XZyq/uZjIvdYCnEkwrlsXROLqSjBYGsalVVc03qLTdWo24j8vQKrsGVYs0FDZU9TSk4SPsX7Mi9at8carNDQjur6DHnKwUCJUZoo8m+nszURubw9dR0ONZ2H5dP1iHIhAA/qoHh+zpXzjx9quoM2L3EPd56eItVFAAr1aTcVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MObSA2ii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MObSA2ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECA0C4CEEA;
	Wed,  5 Mar 2025 18:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198094;
	bh=Z2T/PuGoV0eQAWcLlxj8Zz5Bky5Q+U1OJsCVJVQACHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MObSA2iiHEfOj4yQUnX2vdzGgrORn4s4grq2usShSa34a0BIR7MDoU9u47TSibZFI
	 sU6tRIwquj5OPf9BzeoPDy3Oattex87lXlAUxO7RRiE1BMqdYKiDQY5g1rO3IHi2eu
	 VrhKpDTz/C69PRdxYelKdxPpjxCHUy9BuqjEQzJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lebrun <dlebrun@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/150] net: ipv6: fix dst ref loop on input in seg6 lwt
Date: Wed,  5 Mar 2025 18:48:11 +0100
Message-ID: <20250305174506.313705017@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit c64a0727f9b1cbc63a5538c8c0014e9a175ad864 ]

Prevent a dst ref loop on input in seg6_iptunnel.

Fixes: af4a2209b134 ("ipv6: sr: use dst_cache in seg6_input")
Cc: David Lebrun <dlebrun@google.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_iptunnel.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 33833b2064c07..51583461ae29b 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -472,10 +472,18 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 {
 	struct dst_entry *orig_dst = skb_dst(skb);
 	struct dst_entry *dst = NULL;
+	struct lwtunnel_state *lwtst;
 	struct seg6_lwt *slwt;
 	int err;
 
-	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
+	/* We cannot dereference "orig_dst" once ip6_route_input() or
+	 * skb_dst_drop() is called. However, in order to detect a dst loop, we
+	 * need the address of its lwtstate. So, save the address of lwtstate
+	 * now and use it later as a comparison.
+	 */
+	lwtst = orig_dst->lwtstate;
+
+	slwt = seg6_lwt_lwtunnel(lwtst);
 
 	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
@@ -490,7 +498,9 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 	if (!dst) {
 		ip6_route_input(skb);
 		dst = skb_dst(skb);
-		if (!dst->error) {
+
+		/* cache only if we don't create a dst reference loop */
+		if (!dst->error && lwtst != dst->lwtstate) {
 			local_bh_disable();
 			dst_cache_set_ip6(&slwt->cache, dst,
 					  &ipv6_hdr(skb)->saddr);
-- 
2.39.5



