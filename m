Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5974189DD;
	Wed, 23 Sep 2026 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173129; cv=none; b=Yz0EFb+x9S8rGALRMf5lezvI3utbh8EG7/A2DeeLiwl/ySOKYG/E7AmTK0SmzI6TwJXma0ejNZoyNnsrmNBmL5GPPJrrqqk4B+m0wAT9yx4jsNV0KMTpRLRACh977V9ayjRDW1N58DckUZ/Jl/ikhVaahRKjKO3YgJ+aNrMGfLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173129; c=relaxed/simple;
	bh=XJMdLHWN7YMSBEWKFNpb1pJA7nNRkv6iu5fL11jCedw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HltwwUUnvg+7EIOaqAhXNxWEtv71ZktrckiFync/F2PhiaIgqO5ebrwKgt7DIsaYvfLXyx24CrKuwDROmGtQifnk/98uKGHR9evLUsm4zBRWKZPYzq/21QMteiHknJHfXvsALeCKzGOPph52UfQv+GPUY+tyr5/jL3DRjbxPoMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1Pvb/+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1Pvb/+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953591F000FF;
	Wed, 23 Sep 2026 14:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173128;
	bh=zfWdI/pid5zHoa6GnMa9WPoGCQGwAHTVkwMvVhqGfrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o1Pvb/+LvK43AB1a8/caAUL4ws1+E9M3pmNTHKDgC4sZLc1o9KqOVH8vo7VLYE+qf
	 OQTSLNpTiOaV1Tb7Kx+7yDIDUexQPtUkQpPnc/b+nKjlKs4XkSQrcCbCy3Rp1cQUF6
	 toDqETncZi9UN2/qaz8SddrnwPbkS7xPJDH3d9UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 117/438] neighbour: Dont render blackhole_netdev via RTM_GETNEIGHTBL.
Date: Wed, 23 Sep 2026 16:02:18 +0200
Message-ID: <20260923140647.813161180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 7b430fcfc972f61b09cc19ca95997586af4a147d ]

The cited commits started to initialise blackhole_netdev with
neigh_parms_alloc().

This is visible in init_net as the ifindex==0 entries via
RTM_GETNEIGHTBL:

  # ynl --family rt-neigh --dump getneightbl --output-json \
    | jq '.[] | select(.parms.ifindex == 0)
              | {name: .name, ifindex: .parms.ifindex}'
  {
    "name": "arp_cache",
    "ifindex": 0
  }
  {
    "name": "ndisc_cache",
    "ifindex": 0
  }

For RTM_SETNEIGHTBL, ifindex being 0 means wildcard.

Let's skip blackhole_netdev's parms in neightbl_dump_info().

Note that lookup_neigh_parms() does not need the same change
because the default parms is always the first entry and matches
with ifindex == 0.

Fixes: e5f80fcf869a ("ipv6: give an IPv6 dev to blackhole_netdev")
Fixes: 22600596b675 ("ipv4: give an IPv4 dev to blackhole_netdev")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260909233143.2401847-4-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 0db78a0dfb516..02bf940ce00af 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2624,7 +2624,7 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 			if (!net_eq(neigh_parms_net(p), net))
 				continue;
 
-			if (!p->dev)
+			if (!p->dev || p->dev == blackhole_netdev)
 				continue;
 
 			if (nidx < neigh_skip)
-- 
2.53.0



