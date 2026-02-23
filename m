Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C264730DEB7;
	Mon, 23 Feb 2026 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771863431; cv=none; b=aHjJrI257lR8VsWG6cxVhw+E97ukh1UggJ0Drty6xmZhasc1MalK64JvE1gearck5Edg1PKdG5eOsmj9kO2J09th5N19AxWwbqX02+UuO2YGz29WuL5muatrGYmMld/hRRH+j43R+W+YEjcAOQE3WLsz5kQgnp7VNnaAkc5NJSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771863431; c=relaxed/simple;
	bh=11j/YgPS1K5gNtNQRU2un7idsUfbyDDUSpshVpfWE4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SuSjUXv+7AW3O4xwPmkIfadnNAVB9lqg8yGqOhyZAAdVcUHHKKflHYhME0J8OqiASuSC6RPUwUFm5jeSug9OqD1mM/3+oBQupztd74Dy0XeZIp/4jXVlvGZ/A4OW8EkiapG3k4Cij/FoCfh9lRVr79ejVcg0DYSw4vklFoYuFAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3quHLrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3quHLrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579D2C19421;
	Mon, 23 Feb 2026 16:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771863431;
	bh=11j/YgPS1K5gNtNQRU2un7idsUfbyDDUSpshVpfWE4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3quHLrcnj8ESjsm6UaK8qTTGK/VSPHK1mGR2oygAQqknGX7bKyBZ2ZtPi3nTd6LK
	 5NL3FGfC1prj/hi1YgUrdHvsAW+zXuV3ydHWkEaH22go8AESPH265tHEbHv78l8BQ3
	 QhjqiyY9jIF1ZOgf84MiaiFUMPJs4DrKTGznW+58y4f/2FdNZwwpphY+CB/6FRoTzs
	 +MRFEOAnbVuvn7pOfJ218v6Vy95OM3VqeIf4Nt7ik6gUyI/O915htRosQuVFHHNoKg
	 l5pnOx6pWMOqY2+O5eQEyNMYAMaDp9O2TzrjWhBbHCh3/sIsGsvAADxMoNXS88gRzJ
	 BlneJ/Vlbn47Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maciej Grochowski <Maciej.Grochowski@sony.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>,
	kurt.schwemmer@microsemi.com,
	logang@deltatee.com,
	dave.jiang@intel.com,
	allenbh@gmail.com,
	linux-pci@vger.kernel.org,
	ntb@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] ntb: ntb_hw_switchtec: Fix array-index-out-of-bounds access
Date: Mon, 23 Feb 2026 11:17:06 -0500
Message-ID: <20260223161707.2714732-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223161707.2714732-1-sashal@kernel.org>
References: <20260223161707.2714732-1-sashal@kernel.org>
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

From: Maciej Grochowski <Maciej.Grochowski@sony.com>

[ Upstream commit c8ba7ad2cc1c7b90570aa347b8ebbe279f1eface ]

Number of MW LUTs depends on NTB configuration and can be set to MAX_MWS,
This patch protects against invalid index out of bounds access to mw_sizes
When invalid access print message to user that configuration is not valid.

Signed-off-by: Maciej Grochowski <Maciej.Grochowski@sony.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear picture. Let me verify the key claim about the bug.

The critical finding from the exploration:
- `mw_sizes` is declared as `u64 mw_sizes[MAX_MWS]` where `MAX_MWS =
  128`
- `nr_direct_mw` can be at most 6 (MAX_DIRECT_MW)
- `nr_lut_mw` is read from hardware via `ioread16()` and can be up to
  512 (rounded down to power of 2, so max 256 or 512)
- The buggy loop computes `idx = nr_direct_mw + i` where `i` ranges from
  `0` to `nr_lut_mw - 1`
- If `nr_lut_mw` is large enough (e.g., 256), then `idx` can exceed
  `MAX_MWS (128)`, causing an out-of-bounds write to `mw_sizes[idx]`

This is a real out-of-bounds array access bug. The `nr_lut_mw` value
comes from hardware registers (`ioread16`), and there's no validation
that `nr_direct_mw + nr_lut_mw` stays within `MAX_MWS`. If the hardware
reports a large number of LUT entries, the loop will write past the end
of the `mw_sizes[128]` array, corrupting adjacent memory in the
`shared_mw` structure (the `spad[128]` array) or beyond.

## Analysis

### What the commit fixes
An array-index-out-of-bounds write in `switchtec_ntb_init_shared()`. The
`nr_lut_mw` value is read from hardware registers and can exceed
`MAX_MWS - nr_direct_mw`. When this happens,
`sndev->self_shared->mw_sizes[idx]` writes past the 128-element array
boundary, corrupting the subsequent `spad[128]` field or memory beyond
the structure.

### Bug severity
- **Out-of-bounds write**: This is a memory corruption bug. Writing past
  `mw_sizes` corrupts the `spad` array in the shared memory window
  structure, which could cause unpredictable behavior.
- The shared memory buffer is DMA-allocated (`dma_alloc_coherent`), so
  corrupting it could affect hardware/firmware interaction.
- Triggered by hardware configuration — if a Switchtec NTB device
  reports many LUT table entries, this will fire during driver
  initialization.

### Meets stable criteria
1. **Obviously correct**: The fix adds a simple bounds check `if (idx >=
   MAX_MWS)` before the array access, prints an error, and breaks out of
   the loop. This is straightforward and safe.
2. **Fixes a real bug**: Out-of-bounds array write — memory corruption.
3. **Small and contained**: Only adds 5 lines of bounds-checking code in
   a single function.
4. **No new features**: Pure defensive fix.
5. **Low risk**: The break simply stops filling in MW sizes for indices
   beyond the array — existing valid entries are unaffected.

### Risk assessment
- **Very low risk**. The change is a simple bounds check that prevents
  memory corruption. It cannot break any working configuration — it only
  affects cases where the index would have been out of bounds.
- The affected code has existed since the driver was introduced, so this
  fix applies to all stable trees that include this driver.

### Verification

- Confirmed `MAX_MWS = 128` at line 32, `mw_sizes[MAX_MWS]` at line 38
  of `ntb_hw_switchtec.c`
- Confirmed `nr_lut_mw` is read from hardware via `ioread16()` at line
  1204 and rounded to power of 2 at line 1205 — can be up to 256 or 512
- Confirmed `nr_direct_mw` max is 6 (bounded by `MAX_DIRECT_MW =
  ARRAY_SIZE(bar_entry)` where `bar_entry[6]`)
- Confirmed the `shared_mw` struct layout: `mw_sizes[128]` followed by
  `spad[128]` — OOB write corrupts `spad`
- `git log` shows the file has had other bug fixes backported (shift-
  out-of-bounds, UAF), confirming the driver is in stable trees
- The first loop over `nr_direct_mw` is safe (max index 5), but the
  second loop over `nr_lut_mw` is unbounded before this fix
- Could NOT verify via lore.kernel.org the specific mailing list
  discussion (not fetched), but the commit message and code are clear

**YES**

 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index f851397b65d6e..f15ebab138144 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -1314,6 +1314,12 @@ static void switchtec_ntb_init_shared(struct switchtec_ntb *sndev)
 	for (i = 0; i < sndev->nr_lut_mw; i++) {
 		int idx = sndev->nr_direct_mw + i;
 
+		if (idx >= MAX_MWS) {
+			dev_err(&sndev->stdev->dev,
+				"Total number of MW cannot be bigger than %d", MAX_MWS);
+			break;
+		}
+
 		sndev->self_shared->mw_sizes[idx] = LUT_SIZE;
 	}
 }
-- 
2.51.0

