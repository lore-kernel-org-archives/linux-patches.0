Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042477;
	b=5kVFTeP1ndg8uomPP4pb6OA4kKxmTlkc5lI2Im0X+o8t9qXvpUc8M7ByStmjNJ+f9X/O
	 TOgYlsW98Z67/S05PYmvq7XQD6pxFhHEB+z8J8DL5hn2musHnuooWqMk5QD7u7AkzVl48
	 PZJQnZ0zwGAwbMrCfSzdXUhoMK9GZbI63DSrZpTkDOGrcLbFNkBQHDDdCAO+yXREoGggH
	 Ad6xEilEk7D5wP7mnBXV0bhUTUZo5eiboHRdPNRMrKfzI0DjejNgh9dmGtdPA01GkhMSm
	 961Bu4aOrjMVIE0yQWjvT2bZ8EYmWGl5xmxn8s4dRheunZWKSdmt5Mar88LxlHg0pyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ewLNYJcPKiNm5U4lZNWy7tRHBCnFij+k+LwzmJ6WZuI=;
	b=1pApkGmH63VcB55FOOJk3m10xaduPWWtCywi0xo38rdUhk4n0E8fH/2AsnThR0aZx544
	 GgGRVVJ156FnaNg3uAcxUEbSZPhQvTWXa+1dkBZBf0cGcI+6L8C3r/B4TlpWn5rem4jwW
	 HELQcJt28H78EyJualEt1kfFYR5nabQf6wHp9hxOC3pAALG0a3oODVXexo87XSRSVZJFI
	 q4r2/89i/35Itbl9Ay8segroQgM66JpfDPtUG3l81G0AinKBmJDg4s+Xhg/2t8maQ6wNU
	 kC5Aqeq/RKVNtxOlUSBkjot0OtOJBGyI1p/2DIrlujwQzRkZS6OlD9tr4/Hjxq2nMLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y0wyzjoa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2EE606A31C;
	Wed, 18 Nov 2026 22:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y0wyzjoa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6581F000C4;
	Wed, 18 Nov 2026 22:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042476;
	bh=ewLNYJcPKiNm5U4lZNWy7tRHBCnFij+k+LwzmJ6WZuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0wyzjoaf0R46kxETamVzHpSFSxdtDfstFf7hJGl9FwWtYlUYdfEfyRSgrZbbsIBx
	 Ao1kqWKYlu7VYjOIbSb3Iv3uSBX+2dLM+5Gw/GHebzd8XQ+8ex8QDqVre8rO8qMHdJ
	 sigN8UhvKpL/mFnkrC7I71P5uYRL/gqyWLXHQIig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3184/3318] gtp: hold RCU in gtp_genl_send_echo_req()
Date: Wed, 18 Nov 2026 16:03:26 +0100
Message-ID: <20261118150455.327590469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit a204e9c001dfafe83cac01b16508b1cf5c953355 ]

Such function is invoked in process context, performs an RCU device
lookup and dereference the found device with no additional protection.

  =============================
  WARNING: suspicious RCU usage
  7.3.0-virtme #7 Not tainted
  -----------------------------
  net/core/dev.c:1047 RCU-list traversed in non-reader section!!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  locks held by python3/233: 2, last CPU#5:
   #0: ffffffffbab93268 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40
   #1: ffffffffbab93320 (genl_mutex){+.+.}-{4:4}, at:
                                                genl_rcv_msg+0x12c/0x160

  stack backtrace:
  CPU: 5 UID: 0 PID: 233 Comm: python3 Not tainted 7.3.0#7 PREEMPT(full)
  Hardware name: Bochs, BIOS Bochs 01/01/2011
  Call Trace:
   <TASK>
   dump_stack_lvl+0x6f/0xb0
   lockdep_rcu_suspicious.cold+0x37/0x8e
   dev_get_by_index_rcu+0x135/0x180
   gtp_find_dev+0xe7/0x360 [gtp]
   gtp_genl_send_echo_req+0x298/0xb30 [gtp]
   genl_family_rcv_msg_doit+0x20f/0x310
   genl_family_rcv_msg+0x3a8/0x640
   genl_rcv_msg+0xbb/0x160
   netlink_rcv_skb+0x154/0x3a0
   genl_rcv+0x28/0x40
   netlink_unicast+0x54b/0x860
   netlink_sendmsg+0x7fb/0xf60
   __sys_sendto+0x3d6/0x450
   __x64_sys_sendto+0xe4/0x1f0
   do_syscall_64+0xff/0x530
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7ffa43b0256e
  Code: 4d 89 d8 e8 d4 bd 00 00 4c 8b 5d f8 41 8b 93 08 03 00 00 59 5e 48 83
   f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c9> c3 83 e2 39
   83 fa 08 75 e7 e8 03 ff ff ff 0f 1f 00 f3 0f 1e fa
  RSP: 002b:00007ffd3b8828d0 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 00007ffd3b8829e0 RCX: 00007ffa43b0256e
  RDX: 0000000000000034 RSI: 00007ffa3519d0d0 RDI: 0000000000000006
  RBP: 00007ffd3b8828e0 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffa351cc0c0
  R13: 00007ffd3b8829e0 R14: 00007ffa354ca130 R15: 00007ffa4433d498
   </TASK>

