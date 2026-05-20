Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D734F3EDAC6;
	Wed, 20 May 2026 18:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302600; cv=none; b=YGUFUIXXwu56MaflNG5VhbdThtqE4f1rDqNHvgNIsFSdgRdH54IQOanBSYYBwoCrg8/C424kFk5w3SPy/gAtlfwfq+2oKOYGgN2OYYzS/v6qauNR1aRBRg/sp3Dsor3N7YKM0mTUoRnckb3yxy+cfHz9qL0+PvR/W7D1DGdq6ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302600; c=relaxed/simple;
	bh=d9aBAqj5LKW91wDxEdtOlWFD+e6sCu6y91U83nOQ8V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bq21aHWARLEBdzGmZNmV4jvyHHJOUJjUHwo5TXmHjmJqGuongaDopBceFBec/f2d9W2qVITYajVinxflUDGmHzAzRIJOEGkzcL7wTwADtl55Vxf0tih9bwgcjD9RHpJPA9TDlkjUA6CTUGOXi9c9lQ9f90yttXAHwenDhR9Ak1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlKLSOT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlKLSOT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CBD1F000E9;
	Wed, 20 May 2026 18:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302598;
	bh=Xb30l8ZZiaD0s8xEuInYL2kSlJX6dgx2gxM7xDaDrkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlKLSOT6LRDjrq3dLJQ8sArzS7nlD//KZxKisvQINsudR7flaLexLcjkGktLwEsPo
	 m+gSYBWpQYjI8F3RK0yUD0/yNyM2WcSfF4AcRPEMBax67r8Y48FLFPfVGV4ft68JWH
	 B3GYAZK11FJzQuTVWEalnVd3Xj4AxDKE7Y8/JhqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 328/508] openvswitch: cap upcall PID array size and pre-size vport replies
Date: Wed, 20 May 2026 18:22:31 +0200
Message-ID: <20260520162105.741262708@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 2091c6aa0df6aba47deb5c8ab232b1cb60af3519 ]

The vport netlink reply helpers allocate a fixed-size skb with
nlmsg_new(NLMSG_DEFAULT_SIZE, ...) but serialize the full upcall PID
array via ovs_vport_get_upcall_portids().  Since
ovs_vport_set_upcall_portids() accepts any non-zero multiple of
sizeof(u32) with no upper bound, a CAP_NET_ADMIN user can install a PID
array large enough to overflow the reply buffer, causing nla_put() to
fail with -EMSGSIZE and hitting BUG_ON(err < 0).  On systems with
unprivileged user namespaces enabled (e.g., Ubuntu default), this is
reachable via unshare -Urn since OVS vport mutation operations use
GENL_UNS_ADMIN_PERM.

 kernel BUG at net/openvswitch/datapath.c:2414!
 Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
 CPU: 1 UID: 0 PID: 65 Comm: poc Not tainted 7.0.0-rc7-00195-geb216e422044 #1
 RIP: 0010:ovs_vport_cmd_set+0x34c/0x400
 Call Trace:
  <TASK>
  genl_family_rcv_msg_doit (net/netlink/genetlink.c:1116)
  genl_rcv_msg (net/netlink/genetlink.c:1194)
  netlink_rcv_skb (net/netlink/af_netlink.c:2550)
  genl_rcv (net/netlink/genetlink.c:1219)
  netlink_unicast (net/netlink/af_netlink.c:1344)
  netlink_sendmsg (net/netlink/af_netlink.c:1894)
  __sys_sendto (net/socket.c:2206)
  __x64_sys_sendto (net/socket.c:2209)
  do_syscall_64 (arch/x86/entry/syscall_64.c:63)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
  </TASK>
 Kernel panic - not syncing: Fatal exception

Reject attempts to set more PIDs than nr_cpu_ids in
ovs_vport_set_upcall_portids(), and pre-compute the worst-case reply
size in ovs_vport_cmd_msg_size() based on that bound, similar to the
existing ovs_dp_cmd_msg_size().  nr_cpu_ids matches the cap already
used by the per-CPU dispatch configuration on the datapath side
(ovs_dp_cmd_fill_info() serialises at most nr_cpu_ids PIDs), so the
two sides stay consistent.

Fixes: 5cd667b0a456 ("openvswitch: Allow each vport to have an array of 'port_id's.")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20260416024653.153456-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 35 +++++++++++++++++++++++++++++++++--
 net/openvswitch/vport.c    |  3 +++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index cb52fac7caa3c..7803e7548d920 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2158,9 +2158,40 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 	return err;
 }
 
+static size_t ovs_vport_cmd_msg_size(void)
+{
+	size_t msgsize = NLMSG_ALIGN(sizeof(struct ovs_header));
+
+	msgsize += nla_total_size(sizeof(u32)); /* OVS_VPORT_ATTR_PORT_NO */
+	msgsize += nla_total_size(sizeof(u32)); /* OVS_VPORT_ATTR_TYPE */
+	msgsize += nla_total_size(IFNAMSIZ);    /* OVS_VPORT_ATTR_NAME */
+	msgsize += nla_total_size(sizeof(u32)); /* OVS_VPORT_ATTR_IFINDEX */
+	msgsize += nla_total_size(sizeof(s32)); /* OVS_VPORT_ATTR_NETNSID */
+
+	/* OVS_VPORT_ATTR_STATS */
+	msgsize += nla_total_size_64bit(sizeof(struct ovs_vport_stats));
+
+	/* OVS_VPORT_ATTR_UPCALL_STATS(OVS_VPORT_UPCALL_ATTR_SUCCESS +
+	 *                             OVS_VPORT_UPCALL_ATTR_FAIL)
+	 */
+	msgsize += nla_total_size(nla_total_size_64bit(sizeof(u64)) +
+				  nla_total_size_64bit(sizeof(u64)));
+
+	/* OVS_VPORT_ATTR_UPCALL_PID */
+	msgsize += nla_total_size(nr_cpu_ids * sizeof(u32));
+
+	/* OVS_VPORT_ATTR_OPTIONS(OVS_TUNNEL_ATTR_DST_PORT +
+	 *                        OVS_TUNNEL_ATTR_EXTENSION(OVS_VXLAN_EXT_GBP))
+	 */
+	msgsize += nla_total_size(nla_total_size(sizeof(u16)) +
+				  nla_total_size(nla_total_size(0)));
+
+	return msgsize;
+}
+
 static struct sk_buff *ovs_vport_cmd_alloc_info(void)
 {
-	return nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	return genlmsg_new(ovs_vport_cmd_msg_size(), GFP_KERNEL);
 }
 
 /* Called with ovs_mutex, only via ovs_dp_notify_wq(). */
@@ -2170,7 +2201,7 @@ struct sk_buff *ovs_vport_cmd_build_info(struct vport *vport, struct net *net,
 	struct sk_buff *skb;
 	int retval;
 
-	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	skb = ovs_vport_cmd_alloc_info();
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 0faa6e097829c..a0a8854e9f19e 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -407,6 +407,9 @@ int ovs_vport_set_upcall_portids(struct vport *vport, const struct nlattr *ids)
 	if (!nla_len(ids) || nla_len(ids) % sizeof(u32))
 		return -EINVAL;
 
+	if (nla_len(ids) / sizeof(u32) > nr_cpu_ids)
+		return -EINVAL;
+
 	old = ovsl_dereference(vport->upcall_portids);
 
 	vport_portids = kmalloc(sizeof(*vport_portids) + nla_len(ids),
-- 
2.53.0



