Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E35C1A01D2;
	Thu, 15 Aug 2024 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731482; cv=none; b=rFyjPyJq3wDr6lEXQIVYe+XJFQA2qBdnsBId11YhnnMx/gM+ptoGs32XztE3xY0b/o3dYnmQ0oWrhON2vfBnswcWoEQER8J9Z1qtzW/L5/p+J3kbm3Uft5RoBV0G32ATOjktw7ZZwkb2P6MUuSoTNTkTDKMqLQpif3pVK1FOtKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731482; c=relaxed/simple;
	bh=7kcbAlDIyivt9wOjbLGHYv3jN8s5E6gm878BloKlUhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6rQGUcCVgnIi2Vw7y/ALAan2XwYoSMTD4tU90uxm4b9GN3aBEn0GHjBawzq8mjZBVbMsIiDYGZSS20GsfduB+CP6U9atJ1c7qgd6VEdXyDcu3dcLj6C6YgAyQ3k7cmK74YHMW0lf3cHpLOte6NYVytQ2f5RuceTkvyEvaHQLQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQui2Y0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQui2Y0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92525C4AF0C;
	Thu, 15 Aug 2024 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731482;
	bh=7kcbAlDIyivt9wOjbLGHYv3jN8s5E6gm878BloKlUhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQui2Y0+BAEYXp1ilu8sYHP95NSqnIXcArZySDAS9kouL5Na49t+wjEdBu1m5S88u
	 bQ40/3ABUazZf6nRrQbEmod1BR6KE5go6Ogf5tFOls270RbeERZYxe9AW6j8PRvlcx
	 /RStotK6adOgepiwlmoONzd61nudM4tbI/6Cu38M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/259] net: nexthop: Initialize all fields in dumped nexthops
Date: Thu, 15 Aug 2024 15:24:37 +0200
Message-ID: <20240815131908.352623448@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0137854a7faaa..388f5773b88d2 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -201,9 +201,10 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 
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
 
 	return 0;
-- 
2.43.0



