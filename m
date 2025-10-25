Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D891122689C;
	Sat, 25 Oct 2025 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408610; cv=none; b=iG2LzTQLDMs/KMZLEow48xBtIDTsEaSBHJXSyiXs6m/F4qmIOHtlsz3aXvi+TYWJ180PYuz+Dc1tViwkm4QaQ/HidZye93Hfp05p0JPV19FoNYJwbj10QMqbMZ0Mv1f0z2KdsmBFLPTxCrz86hDxRTUGvpJ2h/LpqoEFU7/FNcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408610; c=relaxed/simple;
	bh=Eulqo/BkiJEFhVNkCL9sODCFuta6Xs3Eb0afV0+P5Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8w4wCQPobbfz2XhN+oBoKZgRIh9MtbhmIecTpOZu1zN/cSbUuO51wD6WL+S1F8RiUXcjVY+oBpbRiEL2hhic2h+stinGW6BRCo+ZVmKOVwab7HjWXJWAb4/tgXwYYOc9HWyJxMW0gpw3f61Ullo+fvb7/SMRgXBhjcN4E07uSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UR2zFbSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UR2zFbSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B572C4CEFB;
	Sat, 25 Oct 2025 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408610;
	bh=Eulqo/BkiJEFhVNkCL9sODCFuta6Xs3Eb0afV0+P5Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UR2zFbSBt8Ihd9JFWlvEdg2BGm8XRBdMKY+S1nOh5kGb96R0B4TD82saRmuVfidnn
	 d/flozhhv4Wl4Y9iWvQjPVPYjGJI8mBAcc2QcTzbXBXFSYwavdnvKHfvmSsc82zEta
	 dkztPJ57sX85yC3llMf/prhO57qEEXsZHFbXBEaOgH238vHVXmSghJrVwlxM/4BS4b
	 x8DHqSE6XpoYqTDv+g5tAUOk7l7zVxkZaUCJnCnwsp00EG/F6XI3v6yTVsvKlNWSnC
	 Q3TLRuFRoMsL2DYHYzYJkKjVxehlswK87rNKF1G9MzTQggBRlpU9FviemsXk5EqOs1
	 QXica1zsZ3n+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yifan Zhang <yifan1.zhang@amd.com>,
	"Philip.Yang" <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] amd/amdkfd: enhance kfd process check in switch partition
Date: Sat, 25 Oct 2025 11:54:13 -0400
Message-ID: <20251025160905.3857885-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 45da20e00d5da842e17dfc633072b127504f0d0e ]

current switch partition only check if kfd_processes_table is empty.
kfd_prcesses_table entry is deleted in kfd_process_notifier_release, but
kfd_process tear down is in kfd_process_wq_release.

consider two processes:

Process A (workqueue) -> kfd_process_wq_release -> Access kfd_node member
Process B switch partition -> amdgpu_xcp_pre_partition_switch -> amdgpu_amdkfd_device_fini_sw
-> kfd_node tear down.

Process A and B may trigger a race as shown in dmesg log.

This patch is to resolve the race by adding an atomic kfd_process counter
kfd_processes_count, it increment as create kfd process, decrement as
finish kfd_process_wq_release.

v2: Put kfd_processes_count per kfd_dev, move decrement to kfd_process_destroy_pdds
and bug fix. (Philip Yang)

