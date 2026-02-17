Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21F034D4F8;
	Tue, 17 Feb 2026 20:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361092; cv=none; b=irX9XiXAY68jDeQ8qgbClhKUyVsz6Qd3qzWfDq0Y26htasQkxpxXyHW5imOH7pWICrZd24j4tFUJ5RYxRaAu1s/Ud/n08WTquNocQZQ02jrD16VzYwNz0NLarn2MSyhWjOMN0Jdbxd4Fjsn177v35pZgr9d4CAHVUx5r0+xYMaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361092; c=relaxed/simple;
	bh=fZV84MiBnfH9grSEMO/O7CZVslV6B5oY9ItYGTMm75I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzDdWlEOnOABbTGX4TtSoCr/7zQR4NC1yoFO1HQEf+sxEUCM0UAap4Aazl/rloBxaWUB2DoCGjW7q0fD65HH+bfJyDYlObjcIb83wAzxVcLJobtk5eYTmoQlWmoUyuaJCyvRMU0jadw688bgtKC9ckfuZ9tPqMv19TRDdZj08Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uiB5pP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uiB5pP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE37C4CEF7;
	Tue, 17 Feb 2026 20:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361092;
	bh=fZV84MiBnfH9grSEMO/O7CZVslV6B5oY9ItYGTMm75I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uiB5pP4SkidiEqWUxMgZW6ACOdQNLULlG1LbqX/1mBXsTUjd/RKgE9jAYHPK8C9v
	 HjU9197doyxtYkaZesgLnlKv0/A9LFqsOFxsPL2aCS0kNJH9VCgX2548T8OPTO7e3O
	 B415DyeRnhEpy7EkjDGdl0WkvMHn5bnkDKYgFO0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Gurumurthy <agurumurthy@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/39] scsi: qla2xxx: Free sp in error path to fix system crash
Date: Tue, 17 Feb 2026 21:31:40 +0100
Message-ID: <20260217200004.140156558@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

From: Anil Gurumurthy <agurumurthy@marvell.com>

[ Upstream commit 7adbd2b7809066c75f0433e5e2a8e114b429f30f ]

System crash seen during load/unload test in a loop,

[61110.449331] qla2xxx [0000:27:00.0]-0042:0: Disabled MSI-X.
[61110.467494] =============================================================================
[61110.467498] BUG qla2xxx_srbs (Tainted: G           OE    --------  --- ): Objects remaining in qla2xxx_srbs on __kmem_cache_shutdown()
[61110.467501] -----------------------------------------------------------------------------

[61110.467502] Slab 0x000000000ffc8162 objects=51 used=1 fp=0x00000000e25d3d85 flags=0x57ffffc0010200(slab|head|node=1|zone=2|lastcpupid=0x1fffff)
[61110.467509] CPU: 53 PID: 455206 Comm: rmmod Kdump: loaded Tainted: G           OE    --------  ---  5.14.0-284.11.1.el9_2.x86_64 #1
[61110.467513] Hardware name: HPE ProLiant DL385 Gen10 Plus v2/ProLiant DL385 Gen10 Plus v2, BIOS A42 08/17/2023
[61110.467515] Call Trace:
[61110.467516]  <TASK>
[61110.467519]  dump_stack_lvl+0x34/0x48
[61110.467526]  slab_err.cold+0x53/0x67
[61110.467534]  __kmem_cache_shutdown+0x16e/0x320
[61110.467540]  kmem_cache_destroy+0x51/0x160
[61110.467544]  qla2x00_module_exit+0x93/0x99 [qla2xxx]
[61110.467607]  ? __do_sys_delete_module.constprop.0+0x178/0x280
[61110.467613]  ? syscall_trace_enter.constprop.0+0x145/0x1d0
[61110.467616]  ? do_syscall_64+0x5c/0x90
[61110.467619]  ? exc_page_fault+0x62/0x150
[61110.467622]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[61110.467626]  </TASK>
[61110.467627] Disabling lock debugging due to kernel taint
[61110.467635] Object 0x0000000026f7e6e6 @offset=16000
[61110.467639] ------------[ cut here ]------------
[61110.467639] kmem_cache_destroy qla2xxx_srbs: Slab cache still has objects when called from qla2x00_module_exit+0x93/0x99 [qla2xxx]
[61110.467659] WARNING: CPU: 53 PID: 455206 at mm/slab_common.c:520 kmem_cache_destroy+0x14d/0x160
[61110.467718] CPU: 53 PID: 455206 Comm: rmmod Kdump: loaded Tainted: G    B      OE    --------  ---  5.14.0-284.11.1.el9_2.x86_64 #1
[61110.467720] Hardware name: HPE ProLiant DL385 Gen10 Plus v2/ProLiant DL385 Gen10 Plus v2, BIOS A42 08/17/2023
[61110.467721] RIP: 0010:kmem_cache_destroy+0x14d/0x160
[61110.467724] Code: 99 7d 07 00 48 89 ef e8 e1 6a 07 00 eb b3 48 8b 55 60 48 8b 4c 24 20 48 c7 c6 70 fc 66 90 48 c7 c7 f8 ef a1 90 e8 e1 ed 7c 00 <0f> 0b eb 93 c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
[61110.467725] RSP: 0018:ffffa304e489fe80 EFLAGS: 00010282
[61110.467727] RAX: 0000000000000000 RBX: ffffffffc0d9a860 RCX: 0000000000000027
[61110.467729] RDX: ffff8fd5ff9598a8 RSI: 0000000000000001 RDI: ffff8fd5ff9598a0
[61110.467730] RBP: ffff8fb6aaf78700 R08: 0000000000000000 R09: 0000000100d863b7
[61110.467731] R10: ffffa304e489fd20 R11: ffffffff913bef48 R12: 0000000040002000
[61110.467731] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[61110.467733] FS:  00007f64c89fb740(0000) GS:ffff8fd5ff940000(0000) knlGS:0000000000000000
[61110.467734] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[61110.467735] CR2: 00007f0f02bfe000 CR3: 00000020ad6dc005 CR4: 0000000000770ee0
[61110.467736] PKRU: 55555554
[61110.467737] Call Trace:
[61110.467738]  <TASK>
[61110.467739]  qla2x00_module_exit+0x93/0x99 [qla2xxx]
[61110.467755]  ? __do_sys_delete_module.constprop.0+0x178/0x280

Free sp in the error path to fix the crash.

Fixes: f352eeb75419 ("scsi: qla2xxx: Add ability to use GPNFT/GNNFT for RSCN handling")
Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
Link: https://patch.msgid.link/20251210101604.431868-9-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3921,8 +3921,8 @@ int qla_fab_async_scan(scsi_qla_host_t *
 	if (vha->scan.scan_flags & SF_SCANNING) {
 		spin_unlock_irqrestore(&vha->work_lock, flags);
 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x2012,
-		    "%s: scan active\n", __func__);
-		return rval;
+		    "%s: scan active for sp:%p\n", __func__, sp);
+		goto done_free_sp;
 	}
 	vha->scan.scan_flags |= SF_SCANNING;
 	if (!sp)


