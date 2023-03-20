Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F48F1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E679CC433A0;
	Mon, 20 Mar 2023 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325216;
	bh=BMLcc+mUHeTIoO5u5A7EYOK8rN40SjGFz855VtVqF6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ob6cWxezep5oQdpysGvTWo7o1ShJyOsR7CYVjAtdmYxYYiEbn/zlWoWUXV9/+F6/k
	 KL9QKQOBB2r0UIEjjyAbOGH4rgSZvFoNTnq+PwX7TQOVfwUHvpGUEjEAY1gUPy4im7
	 e9GkrvqZJDFjslpuSs/6HNQxzb3RuAOE/A4LXxcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paul Holzinger <pholzing@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/198] tcp: Fix bind() conflict check for dual-stack wildcard address.
Date: Mon, 20 Mar 2023 15:53:14 +0100
Message-Id: <20230320145509.871432969@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit d9ba9934285514f1f95d96326a82398a22dc77f2 ]

Paul Holzinger reported [0] that commit 5456262d2baa ("net: Fix
incorrect address comparison when searching for a bind2 bucket")
introduced a bind() regression.  Paul also gave a nice repro that
calls two types of bind() on the same port, both of which now
succeed, but the second call should fail:

  bind(fd1, ::, port) + bind(fd2, 127.0.0.1, port)

The cited commit added address family tests in three functions to
fix the uninit-value KMSAN report. [1]  However, the test added to
inet_bind2_bucket_match_addr_any() removed a necessary conflict
check; the dual-stack wildcard address no longer conflicts with
an IPv4 non-wildcard address.

If tb->family is AF_INET6 and sk->sk_family is AF_INET in
inet_bind2_bucket_match_addr_any(), we still need to check
if tb has the dual-stack wildcard address.

Note that the IPv4 wildcard address does not conflict with
IPv6 non-wildcard addresses.

[0]: https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com/
[1]: https://lore.kernel.org/netdev/CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com/

Fixes: 5456262d2baa ("net: Fix incorrect address comparison when searching for a bind2 bucket")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reported-by: Paul Holzinger <pholzing@redhat.com>
Link: https://lore.kernel.org/netdev/CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com/
Reviewed-by: Eric Dumazet <edumazet@google.com>
Tested-by: Paul Holzinger <pholzing@redhat.com>
Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index cd8b2f7a8f341..f0750c06d5ffc 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -828,8 +828,14 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
 #if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr addr_any = {};
 
-	if (sk->sk_family != tb->family)
+	if (sk->sk_family != tb->family) {
+		if (sk->sk_family == AF_INET)
+			return net_eq(ib2_net(tb), net) && tb->port == port &&
+				tb->l3mdev == l3mdev &&
+				ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
+
 		return false;
+	}
 
 	if (sk->sk_family == AF_INET6)
 		return net_eq(ib2_net(tb), net) && tb->port == port &&
-- 
2.39.2



