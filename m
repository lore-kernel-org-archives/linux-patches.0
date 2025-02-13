Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B18723A9B2;
	Thu, 13 Feb 2025 14:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458602; cv=none; b=NRt/jN1Jms14vKrxjeWCkBRvXN9F4J5ePhqsKon72gv7uCj0mVCP2ns6eyKnKwWPdCiemj8wH4MuTlZ2gJS09Ozbsl3hbjFCknstyjnrVYFudZ5Yets4IHdtljDsfSGh3W3bhGR/LUJbQH+8+nIK+yq60ju31BvxYiIHDD8BmSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458602; c=relaxed/simple;
	bh=yekSAmOOiqmnW9rG9aNY8cZ2ml6t4sp3DEU5Zc7+vTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB1NrV+np8LBZxFqJaVaY8T4eGESkhdmwNYkIxK0lmZPAwZyt0okkNqg3Eu4Bp29tMjzp6fKJIglhAx/pb4TAx4L3ucWfdRzlKojSr8Ju4PgTrl7qAV0PIE9UL3709Pxio3pqGOsHyPOpzSeKTVl+8qO9OwvCAMqn4G/HYiRLPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvKb0Doa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvKb0Doa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97849C4CEE4;
	Thu, 13 Feb 2025 14:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458602;
	bh=yekSAmOOiqmnW9rG9aNY8cZ2ml6t4sp3DEU5Zc7+vTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvKb0DoaNH4DbbuN5FUlCGa1fXqWLbKLFJ0B38QTCdywhU8R5BXYvlYjqhN24CoBs
	 +qzbg1v7gyl9cAIgWdPU+JmjyHJRC7/tezDWkgSndiOj5vjR521f51Xe+qsD/ffhbv
	 I6XoQOe3YSCHIYv03GHvq2p5hE7251cedwD0FHBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 025/443] nvkm: correctly calculate the available space of the GSP cmdq buffer
Date: Thu, 13 Feb 2025 15:23:10 +0100
Message-ID: <20250213142441.592764553@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Wang <zhiw@nvidia.com>

[ Upstream commit 01ed662bdd6fce4f59c1804b334610d710d79fa0 ]

r535_gsp_cmdq_push() waits for the available page in the GSP cmdq
buffer when handling a large RPC request. When it sees at least one
available page in the cmdq, it quits the waiting with the amount of
free buffer pages in the queue.

Unfortunately, it always takes the [write pointer, buf_size) as
available buffer pages before rolling back and wrongly calculates the
size of the data should be copied. Thus, it can overwrite the RPC
request that GSP is currently reading, which causes GSP hang due
to corrupted RPC request:

