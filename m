Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC83443E24;
	Thu, 30 Jul 2026 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423903; cv=none; b=ldiLTzHdmvXU9xtZXtr2lDsxGYcPvPXevnGP8y9/qYDpvuv5WONqG1aMgWgFk5ijZErvpXdmjFONO6ERrgOpsFn6odgx+20eJUOLdI+USoLHLeelJ4T6tuY1zA7YTlLYeXe4vWZJX1AbaQc8yqWwiud/8Lw7kLaKPeohB4zbAhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423903; c=relaxed/simple;
	bh=43Iw8+LQNwBEdJ0nSwVtmCC8M295O6o4jOGgZliJF2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPj86+vG7mFSQXU9LYTX7Edn+fIJVmRvd3w11Y3hJeJPQe1Mk2s3EuFvJSOyXce6qLzioqicQpwwn0HUt5R77kym0qHsQbt3jTo2oYegiX3B5iHxbQGhSheM+7wzs/OubGXRSK0ny4by8QNUeglMbeO0M6Vu0R1p4DS+4jYUwqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iB2wXigX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iB2wXigX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DD81F000E9;
	Thu, 30 Jul 2026 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423901;
	bh=MJNWkEMCFH9Kg92EWZUWGVUk7ubKsKp7+gHwZn36k30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iB2wXigX2ZDWieqFoZX6CngAQXiHOUZnwpVsS5gQ8ZeEEUERf5oOt3ESvg4RHCidI
	 yDcnZpWy2F4On6/Uqr4I3ZDeS3zan/yKtw4QBvWhcglBXOF06iu4QG1FlpK/srKFxC
	 PpJvx5Y3nKRm2Wc08OKSHGBhaxogkx42/JP7RsRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Simon Horman <horms@kernel.org>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 205/675] ovpn: avoid putting unrelated P2P peer on socket release
Date: Thu, 30 Jul 2026 16:08:55 +0200
Message-ID: <20260730141449.501810090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Qing Ming <a0yami@mailbox.org>

[ Upstream commit b52c5103f64ee825996ca1ab8df7283cde8c5f86 ]

ovpn_peer_release_p2p() is called when an OVPN UDP socket is being
destroyed. It checks the currently published P2P peer and releases it only
if that peer still uses the socket being destroyed.

A peer replacement can publish a new peer before the old UDP socket is
destroyed. When the old socket destruction path runs afterwards,
ovpn_peer_release_p2p() observes the new peer through ovpn->peer. Since the
new peer uses a different socket, the function takes the socket mismatch
branch.

That branch still calls ovpn_peer_put(peer). At this point, however, peer
is the currently published replacement peer, not the peer associated with
the socket being destroyed. Dropping its reference can free it while
ovpn->peer still points to it, leading to later use-after-free accesses
from the peer and socket cleanup paths.

KASAN reports this as a slab-use-after-free on the kmalloc-1k ovpn_peer
object. In the reproducer, the object is allocated from ovpn_peer_new() via
ovpn_nl_peer_new_doit(), and freed through ovpn_peer_release_rcu() from RCU
callback processing. Observed access sites include ovpn_peer_remove(),
ovpn_socket_release(), ovpn_nl_peer_del_notify(), and unlock_ovpn().

Fix this by returning from the socket mismatch branch without putting the
peer.

Fixes: f6226ae7a0cd ("ovpn: introduce the ovpn_socket object")
Signed-off-by: Qing Ming <a0yami@mailbox.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/peer.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 87a83321f1dd5f..795741645e5eb0 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -1162,7 +1162,6 @@ static void ovpn_peer_release_p2p(struct ovpn_priv *ovpn, struct sock *sk,
 		ovpn_sock = rcu_access_pointer(peer->sock);
 		if (!ovpn_sock || ovpn_sock->sk != sk) {
 			spin_unlock_bh(&ovpn->lock);
-			ovpn_peer_put(peer);
 			return;
 		}
 	}
-- 
2.53.0



