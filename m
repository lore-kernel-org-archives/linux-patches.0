Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039072F3C3E;
	Sat, 30 May 2026 18:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166596; cv=none; b=JqL3RL1Go2USyY+t9ZSom1OQc668FbsWN6bDUjDHP8wKzNSIiP0PUmieLNOxru0gTDDG7fUqeKXJ2l33UpC2hYtkhVk9g/zrY11eSQbRFxSlC1aSYYMpQKf39qAbPEy74B/b+rVxq8kPLl+y1BtqjYZpDPQ7XHM9qOUPzIsHcD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166596; c=relaxed/simple;
	bh=t9xZkmdH4uqLaol+OnXyrvKUPOgUxpxkWFHkP/ZAYK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxrIEdukpxAh4drd+mC0HxrQfl/TKMwUKdKX4z3FrsoMWHf6YSKYRgzk0XvMjRH9ieUIwahgE967Ydvb62Jx0g49z7bZjMkJHBxgbyOlQ4+sG0mgvi3Iq2abE1Ih5UCaJGJ2zpHE1NEEqHaUWER5QXJMP5J/8j+xfMQz7/XuZiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orVv4GhJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orVv4GhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6E91F00893;
	Sat, 30 May 2026 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166594;
	bh=7ll23bGkzhFcev5dTea9jsdQwIy0mFH14R6Tl4b4VHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orVv4GhJ3rnOPGeroagxMZ3h6mXbg9u4X55T1n9+NPOuccx0WAnqX3jfyD3lnWYs/
	 PidrQIEz7cwNK/jlIouXHT695tPbk0GdSYl0x1eN4lCsHZp6Lwx0d9L1yQhdTsv+QG
	 byDqmtC4Cyv6NbWZeCiz5/24NVvQ/1t2MxDa2vS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 413/589] nexthop: Emit a notification when a nexthop group is modified
Date: Sat, 30 May 2026 18:04:54 +0200
Message-ID: <20260530160235.606342984@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit f17bc33d7412bcca58825273d9f4abf84a87c4cb ]

When a single nexthop is replaced, the configuration of all the groups
using the nexthop is effectively modified. In this case, emit a
notification in the nexthop notification chain for each modified group
so that listeners would not need to keep track of which nexthops are
member in which groups.

The notification can only be emitted after the new configuration (i.e.,
'struct nh_info') is pointed at by the old shell (i.e., 'struct
nexthop'). Before that the configuration of the nexthop groups is still
the same as before the replacement.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 29c95185ba32 ("nexthop: fix IPv6 route referencing IPv4 nexthop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 75e1c8d3bd835..29f95987b68d5 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1014,7 +1014,9 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 				  struct nexthop *new,
 				  struct netlink_ext_ack *extack)
 {
+	u8 old_protocol, old_nh_flags;
 	struct nh_info *oldi, *newi;
+	struct nh_grp_entry *nhge;
 	int err;
 
 	if (new->is_group) {
@@ -1044,18 +1046,29 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 	newi->nh_parent = old;
 	oldi->nh_parent = new;
 
+	old_protocol = old->protocol;
+	old_nh_flags = old->nh_flags;
+
 	old->protocol = new->protocol;
 	old->nh_flags = new->nh_flags;
 
 	rcu_assign_pointer(old->nh_info, newi);
 	rcu_assign_pointer(new->nh_info, oldi);
 
+	/* Send a replace notification for all the groups using the nexthop. */
+	list_for_each_entry(nhge, &old->grp_list, nh_list) {
+		struct nexthop *nhp = nhge->nh_parent;
+
+		err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp,
+					     extack);
+		if (err)
+			goto err_notify;
+	}
+
 	/* When replacing an IPv4 nexthop with an IPv6 nexthop, potentially
 	 * update IPv4 indication in all the groups using the nexthop.
 	 */
 	if (oldi->family == AF_INET && newi->family == AF_INET6) {
-		struct nh_grp_entry *nhge;
-
 		list_for_each_entry(nhge, &old->grp_list, nh_list) {
 			struct nexthop *nhp = nhge->nh_parent;
 			struct nh_group *nhg;
@@ -1066,6 +1079,21 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 	}
 
 	return 0;
+
+err_notify:
+	rcu_assign_pointer(new->nh_info, newi);
+	rcu_assign_pointer(old->nh_info, oldi);
+	old->nh_flags = old_nh_flags;
+	old->protocol = old_protocol;
+	oldi->nh_parent = old;
+	newi->nh_parent = new;
+	list_for_each_entry_continue_reverse(nhge, &old->grp_list, nh_list) {
+		struct nexthop *nhp = nhge->nh_parent;
+
+		call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp, extack);
+	}
+	call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, old, extack);
+	return err;
 }
 
 static void __nexthop_replace_notify(struct net *net, struct nexthop *nh,
-- 
2.53.0



