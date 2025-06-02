Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E49223DC0;
	Mon,  2 Jun 2025 15:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877074; cv=none; b=Phwf82RxpoSWgFGWo3ZnvcaSh6OvBdYP9AeJXWUgSRkoLextWt74qW2E2F7LHtCtvXuAELDJgN9qRZy9xHdGqN/HA4g+IPOY9R6YcE7TCbBeewKKk5wFWueB6AWC2qr006iOjUGw/jRqV+c/MIhDatmD7gS2Ba7ZhtkYCl3HeaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877074; c=relaxed/simple;
	bh=cUvBffMp/oVdr5s7aCeLjURHMWixSAhjx0V917/Jd+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqvuGAmgPU75JIU+8lKBzmeMEhivWOPov76JCONVWzvhgX629WHbSoR6FJBqSpMzmMvB6lidU0AP+p9DvEZ5xLOu2hD7aAhTjn4Q0FX82oSMAp1dL2nBeRa+l0lBIrcXkATGr1ko36nNT5V8321THkDb2cP0MCM9deuqclIVlxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+Owcl7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+Owcl7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C52C4CEEB;
	Mon,  2 Jun 2025 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877073;
	bh=cUvBffMp/oVdr5s7aCeLjURHMWixSAhjx0V917/Jd+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+Owcl7fPN/OGeE/2+FvfLpblhzDR+Bpz3TD2FYW2t8E18W4tN4d+R3V90NOHw0EH
	 m2yvEH2ncjkHLupzzmfmv0y9R/yGay8AYegpU/87hd9xSp4w8w62cZ1xzBqGUHwYY8
	 /7IEMZH3wNLzN6jPN3qHp7uk64TGCavpwSbGSoTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/325] vxlan: Join / leave MC group after remote changes
Date: Mon,  2 Jun 2025 15:47:19 +0200
Message-ID: <20250602134326.422208895@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit d42d543368343c0449a4e433b5f02e063a86209c ]

When a vxlan netdevice is brought up, if its default remote is a multicast
address, the device joins the indicated group.

Therefore when the multicast remote address changes, the device should
leave the current group and subscribe to the new one. Similarly when the
interface used for endpoint communication is changed in a situation when
multicast remote is configured. This is currently not done.

Both vxlan_igmp_join() and vxlan_igmp_leave() can however fail. So it is
possible that with such fix, the netdevice will end up in an inconsistent
situation where the old group is not joined anymore, but joining the new
group fails. Should we join the new group first, and leave the old one
second, we might end up in the opposite situation, where both groups are
joined. Undoing any of this during rollback is going to be similarly
problematic.

One solution would be to just forbid the change when the netdevice is up.
However in vnifilter mode, changing the group address is allowed, and these
problems are simply ignored (see vxlan_vni_update_group()):

 # ip link add name br up type bridge vlan_filtering 1
 # ip link add vx1 up master br type vxlan external vnifilter local 192.0.2.1 dev lo dstport 4789
 # bridge vni add dev vx1 vni 200 group 224.0.0.1
 # tcpdump -i lo &
 # bridge vni add dev vx1 vni 200 group 224.0.0.2
 18:55:46.523438 IP 0.0.0.0 > 224.0.0.22: igmp v3 report, 1 group record(s)
 18:55:46.943447 IP 0.0.0.0 > 224.0.0.22: igmp v3 report, 1 group record(s)
 # bridge vni
 dev               vni                group/remote
 vx1               200                224.0.0.2

Having two different modes of operation for conceptually the same interface
is silly, so in this patch, just do what the vnifilter code does and deal
with the errors by crossing fingers real hard.

The vnifilter code leaves old before joining new, and in case of join /
leave failures does not roll back the configuration changes that have
already been applied, but bails out of joining if it could not leave. Do
the same here: leave before join, apply changes unconditionally and do not
attempt to join if we couldn't leave.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 50be5a3c47795..0afd7eb976e6c 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -4231,6 +4231,7 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 			    struct netlink_ext_ack *extack)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
+	bool rem_ip_changed, change_igmp;
 	struct net_device *lowerdev;
 	struct vxlan_config conf;
 	struct vxlan_rdst *dst;
@@ -4254,8 +4255,13 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (err)
 		return err;
 
+	rem_ip_changed = !vxlan_addr_equal(&conf.remote_ip, &dst->remote_ip);
+	change_igmp = vxlan->dev->flags & IFF_UP &&
+		      (rem_ip_changed ||
+		       dst->remote_ifindex != conf.remote_ifindex);
+
 	/* handle default dst entry */
-	if (!vxlan_addr_equal(&conf.remote_ip, &dst->remote_ip)) {
+	if (rem_ip_changed) {
 		u32 hash_index = fdb_head_index(vxlan, all_zeros_mac, conf.vni);
 
 		spin_lock_bh(&vxlan->hash_lock[hash_index]);
@@ -4299,6 +4305,9 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 		}
 	}
 
+	if (change_igmp && vxlan_addr_multicast(&dst->remote_ip))
+		err = vxlan_multicast_leave(vxlan);
+
 	if (conf.age_interval != vxlan->cfg.age_interval)
 		mod_timer(&vxlan->age_timer, jiffies);
 
@@ -4306,7 +4315,12 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (lowerdev && lowerdev != dst->remote_dev)
 		dst->remote_dev = lowerdev;
 	vxlan_config_apply(dev, &conf, lowerdev, vxlan->net, true);
-	return 0;
+
+	if (!err && change_igmp &&
+	    vxlan_addr_multicast(&dst->remote_ip))
+		err = vxlan_multicast_join(vxlan);
+
+	return err;
 }
 
 static void vxlan_dellink(struct net_device *dev, struct list_head *head)
-- 
2.39.5



