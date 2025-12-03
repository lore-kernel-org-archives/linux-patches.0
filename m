Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DE234AB14;
	Wed,  3 Dec 2025 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777677; cv=none; b=djT2B0WkF2XFrSH0dKMyivhaSw53GfHFh1vor7on8oXX7ISg47wWfrk1YNa/wi3xoRq3izuR07uPqUkFEFtmiKcfZVnBiAB6nVkfmFOHzaTo9QPyL2VOaIC6hO2emM6t9dcAJ4lPF+8aVVhhDp5PGty+8zgbbXtDvn0QegqdkFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777677; c=relaxed/simple;
	bh=q70X19hMI87eSTfZ20rhIQQCLc13EDPaxus4TB/QeyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0SYxzcv9elktgI1nwIQSYwXQKeGle24Cl++eBKJzN3Ez4zI7tsWEzZTtQPMDN4aOUOOEFD6ZE+ekyrI3x02WsYDMqADqu4aRYAvZvC343lboe3v/FmiCayDpk8hSuUgYIFZNldcHcR8WIAeShfNfIIqOuu0vOFOYkOZizL8QMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECdh1V1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECdh1V1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C51DC4CEF5;
	Wed,  3 Dec 2025 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777676;
	bh=q70X19hMI87eSTfZ20rhIQQCLc13EDPaxus4TB/QeyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECdh1V1x90Zp5J3cs8ZLRQmO7NEwonVoKTdAFDIp2o2PpKRgXubob3Imf9FBMPv0y
	 BVcJuTdsN65Fytw9oomAdqtKU+u+EVm0uv+ozVNfP/4gjU1IX+lCFr0GZv1yGP/C2p
	 6AxV4AldLB3hVRIsUlUQJK38zkq+gUW99IhIhE+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@openai.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/392] net: When removing nexthops, dont call synchronize_net if it is not necessary
Date: Wed,  3 Dec 2025 16:24:22 +0100
Message-ID: <20251203152418.220219713@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Paasch <cpaasch@openai.com>

[ Upstream commit b0ac6d3b56a2384db151696cfda2836a8a961b6d ]

When removing a nexthop, commit
90f33bffa382 ("nexthops: don't modify published nexthop groups") added a
call to synchronize_rcu() (later changed to _net()) to make sure
everyone sees the new nexthop-group before the rtnl-lock is released.

When one wants to delete a large number of groups and nexthops, it is
fastest to first flush the groups (ip nexthop flush groups) and then
flush the nexthops themselves (ip -6 nexthop flush). As that way the
groups don't need to be rebalanced.

However, `ip -6 nexthop flush` will still take a long time if there is
a very large number of nexthops because of the call to
synchronize_net(). Now, if there are no more groups, there is no point
in calling synchronize_net(). So, let's skip that entirely by checking
if nh->grp_list is empty.

This gives us a nice speedup:

BEFORE:
=======

$ time sudo ip -6 nexthop flush
Dump was interrupted and may be inconsistent.
Flushed 2097152 nexthops

real	1m45.345s
user	0m0.001s
sys	0m0.005s

$ time sudo ip -6 nexthop flush
Dump was interrupted and may be inconsistent.
Flushed 4194304 nexthops

real	3m10.430s
user	0m0.002s
sys	0m0.004s

AFTER:
======

$ time sudo ip -6 nexthop flush
Dump was interrupted and may be inconsistent.
Flushed 2097152 nexthops

real	0m17.545s
user	0m0.003s
sys	0m0.003s

$ time sudo ip -6 nexthop flush
Dump was interrupted and may be inconsistent.
Flushed 4194304 nexthops

real	0m35.823s
user	0m0.002s
sys	0m0.004s

Signed-off-by: Christoph Paasch <cpaasch@openai.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250816-nexthop_dump-v2-2-491da3462118@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 4a8fdaae6bf21..9bd72526000c4 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1811,6 +1811,12 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
 {
 	struct nh_grp_entry *nhge, *tmp;
 
+	/* If there is nothing to do, let's avoid the costly call to
+	 * synchronize_net()
+	 */
+	if (list_empty(&nh->grp_list))
+		return;
+
 	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list)
 		remove_nh_grp_entry(net, nhge, nlinfo);
 
-- 
2.51.0



