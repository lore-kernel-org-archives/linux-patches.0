Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F4A51616D;
	Wed, 30 Sep 2026 16:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787127; cv=none; b=cIygJdnMO/tELAW0BNCgZ8oud7e4AYOsm8a8Zsgh8CNJ/KjZMApX9ufpS1wzyjBypw7fFdJMBf7NwLYJ6iXkDO8b+qJPfuxWvxSJsB6k7xppPhwRB3FX6dYkuaHTFJyiEBQ0wxNFaryIPKmrjfVxC6cwmQ16kqdv1lRkzZrle6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787127; c=relaxed/simple;
	bh=soOAMBobKC8v3kDEf7hAxzPRsJO2bjESqdmtIyLkn3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leJe/ePwgHJGIY1nr/qMWyv5/ks7Ktj9p2JarEfMi9chOwK91MLLVLqJrCGpK5uHYoX5+SC1taEMfLHtUpgiHeTt7d0MiinUSyP7aaXKPGvlNDqg6/PEqZHuxmSxd9MeyX5wGNTfNLpi3rEvaoH21biG0Zc20DazignxHD9PkYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2yybCvS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2yybCvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9841F000FF;
	Wed, 30 Sep 2026 16:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787126;
	bh=2u0Cw6az70bopzFoX8EYp4AY2ORf47+fu175CrjOlGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2yybCvSvGlD5NCR7V/UMDHV9dSccXdmAGY7VbmBGawvHIFn3JWXQrAOLuYi4kb9n
	 s6ccfql4todTBAf2mxGqJxHYwvNp6oNqTVkhxbzCv2MDl5r6iJYScz7CtJPJDfr4Ab
	 CyItpPt8LxonATqBLRxNn+92sPXku5837f9vsLwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 122/457] ovpn: always unhash old VPN addresses before rehashing
Date: Wed, 30 Sep 2026 17:23:47 +0200
Message-ID: <20260930152348.684832092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 430c6cd48db87..bbd9e17fb0bfa 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -994,10 +994,11 @@ void ovpn_peer_hash_vpn_ip(struct ovpn_peer *peer)
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
@@ -1005,9 +1006,6 @@ void ovpn_peer_hash_vpn_ip(struct ovpn_peer *peer)
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



