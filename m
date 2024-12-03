Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53991F75A4;
	Tue,  3 Dec 2024 15:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240759; cv=none; b=YzFVs3JcrbhAHm0ZKlMxAxkt3fRgtKymy8o0Ac39WAGsMU1tnf48i8ZeHsKUUeFZFI0FsHXWGVULKqywzX2Sox+Q/re6AZxEl2uXZZalYhKqVCY++1xX2IwQyurs5Hxr9UsNozb3sHh0S3jR7yTpDY6qPo0ue4qYQUfxtDzwGYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240759; c=relaxed/simple;
	bh=1yrFvfIsxSTTRCpMyY8JXAn+hHdspXN0+vry0STK1ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knsPSeTv7RdTJEx8M1UCKHKUE6ncNg8nEscrI7OMMQMP8SEQIKuVNQeJHd7cojwthwHa2kQl5+p6x6qPrl2mXl7uhQUSbaGVMxYPmhlYX0a2XlEKZIF9cxcofkqoq/o4MJH8ZUvydYzq46aYFvjVAH33nZWfgrtDkuXJRRRzGm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSV1p/xQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSV1p/xQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1297C4CECF;
	Tue,  3 Dec 2024 15:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240759;
	bh=1yrFvfIsxSTTRCpMyY8JXAn+hHdspXN0+vry0STK1ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSV1p/xQBzDJ6DqNleBJpdvSqK8hrTKFyZO27RkppWwXTiKkIza2J2uQoFrDjIuum
	 iY2teUhDzIME9pQ5REKK5+djmIfDNtCZqfEqz3H8yUz+IXdTj0mSX+7kAb5r2ESTsm
	 O2cDo48qA3ajoUBAwqYUB302iyTp0pKTkVQjDum0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 226/826] drm/amd/display: fix a memleak issue when driver is removed
Date: Tue,  3 Dec 2024 15:39:13 +0100
Message-ID: <20241203144752.554762723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit d4f36e5fd800de7db74c1c4e62baf24a091a5ff6 ]

Running "modprobe amdgpu" the second time (followed by a modprobe -r
amdgpu) causes a call trace like:

[  845.212163] Memory manager not clean during takedown.
[  845.212170] WARNING: CPU: 4 PID: 2481 at drivers/gpu/drm/drm_mm.c:999 dr=
m_mm_takedown+0x2b/0x40
[  845.212177] Modules linked in: amdgpu(OE-) amddrm_ttm_helper(OE) amddrm_=
buddy(OE) amdxcp(OE) amd_sched(OE) drm_exec drm_suballoc_helper drm_display=
_helper i2c_algo_bit amdttm(OE) amdkcl(OE) cec rc_core sunrpc qrtr intel_ra=
pl_msr intel_rapl_common snd_hda_codec_hdmi edac_mce_amd snd_hda_intel snd_=
intel_dspcfg snd_intel_sdw_acpi snd_usb_audio snd_hda_codec snd_usbmidi_lib=
 kvm_amd snd_hda_core snd_ump mc snd_hwdep kvm snd_pcm snd_seq_midi snd_seq=
_midi_event irqbypass crct10dif_pclmul snd_rawmidi polyval_clmulni polyval_=
generic ghash_clmulni_intel sha256_ssse3 sha1_ssse3 snd_seq aesni_intel cry=
pto_simd snd_seq_device cryptd snd_timer mfd_aaeon asus_nb_wmi eeepc_wmi jo=
ydev asus_wmi snd ledtrig_audio sparse_keymap ccp wmi_bmof input_leds k10te=
mp i2c_piix4 platform_profile rapl soundcore gpio_amdpt mac_hid binfmt_misc=
 msr parport_pc ppdev lp parport efi_pstore nfnetlink dmi_sysfs ip_tables x=
