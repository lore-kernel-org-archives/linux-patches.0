Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4170863B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB463C433D2;
	Mon, 20 Feb 2023 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900359;
	bh=1F1hR94WToyjFJLOOc+NN7q2MbWmQ+MmVCeilOz+YLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oF/8gP9JTc3LVvs7+MY0T+/jDDfCO3Csn3uWH5+4amOXTUaauR3BcITlXsFx8OX8Y
	 ZwDxj65pQRl+iobv7M5jnAbYSYZjGQSFbLdXbRiDdjdOD4DO1+h/02LNu8DUvxoKd+
	 OA2njv9E23dzLs/OiyTLTfTgOkAQcyDyV7jLhA6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 49/53] ipv6: Fix datagram socket connection with DSCP.
Date: Mon, 20 Feb 2023 14:36:15 +0100
Message-Id: <20230220133549.916776206@linuxfoundation.org>
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

commit e010ae08c71fda8be3d6bda256837795a0b3ea41 upstream.

Take into account the IPV6_TCLASS socket option (DSCP) in
ip6_datagram_flow_key_init(). Otherwise fib6_rule_match() can't
properly match the DSCP value, resulting in invalid route lookup.

For example:

  ip route add unreachable table main 2001:db8::10/124

  ip route add table 100 2001:db8::10/124 dev eth0
  ip -6 rule add dsfield 0x04 table 100

  echo test | socat - UDP6:[2001:db8::11]:54321,ipv6-tclass=0x04

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
 net/ipv6/datagram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -53,7 +53,7 @@ static void ip6_datagram_flow_key_init(s
 	fl6->flowi6_mark = sk->sk_mark;
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->fl6_sport = inet->inet_sport;
-	fl6->flowlabel = np->flow_label;
+	fl6->flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6->flowi6_uid = sk->sk_uid;
 
 	if (!fl6->flowi6_oif)


