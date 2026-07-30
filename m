Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51DA43F8A0;
	Thu, 30 Jul 2026 14:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421844; cv=none; b=PPeBIWfBcpknUAp1t0im11NS/2VUHd4I/fPqoR72GslmrVP5ikGyFShBaSL/qCe1iH+P+ubnfodXvAzA8YL482ufnTFyWF5hW8GiniZm1LYBT5js2q+L5heNDVYG6yhX3dXF+jBRtW5tFxkJORJC9FGDfH5shbux/BEMMxXg3jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421844; c=relaxed/simple;
	bh=Am/DIqJ1jT2sAybie5z6JD5X0mgBInbcjETsixiV834=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGVn5z6itbEtmgQmpXIUJaA/VafXNqtYTwyXr03cSkYpiIfy6cAfgO/7QfY4KXg+6D1r36yoHXVbqslLxg2ZPNQ2ro9gfK/jAPgMpHG+Hsx9m9c9HlQYoeS3/yF/BHAzgXR+vDlagbg942IQI6cYLnxp46EIXNgsrILHsO5sR8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAa5wpah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAa5wpah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F9C1F000E9;
	Thu, 30 Jul 2026 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421843;
	bh=nh7t4xaM1l7UXbbMJ6dWa2mhJjNzTNhSBCtOC5lHRPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAa5wpahVJfTEtLcGT9pLaVDYF2MgDFBN6GsmdmpwdQJIXVsiiBKxSAki1kr8K786
	 zXHW3jci4dCzf4udbKDsLqboIATcU0I2PjnWSZ6DyFj/U7WQoWR9WUqa9tF8lYGFG/
	 xwnKdXUGZcGHyR1WxQSfO2U3br4o1LR7P5JJI0eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Simon Horman <horms@kernel.org>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 222/744] ovpn: avoid putting unrelated P2P peer on socket release
Date: Thu, 30 Jul 2026 16:08:15 +0200
Message-ID: <20260730141449.004260469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a09d61296425aa..1844d97154cea7 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -1167,7 +1167,6 @@ static void ovpn_peer_release_p2p(struct ovpn_priv *ovpn, struct sock *sk,
 		ovpn_sock = rcu_access_pointer(peer->sock);
 		if (!ovpn_sock || ovpn_sock->sk != sk) {
 			spin_unlock_bh(&ovpn->lock);
-			ovpn_peer_put(peer);
 			return;
 		}
 	}
-- 
2.53.0



