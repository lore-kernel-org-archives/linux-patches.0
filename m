Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3098F11711
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2015C433CA;
	Mon, 21 Aug 2023 19:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647774;
	bh=cBn8qZ58K0qAmPClpol/5nY3DLSsoHGIdnRXhPPvlZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K80t+w3MKWLDT4ud9DYvlcgABK63Yi9CUOB1GmpM0Vi1i7QGo8azs9OY3mWqiK2/a
	 vpfUfXRK47DBwn3NX3YQaozel/uU+UqABnJur1lHSKDRRAmREEd9d1e4FGFipK9o4D
	 u5ijkKjtlBiCxV0CkqJxvmrt3nhKe8FPOeZvN/Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7456b5dcf65111553320@syzkaller.appspotmail.com,
	Leon Romanovsky <leonro@nvidia.com>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/194] net: openvswitch: reject negative ifindex
Date: Mon, 21 Aug 2023 21:41:45 +0200
Message-ID: <20230821194128.250045046@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a552bfa16bab4ce901ee721346a28c4e483f4066 ]

Recent changes in net-next (commit 759ab1edb56c ("net: store netdevs
in an xarray")) refactored the handling of pre-assigned ifindexes
and let syzbot surface a latent problem in ovs. ovs does not validate
ifindex, making it possible to create netdev ports with negative
ifindex values. It's easy to repro with YNL:

$ ./cli.py --spec netlink/specs/ovs_datapath.yaml \
         --do new \
	 --json '{"upcall-pid": 1, "name":"my-dp"}'
$ ./cli.py --spec netlink/specs/ovs_vport.yaml \
	 --do new \
	 --json '{"upcall-pid": "00000001", "name": "some-port0", "dp-ifindex":3,"ifindex":4294901760,"type":2}'

$ ip link show
-65536: some-port0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 7a:48:21:ad:0b:fb brd ff:ff:ff:ff:ff:ff
...

Validate the inputs. Now the second command correctly returns:

$ ./cli.py --spec netlink/specs/ovs_vport.yaml \
	 --do new \
	 --json '{"upcall-pid": "00000001", "name": "some-port0", "dp-ifindex":3,"ifindex":4294901760,"type":2}'

lib.ynl.NlError: Netlink error: Numerical result out of range
nl_len = 108 (92) nl_flags = 0x300 nl_type = 2
	error: -34	extack: {'msg': 'integer out of range', 'unknown': [[type:4 len:36] b'\x0c\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x03\x00\xff\xff\xff\x7f\x00\x00\x00\x00\x08\x00\x01\x00\x08\x00\x00\x00'], 'bad-attr': '.ifindex'}

Accept 0 since it used to be silently ignored.

Fixes: 54c4ef34c4b6 ("openvswitch: allow specifying ifindex of new interfaces")
Reported-by: syzbot+7456b5dcf65111553320@syzkaller.appspotmail.com
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://lore.kernel.org/r/20230814203840.2908710-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 5920fdca12875..3c7b245354096 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1806,7 +1806,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	parms.port_no = OVSP_LOCAL;
 	parms.upcall_portids = a[OVS_DP_ATTR_UPCALL_PID];
 	parms.desired_ifindex = a[OVS_DP_ATTR_IFINDEX]
-		? nla_get_u32(a[OVS_DP_ATTR_IFINDEX]) : 0;
+		? nla_get_s32(a[OVS_DP_ATTR_IFINDEX]) : 0;
 
 	/* So far only local changes have been made, now need the lock. */
 	ovs_lock();
@@ -2026,7 +2026,7 @@ static const struct nla_policy datapath_policy[OVS_DP_ATTR_MAX + 1] = {
 	[OVS_DP_ATTR_USER_FEATURES] = { .type = NLA_U32 },
 	[OVS_DP_ATTR_MASKS_CACHE_SIZE] =  NLA_POLICY_RANGE(NLA_U32, 0,
 		PCPU_MIN_UNIT_SIZE / sizeof(struct mask_cache_entry)),
-	[OVS_DP_ATTR_IFINDEX] = {.type = NLA_U32 },
+	[OVS_DP_ATTR_IFINDEX] = NLA_POLICY_MIN(NLA_S32, 0),
 };
 
 static const struct genl_small_ops dp_datapath_genl_ops[] = {
@@ -2276,7 +2276,7 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	parms.port_no = port_no;
 	parms.upcall_portids = a[OVS_VPORT_ATTR_UPCALL_PID];
 	parms.desired_ifindex = a[OVS_VPORT_ATTR_IFINDEX]
-		? nla_get_u32(a[OVS_VPORT_ATTR_IFINDEX]) : 0;
+		? nla_get_s32(a[OVS_VPORT_ATTR_IFINDEX]) : 0;
 
 	vport = new_vport(&parms);
 	err = PTR_ERR(vport);
@@ -2513,7 +2513,7 @@ static const struct nla_policy vport_policy[OVS_VPORT_ATTR_MAX + 1] = {
 	[OVS_VPORT_ATTR_TYPE] = { .type = NLA_U32 },
 	[OVS_VPORT_ATTR_UPCALL_PID] = { .type = NLA_UNSPEC },
 	[OVS_VPORT_ATTR_OPTIONS] = { .type = NLA_NESTED },
-	[OVS_VPORT_ATTR_IFINDEX] = { .type = NLA_U32 },
+	[OVS_VPORT_ATTR_IFINDEX] = NLA_POLICY_MIN(NLA_S32, 0),
 	[OVS_VPORT_ATTR_NETNSID] = { .type = NLA_S32 },
 };
 
-- 
2.40.1



