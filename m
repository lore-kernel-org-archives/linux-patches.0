Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBF43AB476;
	Sat, 30 May 2026 17:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162569; cv=none; b=HsYbQa7zeYFkett5QoLchreKfayTf5bDns5xBvg9rsqLtCzc3lU67HfgspdTW/dRmdLCetkovSnFICUWBaRykNhQv/dj0Bgogay2pfJvRMyT04YxQi5bbc/6Am9RPMl0sSzfCnJxakoQI6PTB6T8gQ7XTwuuUjG2KxftSJyHlmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162569; c=relaxed/simple;
	bh=tp12LV6i1Ss5hxxYhEuG/2eVZNsyeoWruM24zK21EYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJlgjhhnYzY0QgKquUqlrilL2pKDMCKzygAYcrZhnzQv3T54uUMTkRCksZqGwUFV+0dKG8KPhkXPRb4AxVk9Fr+t/Jy2uEbMuj+r+I8Uz6fROGmjpXUiJ8ylwjtYCwSHQLEnOOEGhWPKi9ZyYuQTeWrhbsp5NYlwNI/S2tAeDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTI9NG0K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTI9NG0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B031F00893;
	Sat, 30 May 2026 17:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162566;
	bh=fAeXlabyFzXkCJ4XrVcs6hRfl5Ql54QTd+S4Ts8i4us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTI9NG0KEDPcCyYCpSX2JhEe5kH9g5WuQcnzKQwVig5Tt6yWWMHl4gXyKf+RyXcMC
	 KkAdkfjxZDxwM76gRiVlIG3vayNz+OizWwjaUe4fa06iF62ileAk8hY5ZeK6kPHzQw
	 8w2tRgW6gqHSYkhfqDMISioEUsrJ5650zxIWuJew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 961/969] net: bridge: Flush multicast groups when snooping is disabled
Date: Sat, 30 May 2026 18:08:05 +0200
Message-ID: <20260530160327.309955032@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 68800bbf583f26f71491141e4b3c8582f9cfcbde ]

When forwarding multicast packets, the bridge takes MDB into account when
IGMP / MLD snooping is enabled. Currently, when snooping is disabled, the
MDB is retained, even though it is not used anymore.

At the same time, during the time that snooping is disabled, the IGMP / MLD
control packets are obviously ignored, and after the snooping is reenabled,
the administrator has to assume it is out of sync. In particular, missed
join and leave messages would lead to traffic being forwarded to wrong
interfaces.

Keeping the MDB entries around thus serves no purpose, and just takes
memory. Note also that disabling per-VLAN snooping does actually flush the
relevant MDB entries.

This patch flushes non-permanent MDB entries as global snooping is
disabled.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/5e992df1bb93b88e19c0ea5819e23b669e3dde5d.1761228273.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4df78ff02629 ("bridge: mcast: Fix a possible use-after-free when removing a bridge port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 140dbcfc8b949..a58b85d21468e 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4468,6 +4468,14 @@ static void br_multicast_start_querier(struct net_bridge_mcast *brmctx,
 	rcu_read_unlock();
 }
 
+static void br_multicast_del_grps(struct net_bridge *br)
+{
+	struct net_bridge_port *port;
+
+	list_for_each_entry(port, &br->port_list, list)
+		__br_multicast_disable_port_ctx(&port->multicast_ctx);
+}
+
 int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 			struct netlink_ext_ack *extack)
 {
@@ -4488,6 +4496,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
 		change_snoopers = true;
+		br_multicast_del_grps(br);
 		goto unlock;
 	}
 
-- 
2.53.0



