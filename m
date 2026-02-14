Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539BE19004A;
	Sat, 14 Feb 2026 01:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031110; cv=none; b=HyBOIAfeOV4zKRHdY9UBcBCSN9G95gb/O0sLbaQaMgDkkXg4LmScyhXCkfEirqJG1PayY1hTli8vC4ygBvtx4usOKhrvuI/LFLRVzyGNeS40hKIFH8GU0if3EgeOX4Zm5TGNThk81L7ejZOZcZCSITCPT6MGHQPimZW+JxXL/7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031110; c=relaxed/simple;
	bh=rnei31f5lBJG247EuZj7gt6OPWxW4I6Rik1OoZS3d3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KnVrllb3Xc2j6lxtuQwyc4giqq8V3RGYn1TAUnDLgqyvOn9gdwtSCftszIf/zf9AR010EKhcmdPtaJwk8Bb9D5P8Vrrc6M854doCkivgqI+jsFPp5XIthvlsCwHaVB+tZnLnLbItaE8aFtzDiHnYtRrfBVipORVegsPaP3Q/+mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DkFx0Rh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkFx0Rh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3EAC116C6;
	Sat, 14 Feb 2026 01:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031110;
	bh=rnei31f5lBJG247EuZj7gt6OPWxW4I6Rik1OoZS3d3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkFx0Rh5yDPDLJZ1K+TMmrYeR7tuVjtjfkECI7+1JJCBaN1TBnDk/pUnknf4j5I/i
	 JqUXX7D6D1mU4F+yVLkoOqH7uILbhSv2RvcOMJqRF2wpsjIr7ouY2a9Epd0kHG7/L9
	 5ByGHtH8BU2Yvr1VJ7+7St04TzQoZRi44uk7I97NVb7qMCvIxsSblyXVvCGDcWsMcH
	 yhjPWMWAH0CwjsmtdjosEI5i0MIH+u1YTRt7T/LV5YPr3Bfu3FruTvl8LsbOgcEME6
	 m71963kGGkMGn3iNXIGDfYef3YFTH4DJJ68hGvJ+GM00p4uSRHHqj6OM74E0DJLYkN
	 yMFawgdMt23hA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	tao.zhou1@amd.com,
	YiPeng.Chai@amd.com,
	ganglxie@amd.com,
	xiang.liu@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	cesun102@amd.com
Subject: [PATCH AUTOSEL 6.19-6.18] drm/amdgpu/ras: Move ras data alloc before bad page check
Date: Fri, 13 Feb 2026 19:59:05 -0500
Message-ID: <20260214010245.3671907-65-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit bd68a1404b6fa2e7e9957b38ba22616faba43e75 ]

In the rare event if eeprom has only invalid address entries,
allocation is skipped, this causes following NULL pointer issue
[  547.103445] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  547.118897] #PF: supervisor read access in kernel mode
[  547.130292] #PF: error_code(0x0000) - not-present page
[  547.141689] PGD 124757067 P4D 0
[  547.148842] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  547.158504] CPU: 49 PID: 8167 Comm: cat Tainted: G           OE      6.8.0-38-generic #38-Ubuntu
[  547.177998] Hardware name: Supermicro AS -8126GS-TNMR/H14DSG-OD, BIOS 1.7 09/12/2025
[  547.195178] RIP: 0010:amdgpu_ras_sysfs_badpages_read+0x2f2/0x5d0 [amdgpu]
[  547.210375] Code: e8 63 78 82 c0 45 31 d2 45 3b 75 08 48 8b 45 a0 73 44 44 89 f1 48 8b 7d 88 48 89 ca 48 c1 e2 05 48 29 ca 49 8b 4d 00 48 01 d1 <48> 83 79 10 00 74 17 49 63 f2 48 8b 49 08 41 83 c2 01 48 8d 34 76
[  547.252045] RSP: 0018:ffa0000067287ac0 EFLAGS: 00010246
[  547.263636] RAX: ff11000167c28130 RBX: ff11000127600000 RCX: 0000000000000000
[  547.279467] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ff11000125b1c800
[  547.295298] RBP: ffa0000067287b50 R08: 0000000000000000 R09: 0000000000000000
[  547.311129] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  547.326959] R13: ff11000217b1de00 R14: 0000000000000000 R15: 0000000000000092
[  547.342790] FS:  0000746e59d14740(0000) GS:ff11017dfda80000(0000) knlGS:0000000000000000
[  547.360744] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  547.373489] CR2: 0000000000000010 CR3: 000000019585e001 CR4: 0000000000f71ef0
[  547.389321] PKRU: 55555554
[  547.395316] Call Trace:
[  547.400737]  <TASK>
[  547.405386]  ? show_regs+0x6d/0x80
[  547.412929]  ? __die+0x24/0x80
[  547.419697]  ? page_fault_oops+0x99/0x1b0
[  547.428588]  ? do_user_addr_fault+0x2ee/0x6b0
[  547.438249]  ? exc_page_fault+0x83/0x1b0
[  547.446949]  ? asm_exc_page_fault+0x27/0x30
[  547.456225]  ? amdgpu_ras_sysfs_badpages_read+0x2f2/0x5d0 [amdgpu]
[  547.470040]  ? mas_wr_modify+0xcd/0x140
[  547.478548]  sysfs_kf_bin_read+0x63/0xb0
[  547.487248]  kernfs_file_read_iter+0xa1/0x190
[  547.496909]  kernfs_fop_read_iter+0x25/0x40
[  547.506182]  vfs_read+0x255/0x390