[3966658.307702] divide error: 0000 [#1] SMP NOPTI
[3966658.350818]  i10nm_edac
[3966658.356318] CPU: 124 PID: 38435 Comm: kworker/124:0 Kdump: loaded Tainted
[3966658.356890] Workqueue: kfd_process_wq kfd_process_wq_release [amdgpu]
[3966658.362839]  nfit
[3966658.366457] RIP: 0010:kfd_get_num_sdma_engines+0x17/0x40 [amdgpu]
[3966658.366460] Code: 00 00 e9 ac 81 02 00 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44 00 00 48 8b 4f 08 48 8b b7 00 01 00 00 8b 81 58 26 03 00 99 <f7> be b8 01 00 00 80 b9 70 2e 00 00 00 74 0b 83 f8 02 ba 02 00 00
[3966658.380967]  x86_pkg_temp_thermal
[3966658.391529] RSP: 0018:ffffc900a0edfdd8 EFLAGS: 00010246
[3966658.391531] RAX: 0000000000000008 RBX: ffff8974e593b800 RCX: ffff888645900000
[3966658.391531] RDX: 0000000000000000 RSI: ffff888129154400 RDI: ffff888129151c00
[3966658.391532] RBP: ffff8883ad79d400 R08: 0000000000000000 R09: ffff8890d2750af4
[3966658.391532] R10: 0000000000000018 R11: 0000000000000018 R12: 0000000000000000
[3966658.391533] R13: ffff8883ad79d400 R14: ffffe87ff662ba00 R15: ffff8974e593b800
[3966658.391533] FS:  0000000000000000(0000) GS:ffff88fe7f600000(0000) knlGS:0000000000000000
[3966658.391534] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[3966658.391534] CR2: 0000000000d71000 CR3: 000000dd0e970004 CR4: 0000000002770ee0
[3966658.391535] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[3966658.391535] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[3966658.391536] PKRU: 55555554
[3966658.391536] Call Trace:
[3966658.391674]  deallocate_sdma_queue+0x38/0xa0 [amdgpu]
[3966658.391762]  process_termination_cpsch+0x1ed/0x480 [amdgpu]
[3966658.399754]  intel_powerclamp
[3966658.402831]  kfd_process_dequeue_from_all_devices+0x5b/0xc0 [amdgpu]
[3966658.402908]  kfd_process_wq_release+0x1a/0x1a0 [amdgpu]
[3966658.410516]  coretemp
[3966658.434016]  process_one_work+0x1ad/0x380
[3966658.434021]  worker_thread+0x49/0x310
[3966658.438963]  kvm_intel
[3966658.446041]  ? process_one_work+0x380/0x380
[3966658.446045]  kthread+0x118/0x140
[3966658.446047]  ? __kthread_bind_mask+0x60/0x60
[3966658.446050]  ret_from_fork+0x1f/0x30
[3966658.446053] Modules linked in: kpatch_20765354(OEK)
[3966658.455310]  kvm
[3966658.464534]  mptcp_diag xsk_diag raw_diag unix_diag af_packet_diag netlink_diag udp_diag act_pedit act_mirred act_vlan cls_flower kpatch_21951273(OEK) kpatch_18424469(OEK) kpatch_19749756(OEK)
[3966658.473462]  idxd_mdev
[3966658.482306]  kpatch_17971294(OEK) sch_ingress xt_conntrack amdgpu(OE) amdxcp(OE) amddrm_buddy(OE) amd_sched(OE) amdttm(OE) amdkcl(OE) intel_ifs iptable_mangle tcm_loop target_core_pscsi tcp_diag target_core_file inet_diag target_core_iblock target_core_user target_core_mod coldpgs kpatch_18383292(OEK) ip6table_nat ip6table_filter ip6_tables ip_set_hash_ipportip ip_set_hash_ipportnet ip_set_hash_ipport ip_set_bitmap_port xt_comment iptable_nat nf_nat iptable_filter ip_tables ip_set ip_vs_sh ip_vs_wrr ip_vs_rr ip_vs nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 sn_core_odd(OE) i40e overlay binfmt_misc tun bonding(OE) aisqos(OE) aisqos_hotfixes(OE) rfkill uio_pci_generic uio cuse fuse nf_tables nfnetlink intel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common i10nm_edac nfit x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm idxd_mdev
[3966658.491237]  vfio_pci
[3966658.501196]  vfio_pci vfio_virqfd mdev vfio_iommu_type1 vfio iax_crypto intel_pmt_telemetry iTCO_wdt intel_pmt_class iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel rapl intel_cstate snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core snd_hwdep snd_seq
[3966658.508537]  vfio_virqfd
[3966658.517569]  snd_seq_device ipmi_ssif isst_if_mbox_pci isst_if_mmio pcspkr snd_pcm idxd intel_uncore ses isst_if_common intel_vsec idxd_bus enclosure snd_timer mei_me snd i2c_i801 i2c_smbus mei i2c_ismt soundcore joydev acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad vfat fat
[3966658.526851]  mdev
[3966658.536096]  nfsd auth_rpcgss nfs_acl lockd grace slb_vtoa(OE) sunrpc dm_mod hookers mlx5_ib(OE) ast i2c_algo_bit drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm_ttm_helper ttm mlx5_core(OE) mlxfw(OE)
[3966658.540381]  vfio_iommu_type1
[3966658.544341]  nvme mpt3sas tls drm nvme_core pci_hyperv_intf raid_class psample libcrc32c crc32c_intel mlxdevm(OE) i2c_core
[3966658.551254]  vfio
[3966658.558742]  scsi_transport_sas wmi pinctrl_emmitsburg sd_mod t10_pi sg ahci libahci libata rdma_ucm(OE) ib_uverbs(OE) rdma_cm(OE) iw_cm(OE) ib_cm(OE) ib_umad(OE) ib_core(OE) ib_ucm(OE) mlx_compat(OE)
[3966658.563004]  iax_crypto
[3966658.570988]  [last unloaded: diagnose]
[3966658.571027] ---[ end trace cc9dbb180f9ae537 ]---

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Philip.Yang<Philip.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The crash the commit describes is real: when
  `kfd_process_notifier_release` removes a process from
  `kfd_processes_table`, the subsequent `kfd_process_wq_release` can
  still touch `kfd_node` while `kgd2kfd_check_and_lock_kfd` allows a
  partition switch to proceed, tearing the device down and triggering
  the reported divide error in `kfd_get_num_sdma_engines`. The
  regression was introduced when commit `96f75f9594466f` relaxed the
  partition switch guard to rely only on the hash table; the new trace
  shows we now have a use-after-free window.
- The fix is tight and well scoped: it adds a per-device atomic counter
  at `drivers/gpu/drm/amd/amdkfd/kfd_priv.h:386` and initializes it in
  `kgd2kfd_probe` (`drivers/gpu/drm/amd/amdkfd/kfd_device.c:498`).
  `kgd2kfd_check_and_lock_kfd` now refuses partition switches while that
  counter is non-zero
  (`drivers/gpu/drm/amd/amdkfd/kfd_device.c:1495-1503`), preventing the
  race.
- The counter is balanced across process lifecycle: it increments
  whenever a process device descriptor is created
  (`drivers/gpu/drm/amd/amdkfd/kfd_process.c:1644-1654`) and decrements
  when the descriptor is destroyed in the workqueue cleanup
  (`drivers/gpu/drm/amd/amdkfd/kfd_process.c:1085-1093`). Because
  `kfd_process_destroy_pdds` zeroes `p->n_pdds` after the loop, double
  decrements are prevented.
- Side effects are minimal: the patch touches only amdkfd code,
  introduces no API/ABI changes, and relies on existing synchronization
  (`kfd_processes_mutex` and atomics). The new counter simply gatekeeps
  the existing teardown path, so regression risk is low. No follow-up
  fixes are required.
- For stable backports, ensure the base tree already contains the
  compute-partition switch support from `96f75f9594466f`; earlier
  kernels that never allowed switching with live processes don’t hit
  this race and wouldn’t benefit. On trees with that support, this
  change cleanly applies and prevents a hard crash, making it an
  excellent stable candidate.

Next step: cherry-pick 45da20e00d5da842e17dfc633072b127504f0d0e onto the
relevant stable branches and run the usual amdgpu/amdkfd partition-
switch regression tests.

 drivers/gpu/drm/amd/amdkfd/kfd_device.c  | 10 ++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h    |  2 ++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |  4 ++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 051a00152b089..e9cfb80bd4366 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -495,6 +495,7 @@ struct kfd_dev *kgd2kfd_probe(struct amdgpu_device *adev, bool vf)
 	mutex_init(&kfd->doorbell_mutex);
 
 	ida_init(&kfd->doorbell_ida);
+	atomic_set(&kfd->kfd_processes_count, 0);
 
 	return kfd;
 }
