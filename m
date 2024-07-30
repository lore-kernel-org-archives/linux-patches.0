Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B726D1A76A5;
	Tue, 30 Jul 2024 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360662; cv=none; b=txa+9u39ATpjKh6xaabeLyBHnWQO3RGxXhdHxdmgrTYk5KgAhPOKRr6Jm0ULdG0Qup4yLCzUtZ8Woc8TAu8csXpJddqYKp7HuONrhD5DIgStaF9/9MiHdhwRF5zmTMehQoLI/rN1hwd0FCk4+RIOpr3h7UvJn12ruvvUwUho9ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360662; c=relaxed/simple;
	bh=cYS5dOs7NyhPfpXSn47fAIiFXSlv639fmw/BNv80JmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnWWTpcsTZC22fB1BN6LHWQDT7l2SBx7cIfaONArX/e1u1NOwAjhRY7eXcFbL8EAMVbetp0IbMoNcKrHgNUjk0FkNPTPzh555DkoG5yt8TG0mUFNhwwLoeA3D1RkHPicpDR6WBX2yUbtceA3f+zzJtN0ah//c51XZeqTserEgoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzToabFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzToabFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5CCC32782;
	Tue, 30 Jul 2024 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360662;
	bh=cYS5dOs7NyhPfpXSn47fAIiFXSlv639fmw/BNv80JmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GzToabFxWCg0jbsapRqdI6554OoHV/dpBAmQM5/V+egD/uwwR7kYvlJHSsfwgUK2J
	 u2ttp+RCERKt6aSKxECQ+WBTuuFwOU4S0HbLSOjBOldXxnS5IZCkmxUNBG0ztynzGX
	 s2f/X5fXWJijSu6mJFWGhOwUGaOqgU89GKPWC7k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 769/809] net: nexthop: Initialize all fields in dumped nexthops
Date: Tue, 30 Jul 2024 17:50:45 +0200
Message-ID: <20240730151755.339330892@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 6d745cd0e9720282cd291d36b9db528aea18add2 ]

struct nexthop_grp contains two reserved fields that are not initialized by
nla_put_nh_group(), and carry garbage. This can be observed e.g. with
strace (edited for clarity):

    # ip nexthop add id 1 dev lo
    # ip nexthop add id 101 group 1
    # strace -e recvmsg ip nexthop get id 101
    ...
    recvmsg(... [{nla_len=12, nla_type=NHA_GROUP},
                 [{id=1, weight=0, resvd1=0x69, resvd2=0x67}]] ...) = 52

The fields are reserved and therefore not currently used. But as they are, they
leak kernel memory, and the fact they are not just zero complicates repurposing
of the fields for new ends. Initialize the full structure.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 535856b0f0edc..6b9787ee86017 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -888,9 +888,10 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nexthop *nh,
 
 	p = nla_data(nla);
 	for (i = 0; i < nhg->num_nh; ++i) {
-		p->id = nhg->nh_entries[i].nh->id;
-		p->weight = nhg->nh_entries[i].weight - 1;
-		p += 1;
+		*p++ = (struct nexthop_grp) {
+			.id = nhg->nh_entries[i].nh->id,
+			.weight = nhg->nh_entries[i].weight - 1,
+		};
 	}
 
 	if (nhg->resilient && nla_put_nh_group_res(skb, nhg))
-- 
2.43.0



