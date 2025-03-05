Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C73D1C6FFE;
	Wed,  5 Mar 2025 17:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197485; cv=none; b=A1FJDj46ejxcAyQlqQSh2DPeOzRk+rokKR9Z2m5pjzsjiEwrO4wpzj1gg1rnVvMBWCOqCIgh1DJCK2n5YuRqrYRb6Ip77dQqHGUMPlxmnXrJpheqiMDGbchTKOTwm+F5wdhVo7t4zS0kP3LDJo4T4R1ascTJGf0vvCnRyD6ppjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197485; c=relaxed/simple;
	bh=SwZNfs2lbkfu0beW0HK/SvyJ+bKdicEcuQxFYy+fwwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HahExV/qnghJ6iuvyK1iR/73MCsVua/Tj7SjB6QcHP4ex7P8cG3mRaI0xZ0JfqT+YMRwfu6MosmEHst11dUd74YOi+BRGWMQEsoAwMhV5O1TtDq1lvbbFN4jb3FQoNF6hrIvSUGivBMUAF4d0nLdllGu2p3lO5R8lucu1Di58b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpTihVJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpTihVJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81EAC4CED1;
	Wed,  5 Mar 2025 17:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197485;
	bh=SwZNfs2lbkfu0beW0HK/SvyJ+bKdicEcuQxFYy+fwwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpTihVJ9SJdnT/z28ebP5ifjP08o8MYNckwtrnxjDLjID2knkLrwRBjjahSmsJIb0
	 U0W4CnbGTdWlwyBBhe/HB7Ho/ybR/rz/oE/CqkYN8mSg8ZgcvtkMp+Zm1ar0b4plOt
	 /a1tGRE1yD4x8S6tJw+cHLprIbu7yw8KWrNu9qFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lebrun <dlebrun@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/176] net: ipv6: fix dst ref loop on input in seg6 lwt
Date: Wed,  5 Mar 2025 18:48:29 +0100
Message-ID: <20250305174511.067164408@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c161298c8b335..b186d85ec5b3f 100644
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



