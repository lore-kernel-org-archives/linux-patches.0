Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A971C255E37;
	Tue, 11 Mar 2025 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707374; cv=none; b=NkPL4KS5Cn+Btd5vBhQafMRlar/iPBr3gwT7FNYqP09oEZ5xGPGPVe4Qt/XA+4uiSeMmOo4rsV+OohDzWAYuqq61sKE8u/3ivp5I7UdnHAAm4yzOgEpCvaIuqqSQC5BagJUDJQjx/R2ljb+dCR8P87kdY2BdDadIZ7cFKbOxZ7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707374; c=relaxed/simple;
	bh=X2W3CgqdXNTmf/qVE/5TkqHqlyef7XMMLBjH7AO+gcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpH+laBU/Dx5BWhjv4U/GfWaHHAVflaD6keq/uZGQ9S+ykWwjxylpICoQiHKjcomklLGQt+wmPlJAgWjgosYu+QrsqIGu89f4dKTr2dHwMsfriO0rAUJqn87YNh2WMC6DKXTd2MnuVy17oXmfJwagwAUDtvDSE3t3pXcSH1jeZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeqSw8LA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeqSw8LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AECC4CEE9;
	Tue, 11 Mar 2025 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707374;
	bh=X2W3CgqdXNTmf/qVE/5TkqHqlyef7XMMLBjH7AO+gcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeqSw8LA3fIvrPoFE+yP4QRFxJhtdMMpTuF39yXq2shGwKTljdckIETxW6o+C9ZPs
	 A/FAUvjqcZ30eXP6XbYBLNRnxXZR2Lg8dofUTUSFAqLQAa9jmCBpfX5NWt7zfCCH2W
	 Cl5ahd5azUz0gGcK36VZWuYvAjhaLhQdGja0KR9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <alex.aring@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 367/462] net: ipv6: fix dst ref loop on input in rpl lwt
Date: Tue, 11 Mar 2025 16:00:33 +0100
Message-ID: <20250311145812.848680897@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dbdfdd2e52784..95e84ec035203 100644
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