Add the missing RCU guards and keep it for the whole function body,
while the RCU-protected device is used.

Found by code inspection, validated explicitly testing the relevant
code path.

Fixes: d33bd757d362 ("gtp: Implement GTP echo request")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/ed27d133fe73afd377d3fa4e553c34e7987b6dd9.1792744478.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 6e6942d1e2c70..23a0dc9f578be 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1761,9 +1761,9 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 	struct gtp_dev *gtp;
 	struct flowi4 fl4;
 	struct rtable *rt;
+	int len, ret = 0;
 	struct sock *sk;
 	__be16 port;
-	int len;
 
 	if (!info->attrs[GTPA_VERSION] ||
 	    !info->attrs[GTPA_LINK] ||
@@ -1775,14 +1775,21 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 	dst_ip = nla_get_be32(info->attrs[GTPA_PEER_ADDRESS]);
 	src_ip = nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
 
+	rcu_read_lock();
 	gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
-	if (!gtp)
-		return -ENODEV;
+	if (!gtp) {
+		ret = -ENODEV;
+		goto unlock;
+	}
 
-	if (!gtp->sk_created)
-		return -EOPNOTSUPP;
-	if (!(gtp->dev->flags & IFF_UP))
-		return -ENETDOWN;
+	if (!gtp->sk_created) {
+		ret = -EOPNOTSUPP;
+		goto unlock;
+	}
+	if (!(gtp->dev->flags & IFF_UP)) {
+		ret = -ENETDOWN;
+		goto unlock;
+	}
 
 	if (version == GTP_V0) {
 		struct gtp0_header *gtp0_h;
@@ -1791,8 +1798,10 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 			sizeof(struct iphdr) + sizeof(struct udphdr);
 
 		skb_to_send = netdev_alloc_skb_ip_align(gtp->dev, len);
-		if (!skb_to_send)
-			return -ENOMEM;
+		if (!skb_to_send) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
 
 		sk = gtp->sk0;
 		port = htons(GTP0_PORT);
@@ -1808,8 +1817,10 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 			sizeof(struct iphdr) + sizeof(struct udphdr);
 
 		skb_to_send = netdev_alloc_skb_ip_align(gtp->dev, len);
-		if (!skb_to_send)
-			return -ENOMEM;
+		if (!skb_to_send) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
 
 		sk = gtp->sk1u;
 		port = htons(GTP1U_PORT);
@@ -1819,7 +1830,8 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 		memset(gtp1u_h, 0, sizeof(struct gtp1_header_long));
 		gtp1u_build_echo_msg(gtp1u_h, GTP_ECHO_REQ);
 	} else {
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unlock;
 	}
 
 	rt = ip4_route_output_gtp(&fl4, sk, dst_ip, src_ip);
@@ -1827,7 +1839,8 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 		netdev_dbg(gtp->dev, "no route for echo request to %pI4\n",
 			   &dst_ip);
 		kfree_skb(skb_to_send);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unlock;
 	}
 
 	local_bh_disable();
@@ -1841,7 +1854,10 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 				    dev_net(gtp->dev)),
 			    false);
 	local_bh_enable();
-	return 0;
+
+unlock:
+	rcu_read_unlock();
+	return ret;
 }
 
 static const struct nla_policy gtp_genl_policy[GTPA_MAX + 1] = {
-- 
2.53.0



