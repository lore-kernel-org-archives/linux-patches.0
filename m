Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAAD1386D4;
	Tue, 14 May 2024 11:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687022; cv=none; b=PDthVVCxGWRR127l/7HYCIQ2/MNexBDgMy8/K1x1i2bE59BffHJxRzWDWFm97J66eX6XsdCuLHjagp9EqOP2aS3ZlHtJWVHbFWhUJfXTZFVMfoe4W72W+4RRSyp299dafeRT+0/cW+wDxG3xjlo+6J+VACbxc5A9dYSTJFh8zUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687022; c=relaxed/simple;
	bh=JVVDfokT2+nmwB8EDMtuBXddVnWvrSxpBesTmn425W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/zAcdZ1HZW2+777G+/HRnBiXYaDtvgCMSwBo55zU7w6NYyFrzOmXKeCpd21gRW3c/DsMRatU4gZOlExFayx7lPJjo0X/Ud/OB2/YrZIt2Ky51VhKfVHQui7/Y2gSmMAhKb0jDWLYSBxUYhnMkEM9H7suBJgvH6KRRZrZ3Y//sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrTXwtSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrTXwtSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA38C2BD10;
	Tue, 14 May 2024 11:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687021;
	bh=JVVDfokT2+nmwB8EDMtuBXddVnWvrSxpBesTmn425W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrTXwtStmcZkLHJQFwmiUT1Fg9m2+kVmysurT7wS+ZljqP/radXEJllVmvKP0vUVR
	 El0Y83sCXiFvSjy+j+PAXRuXjOqqNslvJsEk1tBg9NyziM3jczpSPXbEtXntTYxvxh
	 GagcE3lqx2F91F9HnCEqy1QMInappz8/gdA5ksmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/84] scsi: bnx2fc: Remove spin_lock_bh while releasing resources after upload
Date: Tue, 14 May 2024 12:19:49 +0200
Message-ID: <20240514100953.124711519@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit c214ed2a4dda35b308b0b28eed804d7ae66401f9 ]

The session resources are used by FW and driver when session is offloaded,
once session is uploaded these resources are not used. The lock is not
required as these fields won't be used any longer. The offload and upload
calls are sequential, hence lock is not required.

This will suppress following BUG_ON():

[  449.843143] ------------[ cut here ]------------
[  449.848302] kernel BUG at mm/vmalloc.c:2727!
[  449.853072] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  449.858712] CPU: 5 PID: 1996 Comm: kworker/u24:2 Not tainted 5.14.0-118.=
el9.x86_64 #1
Rebooting.
[  449.867454] Hardware name: Dell Inc. PowerEdge R730/0WCJNT, BIOS 2.3.4 1=
1/08/2016
[  449.876966] Workqueue: fc_rport_eq fc_rport_work [libfc]
[  449.882910] RIP: 0010:vunmap+0x2e/0x30
[  449.887098] Code: 00 65 8b 05 14 a2 f0 4a a9 00 ff ff 00 75 1b 55 48 89 =
fd e8 34 36 79 00 48 85 ed 74 0b 48 89 ef 31 f6 5d e9 14 fc ff ff 5d c3 <0f=
> 0b 0f 1f 44 00 00 41 57 41 56 49 89 ce 41 55 49 89 fd 41 54 41
[  449.908054] RSP: 0018:ffffb83d878b3d68 EFLAGS: 00010206
[  449.913887] RAX: 0000000080000201 RBX: ffff8f4355133550 RCX: 000000000d4=
00005
[  449.921843] RDX: 0000000000000001 RSI: 0000000000001000 RDI: ffffb83da53=
f5000
[  449.929808] RBP: ffff8f4ac6675800 R08: ffffb83d878b3d30 R09: 00000000000=
efbdf
[  449.937774] R10: 0000000000000003 R11: ffff8f434573e000 R12: 00000000000=
01000
[  449.945736] R13: 0000000000001000 R14: ffffb83da53f5000 R15: ffff8f43d4e=
a3ae0
[  449.953701] FS:  0000000000000000(0000) GS:ffff8f529fc80000(0000) knlGS:=
0000000000000000
[  449.962732] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  449.969138] CR2: 00007f8cf993e150 CR3: 0000000efbe10003 CR4: 00000000003=
706e0
[  449.977102] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  449.985065] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  449.993028] Call Trace:
[  449.995756]  __iommu_dma_free+0x96/0x100
[  450.000139]  bnx2fc_free_session_resc+0x67/0x240 [bnx2fc]
[  450.006171]  bnx2fc_upload_session+0xce/0x100 [bnx2fc]
[  450.011910]  bnx2fc_rport_event_handler+0x9f/0x240 [bnx2fc]
[  450.018136]  fc_rport_work+0x103/0x5b0 [libfc]
[  450.023103]  process_one_work+0x1e8/0x3c0
[  450.027581]  worker_thread+0x50/0x3b0
[  450.031669]  ? rescuer_thread+0x370/0x370
[  450.036143]  kthread+0x149/0x170
[  450.039744]  ? set_kthread_struct+0x40/0x40
[  450.044411]  ret_from_fork+0x22/0x30
[  450.048404] Modules linked in: vfat msdos fat xfs nfs_layout_nfsv41_file=
s rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver dm_service_time qedf qed c=
rc8 bnx2fc libfcoe libfc scsi_transport_fc intel_rapl_msr intel_rapl_common=
 x86_pkg_temp_thermal intel_powerclamp dcdbas rapl intel_cstate intel_uncor=
e mei_me pcspkr mei ipmi_ssif lpc_ich ipmi_si fuse zram ext4 mbcache jbd2 l=
oop nfsv3 nfs_acl nfs lockd grace fscache netfs irdma ice sd_mod t10_pi sg =
ib_uverbs ib_core 8021q garp mrp stp llc mgag200 i2c_algo_bit drm_kms_helpe=
r syscopyarea sysfillrect sysimgblt mxm_wmi fb_sys_fops cec crct10dif_pclmu=
l ahci crc32_pclmul bnx2x drm ghash_clmulni_intel libahci rfkill i40e libat=
a megaraid_sas mdio wmi sunrpc lrw dm_crypt dm_round_robin dm_multipath dm_=
snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_zero dm_mod linear rai=
d10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid=
6_pq libcrc32c crc32c_intel raid1 raid0 iscsi_ibft squashfs be2iscsi bnx2i =
cnic uio cxgb4i cxgb4 tls
[  450.048497]  libcxgbi libcxgb qla4xxx iscsi_boot_sysfs iscsi_tcp libiscs=
i_tcp libiscsi scsi_transport_iscsi edd ipmi_devintf ipmi_msghandler
[  450.159753] ---[ end trace 712de2c57c64abc8 ]---

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240315071427.31842-1-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_=
tgt.c
index 50384b4a817c8..5b184c8384d05 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -834,7 +834,6 @@ static void bnx2fc_free_session_resc(struct bnx2fc_hba =
*hba,
=20
 	BNX2FC_TGT_DBG(tgt, "Freeing up session resources\n");
=20
-	spin_lock_bh(&tgt->cq_lock);
 	ctx_base_ptr =3D tgt->ctx_base;
 	tgt->ctx_base =3D NULL;
=20
@@ -890,7 +889,6 @@ static void bnx2fc_free_session_resc(struct bnx2fc_hba =
*hba,
 				    tgt->sq, tgt->sq_dma);
 		tgt->sq =3D NULL;
 	}
-	spin_unlock_bh(&tgt->cq_lock);
=20
 	if (ctx_base_ptr)
 		iounmap(ctx_base_ptr);
--=20
2.43.0



