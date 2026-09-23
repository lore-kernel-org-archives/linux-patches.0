Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B32038D6A2;
	Wed, 23 Sep 2026 14:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173363; cv=none; b=LXGUskP7k3zYTrV4O7cnRBd/WSnxxV/kvnF7CGZ4SY+oV7Xa+PE3o51zFO/6zaT00RJT1FCL+C2JvJJ5MfJszPnamq99CO9DmxWHMykkneiw4XelV3xKBkpBwD0Xz7vE5Rt80BLrbJeA+K8Rjft99HuQxZjUr8zJ9fZCRSe01WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173363; c=relaxed/simple;
	bh=Lixz9AMBTPwHIv1X5lSZXDYWBkEo9OsVgQkHD9YihSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdW9Ip+6Q8zv6nsMXN9tLTrvsAXQmtuBEIrVAs4XSeIpYwgE3cJMBodFG0y3ZeLiojJ6Y2u510b5bsEYlIhW9nIGkKehR3MnPUvUZfZ5GsEKvtKQEuZuezJ5AjRtQ6p/2zvQikAK8xQMcdpbeOUMFxKnl1/MTCM0lanXQ3H/O6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyhrGJ8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyhrGJ8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A3E1F000FF;
	Wed, 23 Sep 2026 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173362;
	bh=2cnYr0mVqTh8eFS/2r/gTFO+vqcT2WefQAiUFYHZfqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyhrGJ8IB0brJCmYYHuLWVndXoFUZzaSYXcFO9x1OVpDwtpYlyRTwOV6rJo4RaNpO
	 81S7u7we3/Q8t7bAsSG0F3Wbyqoj7zzYJQsXGiOGW5GC8PN//igB7/SlIP/z3QXJD5
	 EMxiOXttV/yr7BeX8dhnO7KgrPICPvdhwUMAamgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 188/438] net: bridge: vlan: fix bugs caused by switchdev deletion errors
Date: Wed, 23 Sep 2026 16:03:29 +0200
Message-ID: <20260923140649.637744160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 2842ce397dd09882530b42f7fdb0c855767eb24e ]

Allowing switchdev to prevent vlan deletion and error out in __vlan_del
could cause multiple different issues - inconsistent state, memory leaks
when flushing, NULL pointer dereference on bridge error when flushing.
It doesn't make sense to allow it to stop __vlan_del, so log the error
and continue with software vlan deletion. This is also consistent with
8021q behaviour.

Suggested-by: Ido Schimmel <idosch@nvidia.com>
Fixes: bf361ad38165 ("net: bridge: check __vlan_vid_del for error")
Fixes: 5454f5c28eca ("net: bridge: vlan: check for errors from __vlan_del in __vlan_flush")
Fixes: 2594e9064a57 ("bridge: vlan: add per-vlan struct and move to rhashtables")
Fixes: 9c86ce2c1ae3 ("net: bridge: Notify about bridge VLANs")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260914105258.3436918-1-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_vlan.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 1e0e436629ece..92b3cb621a264 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -387,12 +387,12 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 	goto out;
 }
 
-static int __vlan_del(struct net_bridge_vlan *v)
+static void __vlan_del(struct net_bridge_vlan *v)
 {
 	struct net_bridge_vlan *masterv = v;
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_port *p = NULL;
-	int err = 0;
+	int err;
 
 	if (br_vlan_is_master(v)) {
 		vg = br_vlan_group(v->br);
@@ -406,12 +406,16 @@ static int __vlan_del(struct net_bridge_vlan *v)
 	if (p) {
 		err = __vlan_vid_del(p->dev, p->br, v);
 		if (err)
-			goto out;
+			br_warn(p->br,
+				"port %u(%s) failed to delete vlan %u from switchdev: %pe\n",
+				(unsigned int)p->port_no, p->dev->name,
+				v->vid, ERR_PTR(err));
 	} else {
 		err = br_switchdev_port_vlan_del(v->br->dev, v->vid);
 		if (err && err != -EOPNOTSUPP)
-			goto out;
-		err = 0;
+			br_warn(v->br,
+				"failed to delete bridge vlan %u from switchdev: %pe\n",
+				v->vid, ERR_PTR(err));
 	}
 
 	if (br_vlan_should_use(v)) {
@@ -431,8 +435,6 @@ static int __vlan_del(struct net_bridge_vlan *v)
 	}
 
 	br_vlan_put_master(masterv);
-out:
-	return err;
 }
 
 static void __vlan_group_free(struct net_bridge_vlan_group *vg)
@@ -449,7 +451,6 @@ static void __vlan_flush(const struct net_bridge *br,
 {
 	struct net_bridge_vlan *vlan, *tmp;
 	u16 v_start = 0, v_end = 0;
-	int err;
 
 	__vlan_delete_pvid(vg, vg->pvid);
 	list_for_each_entry_safe(vlan, tmp, &vg->vlan_list, vlist) {
@@ -463,13 +464,7 @@ static void __vlan_flush(const struct net_bridge *br,
 		}
 		v_end = vlan->vid;
 
-		err = __vlan_del(vlan);
-		if (err) {
-			br_err(br,
-			       "port %u(%s) failed to delete vlan %d: %pe\n",
-			       (unsigned int) p->port_no, p->dev->name,
-			       vlan->vid, ERR_PTR(err));
-		}
+		__vlan_del(vlan);
 	}
 
 	/* notify about the last/whole vlan range */
@@ -837,8 +832,9 @@ int br_vlan_delete(struct net_bridge *br, u16 vid)
 	br_fdb_delete_by_port(br, NULL, vid, 0);
 
 	vlan_tunnel_info_del(vg, v);
+	__vlan_del(v);
 
-	return __vlan_del(v);
+	return 0;
 }
 
 void br_vlan_flush(struct net_bridge *br)
@@ -1368,8 +1364,9 @@ int nbp_vlan_delete(struct net_bridge_port *port, u16 vid)
 		return -ENOENT;
 	br_fdb_find_delete_local(port->br, port, port->dev->dev_addr, vid);
 	br_fdb_delete_by_port(port->br, port, vid, 0);
+	__vlan_del(v);
 
-	return __vlan_del(v);
+	return 0;
 }
 
 void nbp_vlan_flush(struct net_bridge_port *port)
-- 
2.53.0



