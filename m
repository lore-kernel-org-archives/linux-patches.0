Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F73B5571AB;
	Mon, 31 Aug 2026 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184032; cv=none; b=TTPNLbv3ntHmtvJg+PPTanimD1OyVqPuZ0cMo5thOIx89HblbC3CWQC3O4X+jUVVM6jBMATw+LssW4W8NAU7GLu77iW+AfE8JB94pYTq9grE8o28NOisNyLZTJGiXa17mMmoaVtW0sUljyr/VsQQJEVFsTR9pFlOEJnbHL6pdzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184032; c=relaxed/simple;
	bh=kYJ+Wh/uegdarqRJq5aTTgnhekeLy1sgzu3cqBAOfOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlTB3ItXci55IYoEQskEtqgGcIX1V55R9H4n1l2EZCAMXZlChGWvTz4FOSNrLnywggu43LK06H/nlger2okZLpE4WsC9gcjHjmE2CBQknIoNNe4/2o7XbqpX0fcIChQMW157q0fARPsCYnhg+whuab69B88A6+5ZeN1alVD2q/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrOL6lbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrOL6lbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7C51F00ACF;
	Mon, 31 Aug 2026 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184030;
	bh=qYh+lkEgMdDpePTo5F23h/MHAHOM0qs8wNy3hVTNflg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrOL6lbW8NYYzkAn3Sp1fcDqcIjviji8uEVpVwEL7d5U5wsAZD4/PQAlT7XTZ4ksl
	 1CBtBSVHxUdTX1nAx2POB2zCSxpLLAG6hKGZJcNxtlEq1yZJ7MOTraYmvYQnERdYIa
	 OsZYVNYq9vif6Fvqr9Di5FWRa3DywH9g801e99aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 50/83] net/tcp-ao: fix use-after-free of current_key on reconnect to another peer
Date: Mon, 31 Aug 2026 15:34:26 +0200
Message-ID: <20260831133402.054582200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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


