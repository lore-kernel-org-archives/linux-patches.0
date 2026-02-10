Received: from n169-112.mail.139.com (n169-112.mail.139.com [120.232.169.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7949A15B0EC
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 03:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770692570; cv=none; b=pPTzA8zYBbfve+OD2DnjyViH0MLqu7Nw8uFC1v9Pwf0xJQXSi7pwrFCUZefk0q2Y9aSR/Mrc23Ur0Gr6iwJuOCc2an/8IZ3nucQqf4dQa3OEONNLwrheFWRFs01jy2uMKCQgR75IC6nO/heHRpn8n5BmtLSUt18PuEC31M/nD1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770692570; c=relaxed/simple;
	bh=Hj/lm6RMusjiPVzJoLal7AtEHe4qLLMGIGa44jshzjo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Wv0tXnq0H7LJF2ZymcR5RnC5k3PZjapNjUoFDwG801+Y8YYl+1ODrOARpuQdqLI33BpoE2YA3/IcxmLe58aaywBVSrV8YOx2982K89ZocLUblTIVUPQCx3aYyPTRV3Nc0yp2lLddOuDeHcaVKSt+yXP3sKa1JSvlF86WbKTAYog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=FtvVj9ZO; arc=none smtp.client-ip=120.232.169.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="FtvVj9ZO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=FtvVj9ZOs/EJpbG1ZRzxItsFt8gXi2kTzz7trxSYhrergxyWv8A/z7WSTQZTZh4DR1PYpmrzYUXRg
	 MrW0IW+ORO3sgWTwXI7kC3InCO3QyOJKan2EcpXmzTNtdteLHpb4Pg9tn7mtf8oOctA/F27APBkyFY
	 mcWfX7rfYNqlJGVA=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-24-12027 (RichMail) with SMTP id 2efb698a9fc9fad-0401d;
	Tue, 10 Feb 2026 11:02:36 +0800 (CST)
X-RM-TRANSID:2efb698a9fc9fad-0401d
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	shayd@nvidia.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jiri@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	dlinkin@nvidia.com,
	vladbu@nvidia.com,
	netdev@vger.kernel.org,
	cjubran@nvidia.com,
	tariqt@nvidia.com
Subject: [PATCH 6.1.y] devlink: rate: Unset parent pointer in devl_rate_nodes_destroy
Date: Tue, 10 Feb 2026 11:02:34 +0800
Message-Id: <20260210030234.1532584-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit f94c1a114ac209977bdf5ca841b98424295ab1f0 ]

The function devl_rate_nodes_destroy is documented to "Unset parent for
all rate objects". However, it was only calling the driver-specific
`rate_leaf_parent_set` or `rate_node_parent_set` ops and decrementing
the parent's refcount, without actually setting the
`devlink_rate->parent` pointer to NULL.

This leaves a dangling pointer in the `devlink_rate` struct, which cause
refcount error in netdevsim[1] and mlx5[2]. In addition, this is
inconsistent with the behavior of `devlink_nl_rate_parent_node_set`,
where the parent pointer is correctly cleared.

This patch fixes the issue by explicitly setting `devlink_rate->parent`
to NULL after notifying the driver, thus fulfilling the function's
documented behavior for all rate objects.

[1]
repro steps:
echo 1 > /sys/bus/netdevsim/new_device
devlink dev eswitch set netdevsim/netdevsim1 mode switchdev
echo 1 > /sys/bus/netdevsim/devices/netdevsim1/sriov_numvfs
devlink port function rate add netdevsim/netdevsim1/test_node
devlink port function rate set netdevsim/netdevsim1/128 parent test_node
echo 1 > /sys/bus/netdevsim/del_device

dmesg:
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 8 PID: 1530 at lib/refcount.c:31 refcount_warn_saturate+0x42/0xe0
CPU: 8 UID: 0 PID: 1530 Comm: bash Not tainted 6.18.0-rc4+ #1 NONE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
RIP: 0010:refcount_warn_saturate+0x42/0xe0
Call Trace:
 <TASK>
 devl_rate_leaf_destroy+0x8d/0x90
 __nsim_dev_port_del+0x6c/0x70 [netdevsim]
 nsim_dev_reload_destroy+0x11c/0x140 [netdevsim]
 nsim_drv_remove+0x2b/0xb0 [netdevsim]
 device_release_driver_internal+0x194/0x1f0
 bus_remove_device+0xc6/0x130
 device_del+0x159/0x3c0
 device_unregister+0x1a/0x60
 del_device_store+0x111/0x170 [netdevsim]
 kernfs_fop_write_iter+0x12e/0x1e0
 vfs_write+0x215/0x3d0
 ksys_write+0x5f/0xd0
 do_syscall_64+0x55/0x10f0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

[2]
devlink dev eswitch set pci/0000:08:00.0 mode switchdev
devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 1000
devlink port function rate add pci/0000:08:00.0/group1
devlink port function rate set pci/0000:08:00.0/32768 parent group1
modprobe -r mlx5_ib mlx5_fwctl mlx5_core

dmesg:
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 7 PID: 16151 at lib/refcount.c:31 refcount_warn_saturate+0x42/0xe0
CPU: 7 UID: 0 PID: 16151 Comm: bash Not tainted 6.17.0-rc7_for_upstream_min_debug_2025_10_02_12_44 #1 NONE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
RIP: 0010:refcount_warn_saturate+0x42/0xe0
Call Trace:
 <TASK>
 devl_rate_leaf_destroy+0x8d/0x90
 mlx5_esw_offloads_devlink_port_unregister+0x33/0x60 [mlx5_core]
 mlx5_esw_offloads_unload_rep+0x3f/0x50 [mlx5_core]
 mlx5_eswitch_unload_sf_vport+0x40/0x90 [mlx5_core]
 mlx5_sf_esw_event+0xc4/0x120 [mlx5_core]
 notifier_call_chain+0x33/0xa0
 blocking_notifier_call_chain+0x3b/0x50
 mlx5_eswitch_disable_locked+0x50/0x110 [mlx5_core]
 mlx5_eswitch_disable+0x63/0x90 [mlx5_core]
 mlx5_unload+0x1d/0x170 [mlx5_core]
 mlx5_uninit_one+0xa2/0x130 [mlx5_core]
 remove_one+0x78/0xd0 [mlx5_core]
 pci_device_remove+0x39/0xa0
 device_release_driver_internal+0x194/0x1f0
 unbind_store+0x99/0xa0
 kernfs_fop_write_iter+0x12e/0x1e0
 vfs_write+0x215/0x3d0
 ksys_write+0x5f/0xd0
 do_syscall_64+0x53/0x1f0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: d75559845078 ("devlink: Allow setting parent node of rate objects")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1763381149-1234377-1-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Routine devl_rate_nodes_destroy is moved to net/devlink/rate.c by commit
 7cc7194e85ca ("devlink: push rate related code into separate file") after linux-6.6.
 This fix applies the same update to its original location in net/devlink/leftover.c. ]
Signed-off-by: Li hongliang <1468888505@139.com>
---
 net/devlink/leftover.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index f1c6bd727a83..1ea84c5ffa9f 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -10274,13 +10274,15 @@ void devl_rate_nodes_destroy(struct devlink *devlink)
 		if (!devlink_rate->parent)
 			continue;
 
-		refcount_dec(&devlink_rate->parent->refcnt);
 		if (devlink_rate_is_leaf(devlink_rate))
 			ops->rate_leaf_parent_set(devlink_rate, NULL, devlink_rate->priv,
 						  NULL, NULL);
 		else if (devlink_rate_is_node(devlink_rate))
 			ops->rate_node_parent_set(devlink_rate, NULL, devlink_rate->priv,
 						  NULL, NULL);
+
+		refcount_dec(&devlink_rate->parent->refcnt);
+		devlink_rate->parent = NULL;
 	}
 	list_for_each_entry_safe(devlink_rate, tmp, &devlink->rate_list, list) {
 		if (devlink_rate_is_node(devlink_rate)) {
-- 
2.34.1


