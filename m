Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E72F36E467;
	Wed, 30 Sep 2026 16:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785902; cv=none; b=Sihr09XtHTRN7W58WSNPPHnPOE8JZF+EHu3WyJod9UKUHGt+84xtfrqr+j5ZJlDz0OUMckJL/IQARvEyMtpeO+2Zaut0ABL2krweSJteVCmG5t7+fsyZNO6qqpL83bjXry8Om3Yk2eCnX3ovyTLpplS6H76USJFraxSvZmVt/sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785902; c=relaxed/simple;
	bh=KdPCGDVeqs7rUYR7PlPGJ5uWbHRW+ICmsqlCRFkT7Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGeT2BMqFL67Da7O/DBzShjbiycPtlKbpbv+tAnUGNGEMi4mjWqLh9FFyyUfUQ4gNHEdYlg325XpPO+jiefzptHLMwmSFq3lJeURIYM3Tr+hoHG8ayXROD7MtYU67/AXX/PGHmz6H/8PSxg1bPI/4xFY3iqx5MrPudaSwMxqUsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KuGOqIYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KuGOqIYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81451F000FF;
	Wed, 30 Sep 2026 16:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785901;
	bh=XEPUdFNAwbjPapDtQBi5dvV5/Ezu0OZ8OfdOHli/ZFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KuGOqIYUESU62/2u0EDc8LpOs/jJf+Dmiif2sr9Q5P6ZoGCXzA+8LLNEYXCpRt49D
	 TBHSvBrrimrdNoBNfRAj8Tpm7kN6n19iNvx3D+dSzoCZS/bqIqYIjFPGHVWVQ0MB2o
	 RS0vDYiuRd+459mhJj/xBQz200Un/t4us6fpRq34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 671/982] net: bridge: mst: move switchdev call outside rcu
Date: Wed, 30 Sep 2026 17:23:27 +0200
Message-ID: <20260930152431.177060781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 18a6fe05fb6e18de29fa90d388bb34044114b3d8 ]

This is a follow-up of one of sashiko's pre-existing bug reports.
br_mst_set_state() calls switchdev_port_attr_set() for nonzero MSTIs
while holding rcu_read_lock() which invokes the blocking switchdev
notifier chain and may sleep. Nonzero MSTI changes come from netlink
with rtnl held. Move the switchdev call before entering the rcu section and
assert that rtnl is held.

The call cannot be deferred because netlink needs its error and extack.
Also DSA reads the old bridge MST state during the callback and checks it.
A deferred callback will be late and will see the updated state.

Fixes: 3a7c1661ae13 ("net: bridge: mst: fix vlan use-after-free")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260911105021.1385934-1-razor@blackwall.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mst.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 43a300ae6bfaf..1654efd3045b0 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -107,21 +107,24 @@ int br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state,
 	struct net_bridge_vlan *v;
 	int err = 0;
 
-	rcu_read_lock();
-	vg = nbp_vlan_group_rcu(p);
-	if (!vg)
-		goto out;
-
 	/* MSTI 0 (CST) state changes are notified via the regular
-	 * SWITCHDEV_ATTR_ID_PORT_STP_STATE.
+	 * SWITCHDEV_ATTR_ID_PORT_STP_STATE. All other MSTIs are handled via
+	 * netlink with RTNL held
 	 */
 	if (msti) {
+		ASSERT_RTNL();
+
 		err = switchdev_port_attr_set(p->dev, &attr, extack);
 		if (err && err != -EOPNOTSUPP)
 			goto out;
+		err = 0;
 	}
 
-	err = 0;
+	rcu_read_lock();
+	vg = nbp_vlan_group_rcu(p);
+	if (!vg)
+		goto out_rcu_unlock;
+
 	list_for_each_entry_rcu(v, &vg->vlan_list, vlist) {
 		if (v->brvlan->msti != msti)
 			continue;
@@ -129,8 +132,9 @@ int br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state,
 		br_mst_vlan_set_state(vg, v, state);
 	}
 
-out:
+out_rcu_unlock:
 	rcu_read_unlock();
+out:
 	return err;
 }
 
-- 
2.53.0



