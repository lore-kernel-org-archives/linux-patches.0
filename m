Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027895;
	b=IEOvrt1fMA93LQ5YyUyk7X4CZZ9JTk1nQrJ+nqAyouHw03nytXmuHVv9pzcb5gL/dOEN
	 O5xv/YWLPUPTUdIp1gkPdEDneXpbXp5D9ajx1sI/fppetgfBtnnkHyTBCw+R3Ia2VVVGj
	 OFAjm+RgqjmAKHdCVaqNLLjKVuw1miB1LrWAAi34x7RfMo28DQBSIDU1dI9O5Xtcr/CHM
	 gBSmg9iDp2ksDTvDmPvlL4H7fSVixvGj6e9z7mrPB/gUaZHzG1eobZ5JMSBL1FkxIl6U6
	 k6NmOPCIxSvmh7Nf2n44Vn6hldJaalaF8s44z4WbUoTQGI4MDlr4Kgc8cKGGmdTvlRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0AQ1+6FffTx2mD+TWX+KGMa+6EDRQzD1sgYMwquI76I=;
	b=4UckzQJ8P8IDwJZtyHbXoQ8qIU4sRuNEdrnuF2oSLPcKPMoVDjuIPSkiWEzDjC//A9m6
	 lDuk0M1Axr2OdoooR9wOPauk5GAawZNtJQOX5U1qkoM0XYBNjOlQafk8myQ7CAemTP8lP
	 iL28Jx3cPqzu/pvrRErqvu8cOHekdeJYKvxgLHhBdum0HUVpKE5sT45cFtwtu6tWF/zm3
	 T6PXsUpmbj8TqSak9g3ELwVbF3nJ6weOj+fprxVdHeasf7VkX8mGLgC9sGSvhPNfFG/AB
	 G5a1X3i3QJHvBZp2ZBj0Sr2ZN7Z4TdXyKDkGzRk3uEK+qOM+WcxXvTco7NSp/6ZeC8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SaEKRaoD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1607B606A320;
	Wed, 18 Nov 2026 18:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SaEKRaoD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674A21F000C4;
	Wed, 18 Nov 2026 18:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027894;
	bh=0AQ1+6FffTx2mD+TWX+KGMa+6EDRQzD1sgYMwquI76I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaEKRaoDN+kLWdIL/erhW56gxPM/HHkXvySwySnR3r2XKDX5nyxyk4yTXdMojgL3L
	 gSICYNZuvXeHfYCHCmqclysvUZ9lObZU0sqXSgKZY+a/q3lySQZVI+p0SBuZ5ywdqW
	 h8v4fkoG3V4u2k1/Ju66PjsZeXyZREObMjf1a6yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1949/2151] netlink: fix out-of-bounds bitmap access clearing stale mc groups
Date: Wed, 18 Nov 2026 16:01:24 +0100
Message-ID: <20261118150232.761607660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 6430fb7f1cc4e329e386521b7b208df443de92f2 ]

netlink_realloc_groups() sizes nlk->groups to the number of groups
that exist at bind/ADD_MEMBERSHIP time.  When more multicast groups
are registered later (e.g. a new genl family), existing sockets keep
their smaller bitmap.

When clearing a multicast group of a departing family,
__netlink_clear_multicast_users() runs netlink_update_socket_mc() on
each socket on mc_list, which does test_bit()/__assign_bit() on
group - 1 with no regard to nlk->ngroups.  Skip sockets whose bitmap
predates the group: such a socket can never have joined it.

The overflow windows differ per architecture, both needing privileged
module (un)loading.  On 32-bit kernels the ~54 dynamically allocated
genl groups already exceed the initial 32-bit bitmap, so the table
can grow there directly.  On 64-bit kernels the same in-tree set fits
the initial 64-bit bitmap only while allocation stays contiguous:
genl_allocate_reserve_groups() takes the first free contiguous range
and unregister does not compact, so an unload/reload sequence can
fragment the ~59 free IDs until no fitting range remains, forcing
the table past 64 bits and reaching the same stale-bitmap overflow on
the next family teardown.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: 84659eb529b3 ("[NETLIKN]: Allow removing multicast groups.")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index fec8b52ed05e7..7141bbfc241f1 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2142,8 +2142,12 @@ void __netlink_clear_multicast_users(struct sock *ksk, unsigned int group)
 	struct netlink_table *tbl = &nl_table[ksk->sk_protocol];
 	struct hlist_node *tmp;
 
-	sk_for_each_bound_safe(sk, tmp, &tbl->mc_list)
+	sk_for_each_bound_safe(sk, tmp, &tbl->mc_list) {
+		/* bitmap predates the group, can't be a member */
+		if (group - 1 >= nlk_sk(sk)->ngroups)
+			continue;
 		netlink_update_socket_mc(nlk_sk(sk), group, 0);
+	}
 }
 
 struct nlmsghdr *
-- 
2.53.0



