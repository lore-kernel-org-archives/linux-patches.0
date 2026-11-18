Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042529;
	b=ND0AfHamBx8dt5uSZmODdCqu3v42d5CfM2Y6gzJugcPUju8wFqsM2XitDBCldnnLBVQm
	 bPq6OLwIApRk/vxP2C919uSeFz9q1z0pfhZjxhywbQjxnHupe8UeKAOy8WvIFbzKd5oyy
	 arsyH+cF3l3H8Rafxhtkm9GzmOd2mvPaILUuJ45M6u7qdy6tfZj61dTDMGZmx1CjDra2I
	 34onaVwMIsmv/AW4rBkoL+gQZQp096CsZEPEZjPl/h0BiOzK01GHX83EEPZU71WjPBEt3
	 8LbNj81EYYK1dlM+wB3up6Fr4k9QpE6QQp6fd5RzVBQ2okwzX4eJH+iPCkwp24G2BYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=akypOQRrkPAehc3iLsU1QSLE62JNcQeh23dwaqypuTA=;
	b=uesBo4cZ9w7ekDijQNuwlxvK4LwoDcrPxBtJEuBAuQOtqQubPFeGv8kcWJf3DtG7QQ7o
	 ttKJm9w6YmHu9Pf/WUaeoQ/dNiI0ofjcYGkX3k12QhrolJX7df3rH+ZoxDrPyOCHfvsm6
	 O4OnGVEL9647Ccx8dS8k4ci0cCZF9QqrWmhR3iD2CIR0r8q5D4J4rfOAFIpmGWpVZSXDG
	 y38sc4Dqt3tpvbWbyPUU8pQA0nWUd2K3/JNImJQvKES4DY2Kmphkvlerf1w23IjMzCoaG
	 CPM8Ytqyagrj6B9Z+GVIt6kn0pSCkaLD2bpD1xfFFTeGbn7kVThKj18bqhQ3QUKbnaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="upFo/u7B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDEA606A320;
	Wed, 18 Nov 2026 22:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upFo/u7B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC201F000C4;
	Wed, 18 Nov 2026 22:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042529;
	bh=akypOQRrkPAehc3iLsU1QSLE62JNcQeh23dwaqypuTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=upFo/u7B2+ulEQs1Drod2o/xeUdMpm5mrLbicr+c4K5FJhAIMYR7PWyI0U244IenV
	 kV8I/VawKVnqnuWRUKm6atVI1VrYvmB0t7EUjNkXZFXr7TpPoOwIRtBgfgGOS0VdPQ
	 sLnMVvFN7AdCCcQhvKmTpOiFoRCjLyJYqMZ7Toto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3163/3318] netlink: fix out-of-bounds bitmap access clearing stale mc groups
Date: Wed, 18 Nov 2026 16:03:05 +0100
Message-ID: <20261118150454.737004725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a7d3673ca72fc..8eda1ad3751ce 100644
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



