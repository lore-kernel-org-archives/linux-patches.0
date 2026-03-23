Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212F21A6828;
	Mon, 23 Mar 2026 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275653; cv=none; b=EGlrq9DUsbPoxIWmGSZM7iHKZt/1UBMYeBsQs7dvLr7aaZ27sosK6OOGUauo6SkGcyyUbTDRAE0sLcAL8ilN4x6D3gAI28C1QF/7LKUPw6lap43ay4mYDpX24PIzPhNNE2I5QSlvj4lPGCSbH4XGX2A4glqXfwf9Lo8sWPJkmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275653; c=relaxed/simple;
	bh=cfS8CBFXGbY/Vf3Mec7FrmKJMWd8edR47TDIWp8Kz7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=evhAOvdPImjUmaRbOdxXf+PN5634rYh0nKxSTWxqKwvT8P5jg0v0jT6wg9n06iFSJjSHOZcQvPjNeB7Oyq9MJf9OlWQXSAVmsUZpPok9GTzcH0wqoOrRHiDIFLRlK/K16BGXnQY8jSNEVmBpvJtmWVVmCs9rLgSoN+z/+Ghjrvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZU73wbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZU73wbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9828FC4CEF7;
	Mon, 23 Mar 2026 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275653;
	bh=cfS8CBFXGbY/Vf3Mec7FrmKJMWd8edR47TDIWp8Kz7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZU73wbGiVnAUbCJg6jwxv0fegJSWg2WYxtSK42GayRQefulHoWXxz5K+j6t/XaAp
	 R0Corx1quiH42/CWX2uLzMs7VXtPkRx35hWZZ9F6VaX5UHJO4ysGj5o9a3IZVnEpLs
	 djpar31/aPnCpLqPcGRF0SpuAm3WGgJgLnfY88Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehul Rao <mehulrao@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 173/460] net: nexthop: fix percpu use-after-free in remove_nh_grp_entry
Date: Mon, 23 Mar 2026 14:42:49 +0100
Message-ID: <20260323134530.786994603@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehul Rao <mehulrao@gmail.com>

commit b2662e7593e94ae09b1cf7ee5f09160a3612bcb2 upstream.

When removing a nexthop from a group, remove_nh_grp_entry() publishes
the new group via rcu_assign_pointer() then immediately frees the
removed entry's percpu stats with free_percpu(). However, the
synchronize_net() grace period in the caller remove_nexthop_from_groups()
runs after the free. RCU readers that entered before the publish still
see the old group and can dereference the freed stats via
nh_grp_entry_stats_inc() -> get_cpu_ptr(nhge->stats), causing a
use-after-free on percpu memory.

Fix by deferring the free_percpu() until after synchronize_net() in the
caller. Removed entries are chained via nh_list onto a local deferred
free list. After the grace period completes and all RCU readers have
finished, the percpu stats are safely freed.

Fixes: f4676ea74b85 ("net: nexthop: Add nexthop group entry stats")
Cc: stable@vger.kernel.org
Signed-off-by: Mehul Rao <mehulrao@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260306233821.196789-1-mehulrao@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1992,7 +1992,8 @@ static void nh_hthr_group_rebalance(stru
 }
 
 static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
-				struct nl_info *nlinfo)
+				struct nl_info *nlinfo,
+				struct list_head *deferred_free)
 {
 	struct nh_grp_entry *nhges, *new_nhges;
 	struct nexthop *nhp = nhge->nh_parent;
@@ -2052,8 +2053,8 @@ static void remove_nh_grp_entry(struct n
 	rcu_assign_pointer(nhp->nh_grp, newg);
 
 	list_del(&nhge->nh_list);
-	free_percpu(nhge->stats);
 	nexthop_put(nhge->nh);
+	list_add(&nhge->nh_list, deferred_free);
 
 	/* Removal of a NH from a resilient group is notified through
 	 * bucket notifications.
@@ -2073,6 +2074,7 @@ static void remove_nexthop_from_groups(s
 				       struct nl_info *nlinfo)
 {
 	struct nh_grp_entry *nhge, *tmp;
+	LIST_HEAD(deferred_free);
 
 	/* If there is nothing to do, let's avoid the costly call to
 	 * synchronize_net()
@@ -2081,10 +2083,16 @@ static void remove_nexthop_from_groups(s
 		return;
 
 	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list)
-		remove_nh_grp_entry(net, nhge, nlinfo);
+		remove_nh_grp_entry(net, nhge, nlinfo, &deferred_free);
 
 	/* make sure all see the newly published array before releasing rtnl */
 	synchronize_net();
+
+	/* Now safe to free percpu stats — all RCU readers have finished */
+	list_for_each_entry_safe(nhge, tmp, &deferred_free, nh_list) {
+		list_del(&nhge->nh_list);
+		free_percpu(nhge->stats);
+	}
 }
 
 static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)