_tables autofs4 hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid a=
hci xhci_pci igc crc32_pclmul libahci xhci_pci_renesas video
[  845.212284]  wmi [last unloaded: amddrm_ttm_helper(OE)]
[  845.212290] CPU: 4 PID: 2481 Comm: modprobe Tainted: G        W  OE     =
 6.8.0-31-generic #31-Ubuntu
[  845.212296] RIP: 0010:drm_mm_takedown+0x2b/0x40
[  845.212300] Code: 1f 44 00 00 48 8b 47 38 48 83 c7 38 48 39 f8 75 09 31 =
c0 31 ff e9 90 2e 86 00 55 48 c7 c7 d0 f6 8e 8a 48 89 e5 e8 f5 db 45 ff <0f=
> 0b 5d 31 c0 31 ff e9 74 2e 86 00 66 0f 1f 84 00 00 00 00 00 90
[  845.212302] RSP: 0018:ffffb11302127ae0 EFLAGS: 00010246
[  845.212305] RAX: 0000000000000000 RBX: ffff92aa5020fc08 RCX: 00000000000=
00000
[  845.212307] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00000
[  845.212309] RBP: ffffb11302127ae0 R08: 0000000000000000 R09: 00000000000=
00000
[  845.212310] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00004
[  845.212312] R13: ffff92aa50200000 R14: ffff92aa5020fb10 R15: ffff92aa502=
0faa0
[  845.212313] FS:  0000707dd7c7c080(0000) GS:ffff92b93de00000(0000) knlGS:=
0000000000000000
[  845.212316] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  845.212318] CR2: 00007d48b0aee200 CR3: 0000000115a58000 CR4: 0000000000f=
50ef0
[  845.212320] PKRU: 55555554
[  845.212321] Call Trace:
[  845.212323]  <TASK>
[  845.212328]  ? show_regs+0x6d/0x80
[  845.212333]  ? __warn+0x89/0x160
[  845.212339]  ? drm_mm_takedown+0x2b/0x40
[  845.212344]  ? report_bug+0x17e/0x1b0
[  845.212350]  ? handle_bug+0x51/0xa0
[  845.212355]  ? exc_invalid_op+0x18/0x80
[  845.212359]  ? asm_exc_invalid_op+0x1b/0x20
[  845.212366]  ? drm_mm_takedown+0x2b/0x40
[  845.212371]  amdgpu_gtt_mgr_fini+0xa9/0x130 [amdgpu]
[  845.212645]  amdgpu_ttm_fini+0x264/0x340 [amdgpu]
[  845.212770]  amdgpu_bo_fini+0x2e/0xc0 [amdgpu]
[  845.212894]  gmc_v12_0_sw_fini+0x2a/0x40 [amdgpu]
[  845.213036]  amdgpu_device_fini_sw+0x11a/0x590 [amdgpu]
[  845.213159]  amdgpu_driver_release_kms+0x16/0x40 [amdgpu]
[  845.213302]  devm_drm_dev_init_release+0x5e/0x90
[  845.213305]  devm_action_release+0x12/0x30
[  845.213308]  release_nodes+0x42/0xd0
[  845.213311]  devres_release_all+0x97/0xe0
[  845.213314]  device_unbind_cleanup+0x12/0x80
[  845.213317]  device_release_driver_internal+0x230/0x270
[  845.213319]  ? srso_alias_return_thunk+0x5/0xfbef5

This is caused by lost memory during early init phase. First time driver
is removed, memory is freed but when second time the driver is inserted,
VBIOS dmub is not active, since the PSP policy is to retain the driver
loaded version on subsequent warm boots. Hence, communication with VBIOS
DMUB fails.

Fix this by aborting further communication with vbios dmub and release
the memory immediately.

Fixes: f59549c7e705 ("drm/amd/display: free bo used for dmub bounding box")
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 32 ++++++++++++++++---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  3 ++
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 13 ++------
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gp=
u/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 8d97f17ffe662..24fbde7dd1c42 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1696,6 +1696,26 @@ dm_allocate_gpu_mem(
 	return da->cpu_ptr;
 }