@@ -1493,6 +1494,15 @@ int kgd2kfd_check_and_lock_kfd(struct kfd_dev *kfd)
 
 	mutex_lock(&kfd_processes_mutex);
 
+	/* kfd_processes_count is per kfd_dev, return -EBUSY without
+	 * further check
+	 */
+	if (!!atomic_read(&kfd->kfd_processes_count)) {
+		pr_debug("process_wq_release not finished\n");
+		r = -EBUSY;
+		goto out;
+	}
+
 	if (hash_empty(kfd_processes_table) && !kfd_is_locked(kfd))
 		goto out;
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index d01ef5ac07666..70ef051511bb1 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -382,6 +382,8 @@ struct kfd_dev {
 
 	/* for dynamic partitioning */
 	int kfd_dev_lock;
+
+	atomic_t kfd_processes_count;
 };
 
 enum kfd_mempool {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 5be28c6c4f6aa..ddfe30c13e9d6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1088,6 +1088,8 @@ static void kfd_process_destroy_pdds(struct kfd_process *p)
 			pdd->runtime_inuse = false;
 		}
 
+		atomic_dec(&pdd->dev->kfd->kfd_processes_count);
+
 		kfree(pdd);
 		p->pdds[i] = NULL;
 	}
@@ -1649,6 +1651,8 @@ struct kfd_process_device *kfd_create_process_device_data(struct kfd_node *dev,
 	/* Init idr used for memory handle translation */
 	idr_init(&pdd->alloc_idr);
 
+	atomic_inc(&dev->kfd->kfd_processes_count);
+
 	return pdd;
 }
 
-- 
2.51.0

