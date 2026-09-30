Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90204F93A8;
	Wed, 30 Sep 2026 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787175; cv=none; b=eoQ/3FXj8B1yRVq1E8O7Pgsh8cINnzshhW2nmYWN6w8t9sxQMH+G67Fbq0Uy4mLXw/z+mxpwovgY5YnMb/Ar8kA0Ac2iMNwjFML4SvfnHgN1xERRKtgdImuWdLkA1Az4oDnOYKjoZeuEj6w1Qve/KSWDsZ4LipXjY6SEiuSkfqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787175; c=relaxed/simple;
	bh=QL6B8tD+7AywrCefSgK/Ez47B6P5js8rSy9EJtagHnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWtEwqOkAKc9k5p4hzw0Do9O3H6P/ye92we8UkeQn1/luWa+BSPEOV7Hrp9BE41N2xhDQ96hhzcd11hZXCBwozhZ/mzciBGHgMLTneaTio0R2pfOqFNaXrTJpjp/GqDqi6Qcebed7AF80vyAEWrbzWgfnB7Wjh9F9DIYn1uRVUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAlJ0inP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAlJ0inP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F6A1F000FF;
	Wed, 30 Sep 2026 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787174;
	bh=K1enUl4ULLQo7nSWczMIHKwmM39h23GXglnQeORntxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAlJ0inP0WWSEQiLaCyRYIeD83DoedqkHeTYyzHQL4IirJzmM6ZFeRkRBgCav8bvB
	 hMdgKeuPVKOanPie//itmOA+idxGMZDyAPxOpgj3zR3Wx1G4gDUULoIUBjk81uqEVS
	 6fsScJX2KPJSX46he0ymTn9850YFVVoeuigMeS14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 137/457] udp: relocate a connected socket in the 4-tuple hash table on re-connect
Date: Wed, 30 Sep 2026 17:24:02 +0200
Message-ID: <20260930152349.004144755@linuxfoundation.org>
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

From: Shardul Bankar <shardul.b@mpiricsoftware.com>

[ Upstream commit 5fd0783b99d4af98f65cd58b56ec203d1d426104 ]

A connected UDP socket that connects again to a different peer is not
re-filed in the 4-tuple hash table:

    sk binds to 127.0.0.1:21001
    sk connects to 127.0.0.2:20001	// filed under hash(sk, peer1)
    sk connects to 127.0.0.3:20002	// still filed under hash(sk, peer1)
    packet from 127.0.0.3:20002		// hash(sk, peer2) misses, so the
					// lookup falls back to scoring the
					// hash2 chain for this address
					// and port

udp_lib_hash4() returns early when the socket is already hashed, assuming
->rehash() relocates it. ->rehash() runs from __ip{4,6}_datagram_connect()
only while the receive address is unset, which a second connect never is:
the first connect assigns it, whether the socket was bound to a specific
address or to the wildcard. commit 644f9108f3a5 ("udp: Make rehash4
independent in udp_lib_rehash()") added that early return and named
connect(AF_UNSPEC) as the way around it. That workaround does not help a
socket with both SOCK_BINDADDR_LOCK and SOCK_BINDPORT_LOCK set, because
__udp_disconnect() skips ->rehash() for the first and ->unhash() for the
second.

Delivery is correct either way.

Relocate the socket when the hash it is filed under differs from the one
requested, which is what commit 78c91ae2c6de ("ipv4/udp: Add 4-tuple hash
for connected socket") did before the early return became unconditional. It
is done here under hslot->lock, which that version did not take, to match
udp_lib_rehash() and udp_lib_unhash(). hslot2 is unchanged, so hash4_cnt
needs no adjustment, as in udp_lib_rehash(). A first connect is unaffected,
and IPv6 shares the code.

With 500 sockets on the port, a re-connected socket measured 522,553 pps
without this change and 2,055,078 with it. The UDP side was noted as
remaining work in [1].

Link: https://lore.kernel.org/netdev/apnHqmYZQ4yzOP4N@v4bel/ [1]
Fixes: 644f9108f3a5 ("udp: Make rehash4 independent in udp_lib_rehash()")
Assisted-by: LLM
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260917-udp_hash4_fix_v1-v1-1-718891af0d7a@mpiricsoftware.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 45e96b7219896..aa095ab833ecd 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -616,14 +616,23 @@ void udp_lib_hash4(struct sock *sk, u16 hash)
 	struct net *net = sock_net(sk);
 	struct udp_table *udptable;
 
-	/* Connected udp socket can re-connect to another remote address, which
-	 * will be handled by rehash. Thus no need to redo hash4 here.
+	udptable = net->ipv4.udp_table;
+	hslot = udp_hashslot(udptable, net, udp_sk(sk)->udp_port_hash);
+
+	/* A connected socket can re-connect to another address. rehash()
+	 * relocates it, but only runs when the local address changes, so a
+	 * socket bound to a specific address would stay filed under the
+	 * previous peer's hash. Move it here.
 	 */
-	if (udp_hashed4(sk))
+	if (udp_hashed4(sk)) {
+		if (udp_sk(sk)->udp_lrpa_hash != hash) {
+			spin_lock_bh(&hslot->lock);
+			udp_rehash4(udptable, sk, hash);
+			spin_unlock_bh(&hslot->lock);
+		}
 		return;
+	}
 
-	udptable = net->ipv4.udp_table;
-	hslot = udp_hashslot(udptable, net, udp_sk(sk)->udp_port_hash);
 	hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
 	hslot4 = udp_hashslot4(udptable, hash);
 	udp_sk(sk)->udp_lrpa_hash = hash;
-- 
2.53.0



