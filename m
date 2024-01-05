Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3085121374;
	Fri,  5 Jan 2024 14:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPU0nw+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE6AC433C7;
	Fri,  5 Jan 2024 14:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465640;
	bh=M1v8dvhtYxvalSGXBxdawLRHyfT6GABHR2A0YpJOOpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPU0nw+F+QeU+i9BgvEJSDj+DiNU5vMamgg1p0gVO2UoK6j2E2LrD7rH/VxL/GLMe
	 DF/Mk222bQFfWwSTZ/SWuYdQDVJwZLnU2W3ICDt8fps0XfXtS4SlfFbArJ1oMs4s0l
	 YgSZs4Al0husRtapplhzLU3FUTLH5nVhEvZfhtKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/41] net: check vlan filter feature in vlan_vids_add_by_dev() and vlan_vids_del_by_dev()
Date: Fri,  5 Jan 2024 15:38:55 +0100
Message-ID: <20240105143814.608490111@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143813.957669139@linuxfoundation.org>
References: <20240105143813.957669139@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 01a564bab4876007ce35f312e16797dfe40e4823 ]

I got the below warning trace:

WARNING: CPU: 4 PID: 4056 at net/core/dev.c:11066 unregister_netdevice_many_notify
CPU: 4 PID: 4056 Comm: ip Not tainted 6.7.0-rc4+ #15
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:unregister_netdevice_many_notify+0x9a4/0x9b0
Call Trace:
 rtnl_dellink
 rtnetlink_rcv_msg
 netlink_rcv_skb
 netlink_unicast
 netlink_sendmsg
 __sock_sendmsg
 ____sys_sendmsg
 ___sys_sendmsg
 __sys_sendmsg
 do_syscall_64
 entry_SYSCALL_64_after_hwframe

It can be repoduced via:

    ip netns add ns1
    ip netns exec ns1 ip link add bond0 type bond mode 0
    ip netns exec ns1 ip link add bond_slave_1 type veth peer veth2
    ip netns exec ns1 ip link set bond_slave_1 master bond0
[1] ip netns exec ns1 ethtool -K bond0 rx-vlan-filter off
[2] ip netns exec ns1 ip link add link bond_slave_1 name bond_slave_1.0 type vlan id 0
[3] ip netns exec ns1 ip link add link bond0 name bond0.0 type vlan id 0
[4] ip netns exec ns1 ip link set bond_slave_1 nomaster
[5] ip netns exec ns1 ip link del veth2
    ip netns del ns1

This is all caused by command [1] turning off the rx-vlan-filter function
of bond0. The reason is the same as commit 01f4fd270870 ("bonding: Fix
incorrect deletion of ETH_P_8021AD protocol vid from slaves"). Commands
[2] [3] add the same vid to slave and master respectively, causing
command [4] to empty slave->vlan_info. The following command [5] triggers
this problem.

To fix this problem, we should add VLAN_FILTER feature checks in
vlan_vids_add_by_dev() and vlan_vids_del_by_dev() to prevent incorrect
addition or deletion of vlan_vid information.

Fixes: 348a1443cc43 ("vlan: introduce functions to do mass addition/deletion of vids by another device")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 4f60e86f4b8d3..e92c914316cbd 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -380,6 +380,8 @@ int vlan_vids_add_by_dev(struct net_device *dev,
 		return 0;
 
 	list_for_each_entry(vid_info, &vlan_info->vid_list, list) {
+		if (!vlan_hw_filter_capable(by_dev, vid_info->proto))
+			continue;
 		err = vlan_vid_add(dev, vid_info->proto, vid_info->vid);
 		if (err)
 			goto unwind;
@@ -390,6 +392,8 @@ int vlan_vids_add_by_dev(struct net_device *dev,
 	list_for_each_entry_continue_reverse(vid_info,
 					     &vlan_info->vid_list,
 					     list) {
+		if (!vlan_hw_filter_capable(by_dev, vid_info->proto))
+			continue;
 		vlan_vid_del(dev, vid_info->proto, vid_info->vid);
 	}
 
@@ -409,8 +413,11 @@ void vlan_vids_del_by_dev(struct net_device *dev,
 	if (!vlan_info)
 		return;
 
-	list_for_each_entry(vid_info, &vlan_info->vid_list, list)
+	list_for_each_entry(vid_info, &vlan_info->vid_list, list) {
+		if (!vlan_hw_filter_capable(by_dev, vid_info->proto))
+			continue;
 		vlan_vid_del(dev, vid_info->proto, vid_info->vid);
+	}
 }
 EXPORT_SYMBOL(vlan_vids_del_by_dev);
 
-- 
2.43.0



