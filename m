Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5551DA4D;
	Tue, 16 Jul 2024 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144980; cv=none; b=IEyTeOqNnDRMFyrzU/N8yDRKskWbfYTLuwDk29vMEApvLSbHmrOLer7yx+pdSaa703F07I7aDKz09R27/RXqA5Ymk33UtDYkXJMte4HYHe9enoUG6xLXGvgLtGZnV5k8uHuUx9i6IM66Gl1FQoIpAmiDJhn2z+CMzHR2yYeB4+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144980; c=relaxed/simple;
	bh=BTXUgcPXNnS7B6SCtkzJFOP9oyHeBUuU3bdz9DhnddE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNFwzo6m7Al0k4ey3GLOidOnrGQQXq1TUPUogvfECRYGF5OulwviW6F48nICKb7AHJioIRmPpSYs85EJtqFA+yabzPSZnwZ3fFtIxcerDx3fcosUMk70MF+9whMkTC7B2M9BLuWcJXPVvO3AEXwDNh4kGSE3qEh6cyGnB3vjicc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8tSDwGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8tSDwGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2266CC116B1;
	Tue, 16 Jul 2024 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144980;
	bh=BTXUgcPXNnS7B6SCtkzJFOP9oyHeBUuU3bdz9DhnddE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8tSDwGxhR6outEz7pz6dqeHE7rUZHWuuPsX2Hn6iwF7/eSf9+DLFLOKBmlOGciI4
	 Bcz+GrPsNUElibdumCbfL+BIdPAOVAmdjwhsbC7NHXy1FFOwJNR3KIl1EuUwWoh1AU
	 oc9BQ1a/J6EjkCcyubALNrn0yKYz5Wgi56d4pvhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.9 028/143] i40e: Fix XDP program unloading while removing the driver
Date: Tue, 16 Jul 2024 17:30:24 +0200
Message-ID: <20240716152757.070694905@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kubiak <michal.kubiak@intel.com>

[ Upstream commit 01fc5142ae6b06b61ed51a624f2732d6525d8ea3 ]

The commit 6533e558c650 ("i40e: Fix reset path while removing
the driver") introduced a new PF state "__I40E_IN_REMOVE" to block
modifying the XDP program while the driver is being removed.
Unfortunately, such a change is useful only if the ".ndo_bpf()"
callback was called out of the rmmod context because unloading the
existing XDP program is also a part of driver removing procedure.
In other words, from the rmmod context the driver is expected to
unload the XDP program without reporting any errors. Otherwise,
the kernel warning with callstack is printed out to dmesg.

Example failing scenario:
 1. Load the i40e driver.
 2. Load the XDP program.
 3. Unload the i40e driver (using "rmmod" command).

The example kernel warning log:

[  +0.004646] WARNING: CPU: 94 PID: 10395 at net/core/dev.c:9290 unregister_netdevice_many_notify+0x7a9/0x870
[...]
[  +0.010959] RIP: 0010:unregister_netdevice_many_notify+0x7a9/0x870
[...]
[  +0.002726] Call Trace:
[  +0.002457]  <TASK>
[  +0.002119]  ? __warn+0x80/0x120
[  +0.003245]  ? unregister_netdevice_many_notify+0x7a9/0x870
[  +0.005586]  ? report_bug+0x164/0x190
[  +0.003678]  ? handle_bug+0x3c/0x80
[  +0.003503]  ? exc_invalid_op+0x17/0x70
[  +0.003846]  ? asm_exc_invalid_op+0x1a/0x20
[  +0.004200]  ? unregister_netdevice_many_notify+0x7a9/0x870
[  +0.005579]  ? unregister_netdevice_many_notify+0x3cc/0x870
[  +0.005586]  unregister_netdevice_queue+0xf7/0x140
[  +0.004806]  unregister_netdev+0x1c/0x30
[  +0.003933]  i40e_vsi_release+0x87/0x2f0 [i40e]
[  +0.004604]  i40e_remove+0x1a1/0x420 [i40e]
[  +0.004220]  pci_device_remove+0x3f/0xb0
[  +0.003943]  device_release_driver_internal+0x19f/0x200
[  +0.005243]  driver_detach+0x48/0x90
[  +0.003586]  bus_remove_driver+0x6d/0xf0
[  +0.003939]  pci_unregister_driver+0x2e/0xb0
[  +0.004278]  i40e_exit_module+0x10/0x5f0 [i40e]
[  +0.004570]  __do_sys_delete_module.isra.0+0x197/0x310
[  +0.005153]  do_syscall_64+0x85/0x170
[  +0.003684]  ? syscall_exit_to_user_mode+0x69/0x220
[  +0.004886]  ? do_syscall_64+0x95/0x170
[  +0.003851]  ? exc_page_fault+0x7e/0x180
[  +0.003932]  entry_SYSCALL_64_after_hwframe+0x71/0x79
[  +0.005064] RIP: 0033:0x7f59dc9347cb
[  +0.003648] Code: 73 01 c3 48 8b 0d 65 16 0c 00 f7 d8 64 89 01 48 83
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 35 16 0c 00 f7 d8 64 89 01 48
[  +0.018753] RSP: 002b:00007ffffac99048 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  +0.007577] RAX: ffffffffffffffda RBX: 0000559b9bb2f6e0 RCX: 00007f59dc9347cb
[  +0.007140] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000559b9bb2f748
[  +0.007146] RBP: 00007ffffac99070 R08: 1999999999999999 R09: 0000000000000000
[  +0.007133] R10: 00007f59dc9a5ac0 R11: 0000000000000206 R12: 0000000000000000
[  +0.007141] R13: 00007ffffac992d8 R14: 0000559b9bb2f6e0 R15: 0000000000000000
[  +0.007151]  </TASK>
[  +0.002204] ---[ end trace 0000000000000000 ]---

Fix this by checking if the XDP program is being loaded or unloaded.
Then, block only loading a new program while "__I40E_IN_REMOVE" is set.
Also, move testing "__I40E_IN_REMOVE" flag to the beginning of XDP_SETUP
callback to avoid unnecessary operations and checks.

Fixes: 6533e558c650 ("i40e: Fix reset path while removing the driver")
Signed-off-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20240708230750.625986-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index ffb9f9f15c523..3a2d4d0697955 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13264,6 +13264,10 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 	bool need_reset;
 	int i;
 
+	/* VSI shall be deleted in a moment, block loading new programs */
+	if (prog && test_bit(__I40E_IN_REMOVE, pf->state))
+		return -EINVAL;
+
 	/* Don't allow frames that span over multiple buffers */
 	if (vsi->netdev->mtu > frame_size - I40E_PACKET_HDR_PAD) {
 		NL_SET_ERR_MSG_MOD(extack, "MTU too large for linear frames and XDP prog does not support frags");
@@ -13272,14 +13276,9 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 
 	/* When turning XDP on->off/off->on we reset and rebuild the rings. */
 	need_reset = (i40e_enabled_xdp_vsi(vsi) != !!prog);
-
 	if (need_reset)
 		i40e_prep_for_reset(pf);
 
-	/* VSI shall be deleted in a moment, just return EINVAL */
-	if (test_bit(__I40E_IN_REMOVE, pf->state))
-		return -EINVAL;
-
 	old_prog = xchg(&vsi->xdp_prog, prog);
 
 	if (need_reset) {
-- 
2.43.0



