Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8EE20316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/I1o+Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1940EC433C7;
	Mon,  6 Nov 2023 13:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276503;
	bh=+MnawLf8b4EAbQIoMbGiAhEuBIXhX8nQB7Vj/MY041A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/I1o+SwHi2DeR3GaFZzacD18V7oq+UJ3sXNt1776OrTzTrbi3lOpIdMXsTsYjmFY
	 2buvWB8izfKxUNtZ6y7/RJb0DYCm2v138Pfa4fpM3QgjUaCl2xeULOkZD0FN37+8fs
	 UwPS5KcBc+ZZ6vyHhnWnLAfsUl2XNaBXbWUAtkYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Allen Zhong <allen@atr.me>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/62] power: supply: core: Use blocking_notifier_call_chain to avoid RCU complaint
Date: Mon,  6 Nov 2023 14:03:46 +0100
Message-ID: <20231106130303.259985707@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit bbaa6ffa5b6c9609d3b3c431c389b407eea5441f ]

AMD PMF driver can cause the following warning:
[  196.159546] ------------[ cut here ]------------
[  196.159556] Voluntary context switch within RCU read-side critical secti=
on!
[  196.159571] WARNING: CPU: 0 PID: 9 at kernel/rcu/tree_plugin.h:320 rcu_n=
ote_context_switch+0x43d/0x560
[  196.159604] Modules linked in: nvme_fabrics ccm rfcomm snd_hda_scodec_cs=
35l41_spi cmac algif_hash algif_skcipher af_alg bnep joydev btusb btrtl uvc=
video btintel btbcm videobuf2_vmalloc intel_rapl_msr btmtk videobuf2_memops=
 uvc videobuf2_v4l2 intel_rapl_common binfmt_misc hid_sensor_als snd_sof_am=
d_vangogh hid_sensor_trigger bluetooth industrialio_triggered_buffer videod=
ev snd_sof_amd_rembrandt hid_sensor_iio_common amdgpu ecdh_generic kfifo_bu=
f videobuf2_common hp_wmi kvm_amd sparse_keymap snd_sof_amd_renoir wmi_bmof=
 industrialio ecc mc nls_iso8859_1 kvm snd_sof_amd_acp irqbypass snd_sof_xt=
ensa_dsp crct10dif_pclmul crc32_pclmul mt7921e snd_sof_pci snd_ctl_led poly=
val_clmulni mt7921_common polyval_generic snd_sof ghash_clmulni_intel mt792=
x_lib mt76_connac_lib sha512_ssse3 snd_sof_utils aesni_intel snd_hda_codec_=
realtek crypto_simd mt76 snd_hda_codec_generic cryptd snd_soc_core snd_hda_=
codec_hdmi rapl ledtrig_audio input_leds snd_compress i2c_algo_bit drm_ttm_=
helper mac80211 snd_pci_ps hid_multitouch ttm drm_exec
[  196.159970]  drm_suballoc_helper snd_rpl_pci_acp6x amdxcp drm_buddy snd_=
hda_intel snd_acp_pci snd_hda_scodec_cs35l41_i2c serio_raw gpu_sched snd_hd=
a_scodec_cs35l41 snd_acp_legacy_common snd_intel_dspcfg snd_hda_cs_dsp_ctls=
 snd_hda_codec libarc4 drm_display_helper snd_pci_acp6x cs_dsp snd_hwdep sn=
