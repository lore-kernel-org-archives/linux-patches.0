Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42D5366060;
	Mon, 23 Feb 2026 12:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850275; cv=none; b=GyQofpcXb760XAmEq1JCHUCQvqG1o6lObuuZNp+B9C5zH2ckmeBr0nnVa/gJPE8nUmjyVBglwZ3A9r9xAs7oEvkE8x+D3P5gXKGAs39TVoYv6DZ5KoghzV9xmFS5ehxEVjc3H/cANtlm94Fl/TGNlw9ePGCwdsmzgM/uqnBOV3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850275; c=relaxed/simple;
	bh=AY7DAd8/iJzlRwcE2gF3ydEu5wc5gzFPG4/2vw0iHOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iNhiyx5QCbJobDDVigliCG6k8a8Z2Srvv9nteQPhOSY/0VfpPGMrymb5eoTAXUhf7MrPrBr67puXsHnbSgZRkiHDDqiQv80XNktTjSEhSzSGLefgCFL/lKu4+jERhzI8dLZj8P1aXsccWVg36gOTbV08Yi4cgPqaru3w/f1+TB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ucDhgYLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ucDhgYLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352CFC116C6;
	Mon, 23 Feb 2026 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850273;
	bh=AY7DAd8/iJzlRwcE2gF3ydEu5wc5gzFPG4/2vw0iHOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucDhgYLmjVyMiVwMe7CM3uJxwIeqTguLG3xsDwwYsOFEb+gBhDJgzq4vL+zlEUeXC
	 pGy7eoH0PBwz1CAP5ChTgS4gNwXSUcE/JII9ZG13ACRTzdTPv0gLOCs70eXYvF4jV4
	 ZubHwERK9BktKU0fdUHjwrtMHH5KLpFwAo+P0nkqauYo/d2oRU9t0rc1GZh1Dx1ujL
	 AazTAEazpUiuDfs0Vriy73OUku3I1S368NSvRJwisEsz0g6OK/1yUHLtEIxkIN0UCF
	 a6aEGX7jy65fSysiaxvnx+N+TpZxPG+pNYy3BYLvvihDDc1ZyCyf9VUnfUv8ZgHg1D
	 kgeFnm6PwZ/Wg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] drm/amdgpu: Skip vcn poison irq release on VF
Date: Mon, 23 Feb 2026 07:37:14 -0500
Message-ID: <20260223123738.1532940-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding. Let me summarize the analysis.

## Analysis

### 1. Commit Message Analysis

The commit fixes a **WARNING/call trace during deinitialization** on AMD
GPU Virtual Functions (VF, i.e., SR-IOV guests). The commit message
includes the full stack trace showing the `WARN_ON` trigger at
`amdgpu_irq_put+0xc6/0xe0` called from `vcn_v2_5_hw_fini+0x19e/0x1e0`,
occurring during `rmmod` of the amdgpu driver.

### 2. Code Change Analysis

**The bug**: In `vcn_v2_5_hw_fini()`, the code unconditionally calls
`amdgpu_irq_put()` for `ras_poison_irq` whenever RAS is supported.
However, for SR-IOV VF (Virtual Function) environments,
`amdgpu_irq_get()` was **never called** on this IRQ source during
initialization. The IRQ enable path is in `amdgpu_vcn_ras_late_init()`
which runs through the RAS block late init — but for VFs, the RAS
interrupt operations are not fully initialized/enabled (as the comment
in the fix says: "VF doesn't enable interrupt operations for RAS").

When `amdgpu_irq_put()` is called on an IRQ that was never enabled
(refcount is 0), line 639 of `amdgpu_irq.c` triggers:
`WARN_ON(!amdgpu_irq_enabled(adev, src, type))`, causing the stack trace
shown in the commit message.

**The fix**: Adds `!amdgpu_sriov_vf(adev)` check before calling
`amdgpu_irq_put()`, so the IRQ release is skipped on VF — matching the
fact that it was never enabled on VF. This is a minimal 2-line change
(adding the VF check to the existing conditional).

