Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618566;
	b=Q1IFJrj8DpagZemMVWT7gN27ruoGdqtnd80Xf3QeucJ9G7Aac7NmeCtQjBCk1KInfLo7
	 Ye05d/IqLz1FjpOQ85VSDoXX9eaQGeHUgJ0TM/DF0eXf8AoCeH28jZMBQdqCYY18ZnSqy
	 +8JMyIizOkTe/dIwsD6jPWaWBADg8TSXcEeuHHRq3PMc4RUv8QGZ/d1marhOFrk2um+B9
	 KWCjIxcQhDVq8CXY639x8RTtXJ3vqfzC/6MWWDgecOO3Af7R5ljQOpUyRAnpJUWjsUPqA
	 BhMyOU1Mct4fhmF3nLiPL8HoXcK21F1m7t0D0Xgl9+GBwsaQl5oKf3POzWCgyWuOLSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C2XcPu+k5EIG2nj/x9AQTMmArdRkS6LiPevZfJLTjdQ=;
	b=w2w++Z7FpD/BmJy5Wv9CyW/J8lBXtJTXN8nSavp4WqP+grwgoP3bOH7QEV2KxInEkhrm
	 NOZq22aAr2YojRdOFNUaUVwM8gddrlbxiFT7valpjh7FOJn0FWkbM4rvjU0RNj0nWSNW7
	 L0fMzrSWOdSmc4MflZqILQjSZYCdUTzzAo33JYxZyvQ4SKAzjrNVEzVHFNIPGGLd1ujy0
	 wOKXxKDENkzytQfp+9GlfN43IIlLNf+MqiyfuCkvH9zBHPHHUXzNn3nJL1ygjjD+az1C2
	 laM/w0zAD0WR7WdX68cIoEu5TY+8m39b6fe6bDXnRhu+w3ZaK1CcO5RJgjrmtQcSAJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nGE/n4Cd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFCD606A33D;
	Wed, 25 Nov 2026 14:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGE/n4Cd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E57C1F0156A;
	Wed, 25 Nov 2026 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618565;
	bh=C2XcPu+k5EIG2nj/x9AQTMmArdRkS6LiPevZfJLTjdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGE/n4CdYUOaNFVPX4VXIabyPcVaMAV4rX3msWWdLh6RN/fdqb3tpen5siQzXwkqu
	 6KKg6xaI3HmxpnmZDXn8VC+raBJKa0Eu41fqkcUF9P2EBLALH8rxAAEstvemQWP+Wl
	 6EOy+3yzHjSsixRbem7H+spVSiNHKfPZHt+t9knM=
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
Subject: [PATCH 7.3 0321/1005] tcp: ipv6: free ireq->ipv6_opt after an RCU grace period
Date: Wed, 25 Nov 2026 15:27:39 +0100
Message-ID: <20261125143829.254798503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 40025284b9110..ff2a7ce78073e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -607,7 +607,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 
 static void tcp_v6_reqsk_destructor(struct request_sock *req)
 {
-	kfree(inet_rsk(req)->ipv6_opt);
+	kfree_rcu(inet_rsk(req)->ipv6_opt, rcu);
 	consume_skb(inet_rsk(req)->pktopts);
 }
 
-- 
2.53.0



