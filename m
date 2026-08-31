Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322195A313E;
	Mon, 31 Aug 2026 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184331; cv=none; b=izknq/GVcoVCP/vrrz7nljhc0pk7i+cpwB3VFae2thZ7+yTbE+vZio0GASpUKo0X9jjy0Ch73uo3t8lHCheRb2MrroW7jUbKAnl38IcmUxtsL1qTV8ZEnd2pfN1gE9EcMrIdEOC6yy/kpeSN2mcGkSyd4sj7zMCb68IcfSDFQyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184331; c=relaxed/simple;
	bh=G+7q50et8GgEm6UgxlOWYedi/aggUxSdtUoFZD4DG9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzjDQ9ypoqOEbHlVHUHB0H8j4voR65Dpz43jUtFEmaAwa/dNImbCKj2e0qNRvTazKCWFGABDGRo3TzhtWhM33L2qv2dgEPXAzWTTAymQnl3LhiMR29BvtLAnnUqS1zKOI4gQ5w1t6SwcohfyrGkFmJAzL2Ic/+pq5sARD5q7x08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9XYvY7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9XYvY7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC911F000E9;
	Mon, 31 Aug 2026 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184329;
	bh=Wk4/ALswoI29/r+8YZU7EDc7SIiPSMwKpSjIFvrlujs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9XYvY7HtLnpI5xT8FzNkd/5OzH/+kSZDp8zoHJiDA73aVeOeFCfuxWXh0V4Mu8lL
	 t+eFo2pBXcIB5gxvuAsijG+ndupxAxl1iDkfSywtMz/2fiALQvV8aUeJzPOUv2TRCf
	 +L2F48z3C3oLuhVJCb6kdodUsFF1wXbT08L7XpD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 70/99] net/tcp-ao: fix use-after-free of current_key on reconnect to another peer
Date: Mon, 31 Aug 2026 15:34:39 +0200
Message-ID: <20260831133403.477177603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit da4471557f279d0f56605158a625bb6e49ef7d41 upstream.

tcp_inbound_ao_hash() is called before bh_lock_sock_nested() is taken,
with only rcu_read_lock() held. On the fast path for established
sockets, if the rnext_keyid sent by the peer differs from
current_key->sndid, the key the peer asked for is looked up and stored
in current_key. The lookup is inside the RCU read side, but current_key
outlives it.

When the socket is disconnected and connect() is called again for
another peer, tcp_ao_connect_init() unlinks every key that does not
match the new peer and frees it with call_rcu(). If current_key points
at such a key, it is cleared to NULL.

The fast path reads sk_state only once on entry, so a softirq that got
into it while the socket was still established can update current_key
after that loop has already run. The update is inside the RCU read side,
so it comes before the call_rcu() callback, and once the callback frees
the key, current_key is left pointing at freed memory.

The next transmission picks that pointer up in tcp_get_current_key().
tcp_ao_transmit_skb() then reads the traffic key from the freed object,
which is the use-after-free.

Wait for one grace period before unlinking, and only if a key is going
to be removed. By the time tcp_connect() runs the socket is already in
TCP_SYN_SENT, and TCP_AO_ESTABLISHED does not contain TCPF_SYN_SENT, so
a softirq entering after the wait cannot reach the fast path, and the
ones already in it have finished. The existing NULL handling in the loop
is then enough.

Fixes: 0a3a809089eb ("net/tcp: Verify inbound TCP-AO signed segments")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/aoIriv3pHDgII2YR@v4bel
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ao.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1120,6 +1120,15 @@ void tcp_ao_connect_init(struct sock *sk
 	l3index = l3mdev_master_ifindex_by_index(sock_net(sk),
 						 sk->sk_bound_dev_if);
 
+	hlist_for_each_entry(key, &ao_info->head, node) {
+		if (tcp_ao_key_cmp(key, l3index, addr, key->prefixlen,
+				   family, -1, -1)) {
+			/* pairs with tcp_inbound_ao_hash() */
+			synchronize_rcu();
+			break;
+		}
+	}
+
 	hlist_for_each_entry_safe(key, next, &ao_info->head, node) {
 		if (!tcp_ao_key_cmp(key, l3index, addr, key->prefixlen, family, -1, -1))
 			continue;


