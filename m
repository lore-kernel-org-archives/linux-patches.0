Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EFD1547F0;
	Thu, 12 Dec 2024 15:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018288; cv=none; b=O1fr3Tewb71SIKkj6s/GCisKKsdMrKCXt/BYqVXoJQhbyg+J0cQgHdIljWTLQg8bAp6J19Elpy7N4YaKUVcfP2DG7o7fpz0W++ZwHCRShVrsYqjWSUSRCcJzmmX0dT14Kx0fgMU18f4XToL6dGsm/rcCBB2Ou9BbaRLPTVNkyzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018288; c=relaxed/simple;
	bh=UXNnlxFhBm6lN8hsI/VNkG9Pv7+AnziFjyHfMi99RVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wz8dyjc03rENSCIo3zEGP6UsWXXb4BQ3043FUhpsZV/23C78YRA9bC9ZoLtlmcmwKRRkhDAOj/Ahg8n4xCD9w9/P1K9sEhHEkp4/YLnR4iPS/SrltfUk993AAIKdN6Hx1hga+noizl2UkKHDswjVBX6KtNVOBISSVCsulOyJG4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwUWcikV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwUWcikV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FAEC4CED0;
	Thu, 12 Dec 2024 15:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018288;
	bh=UXNnlxFhBm6lN8hsI/VNkG9Pv7+AnziFjyHfMi99RVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwUWcikVKwa7B5ti6Qq0TbusVruTWWwV3nOyLOH3+AT+Ww9Nb5al5L4MPq84A7Hr6
	 ALt53t+r62DI6elivqpYkk6sLA7Kvr/x0182d73HdFWQMPBUhb0w5dF7s4c/uitHFA
	 hbstSeFvvPzSHKBiYm5pbSEtDhirgA/tdyuCkIy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/356] drm/amdgpu: set the right AMDGPU sg segment limitation
Date: Thu, 12 Dec 2024 15:59:30 +0100
Message-ID: <20241212144254.524662965@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
Content-Transfer-Encoding: quoted-printable

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit e2e97435783979124ba92d6870415c57ecfef6a5 ]

The driver needs to set the correct max_segment_size;
otherwise debug_dma_map_sg() will complain about the
over-mapping of the AMDGPU sg length as following:

WARNING: CPU: 6 PID: 1964 at kernel/dma/debug.c:1178 debug_dma_map_sg+0x2dc=
/0x370
[  364.049444] Modules linked in: veth amdgpu(OE) amdxcp drm_exec gpu_sched=
 drm_buddy drm_ttm_helper ttm(OE) drm_suballoc_helper drm_display_helper dr=
m_kms_helper i2c_algo_bit rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd grace=
 netfs xt_conntrack xt_MASQUERADE nf_conntrack_netlink xfrm_user xfrm_algo =
iptable_nat xt_addrtype iptable_filter br_netfilter nvme_fabrics overlay nf=
netlink_cttimeout nfnetlink openvswitch nsh nf_conncount nf_nat nf_conntrac=
k nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c bridge stp llc amd_atl intel_rapl=
_msr intel_rapl_common sunrpc sch_fq_codel snd_hda_codec_realtek snd_hda_co=
dec_generic snd_hda_scodec_component snd_hda_codec_hdmi snd_hda_intel snd_i=
ntel_dspcfg edac_mce_amd binfmt_misc snd_hda_codec snd_pci_acp6x snd_hda_co=
re snd_acp_config snd_hwdep snd_soc_acpi kvm_amd snd_pcm kvm snd_seq_midi s=
nd_seq_midi_event crct10dif_pclmul ghash_clmulni_intel sha512_ssse3 snd_raw=
midi sha256_ssse3 sha1_ssse3 aesni_intel snd_seq nls_iso8859_1 crypto_simd =
snd_seq_device cryptd snd_timer rapl input_leds snd
[  364.049532]  ipmi_devintf wmi_bmof ccp serio_raw k10temp sp5100_tco soun=
dcore ipmi_msghandler cm32181 industrialio mac_hid msr parport_pc ppdev lp =
parport drm efi_pstore ip_tables x_tables pci_stub crc32_pclmul nvme ahci l=
ibahci i2c_piix4 r8169 nvme_core i2c_designware_pci realtek i2c_ccgx_ucsi v=
ideo wmi hid_generic cdc_ether usbnet usbhid hid r8152 mii
[  364.049576] CPU: 6 PID: 1964 Comm: rocminfo Tainted: G           OE     =
 6.10.0-custom #492
