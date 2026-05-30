Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B66F3AFCE3;
	Sat, 30 May 2026 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164491; cv=none; b=KGWVeCeTbwSmtdmnEtU/zT2Cq6CrMfVd6skrxz/XXOyHXYKX2d7eEHgeRvCQX4cb+upf/Qx4r9C0FhdOjv+zlNl2tcRMR2juSspaEVpf3/Ii0HmFjU52qOorSRWy7rvYUVseGdnvmrqZnTySgyUXRmyVSrv4vGJP0K96VfzPWuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164491; c=relaxed/simple;
	bh=H8LrLBN1fYxQMeNfPzqk/BbkZym5s1RrlB5sytYbpxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CimaJ+mAbEw29/V5pCNcYrNGwWOhbuhNde9Am3a/8BvBgl7K/qUnvBPoxBg0+LQWsRCmW25eoKXQjTJ3NIkRiZODJNEKkjIKZ5GESdf+Aqb9k5WqxcVP5qqFcrFxRgafz1H/f8LClgiugQ8RG4kaMKeldAga6WXr19ecwEiu6kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qj/Mubf1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qj/Mubf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C9C1F00893;
	Sat, 30 May 2026 18:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164490;
	bh=BfURioxEnVBcFTwKFGNt4v39I5NPU5vEduC72nOCzwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qj/Mubf1KRZhDgcfzyzrpzs/kAByYcmdhUbwG6Ie45R2iu6jEar7Hpv+k3zRN4443
	 8rCNcoQPfPxctl3vkZ+GDVJQPaILse9AhdAeUiPO6NJMSyDGipX6pUA5GH+2ImC2Tf
	 Xtxn7PtHR1tMa2iKIbq/Tg0myzaGmLhDvGJxlITg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 571/776] openvswitch: cap upcall PID array size and pre-size vport replies
Date: Sat, 30 May 2026 18:04:45 +0200
Message-ID: <20260530160254.865643576@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c28b56c309169..16ee704bab04d 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2110,9 +2110,40 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
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
@@ -2122,7 +2153,7 @@ struct sk_buff *ovs_vport_cmd_build_info(struct vport *vport, struct net *net,
 	struct sk_buff *skb;
 	int retval;
 
-	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	skb = ovs_vport_cmd_alloc_info();
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index cf2ce58124896..25197e14c123b 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -342,6 +342,9 @@ int ovs_vport_set_upcall_portids(struct vport *vport, const struct nlattr *ids)
 	if (!nla_len(ids) || nla_len(ids) % sizeof(u32))
 		return -EINVAL;
 
+	if (nla_len(ids) / sizeof(u32) > nr_cpu_ids)
+		return -EINVAL;
+
 	old = ovsl_dereference(vport->upcall_portids);
 
 	vport_portids = kmalloc(sizeof(*vport_portids) + nla_len(ids),
-- 
2.53.0



