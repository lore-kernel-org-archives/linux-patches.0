Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EB23AD539;
	Wed, 30 Sep 2026 18:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793014; cv=none; b=SgnT4A6Fru7aELna6qWhE6lkuiIbR3QLCH2LZq7hlkP7uoJFchDfSq23iP/t3iTOxVfaVIjeDn6NIsi//W1J4epeoyjOLs0XorXuciEuaeHYoZcvOteT0OL5H3HS7tf7+2qsNPEg2unPog2n4KRRMIIstCpC2xYX8Rb+whDnhiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793014; c=relaxed/simple;
	bh=M2bxJOUtulWwZ8O20O82+nK4Z+8B0kOJjxFUbEgmI/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8rWLMlPQEsnJbZCuQWLn67S0kX0NCTM3LIjuqyRkL8sAHLTPxDW2GaXChhXR+armNFrNrmos8fvve90v8NPWCc6LzOoLSwLTQ80hNwikEWbvGJfFYq64XQY/MLWk4Q7k+9BkKG1+NXjL/LfCSlNpaW96Zqy7swwKwu4EPYwhGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ls+CFQqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ls+CFQqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE191F000FF;
	Wed, 30 Sep 2026 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793013;
	bh=rm3tLJgG/hY0fcuaEceWKaHkj1HdKeQTrKGo3xpYGtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ls+CFQqkLMfL4BnlJgxrpUk+BRG9kF7iJnRRdZUxSbZ47LPIhxvi5eUqKWqK8nXIc
	 0VLLBMatCaRKhPMpalaFTwAztYEsaEg6cZqcJBqjCYwlhZC6k/PeV/qasW+VK8KaPz
	 0+Gumsk8l0DtenvKoGmuVGtU1VeneNaExDAhDghU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/395] ovpn: always unhash old VPN addresses before rehashing
Date: Wed, 30 Sep 2026 17:26:06 +0200
Message-ID: <20260930152342.890641708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit b43beccb3713fafada57814b0a652f4a876eb75f ]

ovpn_peer_hash_vpn_ip updates the per-peer VPN address hash entries
after userspace changes a peer VPN address. The current code removes an
old hash entry only when the new address for that family is not the
unspecified address.

When an address is cleared to 0.0.0.0 or ::, its hash node therefore
remains linked in the bucket selected by the old address. The address
comparison performed during lookup prevents the old address from
matching, but the table retains a stale entry until the peer is removed
or another address is configured for that family.

Always remove both old VPN address hash entries before conditionally
adding the currently configured addresses back. This ensures that a
cleared address leaves its hash node unhashed.

Fixes: 1d36a36f6d53 ("ovpn: implement peer add/get/dump/delete via netlink")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/peer.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 6f7c55ff91fbc..03ec043a123b4 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -989,10 +989,11 @@ void ovpn_peer_hash_vpn_ip(struct ovpn_peer *peer)
 	if (hlist_unhashed(&peer->hash_entry_id))
 		return;
 
-	if (peer->vpn_addrs.ipv4.s_addr != htonl(INADDR_ANY)) {
-		/* remove potential old hashing */
-		hlist_nulls_del_init_rcu(&peer->hash_entry_addr4);
+	/* remove potential old hashing */
+	hlist_nulls_del_init_rcu(&peer->hash_entry_addr4);
+	hlist_nulls_del_init_rcu(&peer->hash_entry_addr6);
 
+	if (peer->vpn_addrs.ipv4.s_addr != htonl(INADDR_ANY)) {
 		nhead = ovpn_get_hash_head(peer->ovpn->peers->by_vpn_addr4,
 					   &peer->vpn_addrs.ipv4,
 					   sizeof(peer->vpn_addrs.ipv4));
@@ -1000,9 +1001,6 @@ void ovpn_peer_hash_vpn_ip(struct ovpn_peer *peer)
 	}
 
 	if (!ipv6_addr_any(&peer->vpn_addrs.ipv6)) {
-		/* remove potential old hashing */
-		hlist_nulls_del_init_rcu(&peer->hash_entry_addr6);
-
 		nhead = ovpn_get_hash_head(peer->ovpn->peers->by_vpn_addr6,
 					   &peer->vpn_addrs.ipv6,
 					   sizeof(peer->vpn_addrs.ipv6));
-- 
2.53.0



