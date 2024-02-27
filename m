Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBE313DBB3;
	Tue, 27 Feb 2024 14:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043525; cv=none; b=ZIg1HEQvaZ9+1XRnxj3KTUKv7wkhr7zo0U1GrXFWMrRhxh4dWCaoJu/yBFW4Y3DsEvv+F8oLtqDxZqkgESPjHkNQMTdJp+u1e2bspoDUoU6anZ7CkcnDreiSGqph8ImzTyeLXUECjT8w65zQIFIpcs2JHgbFMOcObH3M43Kd6kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043525; c=relaxed/simple;
	bh=ByTFUlyrMTtbfRZOO8YvgNVSKQR0UR1Fef6gAK/Iyzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW15ZZy09NSt7WxA0NtV+5Q8qVuw8GXipn2iDoIoT3s7di4gOXXFhYPg6sEo7rfBnhLcaGlGFi4TzesNM19FIetAuFQwnSlhWEozVb+JJ1HZAIEMql/vgSoIDQmKRyI1sb6Pjc96+/NgXWJoh+icgCEAXyoFOVK8pXFqXQOliWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oF5jNgxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oF5jNgxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03D7C433F1;
	Tue, 27 Feb 2024 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043525;
	bh=ByTFUlyrMTtbfRZOO8YvgNVSKQR0UR1Fef6gAK/Iyzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oF5jNgxVxjdU2y0pMWWUSZ/50rN0Fihe+Awu+wKVWDqEZP3+sFFmS5tR2i5qQljkK
	 UwTtd+dNECi3v/HVL+wT3hzv9lqQmGDwXcnnaqa0F8ROfwGoQEd41hzHZYvscINTLO
	 P4IRD9p9cLG7ESDBIvb3srp/ODlc9qY/XJRfpKIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Heib <kheib@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/195] RDMA/qedr: Fix qedr_create_user_qp error flow
Date: Tue, 27 Feb 2024 14:26:41 +0100
Message-ID: <20240227131615.054363902@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Heib <kheib@redhat.com>

[ Upstream commit 5ba4e6d5863c53e937f49932dee0ecb004c65928 ]

Avoid the following warning by making sure to free the allocated
resources in case that qedr_init_user_queue() fail.

