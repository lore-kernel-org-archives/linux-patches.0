Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8BD63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE748C433EF;
	Mon, 20 Feb 2023 13:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900364;
	bh=gnfPGIBf8HQY1BWsNQx0oxx+OH7pE9hPsNRjYz8x/po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=038GXCJWLdbY6M338/UTJmOeEVIDvS7HixjlIG0vrpll5DTT0Ft2acLYo1bzCY+Rr
	 w/EQDUVVxgvYGXjnBRvTSKBATVq6lroIp2jQ7S7qZaoobTOfZ0Ed8XOGowudvPXvV1
	 JRoQc668N06WIxqOC/W+x1CA8lia9p9hwfA2e/lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 50/53] ipv6: Fix tcp socket connection with DSCP.
Date: Mon, 20 Feb 2023 14:36:16 +0100
Message-Id: <20230220133549.950894862@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guillaume Nault <gnault@redhat.com>

commit 8230680f36fd1525303d1117768c8852314c488c upstream.

Take into account the IPV6_TCLASS socket option (DSCP) in
tcp_v6_connect(). Otherwise fib6_rule_match() can't properly
match the DSCP value, resulting in invalid route lookup.

For example:

  ip route add unreachable table main 2001:db8::10/124

  ip route add table 100 2001:db8::10/124 dev eth0
  ip -6 rule add dsfield 0x04 table 100

  echo test | socat - TCP6:[2001:db8::11]:54321,ipv6-tclass=0x04

Without this patch, socat fails at connect() time ("No route to host")
because the fib-rule doesn't jump to table 100 and the lookup ends up
being done in the main table.

Fixes: 2cc67cc731d9 ("[IPV6] ROUTE: Routing by Traffic Class.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/tcp_ipv6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -241,6 +241,7 @@ static int tcp_v6_connect(struct sock *s
 	fl6.flowi6_proto = IPPROTO_TCP;
 	fl6.daddr = sk->sk_v6_daddr;
 	fl6.saddr = saddr ? *saddr : np->saddr;
+	fl6.flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6.flowi6_oif = sk->sk_bound_dev_if;
 	fl6.flowi6_mark = sk->sk_mark;
 	fl6.fl6_dport = usin->sin6_port;


