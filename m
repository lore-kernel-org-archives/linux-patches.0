Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B534A1A76AE;
	Tue, 30 Jul 2024 17:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359988; cv=none; b=hnyQerr6Dk3mWhvspwVYS5aEPxka7qDE7uxlY68TXxxTkzmyXlN+FBXxiJUZW/gkXX2nGLPkGTpPQYrUTrB/5uDAHMioU5XjLFvEFTBqCiBuyYotrafu1RbgzfW6Xk8v1SwB86MJRMmuhUSI3hpoalMxuj7at8vs0ydUMFozJIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359988; c=relaxed/simple;
	bh=ae+qylnIwn+nmi5FWM+BC8g+pQOQF1tBW2NhbOtO9Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDZejKvIYS45c5vww/+QTXLSAdbyW59dUD5KojPwPj0zdgl4pdCF955TuaENPpYTWDv8VKeZQd8qmoJqpzEokiez3BiOFgMw/+JQs5c8WLcJ34xy5xhrFdo5fWjQvIjsH3WWlrVZz9gAf4aAiAdLKP1ZpmRf8exYIW1r5ura5Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIqD3Udo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIqD3Udo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADD7C32782;
	Tue, 30 Jul 2024 17:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359988;
	bh=ae+qylnIwn+nmi5FWM+BC8g+pQOQF1tBW2NhbOtO9Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIqD3Udo16t3OKphC4GBVmLyxMy6BrpuLTg57yI0Jz0VqRuUDge1XNFs9g/7sal+1
	 sIeVE/JX/2vm5uuY3zkx2Pue49zDL+wlUa9dRwsDSz+rDM6hpJBpWeuAm+tbdRghuM
	 9fJzai9Kv1JXZn8bINhV136y7R3OSscrUlnBdmT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 542/568] net: nexthop: Initialize all fields in dumped nexthops
Date: Tue, 30 Jul 2024 17:50:49 +0200
Message-ID: <20240730151701.344382005@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bbff68b5b5d4a..8d41b03942197 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -676,9 +676,10 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 
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



