Received: from dmta1004-f.nifty.com (mta-fbsnd01002.nifty.com [106.153.227.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7D6C131
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 14:02:41 +0000 (UTC)
Received: from localhost.localdomain by dmta1001.nifty.com with ESMTP
          id <20230823135913983.SVYK.19115.localhost.localdomain@nifty.com>;
          Wed, 23 Aug 2023 22:59:13 +0900
From: Takashi Yano <takashi.yano@nifty.ne.jp>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org,
	tasos@tasossah.com,
	tiwai@suse.de,
	Takashi Yano <takashi.yano@nifty.ne.jp>
Subject: Re: [PATCH 6.1 110/181] ALSA: ymfpci: Create card with device-managed snd_devm_card_new()
Date: Wed, 23 Aug 2023 22:58:46 +0900
Message-Id: <20230823135846.1812-1-takashi.yano@nifty.ne.jp>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230403140418.679274299@linuxfoundation.org>
References: <20230403140418.679274299@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dear Linux Kernel Team,

I had encountered the problem that I reported to debian kernel team:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1050117
, where I was suggested to report this to upstream.

After a lot of struggle, I found that this issue occurs after the following
commit. The problem happens if a YAMAHA YMF7x4 sound card is present AND the
firmware is missing. Not only the shutdown/reboot problem, but the page fault,
whose error log is being cited following the commit, also occurs in the boot
process.


<<< The commit which causes the reported problem >>>

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit f33fc1576757741479452255132d6e3aaf558ffe ]

snd_card_ymfpci_remove() was removed in commit c6e6bb5eab74 ("ALSA:
ymfpci: Allocate resources with device-managed APIs"), but the call to
snd_card_new() was not replaced with snd_devm_card_new().

Since there was no longer a call to snd_card_free, unloading the module
would eventually result in Oops:

[697561.532887] BUG: unable to handle page fault for address: ffffffffc0924480
[697561.532893] #PF: supervisor read access in kernel mode
[697561.532896] #PF: error_code(0x0000) - not-present page
[697561.532899] PGD ae1e15067 P4D ae1e15067 PUD ae1e17067 PMD 11a8f5067 PTE 0
[697561.532905] Oops: 0000 [#1] PREEMPT SMP NOPTI
[697561.532909] CPU: 21 PID: 5080 Comm: wireplumber Tainted: G        W  OE      6.2.7 #1
[697561.532914] Hardware name: System manufacturer System Product Name/TUF GAMING X570-PLUS, BIOS 4408 10/28/2022
[697561.532916] RIP: 0010:try_module_get.part.0+0x1a/0xe0
[697561.532924] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 55 48 89 e5 41 55 41 54 49 89 fc bf 01 00 00 00 e8 56 3c f8 ff <41> 83 3c 24 02 0f 84 96 00 00 00 41 8b 84 24 30 03 00 00 85 c0 0f
[697561.532927] RSP: 0018:ffffbe9b858c3bd8 EFLAGS: 00010246
[697561.532930] RAX: ffff9815d14f1900 RBX: ffff9815c14e6000 RCX: 0000000000000000
[697561.532933] RDX: 0000000000000000 RSI: ffffffffc055092c RDI: ffffffffb3778c1a
[697561.532935] RBP: ffffbe9b858c3be8 R08: 0000000000000040 R09: ffff981a1a741380
[697561.532937] R10: ffffbe9b858c3c80 R11: 00000009d56533a6 R12: ffffffffc0924480
[697561.532939] R13: ffff9823439d8500 R14: 0000000000000025 R15: ffff9815cd109f80
[697561.532942] FS:  00007f13084f1f80(0000) GS:ffff9824aef40000(0000) knlGS:0000000000000000
[697561.532945] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[697561.532947] CR2: ffffffffc0924480 CR3: 0000000145344000 CR4: 0000000000350ee0
[697561.532949] Call Trace:
[697561.532951]  <TASK>
[697561.532955]  try_module_get+0x13/0x30
[697561.532960]  snd_ctl_open+0x61/0x1c0 [snd]
[697561.532976]  snd_open+0xb4/0x1e0 [snd]
[697561.532989]  chrdev_open+0xc7/0x240
[697561.532995]  ? fsnotify_perm.part.0+0x6e/0x160
[697561.533000]  ? __pfx_chrdev_open+0x10/0x10
[697561.533005]  do_dentry_open+0x169/0x440
[697561.533009]  vfs_open+0x2d/0x40
[697561.533012]  path_openat+0xa9d/0x10d0
[697561.533017]  ? debug_smp_processor_id+0x17/0x20
[697561.533022]  ? trigger_load_balance+0x65/0x370
[697561.533026]  do_filp_open+0xb2/0x160
[697561.533032]  ? _raw_spin_unlock+0x19/0x40
[697561.533036]  ? alloc_fd+0xa9/0x190
[697561.533040]  do_sys_openat2+0x9f/0x160
[697561.533044]  __x64_sys_openat+0x55/0x90
[697561.533048]  do_syscall_64+0x3b/0x90
[697561.533052]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[697561.533056] RIP: 0033:0x7f1308a40db4
[697561.533059] Code: 24 20 eb 8f 66 90 44 89 54 24 0c e8 46 68 f8 ff 44 8b 54 24 0c 44 89 e2 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 32 44 89 c7 89 44 24 0c e8 78 68 f8 ff 8b 44
[697561.533062] RSP: 002b:00007ffcce664450 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
[697561.533066] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f1308a40db4
[697561.533068] RDX: 0000000000080000 RSI: 00007ffcce664690 RDI: 00000000ffffff9c
[697561.533070] RBP: 00007ffcce664690 R08: 0000000000000000 R09: 0000000000000012
[697561.533072] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000080000
[697561.533074] R13: 00007f13054b069b R14: 0000565209f83200 R15: 0000000000000000
[697561.533078]  </TASK>

Fixes: c6e6bb5eab74 ("ALSA: ymfpci: Allocate resources with device-managed APIs")
Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Link: https://lore.kernel.org/r/20230329032422.170024-1-tasos@tasossah.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ymfpci/ymfpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 1e198e4d57b8d..82d4e0fda91be 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -170,7 +170,7 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		return -ENOENT;
 	}
 
-	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
+	err = snd_devm_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
 			   sizeof(*chip), &card);
 	if (err < 0)
 		return err;
-- 
2.39.2



<<< Error Log of the page fault in the boot process >>>

[   24.101852] snd_ymfpci 0000:00:0e.0: firmware: failed to load yamaha/ds1_dsp.fw (-2)
[   24.101931] firmware_class: See https://wiki.debian.org/Firmware for information about missing firmware
[   24.102001] snd_ymfpci 0000:00:0e.0: firmware: failed to load yamaha/ds1_dsp.fw (-2)
[   24.102031] snd_ymfpci 0000:00:0e.0: Direct firmware load for yamaha/ds1_dsp.fw failed with error -2
[   24.102049] snd_ymfpci 0000:00:0e.0: firmware request failed: -2
[   24.102077] snd_ymfpci: probe of 0000:00:0e.0 failed with error -2
[   24.102435] BUG: unable to handle page fault for address: f0da8084
[   24.102465] #PF: supervisor write access in kernel mode
[   24.102486] #PF: error_code(0x0002) - not-present page
[   24.102507] *pdpt = 0000000006bd0001 *pde = 000000000237a067 *pte = 0000000000000000
[   24.102544] Oops: 0002 [#1] PREEMPT SMP PTI
[   24.102568] CPU: 0 PID: 247 Comm: (udev-worker) Not tainted 6.1.27 #3
[   24.102594] Hardware name: MICRO-STAR INTERNATIONAL CO., LTD MS-6163/MS-6163 (i440BX), BIOS 4.51 PG 08/22/00
[   24.102623] EIP: snd_ymfpci_free+0x1b/0x130 [snd_ymfpci]
[   24.102684] Code: b8 01 00 00 00 5b 5e 5f 5d c3 8d 74 26 00 90 3e 8d 74 26 00 55 89 e5 56 53 8b 98 88 01 00 00 8b 43 10 8d 90 84 00 00 00 31 c0 <89> 02 8b 73 10 89 86 b0 00 00 00 8b 4b 10 89 81 80 00 00 00 b9 ff
[   24.102730] EAX: 00000000 EBX: c4d0a610 ECX: 0005f320 EDX: f0da8084
[   24.102754] ESI: c4d0a018 EDI: cfcd780c EBP: c792fc44 ESP: c792fc3c
[   24.102778] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00210246
[   24.102803] CR0: 80050033 CR2: f0da8084 CR3: 06bc8000 CR4: 000006f0
[   24.102828] Call Trace:
[   24.102853]  release_card_device+0x47/0x90 [snd]
[   24.102911]  device_release+0x30/0x90
[   24.102953]  kobject_put+0x99/0x1d0
[   24.102987]  put_device+0x11/0x20
[   24.103009]  __snd_card_release+0x71/0x80 [snd]
[   24.103043]  release_nodes+0x43/0xb0
[   24.103068]  devres_release_all+0x79/0xb0
[   24.103094]  device_unbind_cleanup+0x10/0x60
[   24.103125]  really_probe+0x1f6/0x340
[   24.103150]  __driver_probe_device+0x75/0x100
[   24.103175]  driver_probe_device+0x1f/0x90
[   24.103199]  __driver_attach+0xcf/0x1b0
[   24.103223]  ? __device_attach_driver+0x100/0x100
[   24.103248]  bus_for_each_dev+0x5b/0xa0
[   24.103272]  driver_attach+0x19/0x20
[   24.103293]  ? __device_attach_driver+0x100/0x100
[   24.103317]  bus_add_driver+0x17f/0x1e0
[   24.103340]  driver_register+0x79/0xd0
[   24.103364]  ? 0xf0d3a000
[   24.103383]  __pci_register_driver+0x42/0x50
[   24.103421]  ymfpci_driver_init+0x1c/0x1000 [snd_ymfpci]
[   24.103458]  do_one_initcall+0x41/0x1e0
[   24.103482]  ? kvfree+0x25/0x30
[   24.103518]  ? __kmem_cache_alloc_node+0x24d/0x350
[   24.103546]  ? kmalloc_trace+0x22/0x90
[   24.103581]  ? do_init_module+0x21/0x1e0
[   24.103606]  do_init_module+0x43/0x1e0
[   24.103628]  load_module+0x1a97/0x1ca0
[   24.103661]  __ia32_sys_finit_module+0xa7/0x110
[   24.103692]  __do_fast_syscall_32+0x68/0xb0
[   24.103720]  ? __do_fast_syscall_32+0x72/0xb0
[   24.103742]  ? __do_fast_syscall_32+0x72/0xb0
[   24.103764]  ? __do_fast_syscall_32+0x72/0xb0
[   24.103787]  ? irqentry_exit_to_user_mode+0x8/0x20
[   24.103817]  do_fast_syscall_32+0x29/0x60
[   24.103839]  do_SYSENTER_32+0x15/0x20
[   24.103861]  entry_SYSENTER_32+0x98/0xf1
[   24.103892] EIP: 0xb7f89549
[   24.103911] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
[   24.103956] EAX: ffffffda EBX: 0000001a ECX: b7f6be09 EDX: 00000000
[   24.103983] ESI: 00f31910 EDI: 00f341f0 EBP: 00000000 ESP: bff1561c
[   24.104007] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00200292
[   24.104036] Modules linked in: snd_ymfpci(+) snd_ac97_codec ac97_bus saa7134 snd_mpu401_uart snd_opl3_lib snd_hwdep tveeprom videobuf2_dma_sg gameport ppdev snd_rawmidi videobuf2_memops videobuf2_v4l2 snd_seq_device videobuf2_common snd_pcm snd_timer videodev snd pcspkr soundcore mc parport_pc parport evdev serio_raw sg loop fuse dm_mod efi_pstore dax configfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 crc32c_generic sil164 nouveau hid_generic mxm_wmi sd_mod video usbhid t10_pi wmi hid i2c_algo_bit drm_display_helper crc64_rocksoft crc64 cec crc_t10dif rc_core sr_mod crct10dif_generic crct10dif_common drm_ttm_helper cdrom ttm ata_generic drm_kms_helper ata_piix ohci_pci uhci_hcd ohci_hcd ehci_pci libata ehci_hcd drm usbcore scsi_mod psmouse e1000 i2c_piix4 scsi_common usb_common floppy button fan
[   24.105590] CR2: 00000000f0da8084
[   24.105590] ---[ end trace 0000000000000000 ]---
[   24.105590] EIP: snd_ymfpci_free+0x1b/0x130 [snd_ymfpci]
[   24.105590] Code: b8 01 00 00 00 5b 5e 5f 5d c3 8d 74 26 00 90 3e 8d 74 26 00 55 89 e5 56 53 8b 98 88 01 00 00 8b 43 10 8d 90 84 00 00 00 31 c0 <89> 02 8b 73 10 89 86 b0 00 00 00 8b 4b 10 89 81 80 00 00 00 b9 ff
[   24.105590] EAX: 00000000 EBX: c4d0a610 ECX: 0005f320 EDX: f0da8084
[   24.105590] ESI: c4d0a018 EDI: cfcd780c EBP: c792fc44 ESP: c792fc3c
[   24.105590] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00210246
[   24.105590] CR0: 80050033 CR2: f0da8084 CR3: 06bc8000 CR4: 000006f0
[   24.105590] note: (udev-worker)[247] exited with irqs disabled



I looked into this problem and found the mechanism of the page fault.

1) chip->reg_area_virt is mapped in sound/pci/ymfpci/ymfpci_main.c:
   snd_ymfpci_create() in the initialize process of snd_ymfpci.
2) The initializing fails due to a lack of the firmware.
3) The allocated resources are released in drivers/base/devres.c:
   release_nodes().
4) In the release process 3), reg_area_virt is unmapped before calling
   sound/pci/ymfpci/ymfpci_main.c: snd_ymfpci_free().
5) The first register access in sound/pci/ymfpci/ymfpci_main.c:
   snd_ymfpci_free() causes page fault because the reg_area_virt is
   already unmapped.

Unfortunately, I am not familiar with the linux kernel code, so I am not
sure of the appropriate way how the problem should be fixed.

Any idea?

Thanks in advance.

--
Takashi Yano <takashi.yano@nifty.ne.jp>
