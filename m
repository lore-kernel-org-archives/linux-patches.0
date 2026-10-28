Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209375;
	b=ODhcE7UdfEeZvAjN/JDx5VwCfQdLVmi2ggtJJMBiYiOYs3vNzDmbvwwItCbtOPtkir+9
	 r5gELHR5812FSyIJ3iLeqMYDxlI4zQw0nnTR68ED/Zd9neFBuiMNidV8R+IV4g6Oyp64r
	 hDWQPz3um+WcV7+gMbcoLYGj3TyHSXHPtWLFSsoF6drRTAFF1eLmMYRcxuGbqF53fpqWJ
	 3Nd1u9RIHh/O/jc29JkfTrBINnRIGxYEl1NWBdNRh1biDqGxXXWuSPMQiRHUPhW95I9bl
	 FkNLF5GIZZ6ouLMLrUL1xvlGmh9Nf9M/tJRc/eHMObriGWQSCTSFfWtMMt2wI/ucCaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VM9O6RUDyE7kis0EPJShCVYhw9OZYoPQhshnJmRK09I=;
	b=vo3kMWXopnDhAGmBG5HJvCx0FihWUOHo9gjtwRxTO+6o5BVWk8tQN81JOnVP1Ri+iIKU
	 G+QJRpzgPd8+uKVwZunLllVBv5XI9h8yInBxHexkdUrvH2ZaArp3+8teJmKK5m4mblFRP
	 57SXBsOwB9eWY3jHfKhWwpWOmvD/zdWOfudpfWX+ZQpkedmTXn6L07UMa7UUrBIC+PI6s
	 iP3ejWqrJr0/JCNjyKH8avLAbNvN4h4yeiCsF8UcneMpyVS3gFjBEKLO25mE3El/hfAu8
	 c8+56Dt4BTbNYNUkUvuWaevJPjmKiNEjqCGoEnyyp5VFrS4q1OHq+HZRLmialTS15pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rTl4fxQG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4EF606A31A;
	Wed, 28 Oct 2026 17:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rTl4fxQG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99001F01825;
	Wed, 28 Oct 2026 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209375;
	bh=VM9O6RUDyE7kis0EPJShCVYhw9OZYoPQhshnJmRK09I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rTl4fxQG0jrVk1Pa2RXhq+G8CVRdSTZSme2GvuLPxMmgyrkQXDQ/O8szeufFOo75K
	 TVlG1E1xfs55AaLXCQFWXp3zipC5jvYrYA1bE+PBHujo4RtPJVXnyFNJQQKFmAnR3I
	 ElM7Dc211V/e9VIHkIfQYAhwgiwll0JJXGA4B/3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 448/516] netlink: avoid hashing the network namespace pointer
Date: Wed, 28 Oct 2026 18:00:00 +0100
Message-ID: <20261028170014.094001750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit f88bb3606e4bd11ee035b682cddc2999e604609a ]

The netlink rhashtable key includes a raw struct net pointer and a
user-controlled port ID. Both /proc/net/netlink and socket diagnostics
expose the table's bucket order. By binding and rebinding chosen
NETLINK_USERSOCK port IDs, an unprivileged reader can distinguish equal
buckets and recover the low bits of the Jenkins hash. Its 32-bit seed
and the limited set of kernel-image slides can then be searched offline
to recover the address of init_net.

Use the namespace's unique, non-address net_cookie in the comparison
key instead. It is assigned before the per-net initializers run and
remains unchanged for the namespace's lifetime. The lookup key and
object hash are still built by netlink_compare_arg_init(), keeping
lookup, insertion, removal and rehashing consistent while preserving
namespace separation. Neither public table walker needs to change.

Reading the socket's namespace cookie in netlink_compare() is safe
under RCU, including during namespace teardown. netlink_release()
removes the socket from the hash table and defers its final put with
call_rcu(). cleanup_net() runs the per-net exit methods and waits for
outstanding RCU callbacks with rcu_barrier() before freeing namespace
storage.

Unlike ns.ns_id, net_cookie is also available and initialized during
setup_net() in older stable kernels, making the change straightforward
to backport to v5.15 and later.

Fixes: c428ecd1a21f ("netlink: Move namespace into hash key")
Assisted-by: LLM
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261008011359.63727-2-kylebot@openai.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 291f7eabd37c4..7e608b03ec5eb 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -455,7 +455,7 @@ netlink_unlock_table(void)
 
 struct netlink_compare_arg
 {
-	possible_net_t pnet;
+	u64 net_cookie;
 	u32 portid;
 };
 
@@ -470,14 +470,14 @@ static inline int netlink_compare(struct rhashtable_compare_arg *arg,
 	const struct netlink_sock *nlk = ptr;
 
 	return nlk->portid != x->portid ||
-	       !net_eq(sock_net(&nlk->sk), read_pnet(&x->pnet));
+	       sock_net(&nlk->sk)->net_cookie != x->net_cookie;
 }
 
 static void netlink_compare_arg_init(struct netlink_compare_arg *arg,
 				     struct net *net, u32 portid)
 {
 	memset(arg, 0, sizeof(*arg));
-	write_pnet(&arg->pnet, net);
+	arg->net_cookie = net->net_cookie;
 	arg->portid = portid;
 }
 
-- 
2.53.0



