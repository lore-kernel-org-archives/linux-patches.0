Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590468;
	b=CYu0d5Qa0H+v/gYhfW2EFoqfeSkt59QpIic10uf/vJabM3S7aDowDEccNKAmvkxFE1ex
	 yhQH3ISLPFIV2B9ql2KfI5t/QsGFP7SuUZ6iJNuMNbc5Bfn1AN0ERnLUvflCXbM9/mDh9
	 P6jzcebJ/B/q5JHC4mz37LmbM/+bkVNKaXPcYBETXd5r6/gmDQOoFZ+ouUyKFUK+5gweg
	 p0RpUNOcj3mtySoe0+43L288K1q3gzrktf7zmIPrZJ0gfiThbOfJMqDsBQAY1pLfrb5K4
	 rk++JFy5BnJgi4J/oZPkOOJm++gCBBW17HYq9lfXjaNI/NJuSzgbK//H7ArQhbtKANw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k62weeR/3tbI3vJ+PhBF7kMVUyadTEIiDBqJqzHGoTI=;
	b=pcUipc9OZSxsIGV5KL2Zu8tzzy2hXGxpBxUvrhfA8N+/jOstkWhelM4NTzKK6M6Rk55c
	 +ZLuFj43Uu4I2oY6YEUtz/nDSxU2JAORwu9moFs2rmxq07uR/voD3bhLjkWh7L9WsYvGD
	 tz6k1B6pn7OZH8pVQzHpoYgWE1DRv1PjWjMCi2MtMxRREEVQAEzyvZ14/r1ZEPJH4tsYm
	 01wO8bjCffbsPJzXGP3zBOOtfkUESvKSHlcZcVPjGx0F34sDncUqRjyAgGii74ErImvN0
	 CP4XDPmtGxlQpQr7D8MeG+3iSD9dn2hb5YUBYu8vhaHo5cuJREGxsqlacPYm5CzNoFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwOUNeu1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF017606B80B;
	Fri, 13 Nov 2026 17:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwOUNeu1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB3B1F000C6;
	Fri, 13 Nov 2026 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590467;
	bh=k62weeR/3tbI3vJ+PhBF7kMVUyadTEIiDBqJqzHGoTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwOUNeu1WL13xll93huHSLPuxTKqvCANrEwdASb5H/UzlrwXrYny9Q21d0zo6FHt+
	 J4gIjWcCeBE5Zd8+a4XTC2RK78KTyki0Zor18OodUdlK3y8W62mVDDFfdJIwoYaQdt
	 dpEY+FdkE2ORnyysd0Ejswe6RkMoOS0A88Jk2bQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 423/686] l2tp: only return sessions of the given tunnel in l2tp_session_get()
Date: Fri, 13 Nov 2026 10:49:16 -0500
Message-ID: <20261113153835.277991314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fd78928e9be26..e78e8ea93bb7b 100644
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