d_soc_cs35l41_lib video k10temp snd_pci_acp5x thunderbolt snd_hda_core drm_=
kms_helper cfg80211 snd_seq snd_rn_pci_acp3x snd_pcm snd_acp_config cec snd=
_soc_acpi snd_seq_device rc_core ccp snd_pci_acp3x snd_timer snd soundcore =
wmi amd_pmf platform_profile amd_pmc mac_hid serial_multi_instantiate wirel=
ess_hotkey hid_sensor_hub sch_fq_codel msr parport_pc ppdev lp parport efi_=
pstore ip_tables x_tables autofs4 btrfs blake2b_generic raid10 raid456 asyn=
c_raid6_recov async_memcpy async_pq async_xor async_tx libcrc32c xor raid6_=
pq raid1 raid0 multipath linear dm_mirror dm_region_hash dm_log cdc_ether u=
sbnet r8152 mii hid_generic nvme i2c_hid_acpi i2c_hid nvme_core i2c_piix4 x=
hci_pci amd_sfh drm xhci_pci_renesas nvme_common hid
[  196.160382] CPU: 0 PID: 9 Comm: kworker/0:1 Not tainted 6.6.0-rc1 #4
[  196.160397] Hardware name: HP HP EliteBook 845 14 inch G10 Notebook PC/8=
B6E, BIOS V82 Ver. 01.02.00 08/24/2023
[  196.160405] Workqueue: events power_supply_changed_work
[  196.160426] RIP: 0010:rcu_note_context_switch+0x43d/0x560
[  196.160440] Code: 00 48 89 be 40 08 00 00 48 89 86 48 08 00 00 48 89 10 =
e9 63 fe ff ff 48 c7 c7 10 e7 b0 9e c6 05 e8 d8 20 02 01 e8 13 0f f3 ff <0f=
> 0b e9 27 fc ff ff a9 ff ff ff 7f 0f 84 cf fc ff ff 65 48 8b 3c
[  196.160450] RSP: 0018:ffffc900001878f0 EFLAGS: 00010046
[  196.160462] RAX: 0000000000000000 RBX: ffff88885e834040 RCX: 00000000000=
00000
[  196.160470] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00000
[  196.160476] RBP: ffffc90000187910 R08: 0000000000000000 R09: 00000000000=
00000
[  196.160482] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[  196.160488] R13: 0000000000000000 R14: ffff888100990000 R15: ffff8881009=
90000
[  196.160495] FS:  0000000000000000(0000) GS:ffff88885e800000(0000) knlGS:=
0000000000000000
[  196.160504] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  196.160512] CR2: 000055cb053c8246 CR3: 000000013443a000 CR4: 00000000007=
50ef0
[  196.160520] PKRU: 55555554
[  196.160526] Call Trace:
[  196.160532]  <TASK>
[  196.160548]  ? show_regs+0x72/0x90
[  196.160570]  ? rcu_note_context_switch+0x43d/0x560
[  196.160580]  ? __warn+0x8d/0x160
[  196.160600]  ? rcu_note_context_switch+0x43d/0x560
[  196.160613]  ? report_bug+0x1bb/0x1d0
[  196.160637]  ? handle_bug+0x46/0x90
[  196.160658]  ? exc_invalid_op+0x19/0x80
[  196.160675]  ? asm_exc_invalid_op+0x1b/0x20
[  196.160709]  ? rcu_note_context_switch+0x43d/0x560
[  196.160727]  __schedule+0xb9/0x15f0
[  196.160746]  ? srso_alias_return_thunk+0x5/0x7f
[  196.160765]  ? srso_alias_return_thunk+0x5/0x7f
[  196.160778]  ? acpi_ns_search_one_scope+0xbe/0x270
[  196.160806]  schedule+0x68/0x110
[  196.160820]  schedule_timeout+0x151/0x160
[  196.160829]  ? srso_alias_return_thunk+0x5/0x7f
[  196.160842]  ? srso_alias_return_thunk+0x5/0x7f
[  196.160855]  ? acpi_ns_lookup+0x3c5/0xa90
[  196.160878]  __down_common+0xff/0x220
[  196.160905]  __down_timeout+0x16/0x30
[  196.160920]  down_timeout+0x64/0x70
[  196.160938]  acpi_os_wait_semaphore+0x85/0x200
[  196.160959]  acpi_ut_acquire_mutex+0x9e/0x280
[  196.160979]  acpi_ex_enter_interpreter+0x2d/0xb0
[  196.160992]  acpi_ns_evaluate+0x2f0/0x5f0
[  196.161005]  acpi_evaluate_object+0x172/0x490
[  196.161018]  ? acpi_os_signal_semaphore+0x8a/0xd0
[  196.161038]  acpi_evaluate_integer+0x52/0xe0
[  196.161055]  ? kfree+0x79/0x120
[  196.161071]  ? srso_alias_return_thunk+0x5/0x7f
[  196.161089]  acpi_ac_get_state.part.0+0x27/0x80
[  196.161110]  get_ac_property+0x5c/0x70
[  196.161127]  ? __pfx___power_supply_is_system_supplied+0x10/0x10
[  196.161146]  __power_supply_is_system_supplied+0x44/0xb0
[  196.161166]  class_for_each_device+0x124/0x160
[  196.161184]  ? acpi_ac_get_state.part.0+0x27/0x80
[  196.161203]  ? srso_alias_return_thunk+0x5/0x7f
[  196.161223]  power_supply_is_system_supplied+0x3c/0x70
[  196.161243]  amd_pmf_get_power_source+0xe/0x20 [amd_pmf]
[  196.161276]  amd_pmf_power_slider_update_event+0x49/0x90 [amd_pmf]
[  196.161310]  amd_pmf_pwr_src_notify_call+0xe7/0x100 [amd_pmf]
[  196.161340]  notifier_call_chain+0x5f/0xe0
[  196.161362]  atomic_notifier_call_chain+0x33/0x60
[  196.161378]  power_supply_changed_work+0x84/0x110
[  196.161394]  process_one_work+0x178/0x360
[  196.161412]  ? __pfx_worker_thread+0x10/0x10
[  196.161424]  worker_thread+0x307/0x430
[  196.161440]  ? __pfx_worker_thread+0x10/0x10
[  196.161451]  kthread+0xf4/0x130
[  196.161467]  ? __pfx_kthread+0x10/0x10
[  196.161486]  ret_from_fork+0x43/0x70
[  196.161502]  ? __pfx_kthread+0x10/0x10
[  196.161518]  ret_from_fork_asm+0x1b/0x30
[  196.161558]  </TASK>
[  196.161562] ---[ end trace 0000000000000000 ]---

