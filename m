Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1001B304989;
	Tue, 30 Sep 2025 14:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244348; cv=none; b=ECRD1zM4YdcOqFIYX9eiOxvVgvnxMO287lDgb41CKCllRdYgKNYZyVaIlCtxbJMs04OxuhBLiHp6haMVB7QOXvUueEwQRp2EGV6Q6D2MBcA0LaJ2A8uum8E6V0mMqvstWaEkEChnr+XB4yQyUTLu1pTnTUs8uF0zuICTwIg2s38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244348; c=relaxed/simple;
	bh=W41uSdpbee4bdxcYOoMRRhVlM80OsbaRBRVFN3lrrHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fv0rh4vdxfjyNnxAv/wk2GwdSt+p48B7tUZffCiNy+/HAUdji6qbLQIiRWYViVQ9WqKrHWFljwbaFEt7dA2tnJjVqggCnavgTUwDpXNv8AnSZ8aSSHT58NJYFU2hNuG1h4tUcCgL44BN5CPImGlicnJn35Xy25jWh3NBfuFTvtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0ed0Joo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0ed0Joo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE66C4CEF0;
	Tue, 30 Sep 2025 14:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244345;
	bh=W41uSdpbee4bdxcYOoMRRhVlM80OsbaRBRVFN3lrrHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0ed0Joo4gmJ3WSnEP8byLHfvrjczeCAxr6M0IKz4RMVxR7xsuV42Y4c5GKRoej8n
	 WKB1HrtFwsw4mREP/g1EqKtgggYZSELED1wAU8HOp5/m/ZwQIOCiOODo7aZZ1TwaI6
	 zgSYBNPBIEohNud7EMiuYU2OTZGLfkE6UdFxyIMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/122] nexthop: Pass extack to nexthop notifier
Date: Tue, 30 Sep 2025 16:47:13 +0200
Message-ID: <20250930143827.159983245@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

[ Upstream commit 3578d53dcef152a460a2d560c95dcc4399ff04cd ]

The next patch will add extack to the notification info. This allows
listeners to veto notifications and communicate the reason to user space.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 390b3a300d78 ("nexthop: Forbid FDB status change while nexthop is in a group")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index a508fd94b8be0..0653aa518648c 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -38,7 +38,8 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 
 static int call_nexthop_notifiers(struct net *net,
 				  enum nexthop_event_type event_type,
-				  struct nexthop *nh)
+				  struct nexthop *nh,
+				  struct netlink_ext_ack *extack)
 {
 	int err;
 
@@ -908,7 +909,7 @@ static void __remove_nexthop(struct net *net, struct nexthop *nh,
 static void remove_nexthop(struct net *net, struct nexthop *nh,
 			   struct nl_info *nlinfo)
 {
-	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
+	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh, NULL);
 
 	/* remove from the tree */
 	rb_erase(&nh->rb_node, &net->nexthop.rb_root);
-- 
2.51.0



