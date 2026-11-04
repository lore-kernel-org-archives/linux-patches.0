Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828934;
	b=kjQ3PIRIInHfVfT9WxwbE74FjRC8W4LdvMSQkhg+QFb5zg7SCB7yCoeT6ZjQJem49RQK
	 nZ6cN4ezVx1oYv+wN12bPMo/D/ZR1C+CQcCPojTOIlJYdm4Gahnv3f6wu+MvVTTGi6q2b
	 kP6nBgD7WTHBvWRNj05OUn4aXw8GlarI2Ew5GmZiNvQeqV0qJDjy98nWRAiq/gxw1Ap5o
	 lCOwKRU6l2p62QHko4YrUwAsxCgRWKhEsGwH7CqxgfcINft61Uk7JJCiO9cslwhUNz/Sg
	 sqqZ2DRe0114bKSIaA4OZMFZalhpjXW1ijRQ7saMJXe+RbWjtM9ziORuYhN3LGzL6Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hLSPOMSW6LJp8kJ7ZzOfBrATlmrotFi5v0qtPaOqRwY=;
	b=wDnnD8r2AlXnUJNZRm47zXgEziGqLpepUSRbo/KXvQ1H+vLOIuZWnxMebfTLgjX0LoGj
	 Y/Lw8TJyoSemnM9HWUePos/Cg2oSA7xbzg6TWc9spdbjwweDKvaVO7QNl+rzmr6TsbtB5
	 tqQTyv56MJ0B6cVd9pzNpfp0mIJQD4IB45be8nTUyjAEGgN98vl7DUkptdlR33pEIF8e1
	 IzQf6nv/Q4L7C7Wk3E+OG9XyNagidQPCL40hYX2RACmFC6wkq5PMxrF/YKasc0bcC0wbU
	 iCjqD4dicK7vpIUbA3yCbrHVFktbbzf7sIJznMnRx6QzYBMqMQQEzvSYIWqyTOR7/Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPJWOJ9J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF9F6070439;
	Wed,  4 Nov 2026 21:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPJWOJ9J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32631F00A02;
	Wed,  4 Nov 2026 21:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828934;
	bh=hLSPOMSW6LJp8kJ7ZzOfBrATlmrotFi5v0qtPaOqRwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPJWOJ9JssrMqLgcajxykuJO8NR3xtigpfbvn+HtS4uSUHWPnQRq+eoSPl8w7rfGa
	 21T6o9Q6qUuqfX0Cq+54WUqcl67Zx48dtIZXxevGfbwTLwuMSsDsUtOeIbgxDdL99Y
	 1rVzGZci6cUa7L0d5Z3VyvCYRtFAWdbv1Glrfnno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable+noautosel@kernel.org
Subject: [PATCH 7.3 335/547] rtnetlink: wait for RCU readers in rtnl_link_unregister()
Date: Wed,  4 Nov 2026 16:08:39 -0500
Message-ID: <20261104211047.749997410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 3b70edea393de445255da6c706eebb823117a955 ]

rtnl_link_ops_get() finds ops on link_ops under rcu_read_lock() and only
then takes ops->srcu. rtnl_link_unregister() unlinks ops, then calls
synchronize_srcu() and cleanup_srcu_struct() without first waiting for
RCU readers. A reader that found ops before list_del_rcu() and has not yet
taken ops->srcu is not waited for.

Such a reader then locks a cleaned-up srcu_struct and keeps using ops
after the module that owns it is gone. rtnl_newlink() and
rtnl_dump_ifinfo() both look up ops without RTNL, the latter for any
user that dumps links filtered by kind.

With delays added between the lookup and srcu_read_lock() in
rtnl_link_ops_get(), and before rtnl_link_ops_put() in
rtnl_dump_ifinfo(), running "ip link show type dummy" alongside
"rmmod dummy" on a KASAN kernel gives:

  BUG: KASAN: vmalloc-out-of-bounds in __srcu_read_unlock+0x57/0x70
  Read of size 8 at addr ffffffffc02ff318 by task ip/147
  Call Trace:
   __srcu_read_unlock+0x57/0x70
   rtnl_dump_ifinfo.cold+0x30/0x3b
   rtnl_dumpit+0x7a/0x1b0
   netlink_dump+0x486/0x11b0
   __netlink_dump_start+0x661/0x910
   rtnetlink_rcv_msg+0x611/0x9e0
   netlink_rcv_skb+0x126/0x380
   netlink_unicast+0x605/0x830
   netlink_sendmsg+0x6d0/0xbb0
   __sys_sendto+0x335/0x3a0

Call synchronize_rcu() before synchronize_srcu(), as
rtnl_af_unregister() already does. This should be enough because
rtnl_link_ops_get() is the only RCU walker of link_ops, and it takes
ops->srcu before rcu_read_unlock(), so every reader that found ops is
covered by synchronize_srcu() once the RCU grace period ends. The extra
grace period only costs time at module unload.

Readers and the writer were serialized by RTNL until link_ops got its
own mutex, which is why the missing RCU wait did not matter before.

Cc: stable+noautosel@kernel.org # needs real net-admin (non-ns)
Fixes: 6b57ff21a310 ("rtnetlink: Protect link_ops by mutex.")
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261001143040.28467-1-parri.andrea@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index be9d1625bac31..580101b5ab585 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -707,6 +707,10 @@ void rtnl_link_unregister(struct rtnl_link_ops *ops)
 	list_del_rcu(&ops->list);
 	mutex_unlock(&link_ops_mutex);
 
+	/* Wait for rtnl_link_ops_get() readers that found ops but have
+	 * not yet taken ops->srcu.
+	 */
+	synchronize_rcu();
 	synchronize_srcu(&ops->srcu);
 	cleanup_srcu_struct(&ops->srcu);
 
-- 
2.53.0



