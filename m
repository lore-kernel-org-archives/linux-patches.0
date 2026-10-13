Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24873CFF6F;
	Tue, 13 Oct 2026 11:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892301; cv=none; b=aVlmgXnAgD5KDMnn1slGaiKfcy6acWhNbpgdT8wspkHY+8NSYBWe5qxHaP710fjbjvXZR13tFE+jDYd+uqVAyu1kEkOucrybABDCeUtT8BhfJrGBTENRV85JZVbwcwExDMzFAMfMRMUj7XJBIC4H4GzeLiP/oI91Izg6AJxDF3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892301; c=relaxed/simple;
	bh=RaIQZDmyWK2Rurvs88KOdarj8q/Fvv/OISr/8ViPn6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOR3+oiWROXPOn1M/Y/YcGT+K2dFfS4vUUXo/ZvdEesKo3OIJof5yr7M7JmRRutcUXvCoIfuuTMeVrCkatKjgKQyrleCCBYmNxTOoS42EZ2NWZwQ7Hkj2HqPmh2wbYWpP4pf9UiaBmjh0sfpO6DBRHB7jHhJBIz9Hi2jJBYUDV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzxjUqhS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzxjUqhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479291F000FF;
	Tue, 13 Oct 2026 11:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892299;
	bh=h4uT5v6ejCzNbWOVLR+pf6Yn+4sFvQUe16NBkKgOTTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzxjUqhSissW5qZgR9cCHpQ68NBmTTvYtMyTk30JU//u4BVNCDfLCksfWFCnAlhbT
	 HPIp7gep80iSgXHhVQrxNiHAK3mw+N0WY0lIDnRWAC/3ut29k6pe1UejsbZFyZh39I
	 yCr3FWGpiHKkG/a1BAa/eJ8Hzthd6gNAX5Dro8ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zixuan Chai <petalzu987@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 7.2 083/281] net: bridge: avoid recursive multicast port cleanup
Date: Tue, 13 Oct 2026 13:36:39 +0200
Message-ID: <20261013112857.146601780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zixuan Chai <petalzu987@gmail.com>

commit 5158353121bae4f552cb677ce8c5c3ef52f93a0d upstream.

br_multicast_sg_del_exclude_ports() removes automatically added STAR_EXCL
port groups by calling br_multicast_del_pg(). For S,G entries, that
deletion calls back into br_multicast_sg_del_exclude_ports(), so a large
number of STAR_EXCL ports consumes one kernel stack frame per port and can
hit the stack guard page.

Keep the complete port-group deletion path for cleanup, but suppress the
S,G exclude-port cleanup while that helper is already walking the same
entry. Normal deletion callers retain the existing behavior.

Fixes: 8266a0491e92 ("net: bridge: mcast: handle port group filter modes")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -81,6 +81,10 @@ __br_multicast_add_group(struct net_brid
 			 bool blocked);
 static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg);
+static void __br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+				  struct net_bridge_port_group *pg,
+				  struct net_bridge_port_group __rcu **pp,
+				  bool sg_del_exclude_ports);
 static void __br_multicast_stop(struct net_bridge_mcast *brmctx);
 
 static int br_mc_disabled_update(struct net_device *dev, bool value,
@@ -458,7 +462,7 @@ static void br_multicast_sg_del_exclude_
 	for (pp = &sgmp->ports;
 	     (p = mlock_dereference(*pp, sgmp->br)) != NULL;) {
 		if (!(p->flags & MDB_PG_FLAGS_PERMANENT))
-			br_multicast_del_pg(sgmp, p, pp);
+			__br_multicast_del_pg(sgmp, p, pp, false);
 		else
 			pp = &p->next;
 	}
@@ -799,9 +803,10 @@ static void br_multicast_destroy_port_gr
 	kfree_rcu(pg, rcu);
 }
 
-void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
-			 struct net_bridge_port_group *pg,
-			 struct net_bridge_port_group __rcu **pp)
+static void __br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+				  struct net_bridge_port_group *pg,
+				  struct net_bridge_port_group __rcu **pp,
+				  bool sg_del_exclude_ports)
 {
 	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
@@ -816,7 +821,8 @@ void br_multicast_del_pg(struct net_brid
 	if (!br_multicast_is_star_g(&mp->addr)) {
 		rhashtable_remove_fast(&br->sg_port_tbl, &pg->rhnode,
 				       br_sg_port_rht_params);
-		br_multicast_sg_del_exclude_ports(mp);
+		if (sg_del_exclude_ports)
+			br_multicast_sg_del_exclude_ports(mp);
 	} else {
 		br_multicast_star_g_handle_mode(pg, MCAST_INCLUDE);
 	}
@@ -828,6 +834,13 @@ void br_multicast_del_pg(struct net_brid
 		mod_timer(&mp->timer, jiffies);
 }
 
+void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+			 struct net_bridge_port_group *pg,
+			 struct net_bridge_port_group __rcu **pp)
+{
+	__br_multicast_del_pg(mp, pg, pp, true);
+}
+
 static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg)
 {


