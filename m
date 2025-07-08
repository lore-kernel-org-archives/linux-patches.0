Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C9CF9E8;
	Tue,  8 Jul 2025 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992741; cv=none; b=ImtZoHsllAnacRyIRH/S2JxovtahjE8f6vzze+hJwUGbdogSxy747KHADFV015tasvSYVHzEv2391W+RwFuA6nU8CCiJaHV006jxlyy5OnoWnSGUMvQ/3Ce7gkKIo2hY0otGCqH4RNLdJFtTTSZqaqx2t9a+992r6rJX7ogNp5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992741; c=relaxed/simple;
	bh=Fa7SuaQ5rsAe6DicukaTWAK9LpyioLBWeJm59jmTOhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IK6opqE9jyOlzv0yyW6YnmGCKDnvr2oubbbBPX2kbhM/NQrsqHh5bGoYIzj5U7y2i0gjAcVzQcr6Gg3xE2kmqjKCb8a/q4fRE/V4OLJaC7BI74IQTrjKN4v5DxflYA9jONrG/DlSCzH72zBcmNptxg6Y7BfvagYejg0tNJxkiYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6FEp86y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6FEp86y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2080BC4CEF5;
	Tue,  8 Jul 2025 16:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992741;
	bh=Fa7SuaQ5rsAe6DicukaTWAK9LpyioLBWeJm59jmTOhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6FEp86yhRhNJ8hD+y6h9dy4lb/e0ipKE72Hjs4MAeMWib02pw86nVxZzZqg98rR6
	 UhwNHoBw6p299f0bB2RaY0G5D9ubkNSQOhgY8VOmb0ccu5D1I9J2wXKSKn51zZB/01
	 2YT489h73EbVDpfwZ83pF5SjeC7L6eDT/EW2SEho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/232] RDMA/mlx5: Initialize obj_event->obj_sub_list before xa_insert
Date: Tue,  8 Jul 2025 18:20:30 +0200
Message-ID: <20250708162242.324092775@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 8edab8a72d67742f87e9dc2e2b0cdfddda5dc29a ]

