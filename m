Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7FA27603A;
	Thu, 28 May 2026 20:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001535; cv=none; b=jZskXBEScta46hMmVBNpdYWHcrcm3N8D+MFFSPQWnvfqDDeQHcjeax2HRXbxKV8OaLdZiepj9QREF2j5icvOzQzPHS0TPavR6uUj3W1aOherDPfDZ22/YEKjHDwHA54DvnLwuObf195YNBsL3ATga4kckixBl6FaWT30mX3kAXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001535; c=relaxed/simple;
	bh=xQzct3Y8xOMaJwyqZurrnJAADuyi8NMZxQ7OYbcB5Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO96KnWMMjEQCPUxO7B4pD4eHKQQSljq8MDb/aU/0mg+m89oM1lac3TwZZZznzwdZb1ZXlJnFqk4wz7F4caDpauZLrx7VlUbeladsTAC4sXK3juoTOoLn40Eg9WRY714YqNBx8g6+0FdyKZQPUEy5EW+PWWiDZdiq43/eKc0Lko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kVwdrz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kVwdrz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C331F000E9;
	Thu, 28 May 2026 20:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001534;
	bh=rYxwb+8xmJNfot1PCRSHjypD+quY0x/5NZfT1Ds0o2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1kVwdrz0p4SDAAhKlvpwWiBw9FlLd5zMFFg9faRl3nu4vYDrzWVGoyy1Cw0RNNcVC
	 /6WqPylMHlHn/7IapzneZEmNQCer6cCsz5D2AY/2qlgDZmemmOfthbzKBqisqGroLa
	 WeyCjugs2V0yZ11J0I1PFJuIPc3QeKIqz/WtB0sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/186] net: bridge: Flush multicast groups when snooping is disabled
Date: Thu, 28 May 2026 21:50:43 +0200
Message-ID: <20260528194933.363700326@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4e75ec75c7021..f0a0f24f2172a 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4641,6 +4641,14 @@ static void br_multicast_start_querier(struct net_bridge_mcast *brmctx,
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
@@ -4661,6 +4669,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
 		change_snoopers = true;
+		br_multicast_del_grps(br);
 		goto unlock;
 	}
 
-- 
2.53.0



