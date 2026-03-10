Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281353C3BF4;
	Tue, 10 Mar 2026 11:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142144; cv=none; b=hZj9bmL+mcjwdSvHDkFuDfQmVYLmDBPnB9Zy+JrkikfXsYFbO0AQmQqTe3abtJY4BFDHu6xXoRtKa5/o4baAposVG9M7HT4RMQytD1Y3f3J6TsILvCHELyPz55oReFBNre0jBtxTnMYdWyRCpEijrzLfp3nIPqajd7tZDpruOMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142144; c=relaxed/simple;
	bh=7/bWT+WEq/ipyRNCCV3fhMbko2RgcXgf5H6COyFwKU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALYVbqfsLnaa1D7FRY/GIhRfwc0hve+G8NxxWU81wNWcBR+lrW3MOGxlORcsb8msBy/K/G3UHRAKdXWCRpWDCTcu2A4MudZT3qwLQpalJoVTY+8biICVEgOODKKfPBWdE8rGqIxyPSDkTzb8p3D5a6O9PGI9AdNeenMRWwOKAJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KU6bdVBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KU6bdVBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6E0C2BC86;
	Tue, 10 Mar 2026 11:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142144;
	bh=7/bWT+WEq/ipyRNCCV3fhMbko2RgcXgf5H6COyFwKU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KU6bdVBAyy60hvtlaR6o2Fn5YqaSsINfbJd0+KjbRN6SwdHpwJcL/ByGCI0tRZdqx
	 ZPQSlkN9X1GkjRTYGx8g1lz0u1TnAT95URO8kkSGTy4+Kh6sZ7pcurOL2oGaKHrLMC
	 szslEFJ3JheSTe2xCDuzsUQP9iFpDr2LEZeJX1bqaDks8+05l/oMZCxxwTWRdqbacD
	 xP8FnUyLxcLRRtfqHazy1pxJUcnlgnia/unFRxEuLdZfzHrfXzxgH8qqLCRWiTL/Av
	 5tvg8Kbg+Yv1oGc5/d15RB8KLAJIRniO+rAtNNoU9qdMSFRAb2BJAmo7f1T/ux5xBN
	 YJx09JQWDzQXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 231/314] udp: Unhash auto-bound connected sk from 4-tuple hash table when disconnected.
Date: Tue, 10 Mar 2026 07:18:10 -0400
Message-ID: <09ed0c44007f14c5e5a69b292de421551a708233.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 6996a2d2d0a64808c19c98002aeb5d9d1b2df6a4 ]

Let's say we bind() an UDP socket to the wildcard address with a
non-zero port, connect() it to an address, and disconnect it from
the address.

bind() sets SOCK_BINDPORT_LOCK on sk->sk_userlocks (but not
SOCK_BINDADDR_LOCK), and connect() calls udp_lib_hash4() to put
the socket into the 4-tuple hash table.

Then, __udp_disconnect() calls sk->sk_prot->rehash(sk).

It computes a new hash based on the wildcard address and moves
the socket to a new slot in the 4-tuple hash table, leaving a
garbage in the chain that no packet hits.

Let's remove such a socket from 4-tuple hash table when disconnected.

Note that udp_sk(sk)->udp_portaddr_hash needs to be udpated after
udp_hash4_dec(hslot2) in udp_unhash4().

Fixes: 78c91ae2c6de ("ipv4/udp: Add 4-tuple hash for connected socket")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260227035547.3321327-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 777199fa9502f..024cb4f5978c1 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2266,7 +2266,6 @@ void udp_lib_rehash(struct sock *sk, u16 newhash, u16 newhash4)
 				     udp_sk(sk)->udp_port_hash);
 		hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
 		nhslot2 = udp_hashslot2(udptable, newhash);
-		udp_sk(sk)->udp_portaddr_hash = newhash;
 
 		if (hslot2 != nhslot2 ||
 		    rcu_access_pointer(sk->sk_reuseport_cb)) {
@@ -2300,19 +2299,25 @@ void udp_lib_rehash(struct sock *sk, u16 newhash, u16 newhash4)
 		if (udp_hashed4(sk)) {
 			spin_lock_bh(&hslot->lock);
 
-			udp_rehash4(udptable, sk, newhash4);
-			if (hslot2 != nhslot2) {
-				spin_lock(&hslot2->lock);
-				udp_hash4_dec(hslot2);
-				spin_unlock(&hslot2->lock);
-
-				spin_lock(&nhslot2->lock);
-				udp_hash4_inc(nhslot2);
-				spin_unlock(&nhslot2->lock);
+			if (inet_rcv_saddr_any(sk)) {
+				udp_unhash4(udptable, sk);
+			} else {
+				udp_rehash4(udptable, sk, newhash4);
+				if (hslot2 != nhslot2) {
+					spin_lock(&hslot2->lock);
+					udp_hash4_dec(hslot2);
+					spin_unlock(&hslot2->lock);
+
+					spin_lock(&nhslot2->lock);
+					udp_hash4_inc(nhslot2);
+					spin_unlock(&nhslot2->lock);
+				}
 			}
 
 			spin_unlock_bh(&hslot->lock);
 		}
+
+		udp_sk(sk)->udp_portaddr_hash = newhash;
 	}
 }
 EXPORT_IPV6_MOD(udp_lib_rehash);
-- 
2.51.0