This also result in space left assigned to negative values.
Moving data alloc call before bad page check resolves both the issue.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the exact crash path. Now I have the complete picture.

## Comprehensive Analysis

### 1. Commit Message Analysis

The commit message is very clear and includes:
- A precise description of the bug: NULL pointer dereference when EEPROM
  has only invalid address entries
- A full kernel oops stack trace showing the crash at
  `amdgpu_ras_sysfs_badpages_read+0x2f2/0x5d0`
- The crash occurs on real hardware (Supermicro AS-8126GS-TNMR server
  with AMD GPU)
- Triggered by userspace reading sysfs (`cat` command, PID 8167)
- Two reviewers from AMD (Hawking Zhang, Lijo Lazar)
- Suggested-by from Lijo Lazar, showing the fix approach was agreed upon
  by the domain expert

### 2. Code Change Analysis - The Bug Mechanism

**Root cause tracing:** The bug was introduced by commit `d45c5e6845a76`
("drm/amdgpu: adjust the update of RAS bad page number"), which landed
in v6.18-rc1. That commit changed `__amdgpu_ras_restore_bad_pages` to
increment `data->count` and decrement `data->space_left` even when
`amdgpu_ras_check_bad_page_unlock()` returns non-zero (invalid or
already-known pages), via the `continue` branch.

**The problem step-by-step:**

1. `eh_data` is allocated with `kzalloc` in `amdgpu_ras_recovery_init`
   (line 3857). This means:
   - `data->bps = NULL` (zero-initialized)
   - `data->count = 0`
   - `data->space_left = 0`

2. When EEPROM records are loaded via `amdgpu_ras_load_bad_pages` →
   `amdgpu_ras_add_bad_pages` → eventually
   `__amdgpu_ras_restore_bad_pages`, the loop processes each record.

3. In the **old (buggy) code order**,
   `amdgpu_ras_check_bad_page_unlock()` is called FIRST. If the address
   is invalid (out of range, returning `-EINVAL`), the code increments
   `data->count++`, decrements `data->space_left--`, and takes
   `continue` — **never reaching** the
   `amdgpu_ras_realloc_eh_data_space()` call.

4. If ALL EEPROM entries are invalid addresses, `data->bps` remains NULL
   while `data->count` becomes non-zero and `data->space_left` goes
   negative.

5. When userspace reads
   `/sys/class/drm/card*/device/ras/gpu_vram_bad_pages`, the call chain
   `amdgpu_ras_sysfs_badpages_read` → `amdgpu_ras_badpages_read`
   iterates `data->bps[i]` from `start` to `data->count`:

```2776:2778:drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
                for (i = start; i < data->count; i++) {
                        if (!data->bps[i].ts)
```

Since `data->bps` is NULL and `data->count > 0`, this dereferences NULL
→ **kernel oops**.

**The fix:** Moving the space reallocation check (4 lines) BEFORE the
bad page check ensures `data->bps` is allocated before any entry
processing:

```3079:3083:drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
                if (!data->space_left &&
                    amdgpu_ras_realloc_eh_data_space(adev, data, 256)) {
                        return -ENOMEM;
                }
```

