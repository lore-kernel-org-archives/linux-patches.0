Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117AE50DDB4;
	Mon, 31 Aug 2026 13:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183775; cv=none; b=fnKLeiMRzZFsDrxQc+SP6exzLT3MKqE4ZO1wongXb3ZJoDPyKZJYzw7tJ34ySYd2Ndks1gmeUNwMXdlRkE7xrqLNvQtz4Z2ChUPFES9crLVU63/7FWUmrHs0kGJriTlccd30sTxcNQk2pfV4psr2lChciWH/aGbIqdv5NAs8ZTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183775; c=relaxed/simple;
	bh=Jy89bVUKj7otZnb15wF9rq7X8JBm6LJxM2VWYe1sM/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmKy/nuWmvvBLvtZgmyNvUNuWB2j9G4x5BB3mIqNjubDE6ZOh6kXe5WU6vjoQBmqRAdfCZBn3kloOSbPDBV8Qj8WZrL7iDBljgo3rR5H+EtBIZcvBPywlSwXtxmGfQG6bYGOOzb64wB6+YaksNUQWNxpUhvwsIBju7EGfdWRwLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvFCbzbd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvFCbzbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517741F000E9;
	Mon, 31 Aug 2026 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183773;
	bh=kLytxNBoxqWipDyc+5eFULyJsKyemd40ZaxGC0xG0h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvFCbzbdNG7woRH2qz8t6sGMWBIjVu6+QJ8vbMROGWZf9J0oMpfkVqUNgAgaIV9uC
	 Ikeq55Ej18yVpG/rA8S/HDcgdiZzYxTRJzdc5aXWKw8MxkZ7z+kFVD1T0rj01I+Uw7
	 p9Z7uKEQGgycTA/O5HnwVkxro7ytspmV1TgWMUR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 38/76] net/tcp-ao: fix use-after-free of current_key on reconnect to another peer
Date: Mon, 31 Aug 2026 15:34:10 +0200
Message-ID: <20260831133401.395357778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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


