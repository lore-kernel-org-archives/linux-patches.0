Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5831814263
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vR33j9iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DDBC433C7;
	Mon, 23 Oct 2023 11:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059336;
	bh=1slv8re9flLQ1E15Cth8l3Musu8H+H4r30SP9UnojsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vR33j9ivDx0wK1gURkXuPCHuL/CwSx671Bb3dcMjTgOtf6zJ0N8bAbecskK0DZKmI
	 FAOqwvO2OcpaG2pl5iiI3e6ErFnEys2EHgfa5DF07DKtMpmiyJDuuh/yHS7zr10/hJ
	 58r6d8w4v/TgE2DtOySyJE7ohupaQYUzU5OUS5+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Moyer <jmoyer@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 143/241] io-wq: fully initialize wqe before calling cpuhp_state_add_instance_nocalls()
Date: Mon, 23 Oct 2023 12:55:29 +0200
Message-ID: <20231023104837.360365541@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Moyer <jmoyer@redhat.com>

[ Upstream commit 0f8baa3c9802fbfe313c901e1598397b61b91ada ]

I received a bug report with the following signature:

[ 1759.937637] BUG: unable to handle page fault for address: ffffffffffffffe8
[ 1759.944564] #PF: supervisor read access in kernel mode
[ 1759.949732] #PF: error_code(0x0000) - not-present page
[ 1759.954901] PGD 7ab615067 P4D 7ab615067 PUD 7ab617067 PMD 0
[ 1759.960596] Oops: 0000 1 PREEMPT SMP PTI
[ 1759.964804] CPU: 15 PID: 109 Comm: cpuhp/15 Kdump: loaded Tainted: G X ------- — 5.14.0-362.3.1.el9_3.x86_64 #1
[ 1759.976609] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 06/20/2018
[ 1759.985181] RIP: 0010:io_wq_for_each_worker.isra.0+0x24/0xa0
[ 1759.990877] Code: 90 90 90 90 90 90 0f 1f 44 00 00 41 56 41 55 41 54 55 48 8d 6f 78 53 48 8b 47 78 48 39 c5 74 4f 49 89 f5 49 89 d4 48 8d 58 e8 <8b> 13 85 d2 74 32 8d 4a 01 89 d0 f0 0f b1 0b 75 5c 09 ca 78 3d 48
[ 1760.009758] RSP: 0000:ffffb6f403603e20 EFLAGS: 00010286
[ 1760.015013] RAX: 0000000000000000 RBX: ffffffffffffffe8 RCX: 0000000000000000
[ 1760.022188] RDX: ffffb6f403603e50 RSI: ffffffffb11e95b0 RDI: ffff9f73b09e9400
[ 1760.029362] RBP: ffff9f73b09e9478 R08: 000000000000000f R09: 0000000000000000
[ 1760.036536] R10: ffffffffffffff00 R11: ffffb6f403603d80 R12: ffffb6f403603e50
[ 1760.043712] R13: ffffffffb11e95b0 R14: ffffffffb28531e8 R15: ffff9f7a6fbdf548
[ 1760.050887] FS: 0000000000000000(0000) GS:ffff9f7a6fbc0000(0000) knlGS:0000000000000000
[ 1760.059025] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1760.064801] CR2: ffffffffffffffe8 CR3: 00000007ab610002 CR4: 00000000007706e0
[ 1760.071976] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1760.079150] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1760.086325] PKRU: 55555554
[ 1760.089044] Call Trace:
[ 1760.091501] <TASK>
[ 1760.093612] ? show_trace_log_lvl+0x1c4/0x2df
[ 1760.097995] ? show_trace_log_lvl+0x1c4/0x2df
[ 1760.102377] ? __io_wq_cpu_online+0x54/0xb0
[ 1760.106584] ? __die_body.cold+0x8/0xd
[ 1760.110356] ? page_fault_oops+0x134/0x170
[ 1760.114479] ? kernelmode_fixup_or_oops+0x84/0x110
[ 1760.119298] ? exc_page_fault+0xa8/0x150
[ 1760.123247] ? asm_exc_page_fault+0x22/0x30
[ 1760.127458] ? __pfx_io_wq_worker_affinity+0x10/0x10
[ 1760.132453] ? __pfx_io_wq_worker_affinity+0x10/0x10
[ 1760.137446] ? io_wq_for_each_worker.isra.0+0x24/0xa0
[ 1760.142527] __io_wq_cpu_online+0x54/0xb0
[ 1760.146558] cpuhp_invoke_callback+0x109/0x460
[ 1760.151029] ? __pfx_io_wq_cpu_offline+0x10/0x10
[ 1760.155673] ? __pfx_smpboot_thread_fn+0x10/0x10
[ 1760.160320] cpuhp_thread_fun+0x8d/0x140
[ 1760.164266] smpboot_thread_fn+0xd3/0x1a0
[ 1760.168297] kthread+0xdd/0x100
[ 1760.171457] ? __pfx_kthread+0x10/0x10
[ 1760.175225] ret_from_fork+0x29/0x50
[ 1760.178826] </TASK>
[ 1760.181022] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill sunrpc vfat fat dm_multipath intel_rapl_msr intel_rapl_common isst_if_common ipmi_ssif nfit libnvdimm mgag200 i2c_algo_bit ioatdma drm_shmem_helper drm_kms_helper acpi_ipmi syscopyarea x86_pkg_temp_thermal sysfillrect ipmi_si intel_powerclamp sysimgblt ipmi_devintf coretemp acpi_power_meter ipmi_msghandler rapl pcspkr dca intel_pch_thermal intel_cstate ses lpc_ich intel_uncore enclosure hpilo mei_me mei acpi_tad fuse drm xfs sd_mod sg bnx2x nvme nvme_core crct10dif_pclmul crc32_pclmul nvme_common ghash_clmulni_intel smartpqi tg3 t10_pi mdio uas libcrc32c crc32c_intel scsi_transport_sas usb_storage hpwdt wmi dm_mirror dm_region_hash dm_log dm_mod
[ 1760.248623] CR2: ffffffffffffffe8

A cpu hotplug callback was issued before wq->all_list was initialized.
This results in a null pointer dereference.  The fix is to fully setup
the io_wq before calling cpuhp_state_add_instance_nocalls().

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Link: https://lore.kernel.org/r/x49y1ghnecs.fsf@segfault.boston.devel.redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 2c03bc881edfd..fbab9b2727fde 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1130,9 +1130,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	wq = kzalloc(sizeof(struct io_wq), GFP_KERNEL);
 	if (!wq)
 		return ERR_PTR(-ENOMEM);
-	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-	if (ret)
-		goto err_wq;
 
 	refcount_inc(&data->hash->refs);
 	wq->hash = data->hash;
@@ -1165,13 +1162,14 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	wq->task = get_task_struct(data->task);
 	atomic_set(&wq->worker_refs, 1);
 	init_completion(&wq->worker_done);
+	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
+	if (ret)
+		goto err;
+
 	return wq;
 err:
 	io_wq_put_hash(data->hash);
-	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-
 	free_cpumask_var(wq->cpu_mask);
-err_wq:
 	kfree(wq);
 	return ERR_PTR(ret);
 }
-- 
2.40.1