### 3. Classification

This is a **bug fix** — it fixes a mismatched IRQ get/put that causes a
WARNING and call trace during driver deinitialization (rmmod) on SR-IOV
VF environments. The fix is:
- Obviously correct (symmetry between init/fini paths)
- Small and surgical (2-line change to an existing conditional)
- Fixes a real user-visible issue (WARNING + call trace during rmmod)
- No new features, no API changes

### 4. Scope and Risk

- **Very small change**: Only adds a VF check to an existing `if`
  condition
- **Low risk**: The change only affects SR-IOV VF environments, and it
  simply skips an operation that should never have run in that context
- **Single file**: Only `vcn_v2_5.c` is modified
- **Well-understood pattern**: Other VCN versions (e.g., vcn_v4_0.c)
  have similar structures, and the author (Lijo Lazar) is an AMD kernel
  developer familiar with the subsystem

### 5. User Impact

This affects AMD GPU users running in SR-IOV virtualized environments
(VMs using AMD GPU virtual functions). When they unload the amdgpu
driver (rmmod), they see a WARNING call trace in the kernel log. While
not a crash, this is a real operational annoyance and the WARN_ON could
trigger panic-on-warn systems.

### 6. Stability

- Reviewed by Mangesh Gadre (AMD engineer)
- Signed off by Alex Deucher (AMD GPU maintainer)
- The fix is logically straightforward — matching the fini path to what
  the init path actually does

### 7. Dependencies

None. The fix is self-contained and uses existing APIs
(`amdgpu_sriov_vf()`) that have been in the kernel for a long time. The
`vcn_v2_5.c` file and the relevant code paths exist in all supported
stable trees that include VCN 2.5 support.

## Verification

- Read `vcn_v2_5.c:506-529` (pre-fix code on current tree) confirming
  the `amdgpu_irq_put` call at line 524-525 lacks the VF check
- Read `amdgpu_irq.c:623-646` confirming the `WARN_ON` at line 639
  matches the stack trace
- Read `amdgpu_vcn.c:1286-1310` confirming `amdgpu_vcn_ras_late_init`
  calls `amdgpu_irq_get` for poison IRQ — but this may not run for VF
  environments
- Verified commit `8980be03b3f9a` exists in tree and matches the
  analyzed patch
- Searched for similar patterns (`sriov_vf` + `ras_poison_irq`) — no
  other instance found, confirming this is the only VCN version patched
  (VCN 2.5 specific)
- The `vcn_v4_0.c` hw_fini was noted by the explore agent as having the
  same pattern (no VF check before irq_put) — this is potentially a
  separate issue for other VCN versions
- Could NOT verify which stable trees contain VCN 2.5 support
  specifically — unverified, but VCN 2.5 has been in the kernel since
  ~5.4-5.5 era

## Conclusion

This is a small, surgical bug fix that resolves a WARNING/call trace
during driver deinitialization on SR-IOV VF environments. It fixes an
asymmetry between the init and fini paths (IRQ never enabled on VF, but
unconditionally released). The fix is obviously correct, low risk, well-
reviewed, and impacts real users of AMD GPU virtualization. It meets all
stable kernel criteria.

**YES**

 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
index cebee453871c1..006a154511971 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -521,7 +521,9 @@ static int vcn_v2_5_hw_fini(struct amdgpu_ip_block *ip_block)
 		     RREG32_SOC15(VCN, i, mmUVD_STATUS)))
 			vinst->set_pg_state(vinst, AMD_PG_STATE_GATE);
 
-		if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN))
+		/* VF doesn't enable interrupt operations for RAS */
+		if (!amdgpu_sriov_vf(adev) &&
+		    amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN))
 			amdgpu_irq_put(adev, &vinst->ras_poison_irq, 0);
 	}
 
-- 
2.51.0

