Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585801;
	b=EkXOaYXeWt/yaQsSybyzsx+iagKhCZxGnQNg5rJdeJ4zyAS3grdzxEbG4ogCLu5JKr/f
	 h9QrGQu2t6+KygS8OX65fC/C1yfIUpJg88nZaCygCi0AWxtUJ0cziMUus3YTc1cR0bqGT
	 Essc40GHj5GIc6HXE4UAe9J2gEIa0VA9lchdSFg4dAuIuUQbOREPk5KKMN2Es3Ksd2C1q
	 GSw/tpB9b0z4vU9XNpSzCDx3rVCCfE09qq4amiWJowsHrvmZk7F3F8+JtD20Bw740L6EJ
	 7Si6pLegN1ok6rHmcBvvsX1fkvy2pmbpuy262muQf1xbm70jlqjDOrKRmJ/8qlDd9rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iqnrHKovENJ7cpPm/6ys7o7Ozw27AdwiRkJxT21kDRw=;
	b=cCKSLSV3QDn0d2godk4YwrybzDI96koDiID7rYigK52tbMHNFsB9M/kCDXq853DszAYq
	 gOc1WuH9axFAxTQRXXS2YxYmxkjeLTgLhslM5xNWe605pw45U5sAWIk6jVi29ooRjkDh6
	 H69VKzb9i0AzfZ9y1TI89ciUK7aa4wVUFrdjXnR77akUH4jl4CkVy+0pSjktRwtPJBG06
	 lFz7Vz2fTpDoLat2a7HVOerRl2R/SDRTVkVGgJ5Dz5aRkNCdKkaEnMQ3PxGH4a5fOsGGZ
	 xIThrtjdlovtt3NOlPlRUnh2u4+cB1esoLdCESaJ+VdphNuFcPFxp01e8t4JULY7Xeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9roTzOz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03F3606BA9A;
	Fri, 13 Nov 2026 16:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9roTzOz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA011F000C4;
	Fri, 13 Nov 2026 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585801;
	bh=iqnrHKovENJ7cpPm/6ys7o7Ozw27AdwiRkJxT21kDRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9roTzOzNQJMCqE0v8NQbA8nUUlMWm1/0/3rh6r9kD7P6zGR7jYsskNyKFxqWViPf
	 bj1Ou/1XC7sLVux9i1gao3zEwEsGGQKbUgkAEOdJ4D9zyU4ZYa2+yRrP6AfJ86zKVp
	 QZ2gE2hRbG8ISLONIto87/lC/37tGeqEVe0LwSOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 387/507] l2tp: only return sessions of the given tunnel in l2tp_session_get()
Date: Fri, 13 Nov 2026 10:51:31 -0500
Message-ID: <20261113153809.631883070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit a75facf4bb3e866103ddca4f47a6f3ca4b090d8b ]

Commit 5f77c18ea556 ("l2tp: use IDR for all session lookups") made
pppol2tp_connect() and the netlink session commands find sessions with
l2tp_session_get(), passing the socket of the tunnel they name.

L2TPv3 session IDs are unique per network namespace, except that
sessions carried over UDP are only unique per UDP socket, the socket of
their tunnel. However, l2tp_v3_session_get() only checks the socket when
another session has the same session ID. Otherwise it returns the
session, whichever tunnel it belongs to. As of now, a session command
that names the wrong tunnel acts on a session of another tunnel, and a
PPPoL2TP socket for a second L2TPv3 tunnel fails with EEXIST, because it
finds session 0 of the first tunnel.

The issue can be reproduced with:

    ip l2tp add tunnel tunnel_id 3 peer_tunnel_id 3 encap udp \
        local 127.0.0.1 remote 127.0.0.1 udp_sport 5003 udp_dport 6003
    ip l2tp add tunnel tunnel_id 4 peer_tunnel_id 4 encap udp \
        local 127.0.0.1 remote 127.0.0.1 udp_sport 5004 udp_dport 6004
    ip l2tp add session tunnel_id 3 session_id 7 peer_session_id 7
    ip l2tp del session tunnel_id 4 session_id 7
    ip l2tp show session

Before that commit, the delete fails with "No such device", and session
7 of tunnel 3 is still listed. After that commit, the delete succeeds,
and session 7 of tunnel 3 is gone.

This patch will make l2tp_session_get() return NULL when the L2TPv3
session it finds does not belong to the given socket. The receive path
calls l2tp_v3_session_get() directly and is not changed.

Fixes: 5f77c18ea556 ("l2tp: use IDR for all session lookups")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Acked-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20261030032617.4065353-1-hengyul@cs.unc.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7e042a3e648ce..0cd3e38bf662f 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -315,10 +315,19 @@ EXPORT_SYMBOL_GPL(l2tp_v2_session_get);
 struct l2tp_session *l2tp_session_get(const struct net *net, struct sock *sk, int pver,
 				      u32 tunnel_id, u32 session_id)
 {
+	struct l2tp_session *session;
+
 	if (pver == L2TP_HDR_VER_2)
 		return l2tp_v2_session_get(net, tunnel_id, session_id);
-	else
-		return l2tp_v3_session_get(net, sk, session_id);
+
+	/* l2tp_v3_session_get() doesn't check sk if the ID hasn't collided */
+	session = l2tp_v3_session_get(net, sk, session_id);
+	if (session && session->tunnel->sock != sk) {
+		l2tp_session_put(session);
+		return NULL;
+	}
+
+	return session;
 }
 EXPORT_SYMBOL_GPL(l2tp_session_get);
 
-- 
2.53.0



