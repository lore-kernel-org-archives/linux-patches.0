Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C651417BED0;
	Sat, 17 Oct 2026 16:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253961; cv=none; b=V5jk/l9/e/V0Huq7jZ+CglfaTyQrPDD5POdNessIY1AS+nQsLK8gGZ9fBG2/c83p6pOy40B9B0vS857CfyByd0NrVAuj2iYwJ73YmEwgH65y61D0tsS2JTfZa8LdH38hT84gx2R3A/gAq0Ljz6TE8W4A798R9h3I/FK/X/rsPVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253961; c=relaxed/simple;
	bh=kWMhYU1F5YbNR0NPuqAXb9u37LH08xplWsdGXoS2do8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEy0NukjGdkpYU8BMSZrhC20CX5wONEJdn6OJ0KTCD+45EoRToDcSPImsRMeOnDeD8RGzTEtp/tQWGFLcdkdKy+eAgMu3qDL3C7e4gLWo9EmVJOksnJ10yj33rUWFD648WUPqBSCjZ3Mt0/ENP4DG1sfKLEkpiF+F42horHTRWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3LO5kPN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3LO5kPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EA61F000C4;
	Sat, 17 Oct 2026 16:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253960;
	bh=ryYNTgnLBGGMPLqRD3HY2LtQCWwF3m5Jpfix8oGVLoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3LO5kPNgSKR7pkMaudSPh+e0D+oYNPf3PDzPiqrA8rvr1Fk9O6me3unJdjpBLiVQ
	 1xvcs2m8eve9C8co4mTC1rxK+hbY+lp5tQHfqkA8Hd0DzBPrvklvLaIB4seYLI3ByR
	 safE+hal3aAcYtLOqVVR0UAIxMaUytsPoRe3a6/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/869] drm/amdgpu: Skip vcn poison irq release on VF
Date: Sat, 17 Oct 2026 17:51:31 +0200
Message-ID: <20261017160043.466988910@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 8980be03b3f9a4b58197ef95d3b37efa41a25331 ]

VF doesn't enable VCN poison irq in VCNv2.5. Skip releasing it and avoid
call trace during deinitialization.

[   71.913601] [drm] clean up the vf2pf work item
[   71.915088] ------------[ cut here ]------------
[   71.915092] WARNING: CPU: 3 PID: 1079 at /tmp/amd.aFkFvSQl/amd/amdgpu/amdgpu_irq.c:641 amdgpu_irq_put+0xc6/0xe0 [amdgpu]
[   71.915355] Modules linked in: amdgpu(OE-) amddrm_ttm_helper(OE) amdttm(OE) amddrm_buddy(OE) amdxcp(OE) amddrm_exec(OE) amd_sched(OE) amdkcl(OE) drm_suballoc_helper drm_display_helper cec rc_core i2c_algo_bit video wmi binfmt_misc nls_iso8859_1 intel_rapl_msr intel_rapl_common input_leds joydev serio_raw mac_hid qemu_fw_cfg sch_fq_codel dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua efi_pstore ip_tables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 hid_generic crct10dif_pclmul crc32_pclmul polyval_clmulni polyval_generic ghash_clmulni_intel usbhid 8139too sha256_ssse3 sha1_ssse3 hid psmouse bochs i2c_i801 ahci drm_vram_helper libahci i2c_smbus lpc_ich drm_ttm_helper 8139cp mii ttm aesni_intel crypto_simd cryptd
[   71.915484] CPU: 3 PID: 1079 Comm: rmmod Tainted: G           OE      6.8.0-87-generic #88~22.04.1-Ubuntu
[   71.915489] Hardware name: Red Hat KVM/RHEL, BIOS 1.16.3-2.el9_5.1 04/01/2014
[   71.915492] RIP: 0010:amdgpu_irq_put+0xc6/0xe0 [amdgpu]
[   71.915768] Code: 75 84 b8 ea ff ff ff eb d4 44 89 ea 48 89 de 4c 89 e7 e8 fd fc ff ff 5b 41 5c 41 5d 41 5e 5d 31 d2 31 f6 31 ff e9 55 30 3b c7 <0f> 0b eb d4 b8 fe ff ff ff eb a8 e9 b7 3b 8a 00 66 2e 0f 1f 84 00
[   71.915771] RSP: 0018:ffffcf0800eafa30 EFLAGS: 00010246
[   71.915775] RAX: 0000000000000000 RBX: ffff891bda4b0668 RCX: 0000000000000000
[   71.915777] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   71.915779] RBP: ffffcf0800eafa50 R08: 0000000000000000 R09: 0000000000000000
[   71.915781] R10: 0000000000000000 R11: 0000000000000000 R12: ffff891bda480000
[   71.915782] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
[   71.915792] FS:  000070cff87c4c40(0000) GS:ffff893abfb80000(0000) knlGS:0000000000000000
[   71.915795] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   71.915797] CR2: 00005fa13073e478 CR3: 000000010d634006 CR4: 0000000000770ef0
[   71.915800] PKRU: 55555554
[   71.915802] Call Trace:
[   71.915805]  <TASK>
[   71.915809]  vcn_v2_5_hw_fini+0x19e/0x1e0 [amdgpu]

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
index 42edc91f4a78d..20ef8835b12b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -402,7 +402,9 @@ static int vcn_v2_5_hw_fini(void *handle)
 		     RREG32_SOC15(VCN, i, mmUVD_STATUS)))
 			vcn_v2_5_set_powergating_state(adev, AMD_PG_STATE_GATE);
 
-		if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN))
+		/* VF doesn't enable interrupt operations for RAS */
+		if (!amdgpu_sriov_vf(adev) &&
+		    amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN))
 			amdgpu_irq_put(adev, &adev->vcn.inst[i].ras_poison_irq, 0);
 	}
 
-- 
2.53.0



