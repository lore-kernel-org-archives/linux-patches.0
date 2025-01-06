Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DABA81728;
	Mon,  6 Jan 2025 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178963; cv=none; b=UffI00pSx4XmpDzyOJg7izyQtCuWiQq97CIlwJQuKbRwTCknOHaJ0n/nCCxaJ69QP5LjkMuApdk1E7Pw/AsUnsZl/RhIHu6+vT7gxBD0Ykk/EQrU8szMJXz0HF2aq9FTuxrDOhnMnqKWrd2VkdZbCWduydmDQjXTTON2hRCMgIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178963; c=relaxed/simple;
	bh=eTbqWtlJWNAzsb14YAc7P9/AUoV+lAMWglpNoKo8oxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVlMZL+225KY9mgmyKY3zraInacqQDL6qLCxCIP4nnR4f64bOt7VsAD7oVXM1ka44BSbyeYHklup0zFtorCdTnmn5zmaSKVRV2v+W3JSXJ5LDSNHygqbVaco6IsbhzkWbUgYW2a1yhIEJkMX92Gls8LEXw3CWQpfnl7JJnLUhKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yld6Rq6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yld6Rq6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE757C4CED6;
	Mon,  6 Jan 2025 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178963;
	bh=eTbqWtlJWNAzsb14YAc7P9/AUoV+lAMWglpNoKo8oxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yld6Rq6AryaUSY90nv0Xk3imaRmqzriNq2XsriHA6tqrp6tl/2e29pQ2++FSIo64h
	 X9n8ZyHOgLknoPp2JUKq6/MO89FXNMuIAodDDIA1fPzssjrE3OXtHtaAHFWcvbiDv4
	 PWfgu1vYoAKmRs1loS6hQgptNiOXAg90BgUl0yOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/168] drm/amdkfd: Correct the migration DMA map direction
Date: Mon,  6 Jan 2025 16:17:38 +0100
Message-ID: <20250106151144.100673530@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 5c3de6b02d38eb9386edf50490e050bb44398e40 ]

The SVM DMA device map direction should be set the same as
the DMA unmap setting, otherwise the DMA core will report
the following warning.

Before finialize this solution, there're some discussion on
the DMA mapping type(stream-based or coherent) in this KFD
migration case, followed by https://lore.kernel.org/all/04d4ab32
-45a1-4b88-86ee-fb0f35a0ca40@amd.com/T/.

As there's no dma_sync_single_for_*() in the DMA buffer accessed
that because this migration operation should be sync properly and
automatically. Give that there's might not be a performance problem
in various cache sync policy of DMA sync. Therefore, in order to
simplify the DMA direction setting alignment, let's set the DMA map
direction as BIDIRECTIONAL.

[  150.834218] WARNING: CPU: 8 PID: 1812 at kernel/dma/debug.c:1028 check_u=
nmap+0x1cc/0x930
[  150.834225] Modules linked in: amdgpu(OE) amdxcp drm_exec(OE) gpu_sched =
drm_buddy(OE) drm_ttm_helper(OE) ttm(OE) drm_suballoc_helper(OE) drm_displa=
y_helper(OE) drm_kms_helper(OE) i2c_algo_bit rpcsec_gss_krb5 auth_rpcgss nf=
sv4 nfs lockd grace netfs xt_conntrack xt_MASQUERADE nf_conntrack_netlink x=
frm_user xfrm_algo iptable_nat xt_addrtype iptable_filter br_netfilter nvme=
_fabrics overlay nfnetlink_cttimeout nfnetlink openvswitch nsh nf_conncount=
 nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c bridge stp llc=
 sch_fq_codel intel_rapl_msr amd_atl intel_rapl_common snd_hda_codec_realte=
k snd_hda_codec_generic snd_hda_scodec_component snd_hda_codec_hdmi snd_hda=
_intel snd_intel_dspcfg edac_mce_amd snd_pci_acp6x snd_hda_codec snd_acp_co=
nfig snd_hda_core snd_hwdep snd_soc_acpi kvm_amd sunrpc snd_pcm kvm binfmt_=
misc snd_seq_midi crct10dif_pclmul snd_seq_midi_event ghash_clmulni_intel s=
ha512_ssse3 snd_rawmidi nls_iso8859_1 sha256_ssse3 sha1_ssse3 snd_seq aesni=
_intel snd_seq_device crypto_simd snd_timer cryptd input_leds
[  150.834310]  wmi_bmof serio_raw k10temp rapl snd sp5100_tco ipmi_devintf=
 soundcore ccp ipmi_msghandler cm32181 industrialio mac_hid msr parport_pc =
ppdev lp parport efi_pstore drm(OE) ip_tables x_tables pci_stub crc32_pclmu=
l nvme ahci libahci i2c_piix4 r8169 nvme_core i2c_designware_pci realtek i2=
c_ccgx_ucsi video wmi hid_generic cdc_ether usbnet usbhid hid r8152 mii
[  150.834354] CPU: 8 PID: 1812 Comm: rocrtst64 Tainted: G           OE    =
  6.10.0-custom #492