Now, on the first iteration, `space_left == 0` triggers
`amdgpu_ras_realloc_eh_data_space()`, which allocates `data->bps`.
Subsequent iterations can safely decrement `space_left` (since it was
just set to a positive value by the realloc). This is correct because
the invalid entries still need space in `data->bps` — they were being
counted but not allocated for.

### 3. Classification

- **Bug type:** NULL pointer dereference (kernel oops)
- **Trigger:** Reading sysfs file from userspace, trivially reproducible
- **Severity:** HIGH — kernel crash from a simple `cat` command
- **Category:** Definitely a bug fix, not a feature

### 4. Scope and Risk Assessment

- **Size:** Extremely small — moves 4 lines of code within one function,
  zero net lines changed
- **Files touched:** 1 file (`amdgpu_ras.c`)
- **Risk:** Very low — the reallocation function is the same, it's just
  called earlier in the loop iteration. The semantics are preserved:
  space is still ensured before use. In fact, it's more correct now
  because even invalid entries need space.
- **Could break something:** No. The realloc is idempotent (if
  `space_left > 0`, the condition `!data->space_left` is false and it's
  skipped). Moving it earlier only means it runs when it previously
  wouldn't have (the all-invalid-entries case), which is precisely the
  fix.

### 5. User Impact

- **Who is affected:** Users with AMD GPUs that have ECC/RAS support
  (enterprise GPUs like MI200, MI300 series, and Instinct accelerators),
  specifically when the EEPROM contains only invalid address entries
- **Severity if triggered:** Complete kernel oops, requiring reboot
- **Ease of trigger:** Trivial — any userspace tool reading the RAS
  sysfs file (monitoring tools, `cat`, etc.)
- **Real-world evidence:** Stack trace from a real Supermicro server
  running Ubuntu 6.8.0-38-generic

### 6. Stability Indicators

- Reviewed-by: Hawking Zhang (AMD) and Lijo Lazar (AMD) — both are
  regular RAS subsystem reviewers
- Suggested-by: Lijo Lazar — the approach was recommended by a domain
  expert
- Signed-off-by: Alex Deucher — the AMD GPU driver maintainer
- The fix is obviously correct by inspection

### 7. Dependency Check

The bug was introduced by `d45c5e6845a76` which first appeared in
v6.18-rc1 (and is in v6.18 final). The fix applies cleanly to the code
as modified by that commit. For stable trees based on v6.18.y, this fix
should apply cleanly. For earlier stable trees (6.17.y and before), the
bug doesn't exist so the fix isn't needed.

No other dependencies are needed — the fix is self-contained within
`__amdgpu_ras_restore_bad_pages`.

### Summary

This is a textbook stable backport candidate:
- Fixes a real NULL pointer dereference kernel oops
- Triggered by trivial userspace action (reading a sysfs file)
- Extremely small and surgical fix (reorders 4 lines within one
  function)
- Obviously correct by code inspection
- Well-reviewed by AMD domain experts
- No risk of regression
- Self-contained, no dependencies on other patches
- Affects real hardware users (AMD enterprise/data center GPUs)

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index d79b41ce21240..3d51a3c8852ad 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -3076,6 +3076,11 @@ static int __amdgpu_ras_restore_bad_pages(struct amdgpu_device *adev,
 	struct ras_err_handler_data *data = con->eh_data;
 
 	for (j = 0; j < count; j++) {
+		if (!data->space_left &&
+		    amdgpu_ras_realloc_eh_data_space(adev, data, 256)) {
+			return -ENOMEM;
+		}
+
 		if (amdgpu_ras_check_bad_page_unlock(con,
 			bps[j].retired_page << AMDGPU_GPU_PAGE_SHIFT)) {
 			data->count++;
@@ -3083,11 +3088,6 @@ static int __amdgpu_ras_restore_bad_pages(struct amdgpu_device *adev,
 			continue;
 		}
 
-		if (!data->space_left &&
-		    amdgpu_ras_realloc_eh_data_space(adev, data, 256)) {
-			return -ENOMEM;
-		}
-
 		amdgpu_ras_reserve_page(adev, bps[j].retired_page);
 
 		memcpy(&data->bps[data->count], &(bps[j]),
-- 
2.51.0

