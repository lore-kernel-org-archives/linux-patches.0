Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621655;
	b=uoFsKmbr0nuxxnBJPN/dzX3IlDnu1/itq8I9bicuCwqOW/Aqick52XZFoWm32fQY91iK
	 BsyTGwIj1ChbxftNdte8kyoIXbwRbx4DXa9idWTqIMsTdXcZqWn3aXxLL/Q+bOKmnxeRW
	 Q0ojZ13MvEl0sgTQEZ77IO+dLX8ZS/qwgpjGdeDSGdAb6qpB2VuuM5+aE7LCaPfjRj6Ag
	 H3GboKLm8M1MQtpPul8vRAmdYG9yMs8BMT1tQbAyDewwGJcD+TYjNQGGb/xaHWEZY5jIa
	 u24CoWuXHDyVWld0Z2wx+aEFD9W+vCXlba9RLEDd+9zUWGau/8sFViDfOtuTrIlyFmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VjJJfNo0wLEYbSbaqQOFLdTjKeqHppnqpNSstxF8pOo=;
	b=XoGhL/3mJdydlp15iTAYl5CiL6PwscfL7kGazbTNH4DjsV/ypUavVHppbT0Sgsn9aeNU
	 DT2MtnC5/aw6hT4VzfUgr9XKSuJG8F12bg3/DoKIKm+sXAh+PzRCx73g3PuNlZg/BbPjF
	 foOGlrKnOiI6qHYJy1lx1RLuCw/h2/XcBBoJFEzNHDRx2z+WLrY95ofI8TeC3E/cdBlT1
	 Rpjk5Gw40HaNaAOGlA6O/UidloMAiCr5TWNoPS6maQIYNeKDN1S1xIt7pq85PwwS8H1XZ
	 c/mO1dH0L85bQgFWAgmgsaSQItRwB2L+dPUfMhodHzbM4lA4f2e3Gx0IepBvzXtp4oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MBWTibh6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639FD606A333;
	Wed, 25 Nov 2026 15:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MBWTibh6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7551F000C0;
	Wed, 25 Nov 2026 15:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621655;
	bh=VjJJfNo0wLEYbSbaqQOFLdTjKeqHppnqpNSstxF8pOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBWTibh6LKYyczknw3elpzjrRUUOdMiyOof9BbmEkswfwnfafrKDyZTmO0fVEP1OT
	 NwniOxT33JNY3ct8tLU6GuFbgTtW7FKXeAQH8KrTuxIun7I2VC0y5GVqs2eGmT4uYc
	 VT8sXcPXMq4UGaoWgXHjnU/YNzbMf/hQJdROT92w=
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
Subject: [PATCH 6.18 293/990] tcp: ipv6: free ireq->ipv6_opt after an RCU grace period
Date: Wed, 25 Nov 2026 15:27:40 +0100
Message-ID: <20261125143828.952130078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fade3907b05da..b07e8d22edcfb 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -583,7 +583,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 
 static void tcp_v6_reqsk_destructor(struct request_sock *req)
 {
-	kfree(inet_rsk(req)->ipv6_opt);
+	kfree_rcu(inet_rsk(req)->ipv6_opt, rcu);
 	consume_skb(inet_rsk(req)->pktopts);
 }
 
-- 
2.53.0