[  150.834358] Hardware name: AMD Majolica-RN/Majolica-RN, BIOS RMJ1009A 06=
/13/2021
[  150.834360] RIP: 0010:check_unmap+0x1cc/0x930
[  150.834363] Code: c0 4c 89 4d c8 e8 34 bf 86 00 4c 8b 4d c8 4c 8b 45 c0 =
48 8b 4d b8 48 89 c6 41 57 4c 89 ea 48 c7 c7 80 49 b4 84 e8 b4 81 f3 ff <0f=
> 0b 48 c7 c7 04 83 ac 84 e8 76 ba fc ff 41 8b 76 4c 49 8d 7e 50
[  150.834365] RSP: 0018:ffffaac5023739e0 EFLAGS: 00010086
[  150.834368] RAX: 0000000000000000 RBX: ffffffff8566a2e0 RCX: 00000000000=
00027
[  150.834370] RDX: ffff8f6a8f621688 RSI: 0000000000000001 RDI: ffff8f6a8f6=
21680
[  150.834372] RBP: ffffaac502373a30 R08: 00000000000000c9 R09: ffffaac5023=
73850
[  150.834373] R10: ffffaac502373848 R11: ffffffff84f46328 R12: ffffaac5023=
73a40
[  150.834375] R13: ffff8f6741045330 R14: ffff8f6741a77700 R15: ffffffff84a=
c831b
[  150.834377] FS:  00007faf0fc94c00(0000) GS:ffff8f6a8f600000(0000) knlGS:=
0000000000000000
[  150.834379] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  150.834381] CR2: 00007faf0b600020 CR3: 000000010a52e000 CR4: 00000000003=
50ef0
[  150.834383] Call Trace:
[  150.834385]  <TASK>
[  150.834387]  ? show_regs+0x6d/0x80
[  150.834393]  ? __warn+0x8c/0x140
[  150.834397]  ? check_unmap+0x1cc/0x930
[  150.834400]  ? report_bug+0x193/0x1a0
[  150.834406]  ? handle_bug+0x46/0x80
[  150.834410]  ? exc_invalid_op+0x1d/0x80
[  150.834413]  ? asm_exc_invalid_op+0x1f/0x30
[  150.834420]  ? check_unmap+0x1cc/0x930
[  150.834425]  debug_dma_unmap_page+0x86/0x90
[  150.834431]  ? srso_return_thunk+0x5/0x5f
[  150.834435]  ? rmap_walk+0x28/0x50
[  150.834438]  ? srso_return_thunk+0x5/0x5f
[  150.834441]  ? remove_migration_ptes+0x79/0x80
[  150.834445]  ? srso_return_thunk+0x5/0x5f
[  150.834448]  dma_unmap_page_attrs+0xfa/0x1d0
[  150.834453]  svm_range_dma_unmap_dev+0x8a/0xf0 [amdgpu]
[  150.834710]  svm_migrate_ram_to_vram+0x361/0x740 [amdgpu]
[  150.834914]  svm_migrate_to_vram+0xa8/0xe0 [amdgpu]
[  150.835111]  svm_range_set_attr+0xff2/0x1450 [amdgpu]
[  150.835311]  svm_ioctl+0x4a/0x50 [amdgpu]
[  150.835510]  kfd_ioctl_svm+0x54/0x90 [amdgpu]
[  150.835701]  kfd_ioctl+0x3c2/0x530 [amdgpu]
[  150.835888]  ? __pfx_kfd_ioctl_svm+0x10/0x10 [amdgpu]
[  150.836075]  ? srso_return_thunk+0x5/0x5f
[  150.836080]  ? tomoyo_file_ioctl+0x20/0x30
[  150.836086]  __x64_sys_ioctl+0x9c/0xd0
[  150.836091]  x64_sys_call+0x1219/0x20d0
[  150.836095]  do_syscall_64+0x51/0x120
[  150.836098]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  150.836102] RIP: 0033:0x7faf0f11a94f
[  150.836105] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 =
00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <41=
> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
[  150.836107] RSP: 002b:00007ffeced26bc0 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[  150.836110] RAX: ffffffffffffffda RBX: 000055c683528fb0 RCX: 00007faf0f1=
1a94f
[  150.836112] RDX: 00007ffeced26c60 RSI: 00000000c0484b20 RDI: 00000000000=
00003
[  150.836114] RBP: 00007ffeced26c50 R08: 0000000000000000 R09: 00000000000=
00001
[  150.836115] R10: 0000000000000032 R11: 0000000000000246 R12: 000055c6835=
28bd0
[  150.836117] R13: 0000000000000000 R14: 0000000000000021 R15: 00000000000=
00000
[  150.836122]  </TASK>
[  150.836124] ---[ end trace 0000000000000000 ]---

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd=
/amdkfd/kfd_migrate.c
index 131d98c600ee..013749cd3ae2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -302,7 +302,7 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, st=
ruct svm_range *prange,
 			migrate->dst[i] =3D migrate_pfn(migrate->dst[i]);
 			migrate->dst[i] |=3D MIGRATE_PFN_LOCKED;
 			src[i] =3D dma_map_page(dev, spage, 0, PAGE_SIZE,
-					      DMA_TO_DEVICE);
+					      DMA_BIDIRECTIONAL);
 			r =3D dma_mapping_error(dev, src[i]);
 			if (r) {
 				pr_debug("failed %d dma_map_page\n", r);
@@ -569,7 +569,7 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, str=
uct svm_range *prange,
 			goto out_oom;
 		}
=20
-		dst[i] =3D dma_map_page(dev, dpage, 0, PAGE_SIZE, DMA_FROM_DEVICE);
+		dst[i] =3D dma_map_page(dev, dpage, 0, PAGE_SIZE, DMA_BIDIRECTIONAL);
 		r =3D dma_mapping_error(dev, dst[i]);
 		if (r) {
 			pr_debug("failed %d dma_map_page\n", r);
--=20
2.39.5



