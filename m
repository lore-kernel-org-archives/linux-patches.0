Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40DD350A03;
	Wed,  3 Dec 2025 16:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779128; cv=none; b=mGj9ubppXLbmSzqo+twJ7fQWVDkaHcGNYUQOqPNF44mp1w77ka6+exlHDI5aF7SmobSRo9wzOevQwsi4O+ML+5Sd6coEbxWV9sUuChIFir773mtHutjlB03/xtNi00Jsc+ryI3PHnGUfogZ2BbZJgH/oJHofDL3hFpcdxQ4SA7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779128; c=relaxed/simple;
	bh=oXBYx1rjxiUFFsAVzHFguAly1OVdnWx/fPH1U9lDTaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZ/GEhfqGeB/CoZXR/mwiDW4u0L9PUWOqJzHh/kNFd5GlBRolTnI4tjK9rAU9i1Ko0LvBse4eDi6G7HfJHCYhoY1G9W4fDxFsEPWHZbG/VEFOTaem/74A4L7+bKw1qswOWxgS8sJSxQR7HTC84kBF0rrgfBpDvQioNrGvunRqiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9tsW8lF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9tsW8lF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45034C116C6;
	Wed,  3 Dec 2025 16:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779127;
	bh=oXBYx1rjxiUFFsAVzHFguAly1OVdnWx/fPH1U9lDTaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9tsW8lFQpksyJb+B7O68dZEJuRgETdd0Gv7+2YBvxr1Ku0MhooZrafs2IzlWl1MD
	 VEFD4dP5ZGRkYnxZgxOmRTsZuwjO3Yn/kHaXVcT7bJqmPcnvEQrU37u2kO3QEFp8bC
	 EtItj9vi9vi/utBxDwJhRr2Oh/5OFYeYFs0pj5tk=
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
Subject: [PATCH 6.1 163/568] net: When removing nexthops, dont call synchronize_net if it is not necessary
Date: Wed,  3 Dec 2025 16:22:45 +0100
Message-ID: <20251203152446.693308921@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c0f9d125f401c..10cb365639aaa 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1812,6 +1812,12 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
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



