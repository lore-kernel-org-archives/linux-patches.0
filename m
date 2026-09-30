Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCEC511E96;
	Wed, 30 Sep 2026 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787178; cv=none; b=YKfAh/BvsPyXRkOc5r/Y1DceY1hdpNbpuUZcSCGlP9HsjtOGnQOWRfkgLX0RjAFBDkzeSZ+uDyFv5awSLqAX6ABV7uTuoV6XAHlYT0Zcf1DSiFU4hRT5PwDCiTZEFJPu/LIiXz1dz8LShdEsfVtIIai4YNDhGEd8/yHCQ7hfmPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787178; c=relaxed/simple;
	bh=OVJ8667hT9BwMMdnp9i4+GTYEtZ/xSSkW79Z6ZTuH9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tT0UJRkYArXHHabmdcoQV54xyxlgiiEgdyP5IGhLaB4fvleAS3H9vpmZTjVvC+KKK9pOYSoQ2S/oAQJ5AScxtr438Uih8bR7YPdX9qiAOA+t3OQN6obXrNYVdL7JDMTvenN2GhU3koMq3Cfi/eMwwf3q4GOl0IakzIV2UJcHHwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci9pBmwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci9pBmwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59EE1F000FF;
	Wed, 30 Sep 2026 16:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787177;
	bh=uD98Jn3pk9o6X+5bF2tuELcu00JPDfwegXhOqcXn/1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ci9pBmwaFUdw3DtmRN6ubFI1RYUNmCT+hqWQaDsoyE9HMxRFtsUL9Rv8LRX+Hsnh1
	 7TJw01xQXG7j+vb7hOjSzfculhi33YYDO5uLADF8gE8HvlZBMsiJPUu6JdJ5Dnqxmi
	 ghW8MwMQhVeofoFC+nop7AQ/qvGJshQo4TytwV9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 138/457] udp: remove a disconnected socket from the 4-tuple hash table
Date: Wed, 30 Sep 2026 17:24:03 +0200
Message-ID: <20260930152349.026862624@linuxfoundation.org>
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

[ Upstream commit 9e95b1a94c9c49b4ba722251bbca2759b9c51737 ]

A UDP socket bound to a specific address and port keeps its entry in the
4-tuple hash table after it is disconnected:

    sk binds to 127.0.0.1:21001
    sk connects to 127.0.0.2:20001	// filed in the 4-tuple table
    sk disconnects, connect(AF_UNSPEC)	// still filed, peer now 0.0.0.0:0

__udp_disconnect() takes a socket out of that table only as a side effect
of ->rehash() or ->unhash(), and it skips ->rehash() when
SOCK_BINDADDR_LOCK is set and ->unhash() when SOCK_BINDPORT_LOCK is set.
commit 6996a2d2d0a6 ("udp: Unhash auto-bound connected sk from 4-tuple hash
table when disconnected.") fixed the same end state for a wildcard-bound
socket, by a path this one does not take.

The entry is counted whether or not anything hits it. hash4_cnt on the
hash2 slot stays raised for as long as the socket lives, so udp_has_hash4()
keeps sending every packet for that address and port through the 4-tuple
lookup first.

On IPv6 it can also be hit. __udp_disconnect() does not clear sk_v6_daddr,
so udp_v6_rehash() files the entry under the peer the socket was connected
to with a zero dport, and inet6_match() compares that same
field: a datagram from the former peer with a zero source port matches,
and source port zero is accepted on receive. On IPv4 the peer is cleared,
so a match would need a zero source address as well, which the routing
layer rejects as martian. The stale sk_v6_daddr is a separate defect, not
addressed here; removing the entry closes this path either way.

The entry can also be relocated. __udp_disconnect() clears sk_bound_dev_if,
so a subsequent SO_BINDTODEVICE calls ->rehash(), and because the receive
address is still specific udp_lib_rehash() moves the entry instead of
removing it, into the bucket that (rcv_saddr, num, 0, 0) hashes to -- a
pure function of the address and port, so every socket reaching this state
on one address and port collects in one bucket. The bucket cannot be chosen
from outside, as udp_ehashfn() is seeded with a per-boot secret. This last
one became reachable only with commit 644f9108f3a5 ("udp: Make rehash4
independent in udp_lib_rehash()"), which moved the hash4 handling out of a
branch a disconnected socket does not take; the stale entry itself dates
from the commit in Fixes.

Take the socket out of the table before __udp_disconnect() runs, while it
still matches how it was filed. This also reaches the wildcard case ahead
of udp_lib_rehash()'s udp_unhash4() branch, leaving that branch unreachable
from udp_disconnect(); removing it belongs in net-next. udp_disconnect()
and udp_abort() are the only UDP entries into __udp_disconnect(), which is
shared with raw, ping and l2tp sockets that are not struct udp_sock:
ping_prot.obj_size is sizeof(struct inet_sock), so udp_hashed4() on one
would read past the allocation.

Fixes: 78c91ae2c6de ("ipv4/udp: Add 4-tuple hash for connected socket")
Assisted-by: LLM
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260917-udp_hash4_fix_v1-v1-2-718891af0d7a@mpiricsoftware.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index aa095ab833ecd..59afce196079a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2193,9 +2193,31 @@ int __udp_disconnect(struct sock *sk, int flags)
 }
 EXPORT_SYMBOL(__udp_disconnect);
 
+/* __udp_disconnect() takes a socket out of the 4-tuple hash table only via
+ * ->rehash() or ->unhash(), and neither runs for a socket bound to a
+ * specific address and port. Remove it here, before its peer is cleared.
+ */
+static void udp_unhash4_on_disconnect(struct sock *sk)
+{
+	struct net *net = sock_net(sk);
+	struct udp_table *udptable;
+	struct udp_hslot *hslot;
+
+	if (!udp_hashed4(sk))
+		return;
+
+	udptable = net->ipv4.udp_table;
+	hslot = udp_hashslot(udptable, net, udp_sk(sk)->udp_port_hash);
+
+	spin_lock_bh(&hslot->lock);
+	udp_unhash4(udptable, sk);
+	spin_unlock_bh(&hslot->lock);
+}
+
 int udp_disconnect(struct sock *sk, int flags)
 {
 	lock_sock(sk);
+	udp_unhash4_on_disconnect(sk);
 	__udp_disconnect(sk, flags);
 	release_sock(sk);
 	return 0;
@@ -3107,6 +3129,7 @@ int udp_abort(struct sock *sk, int err)
 
 	sk->sk_err = err;
 	sk_error_report(sk);
+	udp_unhash4_on_disconnect(sk);
 	__udp_disconnect(sk, 0);
 
 out:
-- 
2.53.0



