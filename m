Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B64714B075;
	Wed,  5 Mar 2025 18:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197639; cv=none; b=GPBVgg/97+ijEExOI9+8BslRXzCTGp1WZqkmRRVv/yczs0RzBIGscggR9W1kFCwrYbM9zjrm2Z1cs+e3KdwQLGeT7KSUGS7/oYOboCxQKgln01HLQE0xfeITqCe179LY+YJA/IZC41DG5xFc2Af5+9dosYxi8W7aePLRtwGJzLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197639; c=relaxed/simple;
	bh=DkMtw/KtHF2OpDZ77/5CdmWNEb94g3TDH1vWWDVlVgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYcA+caP3nFucrUMenR3QpPYHKlT7hFI2urgmkxUeFqDRCf/XNDFYX+rwSdRucgRZxjWWm9iIufGePnoImI9Y7EVhMahSHSgCM3PNBcazRwXHtF2j695hhP4PLIcjhWcBjAfDRueTsxsEl207aNQ6/9+9EpfBEVGJYloXQ8Q/4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SulM/4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SulM/4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC82C4CED1;
	Wed,  5 Mar 2025 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197638;
	bh=DkMtw/KtHF2OpDZ77/5CdmWNEb94g3TDH1vWWDVlVgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SulM/4i/HEwbTMSrVrIQSgPXVfSDga6PXZoBtB/4N3A6JjEyHVLtBBQpz5XQFmEB
	 nj2ON4bb/XMZ1YzoaFUNWxLs6lRHaEEvcGCvuu9+VTjgQWd0VxZ5HF26G372+9+8TJ
	 bvfLUGxSiqhTQIYJ81yKj89BKD6bbz5pMEzjB6Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <alex.aring@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/142] net: ipv6: fix dst ref loop on input in rpl lwt
Date: Wed,  5 Mar 2025 18:47:48 +0100
Message-ID: <20250305174502.308544088@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7ba22d2f2bfef..28fc7fae57972 100644
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
@@ -275,7 +283,9 @@ static int rpl_input(struct sk_buff *skb)
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