[  364.049579] Hardware name: AMD Majolica-RN/Majolica-RN, BIOS RMJ1009A 06=
/13/2021
[  364.049582] RIP: 0010:debug_dma_map_sg+0x2dc/0x370
[  364.049585] Code: 89 4d b8 e8 36 b1 86 00 8b 4d b8 48 8b 55 b0 44 8b 45 =
a8 4c 8b 4d a0 48 89 c6 48 c7 c7 00 4b 74 bc 4c 89 4d b8 e8 b4 73 f3 ff <0f=
> 0b 4c 8b 4d b8 8b 15 c8 2c b8 01 85 d2 0f 85 ee fd ff ff 8b 05
[  364.049588] RSP: 0018:ffff9ca600b57ac0 EFLAGS: 00010286
[  364.049590] RAX: 0000000000000000 RBX: ffff88b7c132b0c8 RCX: 00000000000=
00027
[  364.049592] RDX: ffff88bb0f521688 RSI: 0000000000000001 RDI: ffff88bb0f5=
21680
[  364.049594] RBP: ffff9ca600b57b20 R08: 000000000000006f R09: ffff9ca600b=
57930
[  364.049596] R10: ffff9ca600b57928 R11: ffffffffbcb46328 R12: 00000000000=
00000
[  364.049597] R13: 0000000000000001 R14: ffff88b7c19c0700 R15: ffff88b7c90=
59800
[  364.049599] FS:  00007fb2d3516e80(0000) GS:ffff88bb0f500000(0000) knlGS:=
0000000000000000
[  364.049601] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  364.049603] CR2: 000055610bd03598 CR3: 00000001049f6000 CR4: 00000000003=
50ef0
[  364.049605] Call Trace:
[  364.049607]  <TASK>
[  364.049609]  ? show_regs+0x6d/0x80
[  364.049614]  ? __warn+0x8c/0x140
[  364.049618]  ? debug_dma_map_sg+0x2dc/0x370
[  364.049621]  ? report_bug+0x193/0x1a0
[  364.049627]  ? handle_bug+0x46/0x80
[  364.049631]  ? exc_invalid_op+0x1d/0x80
[  364.049635]  ? asm_exc_invalid_op+0x1f/0x30
[  364.049642]  ? debug_dma_map_sg+0x2dc/0x370
[  364.049647]  __dma_map_sg_attrs+0x90/0xe0
[  364.049651]  dma_map_sgtable+0x25/0x40
[  364.049654]  amdgpu_bo_move+0x59a/0x850 [amdgpu]
[  364.049935]  ? srso_return_thunk+0x5/0x5f
[  364.049939]  ? amdgpu_ttm_tt_populate+0x5d/0xc0 [amdgpu]
[  364.050095]  ttm_bo_handle_move_mem+0xc3/0x180 [ttm]
[  364.050103]  ttm_bo_validate+0xc1/0x160 [ttm]
[  364.050108]  ? amdgpu_ttm_tt_get_user_pages+0xe5/0x1b0 [amdgpu]
[  364.050263]  amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu+0xa12/0xc90 [amdgpu]
[  364.050473]  kfd_ioctl_alloc_memory_of_gpu+0x16b/0x3b0 [amdgpu]
[  364.050680]  kfd_ioctl+0x3c2/0x530 [amdgpu]
[  364.050866]  ? __pfx_kfd_ioctl_alloc_memory_of_gpu+0x10/0x10 [amdgpu]
[  364.051054]  ? srso_return_thunk+0x5/0x5f
[  364.051057]  ? tomoyo_file_ioctl+0x20/0x30
[  364.051063]  __x64_sys_ioctl+0x9c/0xd0
[  364.051068]  x64_sys_call+0x1219/0x20d0
[  364.051073]  do_syscall_64+0x51/0x120
[  364.051077]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  364.051081] RIP: 0033:0x7fb2d2f1a94f

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian K=C3=B6nig <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/=
amdgpu/amdgpu_ttm.c
index 6f06183e82b2b..c89264242bea3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1835,6 +1835,7 @@ int amdgpu_ttm_init(struct amdgpu_device *adev)
=20
 	mutex_init(&adev->mman.gtt_window_lock);
=20
+	dma_set_max_seg_size(adev->dev, UINT_MAX);
 	/* No others user of address space so set it to 0 */
 	r =3D ttm_device_init(&adev->mman.bdev, &amdgpu_bo_driver, adev->dev,
 			       adev_to_drm(adev)->anon_inode->i_mapping,
--=20
2.43.0



