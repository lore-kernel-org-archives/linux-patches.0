Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774538;
	b=C2yOVrWZM7JkplEzeqRs2cHp+eDDk49S+LvU53e/bYvvY7JaPSu4JTtujEviaqdJPBAH
	 Xy1auicDnwH3qbLvAWiQs+4q0hhAwbJa3AYC+Gjqdq8ZQ9+AzWtQx0xfJH+NKOStfb1fW
	 uRzzm5QfP6X/ClEWLK07wnCQeMBg0eY6mAlG9MmKkF8HORtUIp12stnAZczZirqa+h2kK
	 APoMMIK+YvLgalv+H4xeY7qbHNAQdQLMze/vxAeuRUyumehAgVNF8GrAd06OQseOCH/4/
	 03vmpeUTE5zDbeTHbBFOt4wjaCse6jx0Nf6xVhVy3btPdOvkuHvJ0rlYzBhWaSfhlnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3W2jnDpxUQKPZ4HEzmxYrlyGW/mSLVWuy8JuI09zIk=;
	b=uyBxTSPgSr6WaYRtwmqn/uYVOB4Fk1SGufgWwvesKzj1Tw79OgAdrTjcmIGuX4d6IyoJ
	 vz4E4Y2vxdPgGrF2PVfYRLxnD83Yfoa/GovaMTdso7Rm5ammawXPVdP8F7NO6HuYldNzf
	 jfZAZwoQKcPmx6hKvFY5x9QuO9O728yqBdRenfeIt8P6mzWPk/iAXKJPCgKhqGSvR6pzB
	 AVGtUDv/XG2lHAofMc0QggtaWjadyqlDk6AmFOuO+BP3uLBMjMxHO6x5RzDribvg977Oo
	 rm0cKZaP/vozeIzOtbNF1GJvKainHaEbr299IkN6r9miZ4VITBni/JXJOAPFryCgETQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yA9dzYHZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E581606A31E;
	Fri, 23 Oct 2026 16:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yA9dzYHZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792F71F01825;
	Fri, 23 Oct 2026 16:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774538;
	bh=b3W2jnDpxUQKPZ4HEzmxYrlyGW/mSLVWuy8JuI09zIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yA9dzYHZI3Y0d5vpO6iAyL1B64qgbeoKZzZFdOPWEAL3E2bFH7w5NON/g2Xe5j1Tr
	 ka4jOUI2NbQvHGE9IgMAg5lhGmTJvN+9Pqox5HAaBoDEVSkerYaEV10wzTmYcu2fmv
	 NGQAcWAtuTUMF3YyXpHKFbiQn314thIxffNYVAnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 074/242] netlink: avoid hashing the network namespace pointer
Date: Fri, 23 Oct 2026 18:38:36 +0200
Message-ID: <20261023163715.530219207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5324edb13760a..3b980302a7991 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -464,7 +464,7 @@ netlink_unlock_table(void)
 
 struct netlink_compare_arg
 {
-	possible_net_t pnet;
+	u64 net_cookie;
 	u32 portid;
 };
 
@@ -479,14 +479,14 @@ static inline int netlink_compare(struct rhashtable_compare_arg *arg,
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



