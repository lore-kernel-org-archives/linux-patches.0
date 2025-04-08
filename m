Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97007267F5B;
	Tue,  8 Apr 2025 12:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115245; cv=none; b=F3arnlZTKUldVn9ZUdo6F3AsXX6x1b4DG9i5B9zDZhTU0yYNj/ZwDKEoPPvAO7/LTVpTwnFKFsoD8zez5sxWAUwR0fnozri/5+NlDUGDgRRWeEZezuNRN6ViP2DBYwtSgei93ZhNAshM8fS725jMp7byx6gUkOTTaig06ujTs4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115245; c=relaxed/simple;
	bh=UwC5q7rhiCOW5Ce3+vOo6PZZrxCouDt1ShYuPs5scUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq3JGJA6VcZPFNfqrnxfLA+cnfR35enE3IJStyxSDkpBUm3OpdVTqvtt7+dZkxDLZx4GYFxpO2jx7JnK8dJQcwDHtzo3l4c46rbEVcvJ3CwYNkLTt4xsdXsHt4Arq7l1pP7BvZereNQiWiDPb3KTXDrV56ipGZJyneKjVl0XryE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddgPrRWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddgPrRWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289A6C4CEE5;
	Tue,  8 Apr 2025 12:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115245;
	bh=UwC5q7rhiCOW5Ce3+vOo6PZZrxCouDt1ShYuPs5scUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddgPrRWuqAfUh/JxeIhKUexd2NHE+daijz2GG+8JeKx4Az73XvMICfku918NGSjfN
	 mBwkvfuWku8lzgxxydRUljtHtNhLMuDruxSHzf76mL6N/62Tdj6xq6sPx9wFLklx0K
	 OUsMqWm56GK9aKILclq3zhhJTEiHEov4I0e0epiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 403/499] ipv6: Do not consider link down nexthops in path selection
Date: Tue,  8 Apr 2025 12:50:15 +0200
Message-ID: <20250408104901.274855592@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 8b8e0dd357165e0258d9f9cdab5366720ed2f619 ]

Nexthops whose link is down are not supposed to be considered during
path selection when the "ignore_routes_with_linkdown" sysctl is set.
This is done by assigning them a negative region boundary.

However, when comparing the computed hash (unsigned) with the region
boundary (signed), the negative region boundary is treated as unsigned,
resulting in incorrect nexthop selection.

Fix by treating the computed hash as signed. Note that the computed hash
is always in range of [0, 2^31 - 1].

Fixes: 3d709f69a3e7 ("ipv6: Use hash-threshold instead of modulo-N")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250402114224.293392-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2656356c980ca..1114480b3755c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -442,6 +442,7 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 {
 	struct fib6_info *first, *match = res->f6i;
 	struct fib6_info *sibling;
+	int hash;
 
 	if (!match->nh && (!match->fib6_nsiblings || have_oif_match))
 		goto out;
@@ -468,7 +469,8 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 	if (!first)
 		goto out;
 
-	if (fl6->mp_hash <= atomic_read(&first->fib6_nh->fib_nh_upper_bound) &&
+	hash = fl6->mp_hash;
+	if (hash <= atomic_read(&first->fib6_nh->fib_nh_upper_bound) &&
 	    rt6_score_route(first->fib6_nh, first->fib6_flags, oif,
 			    strict) >= 0) {
 		match = first;
@@ -481,7 +483,7 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 		int nh_upper_bound;
 
 		nh_upper_bound = atomic_read(&nh->fib_nh_upper_bound);
-		if (fl6->mp_hash > nh_upper_bound)
+		if (hash > nh_upper_bound)
 			continue;
 		if (rt6_score_route(nh, sibling->fib6_flags, oif, strict) < 0)
 			break;
-- 
2.39.5



