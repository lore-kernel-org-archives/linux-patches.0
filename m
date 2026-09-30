Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EC93B42E7;
	Wed, 30 Sep 2026 19:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796169; cv=none; b=rixtx8jdCPKcl1PjrmE8CPugrMKd+LIOp30hW1EdzwNdNoraaFZmQiMkpQQtuQ3uI/2bHuy80papGuLAh9cv0QPUzIMF/aQUBN4mucMj3CC4RNJiir4SqITDwMCBorjBpjxQHwjFSoRCLF2kTzc18n7cV/4GiteuofnfE3cp6FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796169; c=relaxed/simple;
	bh=2xnUGNYT2getm8rtxBKj57Q9+OR06Rgxh0c/0pL9dKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUC6SbxWOu8kp9TWd0MOslHZcvQWydh+brxq+D3PcaRDQLrAxRKs0ZIIeLra1cVW5rA8HyN8du7OnpHebpxFzxSx7iLFM3UAOO5HJRTCOJQ/F1bty26PRQimMUBB+/qbJXmhRnEOKe4E00oXt9ZNGCPtjRCbxTotVY3e9qSxLts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTUGR1Yd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTUGR1Yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F4D1F000FF;
	Wed, 30 Sep 2026 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796168;
	bh=CfTMLzlViKZGCKACFtTuwMLQiglhejog8xamT81wtOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTUGR1YdSEML5LeEdVp8/1tpSVRhjJX6EEOFYaxP+YGgD2irnLIw89ntWc7Ud0CDS
	 fl68N/gjn+y0zG8jpMpRqLWJm3bvgJ8LgJlAwo9Cw40Vm9YBhAvCS1tOMRPqpRRac8
	 tKBC+D3fB/om3nCEiVw8cOefRWpRQJlpI356ge/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jungwoo Lee <jwlee2217@gmail.com>,
	Wongi Lee <qw3rtyp0@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0819/1193] net: lock the socket in sock_gettstamp()
Date: Wed, 30 Sep 2026 17:25:03 +0200
Message-ID: <20260930152452.442550275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9ed55f3dbef4f4adfe65eb03b0c35c53229a8490 ]

sk->sk_flags must only be changed while holding the socket lock,
because sock_set_flag() and sock_reset_flag() use non atomic
operations (__set_bit() and __clear_bit()).

sock_gettstamp() is one of the last places where a bit of sk->sk_flags
is changed from a syscall without owning the socket lock, through
sock_enable_timestamp(sk, SOCK_TIMESTAMP).

sk_set_memalloc() and sk_clear_memalloc() also change sk->sk_flags
without the socket lock, but their callers (nbd, iscsi_tcp, nvme-tcp,
sunrpc, wireguard) need a careful audit, this will be addressed in a
separate patch.

Jungwoo Lee and Wongi Lee reported an UDP socket use-after-free
caused by this bug: a SIOCGSTAMPNS_NEW ioctl racing with bind()
can cancel the SOCK_RCU_FREE bit that udp_lib_get_port() just set,
because both threads perform a read-modify-write on the same word.

  CPU 0 (bind)                        CPU 1 (SIOCGSTAMPNS_NEW)
  --------------------------------    ----------------------------
  read sk_flags = F                   read sk_flags = F
  compute F | BIT(SOCK_RCU_FREE)      compute F | BIT(SOCK_TIMESTAMP)
  store F | BIT(SOCK_RCU_FREE)
  sk_add_node_rcu(sk, ...)
                                      store F | BIT(SOCK_TIMESTAMP)

After the lost update, SOCK_RCU_FREE is clear while the socket is
visible to lockless UDP receive lookups. sk_destruct() then frees
the socket immediately instead of waiting for a RCU grace period,
while the receive path still holds a reference-less pointer to it:

 BUG: KASAN: slab-use-after-free in ipv4_pktinfo_prepare+0x30/0x410
 Read of size 8 at addr ffff888008806610 by task exploit/207
 CPU: 0 UID: 1000 PID: 207 Comm: exploit Not tainted 6.12.95+ #1
  ipv4_pktinfo_prepare+0x30/0x410
  udp_queue_rcv_one_skb+0x51c/0x1180
  udp_unicast_rcv_skb+0x109/0x350
  ip_protocol_deliver_rcu+0x14b/0x310
  ip_local_deliver_finish+0x29d/0x390
  ip_local_deliver+0x24d/0x2a0

Only grab the socket lock when SOCK_TIMESTAMP has to be set,
to keep the common case lockless.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Jungwoo Lee <jwlee2217@gmail.com>
Reported-by: Wongi Lee <qw3rtyp0@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260915043055.3441600-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 9d0fe1e8f5b29..ef5f69a4b3abc 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3608,7 +3608,14 @@ int sock_gettstamp(struct socket *sock, void __user *userstamp,
 	struct sock *sk = sock->sk;
 	struct timespec64 ts;
 
-	sock_enable_timestamp(sk, SOCK_TIMESTAMP);
+	/* sk->sk_flags must only be changed under the socket lock,
+	 * because sock_set_flag() uses non atomic operations.
+	 */
+	if (!sock_flag(sk, SOCK_TIMESTAMP)) {
+		lock_sock(sk);
+		sock_enable_timestamp(sk, SOCK_TIMESTAMP);
+		release_sock(sk);
+	}
 	ts = ktime_to_timespec64(sock_read_timestamp(sk));
 	if (ts.tv_sec == -1)
 		return -ENOENT;
-- 
2.53.0