-----------[ cut here ]-----------
WARNING: CPU: 0 PID: 143192 at drivers/infiniband/core/rdma_core.c:874 uverbs_destroy_ufile_hw+0xcf/0xf0 [ib_uverbs]
Modules linked in: tls target_core_user uio target_core_pscsi target_core_file target_core_iblock ib_srpt ib_srp scsi_transport_srp nfsd nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs 8021q garp mrp stp llc ext4 mbcache jbd2 opa_vnic ib_umad ib_ipoib sunrpc rdma_ucm ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm hfi1 intel_rapl_msr intel_rapl_common mgag200 qedr sb_edac drm_shmem_helper rdmavt x86_pkg_temp_thermal drm_kms_helper intel_powerclamp ib_uverbs coretemp i2c_algo_bit kvm_intel dell_wmi_descriptor ipmi_ssif sparse_keymap kvm ib_core rfkill syscopyarea sysfillrect video sysimgblt irqbypass ipmi_si ipmi_devintf fb_sys_fops rapl iTCO_wdt mxm_wmi iTCO_vendor_support intel_cstate pcspkr dcdbas intel_uncore ipmi_msghandler lpc_ich acpi_power_meter mei_me mei fuse drm xfs libcrc32c qede sd_mod ahci libahci t10_pi sg crct10dif_pclmul crc32_pclmul crc32c_intel qed libata tg3
ghash_clmulni_intel megaraid_sas crc8 wmi [last unloaded: ib_srpt]
CPU: 0 PID: 143192 Comm: fi_rdm_tagged_p Kdump: loaded Not tainted 5.14.0-408.el9.x86_64 #1
Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 2.14.0 01/25/2022
RIP: 0010:uverbs_destroy_ufile_hw+0xcf/0xf0 [ib_uverbs]
Code: 5d 41 5c 41 5d 41 5e e9 0f 26 1b dd 48 89 df e8 67 6a ff ff 49 8b 86 10 01 00 00 48 85 c0 74 9c 4c 89 e7 e8 83 c0 cb dd eb 92 <0f> 0b eb be 0f 0b be 04 00 00 00 48 89 df e8 8e f5 ff ff e9 6d ff
RSP: 0018:ffffb7c6cadfbc60 EFLAGS: 00010286
RAX: ffff8f0889ee3f60 RBX: ffff8f088c1a5200 RCX: 00000000802a0016
RDX: 00000000802a0017 RSI: 0000000000000001 RDI: ffff8f0880042600
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: ffff8f11fffd5000 R11: 0000000000039000 R12: ffff8f0d5b36cd80
R13: ffff8f088c1a5250 R14: ffff8f1206d91000 R15: 0000000000000000
FS: 0000000000000000(0000) GS:ffff8f11d7c00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000147069200e20 CR3: 00000001c7210002 CR4: 00000000001706f0
Call Trace:
<TASK>
? show_trace_log_lvl+0x1c4/0x2df
? show_trace_log_lvl+0x1c4/0x2df
? ib_uverbs_close+0x1f/0xb0 [ib_uverbs]
? uverbs_destroy_ufile_hw+0xcf/0xf0 [ib_uverbs]
? __warn+0x81/0x110
? uverbs_destroy_ufile_hw+0xcf/0xf0 [ib_uverbs]
? report_bug+0x10a/0x140
? handle_bug+0x3c/0x70
? exc_invalid_op+0x14/0x70
? asm_exc_invalid_op+0x16/0x20
? uverbs_destroy_ufile_hw+0xcf/0xf0 [ib_uverbs]
ib_uverbs_close+0x1f/0xb0 [ib_uverbs]
__fput+0x94/0x250
task_work_run+0x5c/0x90
do_exit+0x270/0x4a0
do_group_exit+0x2d/0x90
get_signal+0x87c/0x8c0
arch_do_signal_or_restart+0x25/0x100
? ib_uverbs_ioctl+0xc2/0x110 [ib_uverbs]
exit_to_user_mode_loop+0x9c/0x130
exit_to_user_mode_prepare+0xb6/0x100
syscall_exit_to_user_mode+0x12/0x40
do_syscall_64+0x69/0x90
? syscall_exit_work+0x103/0x130
? syscall_exit_to_user_mode+0x22/0x40
? do_syscall_64+0x69/0x90
? syscall_exit_work+0x103/0x130
? syscall_exit_to_user_mode+0x22/0x40
? do_syscall_64+0x69/0x90
? do_syscall_64+0x69/0x90
? common_interrupt+0x43/0xa0
entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x1470abe3ec6b
Code: Unable to access opcode bytes at RIP 0x1470abe3ec41.
RSP: 002b:00007fff13ce9108 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: fffffffffffffffc RBX: 00007fff13ce9218 RCX: 00001470abe3ec6b
RDX: 00007fff13ce9200 RSI: 00000000c0181b01 RDI: 0000000000000004
RBP: 00007fff13ce91e0 R08: 0000558d9655da10 R09: 0000558d9655dd00
R10: 00007fff13ce95c0 R11: 0000000000000246 R12: 00007fff13ce9358
R13: 0000000000000013 R14: 0000558d9655db50 R15: 00007fff13ce9470
</TASK>
--[ end trace 888a9b92e04c5c97 ]--

Fixes: df15856132bc ("RDMA/qedr: restructure functions that create/destroy QPs")
Signed-off-by: Kamal Heib <kheib@redhat.com>
Link: https://lore.kernel.org/r/20240208223628.2040841-1-kheib@redhat.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index d745ce9dc88aa..61755b5f3e20d 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1879,8 +1879,17 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 		/* RQ - read access only (0) */
 		rc = qedr_init_user_queue(udata, dev, &qp->urq, ureq.rq_addr,
 					  ureq.rq_len, true, 0, alloc_and_init);
-		if (rc)
+		if (rc) {
+			ib_umem_release(qp->usq.umem);
+			qp->usq.umem = NULL;
+			if (rdma_protocol_roce(&dev->ibdev, 1)) {
+				qedr_free_pbl(dev, &qp->usq.pbl_info,
+					      qp->usq.pbl_tbl);
+			} else {
+				kfree(qp->usq.pbl_tbl);
+			}
 			return rc;
+		}
 	}
 
 	memset(&in_params, 0, sizeof(in_params));
-- 
2.43.0



