Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184C928469B;
	Thu, 27 Nov 2025 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254986; cv=none; b=NDF5a0H00PRhx7ZM/05aiithVFf0i2wxC5IUZSCQlQJqpsOQpW412NkNu8waNyWe2rxcfhZvWRsvyT5bj/DBcBn5rIoNS3gh5nUfWWidpS0sS76MkkBseayQM86qscwaR6wDy/3mhuYhJ6hv8Zj74fK7QoPqAzSTATiOeQMSNyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254986; c=relaxed/simple;
	bh=IAZrR/mOfPRKl7h0vKumPPr7cSyoE4F4ic6frNjNuPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo7NEW/9fiefZMZ+O5ydG5rTPV62+6u6L3OKrrs2JFkgwcQYEoYcpPxmqrsBkytybBQdd37Dnm250gE4LDAsLOeFu4MrSsae+vW5dcPvmEy7zA4GdTbVITsozRPEgjzPWbexP0Pxumnz/q2UNQu29gurRASp83KIOWKBoRGv/QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOnGDhfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOnGDhfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F38C4CEF8;
	Thu, 27 Nov 2025 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254986;
	bh=IAZrR/mOfPRKl7h0vKumPPr7cSyoE4F4ic6frNjNuPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOnGDhfRmOgUNQcrMC0buDpUvomdC/XAFVr8/gGAo1uwCHjV9FzCgdQ21Rnwn+yRb
	 y6mEkvG9zOUWyqOJcggUxyC9v+sdPE5CuL5AiRYMlqv6p4uXT/IHslQf6sZoPmi/FE
	 fwQfKonBXl4XrtLrhXIUUO1PtALVSdN1xKDu63dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 53/86] devlink: rate: Unset parent pointer in devl_rate_nodes_destroy
Date: Thu, 27 Nov 2025 15:46:09 +0100
Message-ID: <20251127144029.768651183@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/rate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/devlink/rate.c b/net/devlink/rate.c
index dff1593b8406a..e7e80af4abaf6 100644
--- a/net/devlink/rate.c
+++ b/net/devlink/rate.c
@@ -702,13 +702,15 @@ void devl_rate_nodes_destroy(struct devlink *devlink)
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
2.51.0