=20
+void
+dm_free_gpu_mem(
+		struct amdgpu_device *adev,
+		enum dc_gpu_mem_alloc_type type,
+		void *pvMem)
+{
+	struct dal_allocation *da;
+
+	/* walk the da list in DM */
+	list_for_each_entry(da, &adev->dm.da_list, list) {
+		if (pvMem =3D=3D da->cpu_ptr) {
+			amdgpu_bo_free_kernel(&da->bo, &da->gpu_addr, &da->cpu_ptr);
+			list_del(&da->list);
+			kfree(da);
+			break;
+		}
+	}
+
+}
+
 static enum dmub_status
 dm_dmub_send_vbios_gpint_command(struct amdgpu_device *adev,
 				 enum dmub_gpint_command command_code,
@@ -1762,16 +1782,20 @@ static struct dml2_soc_bb *dm_dmub_get_vbios_boundi=
ng_box(struct amdgpu_device *
 		/* Send the chunk */
 		ret =3D dm_dmub_send_vbios_gpint_command(adev, send_addrs[i], chunk, 300=
00);
 		if (ret !=3D DMUB_STATUS_OK)
-			/* No need to free bb here since it shall be done in dm_sw_fini() */
-			return NULL;
+			goto free_bb;
 	}
=20
 	/* Now ask DMUB to copy the bb */
 	ret =3D dm_dmub_send_vbios_gpint_command(adev, DMUB_GPINT__BB_COPY, 1, 20=
0000);
 	if (ret !=3D DMUB_STATUS_OK)
-		return NULL;
+		goto free_bb;
=20
 	return bb;
+
+free_bb:
+	dm_free_gpu_mem(adev, DC_MEM_ALLOC_TYPE_GART, (void *) bb);
+	return NULL;
+
 }
=20
 static enum dmub_ips_disable_type dm_get_default_ips_mode(
@@ -2541,11 +2565,11 @@ static int dm_sw_fini(void *handle)
 			amdgpu_bo_free_kernel(&da->bo, &da->gpu_addr, &da->cpu_ptr);
 			list_del(&da->list);
 			kfree(da);
+			adev->dm.bb_from_dmub =3D NULL;
 			break;
 		}
 	}
=20
-	adev->dm.bb_from_dmub =3D NULL;
=20
 	kfree(adev->dm.dmub_fb_info);
 	adev->dm.dmub_fb_info =3D NULL;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gp=
u/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 90dfffec33cf4..a0bc2c0ac04d9 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -1004,6 +1004,9 @@ void *dm_allocate_gpu_mem(struct amdgpu_device *adev,
 						  enum dc_gpu_mem_alloc_type type,
 						  size_t size,
 						  long long *addr);
+void dm_free_gpu_mem(struct amdgpu_device *adev,
+						  enum dc_gpu_mem_alloc_type type,
+						  void *addr);
=20
 bool amdgpu_dm_is_headless(struct amdgpu_device *adev);
=20
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/dr=
ivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index eea317dcbe8c3..9752548cc5b21 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -1055,17 +1055,8 @@ void dm_helpers_free_gpu_mem(
 		void *pvMem)
 {
 	struct amdgpu_device *adev =3D ctx->driver_context;
-	struct dal_allocation *da;
-
-	/* walk the da list in DM */
-	list_for_each_entry(da, &adev->dm.da_list, list) {
-		if (pvMem =3D=3D da->cpu_ptr) {
-			amdgpu_bo_free_kernel(&da->bo, &da->gpu_addr, &da->cpu_ptr);
-			list_del(&da->list);
-			kfree(da);
-			break;
-		}
-	}
+
+	dm_free_gpu_mem(adev, type, pvMem);
 }
=20
 bool dm_helpers_dmub_outbox_interrupt_control(struct dc_context *ctx, bool=
 enable)
--=20
2.43.0



