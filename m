Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECCB343D67;
	Tue, 11 Nov 2025 01:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823599; cv=none; b=DoxSou/98RQFQNfRWuBlG9hzhEJSp+w+vOFJw2EHRitk3QDW8HmUFRi+bt1xlmMzkcTCxpAlpm+awrY3By+dFCrUcD5wbmaGL5V3S/jnO944zoCMEQseF3K92twHzMdHZofVxb+lCTwh7d3BdaLx8fB7YQe4QRknis9fdBoksbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823599; c=relaxed/simple;
	bh=vHPYdzg5lmy1xvrkKITrTkitomBh0eKuOJDs5NetCf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NamsjEGjwyVZu6jyMER7Pi828Ms29akP5EJhuZvvi2k2Le06lmTIBG1cnBmbKErGkttrdbOAZOKopicA/J3K/XTlYNJIYJrXnelByRYIM6VCbIZYCzbp8KWrKYD3nZ7sH9Uzr4eebPJyHVjQvaxkMwF6tpufV3O1rvdahH02MXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKe5JHgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKe5JHgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00298C116B1;
	Tue, 11 Nov 2025 01:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823599;
	bh=vHPYdzg5lmy1xvrkKITrTkitomBh0eKuOJDs5NetCf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKe5JHgiTze7BkDBJPPziuSGIZpP8eAg+4h9BsKL3yh7gZz6eacIFsJioR59WMVET
	 83p9AAkgUvnpv9fbII/71nDbwry84XGsY6mnwjem01mVRchyYe5yy5tziT79mi0D4O
	 Lg2zxNj1Qn7nZhaITGIHKw1v4vXb3grRsd6ZBKqE=
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
Subject: [PATCH 6.17 333/849] net: When removing nexthops, dont call synchronize_net if it is not necessary
Date: Tue, 11 Nov 2025 09:38:23 +0900
Message-ID: <20251111004544.467774433@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 34137768e7f9a..15acfb74fd238 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2087,6 +2087,12 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
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