[  549.209389] ------------[ cut here ]------------
[  549.214010] WARNING: CPU: 8 PID: 6314 at drivers/gpu/drm/nouveau/nvkm/su=
bdev/gsp/r535.c:116 r535_gsp_msgq_wait+0xd0/0x190 [nvkm]
[  549.225678] Modules linked in: nvkm(E+) gsp_log(E) snd_seq_dummy(E) snd_=
hrtimer(E) snd_seq(E) snd_timer(E) snd_seq_device(E) snd(E) soundcore(E) rf=
kill(E) qrtr(E) vfat(E) fat(E) ipmi_ssif(E) amd_atl(E) intel_rapl_msr(E) in=
tel_rapl_common(E) mlx5_ib(E) amd64_edac(E) edac_mce_amd(E) kvm_amd(E) ib_u=
verbs(E) kvm(E) ib_core(E) acpi_ipmi(E) ipmi_si(E) mxm_wmi(E) ipmi_devintf(=
E) rapl(E) i2c_piix4(E) wmi_bmof(E) joydev(E) ptdma(E) acpi_cpufreq(E) k10t=
emp(E) pcspkr(E) ipmi_msghandler(E) xfs(E) libcrc32c(E) ast(E) i2c_algo_bit=
(E) crct10dif_pclmul(E) drm_shmem_helper(E) nvme_tcp(E) crc32_pclmul(E) ahc=
i(E) drm_kms_helper(E) libahci(E) nvme_fabrics(E) crc32c_intel(E) nvme(E) c=
dc_ether(E) mlx5_core(E) nvme_core(E) usbnet(E) drm(E) libata(E) ccp(E) gha=
sh_clmulni_intel(E) mii(E) t10_pi(E) mlxfw(E) sp5100_tco(E) psample(E) pci_=
hyperv_intf(E) wmi(E) dm_multipath(E) sunrpc(E) dm_mirror(E) dm_region_hash=
(E) dm_log(E) dm_mod(E) be2iscsi(E) bnx2i(E) cnic(E) uio(E) cxgb4i(E) cxgb4=
(E) tls(E) libcxgbi(E) libcxgb(E) qla4xxx(E)
[  549.225752]  iscsi_boot_sysfs(E) iscsi_tcp(E) libiscsi_tcp(E) libiscsi(E=
) scsi_transport_iscsi(E) fuse(E) [last unloaded: gsp_log(E)]
[  549.326293] CPU: 8 PID: 6314 Comm: insmod Tainted: G            E      6=
.9.0-rc6+ #1
[  549.334039] Hardware name: ASRockRack 1U1G-MILAN/N/ROMED8-NL, BIOS L3.12=
E 09/06/2022
[  549.341781] RIP: 0010:r535_gsp_msgq_wait+0xd0/0x190 [nvkm]
[  549.347343] Code: 08 00 00 89 da c1 e2 0c 48 8d ac 11 00 10 00 00 48 8b =
0c 24 48 85 c9 74 1f c1 e0 0c 4c 8d 6d 30 83 e8 30 89 01 e9 68 ff ff ff <0f=
> 0b 49 c7 c5 92 ff ff ff e9 5a ff ff ff ba ff ff ff ff be c0 0c
[  549.366090] RSP: 0018:ffffacbccaaeb7d0 EFLAGS: 00010246
[  549.371315] RAX: 0000000000000000 RBX: 0000000000000012 RCX: 00000000009=
23e28
[  549.378451] RDX: 0000000000000000 RSI: 0000000055555554 RDI: ffffacbccaa=
eb730
[  549.385590] RBP: 0000000000000001 R08: ffff8bd14d235f70 R09: ffff8bd14d2=
35f70
[  549.392721] R10: 0000000000000002 R11: ffff8bd14d233864 R12: 00000000000=
00020
[  549.399854] R13: ffffacbccaaeb818 R14: 0000000000000020 R15: ffff8bb298c=
67000
[  549.406988] FS:  00007f5179244740(0000) GS:ffff8bd14d200000(0000) knlGS:=
0000000000000000
[  549.415076] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  549.420829] CR2: 00007fa844000010 CR3: 00000001567dc005 CR4: 00000000007=
70ef0
[  549.427963] PKRU: 55555554
[  549.430672] Call Trace:
[  549.433126]  <TASK>
[  549.435233]  ? __warn+0x7f/0x130
[  549.438473]  ? r535_gsp_msgq_wait+0xd0/0x190 [nvkm]
[  549.443426]  ? report_bug+0x18a/0x1a0
[  549.447098]  ? handle_bug+0x3c/0x70
[  549.450589]  ? exc_invalid_op+0x14/0x70
[  549.454430]  ? asm_exc_invalid_op+0x16/0x20
[  549.458619]  ? r535_gsp_msgq_wait+0xd0/0x190 [nvkm]
[  549.463565]  r535_gsp_msg_recv+0x46/0x230 [nvkm]
[  549.468257]  r535_gsp_rpc_push+0x106/0x160 [nvkm]
[  549.473033]  r535_gsp_rpc_rm_ctrl_push+0x40/0x130 [nvkm]
[  549.478422]  nvidia_grid_init_vgpu_types+0xbc/0xe0 [nvkm]
[  549.483899]  nvidia_grid_init+0xb1/0xd0 [nvkm]
[  549.488420]  ? srso_alias_return_thunk+0x5/0xfbef5
[  549.493213]  nvkm_device_pci_probe+0x305/0x420 [nvkm]
[  549.498338]  local_pci_probe+0x46/0xa0
[  549.502096]  pci_call_probe+0x56/0x170
[  549.505851]  pci_device_probe+0x79/0xf0
[  549.509690]  ? driver_sysfs_add+0x59/0xc0
[  549.513702]  really_probe+0xd9/0x380
[  549.517282]  __driver_probe_device+0x78/0x150
[  549.521640]  driver_probe_device+0x1e/0x90
[  549.525746]  __driver_attach+0xd2/0x1c0
[  549.529594]  ? __pfx___driver_attach+0x10/0x10
[  549.534045]  bus_for_each_dev+0x78/0xd0
[  549.537893]  bus_add_driver+0x112/0x210
[  549.541750]  driver_register+0x5c/0x120
[  549.545596]  ? __pfx_nvkm_init+0x10/0x10 [nvkm]
[  549.550224]  do_one_initcall+0x44/0x300
[  549.554063]  ? do_init_module+0x23/0x240
[  549.557989]  do_init_module+0x64/0x240

Calculate the available buffer page before rolling back based on
the result from the waiting.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241017071922.2518724-=
3-zhiw@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/d=
rm/nouveau/nvkm/subdev/gsp/r535.c
index bd4b5d6a7bd36..9c83bab0a5309 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -161,7 +161,7 @@ r535_gsp_cmdq_push(struct nvkm_gsp *gsp, void *argv)
 	u64 *end;
 	u64 csum =3D 0;
 	int free, time =3D 1000000;
-	u32 wptr, size;
+	u32 wptr, size, step;
 	u32 off =3D 0;
=20
 	argc =3D ALIGN(GSP_MSG_HDR_SIZE + argc, GSP_PAGE_SIZE);
@@ -195,7 +195,9 @@ r535_gsp_cmdq_push(struct nvkm_gsp *gsp, void *argv)
 		}
=20
 		cqe =3D (void *)((u8 *)gsp->shm.cmdq.ptr + 0x1000 + wptr * 0x1000);
-		size =3D min_t(u32, argc, (gsp->cmdq.cnt - wptr) * GSP_PAGE_SIZE);
+		step =3D min_t(u32, free, (gsp->cmdq.cnt - wptr));
+		size =3D min_t(u32, argc, step * GSP_PAGE_SIZE);
+
 		memcpy(cqe, (u8 *)cmd + off, size);
=20
 		wptr +=3D DIV_ROUND_UP(size, 0x1000);
--=20
2.39.5