Since there's no guarantee that all the callbacks can work in atomic
context, switch to use blocking_notifier_call_chain to relax the
constraint.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reported-by: Allen Zhong <allen@atr.me>
Fixes: 4c71ae414474 ("platform/x86/amd/pmf: Add support SPS PMF feature")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D217571
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230913033233.602986-1-kai.heng.feng@canon=
ical.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 8 ++++----
 include/linux/power_supply.h             | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/suppl=
y/power_supply_core.c
index 7871ab5e979c0..ac88c9636b663 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -29,7 +29,7 @@
 struct class *power_supply_class;
 EXPORT_SYMBOL_GPL(power_supply_class);
=20
-ATOMIC_NOTIFIER_HEAD(power_supply_notifier);
+BLOCKING_NOTIFIER_HEAD(power_supply_notifier);
 EXPORT_SYMBOL_GPL(power_supply_notifier);
=20
 static struct device_type power_supply_dev_type;
@@ -97,7 +97,7 @@ static void power_supply_changed_work(struct work_struct =
*work)
 		class_for_each_device(power_supply_class, NULL, psy,
 				      __power_supply_changed_work);
 		power_supply_update_leds(psy);
-		atomic_notifier_call_chain(&power_supply_notifier,
+		blocking_notifier_call_chain(&power_supply_notifier,
 				PSY_EVENT_PROP_CHANGED, psy);
 		kobject_uevent(&psy->dev.kobj, KOBJ_CHANGE);
 		spin_lock_irqsave(&psy->changed_lock, flags);
@@ -1112,13 +1112,13 @@ static void power_supply_dev_release(struct device =
*dev)
=20
 int power_supply_reg_notifier(struct notifier_block *nb)
 {
-	return atomic_notifier_chain_register(&power_supply_notifier, nb);
+	return blocking_notifier_chain_register(&power_supply_notifier, nb);
 }
 EXPORT_SYMBOL_GPL(power_supply_reg_notifier);
=20
 void power_supply_unreg_notifier(struct notifier_block *nb)
 {
-	atomic_notifier_chain_unregister(&power_supply_notifier, nb);
+	blocking_notifier_chain_unregister(&power_supply_notifier, nb);
 }
 EXPORT_SYMBOL_GPL(power_supply_unreg_notifier);
=20
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index aa2c4a7c4826d..a10428884e6a5 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -766,7 +766,7 @@ struct power_supply_battery_info {
 	int bti_resistance_tolerance;
 };
=20
-extern struct atomic_notifier_head power_supply_notifier;
+extern struct blocking_notifier_head power_supply_notifier;
 extern int power_supply_reg_notifier(struct notifier_block *nb);
 extern void power_supply_unreg_notifier(struct notifier_block *nb);
 #if IS_ENABLED(CONFIG_POWER_SUPPLY)
--=20
2.42.0



