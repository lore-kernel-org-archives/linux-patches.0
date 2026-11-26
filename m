Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705178;
	b=DzJKSn8ce5bFbDIsEzsIVCDjjh5c/PdE4SWCWaFdoPFP6P1BGFpjQfC+xJmNMxDg5LdX
	 gO2eYzVHrFJH2GUuvz9zlVNLv/32uFjhOJ+0mHgXRO+AS08+UsmXjzRAqenHE3Fc27KN3
	 vefjgLox91RjIPuGCtcpl+aX94Gl5nYGxBi7lv4ubjnmoJjV1jJwAlQARD/SalX6R2xDE
	 7qpsQK6y7OF9fgaM75nciRod3D6XwzvTh8umBVtqEaP1uedlNl+Cpt9r1GD1GHB5jB3UD
	 afMnH40nxCzXTQxTtjlOepiuh5j71bvIfxaLL2kRq08QKNB3N5d1OvFic7JZu56s/xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/zDTY4+l/qWee+VfbtfDbfueflD/u5638+1nLxQrXvM=;
	b=SCQfr1UGu5uw0VNkfyLFGRmrHRmrA787fLcZ8FoFffS3NxujbfCHik/HFWcavVhwgGgM
	 n8+iGHwx4JvB34juc+CrC8yZkh8y+8VrmfZPUY1/HNf4Qnplxq2b13hkHNnZ+3r4+vJUy
	 Euk1frcojqsRr+KHN896LHfkMiml9JMm5bsMwT+uSJif4U0iiDvbuIoFX/H0EMhD4lTSq
	 SpeO7iEPF8/XNlhmR4PMxclJX27DGH6gbPzLBb9UzR307K85JzZWn2Pt9w3nDZOYu9FjM
	 YCKzg1xDvlFOVPoFVwJbLhMrOy74Sp1RgdwsV55Ol3Ks5srk35KHBfJQJW4SsY1RqIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfxajOK7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7927E606A31C;
	Thu, 26 Nov 2026 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfxajOK7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933651F000C0;
	Thu, 26 Nov 2026 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705178;
	bh=/zDTY4+l/qWee+VfbtfDbfueflD/u5638+1nLxQrXvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfxajOK7dBacEX+eDYsRqjTlIdS92N2ZWarcN1nLRhi5S/IluJ5oDsQ9vhUyuRkAC
	 8ujv7jPbNyKoVfYorjQdUvC33PaqyvA8I8F2ZK1/QQlacgRxy2vicIu7Jg8eLTceSA
	 +d9CCCRKuvHKjENhomqfzoRXu/d21cwrYW59wlDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Linkui Xiao <xiaolinkui@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/319] tcp: ipv6: free ireq->ipv6_opt after an RCU grace period
Date: Thu, 26 Nov 2026 15:37:57 +0100
Message-ID: <20261126144009.204909349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit fafbc4051123d5459ea6950899cec08ed946e278 ]

ireq->ipv6_opt is only set by calipso_req_setattr(), when a CALIPSO
NetLabel mapping is configured.

Request socket migration (net.ipv4.tcp_migrate_req=1, or a
BPF_SK_REUSEPORT_SELECT_OR_MIGRATE program) clones the request
socket with inet_reqsk_clone(), so that the old request socket and
its clone share the same ipv6_opt, then reqsk_migrate_reset() clears
the pointer in the old one.

Another cpu holding a reference on the old request socket can still
be using these options, sending a SYNACK from tcp_v6_send_synack()
or creating a child in tcp_v6_syn_recv_sock(), when the clone
is freed. tcp_v6_reqsk_destructor() frees ipv6_opt with a plain
kfree(), leading to a use-after-free.

Both readers already run under RCU, like their IPv4 counterparts.
Use kfree_rcu() in tcp_v6_reqsk_destructor(), as commit e3f33b0a1d89
("ipv4: free inet_opt and ireq_opt after an RCU grace period") did
for ireq_opt.

Fixes: c905dee62232 ("tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netdev/179369559062.488856.15441115725436277776@kernel.org/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Tested-by: Linkui Xiao <xiaolinkui@kylinos.cn>
Link: https://patch.msgid.link/20261103090011.4128420-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 723831e2cc65d..4303d46fd4055 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -571,7 +571,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 
 static void tcp_v6_reqsk_destructor(struct request_sock *req)
 {
-	kfree(inet_rsk(req)->ipv6_opt);
+	kfree_rcu(inet_rsk(req)->ipv6_opt, rcu);
 	consume_skb(inet_rsk(req)->pktopts);
 }
 
-- 
2.53.0



