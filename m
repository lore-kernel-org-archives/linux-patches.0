Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BD13DBD65;
	Wed, 30 Sep 2026 19:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796121; cv=none; b=oNM3n5j/c6Dxl9fwfwk++s3YHfcqBjbKQrHV0a4vpdAFnuAna5PGDABUG6krq7iBIYjoZS/32QS2gFFkS4BkSut34CCliKOH1U2deIqateWLWkAffwu76ynOh0O/bF8bMenkm9bu6fS2XJXK2iXXayNB3BVZaxMklbgLrYil/6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796121; c=relaxed/simple;
	bh=LU3pm4yoH1brUeNqteFyDdQlfWcGaBIrWcieBr/vVUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPAR2qUAVWtbCf4JoCP+UXYUeXYlFfRDwRNbEj8tbE2YXNUQqcl/VtalZiFJFaHWmRbv6inMAKtgvhFuU3YcP7vIG6bZnE+bOsfJL+oWsFhyeGQSLEpNxcERhFTpegT3JG5Z0W7G/fBg+kEWMby7pqjBSKq8o6MszjEQjHgdinA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1s1qU3s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1s1qU3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3891F000FF;
	Wed, 30 Sep 2026 19:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796120;
	bh=xf7+CPNjlo7zwTA5WdUgmjXApkcyiUI5T9RtNhhfqWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1s1qU3s6PGRLkWepMwFSxEBQKSuk65a9r1Z2Ak0CE6DBgQ+/TFzxoTPBPgiWXOJr
	 5Xjxc7MxxT0EHpv5wH4F4pOaaAZXIyWmpbw5b1ozProGbYc0gOd32h2nWPjh/s6Zzl
	 Tl2bvi6d19EFSP1pYNQrKAD0/P6ECb+ttxkIgt/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0799/1193] net: bridge: mst: move switchdev call outside rcu
Date: Wed, 30 Sep 2026 17:24:43 +0200
Message-ID: <20260930152451.997440357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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