The obj_event may be loaded immediately after inserted, then if the
list_head is not initialized then we may get a poisonous pointer.  This
fixes the crash below:

 mlx5_core 0000:03:00.0: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0 enhanced)
 mlx5_core.sf mlx5_core.sf.4: firmware version: 32.38.3056
 mlx5_core 0000:03:00.0 en3f0pf0sf2002: renamed from eth0
 mlx5_core.sf mlx5_core.sf.4: Rate limit: 127 rates are supported, range: 0Mbps to 195312Mbps
 IPv6: ADDRCONF(NETDEV_CHANGE): en3f0pf0sf2002: link becomes ready
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000060
 Mem abort info:
   ESR = 0x96000006
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000006
   CM = 0, WnR = 0
 user pgtable: 4k pages, 48-bit VAs, pgdp=00000007760fb000
 [0000000000000060] pgd=000000076f6d7003, p4d=000000076f6d7003, pud=0000000777841003, pmd=0000000000000000
 Internal error: Oops: 96000006 [#1] SMP
 Modules linked in: ipmb_host(OE) act_mirred(E) cls_flower(E) sch_ingress(E) mptcp_diag(E) udp_diag(E) raw_diag(E) unix_diag(E) tcp_diag(E) inet_diag(E) binfmt_misc(E) bonding(OE) rdma_ucm(OE) rdma_cm(OE) iw_cm(OE) ib_ipoib(OE) ib_cm(OE) isofs(E) cdrom(E) mst_pciconf(OE) ib_umad(OE) mlx5_ib(OE) ipmb_dev_int(OE) mlx5_core(OE) kpatch_15237886(OEK) mlxdevm(OE) auxiliary(OE) ib_uverbs(OE) ib_core(OE) psample(E) mlxfw(OE) tls(E) sunrpc(E) vfat(E) fat(E) crct10dif_ce(E) ghash_ce(E) sha1_ce(E) sbsa_gwdt(E) virtio_console(E) ext4(E) mbcache(E) jbd2(E) xfs(E) libcrc32c(E) mmc_block(E) virtio_net(E) net_failover(E) failover(E) sha2_ce(E) sha256_arm64(E) nvme(OE) nvme_core(OE) gpio_mlxbf3(OE) mlx_compat(OE) mlxbf_pmc(OE) i2c_mlxbf(OE) sdhci_of_dwcmshc(OE) pinctrl_mlxbf3(OE) mlxbf_pka(OE) gpio_generic(E) i2c_core(E) mmc_core(E) mlxbf_gige(OE) vitesse(E) pwr_mlxbf(OE) mlxbf_tmfifo(OE) micrel(E) mlxbf_bootctl(OE) virtio_ring(E) virtio(E) ipmi_devintf(E) ipmi_msghandler(E)
  [last unloaded: mst_pci]
 CPU: 11 PID: 20913 Comm: rte-worker-11 Kdump: loaded Tainted: G           OE K   5.10.134-13.1.an8.aarch64 #1
 Hardware name: https://www.mellanox.com BlueField-3 SmartNIC Main Card/BlueField-3 SmartNIC Main Card, BIOS 4.2.2.12968 Oct 26 2023
 pstate: a0400089 (NzCv daIf +PAN -UAO -TCO BTYPE=--)
 pc : dispatch_event_fd+0x68/0x300 [mlx5_ib]
 lr : devx_event_notifier+0xcc/0x228 [mlx5_ib]
 sp : ffff80001005bcf0
 x29: ffff80001005bcf0 x28: 0000000000000001
 x27: ffff244e0740a1d8 x26: ffff244e0740a1d0
 x25: ffffda56beff5ae0 x24: ffffda56bf911618
 x23: ffff244e0596a480 x22: ffff244e0596a480
 x21: ffff244d8312ad90 x20: ffff244e0596a480
 x19: fffffffffffffff0 x18: 0000000000000000
 x17: 0000000000000000 x16: ffffda56be66d620
 x15: 0000000000000000 x14: 0000000000000000
 x13: 0000000000000000 x12: 0000000000000000
 x11: 0000000000000040 x10: ffffda56bfcafb50
 x9 : ffffda5655c25f2c x8 : 0000000000000010
 x7 : 0000000000000000 x6 : ffff24545a2e24b8
 x5 : 0000000000000003 x4 : ffff80001005bd28
 x3 : 0000000000000000 x2 : 0000000000000000
 x1 : ffff244e0596a480 x0 : ffff244d8312ad90
 Call trace:
  dispatch_event_fd+0x68/0x300 [mlx5_ib]
  devx_event_notifier+0xcc/0x228 [mlx5_ib]
  atomic_notifier_call_chain+0x58/0x80
  mlx5_eq_async_int+0x148/0x2b0 [mlx5_core]
  atomic_notifier_call_chain+0x58/0x80
  irq_int_handler+0x20/0x30 [mlx5_core]
  __handle_irq_event_percpu+0x60/0x220
  handle_irq_event_percpu+0x3c/0x90
  handle_irq_event+0x58/0x158
  handle_fasteoi_irq+0xfc/0x188
  generic_handle_irq+0x34/0x48
  ...

Fixes: 759738537142 ("IB/mlx5: Enable subscription for device events over DEVX")
Link: https://patch.msgid.link/r/3ce7f20e0d1a03dc7de6e57494ec4b8eaf1f05c2.1750147949.git.leon@kernel.org
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 69999d8d24f37..f49f78b69ab9c 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1914,6 +1914,7 @@ subscribe_event_xa_alloc(struct mlx5_devx_event_table *devx_event_table,
 			/* Level1 is valid for future use, no need to free */
 			return -ENOMEM;
 
+		INIT_LIST_HEAD(&obj_event->obj_sub_list);
 		err = xa_insert(&event->object_ids,
 				key_level2,
 				obj_event,
@@ -1922,7 +1923,6 @@ subscribe_event_xa_alloc(struct mlx5_devx_event_table *devx_event_table,
 			kfree(obj_event);
 			return err;
 		}
-		INIT_LIST_HEAD(&obj_event->obj_sub_list);
 	}
 
 	return 0;
-- 
2.39.5



