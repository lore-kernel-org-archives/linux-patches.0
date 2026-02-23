Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614931F2380;
	Mon, 23 Feb 2026 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771863430; cv=none; b=fAhNSBw9KCObuA7Z2wp1eyKkm8zYfgdNWN2G325PVkxpH9uQzWX22GUN0g+vcHV08i70zNA8O3XNJ5qEW3d2/skk4qTx/SaPJtlLLr9CIKdvMb5rn+L5BQl4fe57bya92q47RUhWPLrQ0pfHFMy0U8McG5ZT09+Xhnj40NHlXdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771863430; c=relaxed/simple;
	bh=qc/Pj+e+abFOM8hFmthyMpplEjTK0RVSw/BU/rotFUo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ID0ad0ForkVD5Z7sqTWaZS7THN6zX6kq0S/frIZh7qLq0moA2iKciqiGRGHxnLpkwbMneZBRVRPU3ILWksCbsnDAPhNRD+e48+XAg97yDsnlzsMjjigl2JbQrcIISUNla+NJumEst/fiYEBpmecoGZt8+qt+0tnUVkLbZibwv8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNuuzbEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNuuzbEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E6FC116C6;
	Mon, 23 Feb 2026 16:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771863430;
	bh=qc/Pj+e+abFOM8hFmthyMpplEjTK0RVSw/BU/rotFUo=;
	h=From:To:Cc:Subject:Date:From;
	b=MNuuzbEPRtdoalWzXso9OOsyrMnjIhz79YvWPajXYBZjZdFz5SGpZ60EjKgWhGtNP
	 zhAnB/VGXpA2/2MDe6yGgh87jnikzQHmGciCbKPEAzsoHv+/iX2vyA9TzMfVoY5Z2f
	 glGbnI0niUeINeYA7QRLzZDmnGLjmgB8dzTmOUMjpnGGRCPPhOm+3eVzg+8b7XFw+b
	 6h7IlQ1hAWPeq7SrGr1Qy2Kmi44YUEcxsPszgWWmqALiGD5/T4m+1jsy34P5v+Q0Qm
	 C+/4+D0QyeYJe7hYE07pmKYB0EDMwSfvm48PciA9C3VTczt4xwZJicHB4P9YMaps1B
	 npjsBNMRpb5RQ==
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
Subject: [PATCH AUTOSEL 6.19-5.10] ntb: ntb_hw_switchtec: Fix shift-out-of-bounds for 0 mw lut
Date: Mon, 23 Feb 2026 11:17:05 -0500
Message-ID: <20260223161707.2714732-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
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

[ Upstream commit 186615f8855a0be4ee7d3fcd09a8ecc10e783b08 ]

Number of MW LUTs depends on NTB configuration and can be set to zero,
in such scenario rounddown_pow_of_two will cause undefined behaviour and
should not be performed.
This patch ensures that rounddown_pow_of_two is called on valid value.

Signed-off-by: Maciej Grochowski <Maciej.Grochowski@sony.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The file has been present since 2017 (v4.14 era), so it's in all stable
trees.

Now let me verify the exact nature of the bug:

## Analysis

### Problem
The commit fixes undefined behavior (UB) in `switchtec_ntb_init_mw()`.
When `nr_lut_mw` or `peer_nr_lut_mw` is read as 0 from hardware (via
`ioread16`), calling `rounddown_pow_of_two(0)` results in:

- `1UL << (fls_long(0) - 1)` = `1UL << (0 - 1)` = `1UL << -1` (unsigned
  underflow to a huge shift value)

This is explicitly documented as undefined in the kernel: the comment in
`include/linux/log2.h` says "the result is undefined when n == 0". This
is a **shift-out-of-bounds** bug that:
- Triggers UBSAN warnings
- Produces an incorrect (garbage) value for `nr_lut_mw`, which could
  cause further issues downstream

### Fix
The fix adds a simple `if (sndev->nr_lut_mw)` guard before calling
`rounddown_pow_of_two()` in two places — for both `self` and `peer` LUT
MW counts. If the value is 0, it stays 0 (which is correct — no LUT
memory windows).

### Stable Criteria Assessment
1. **Obviously correct and tested**: Yes — trivially correct. If the
   count is 0, rounding down 0 should remain 0.
2. **Fixes a real bug**: Yes — undefined behavior from shift-out-of-
   bounds. This can cause UBSAN splats and potentially incorrect values.
3. **Important issue**: Medium — UB can have unpredictable consequences
   depending on compiler optimizations. The value 0 is a valid hardware
   configuration.
4. **Small and contained**: Yes — 4 lines changed (2 `if` guards added),
   single file, single function.
5. **No new features**: Correct — purely a bug fix.
6. **Applies cleanly**: The code has been stable since 2017; should
   apply to all active stable trees.

### Risk Assessment
- **Risk**: Extremely low. The guard only adds a check for zero before
  calling a function that explicitly documents UB for zero input.
- **Benefit**: Eliminates undefined behavior and potential UBSAN splats
  on hardware configurations with 0 LUT memory windows.

### Verification
- Verified `rounddown_pow_of_two` is documented as "result is undefined
  when n == 0" in `include/linux/log2.h`
- Verified the implementation: `1UL << (fls_long(n) - 1)` with n=0
  produces `1UL << (0-1)` = shift-out-of-bounds
- Verified the file has existed since 2017 (commit 33dea5aae032),
  present in all active stable trees
- Verified the fix is minimal: 2 `if` guards added, no other behavioral
  changes
- Verified there's a related prior shift fix in the same file
  (ff148d8ac53e5), showing this class of bugs has been addressed before

**YES**

 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index f15ebab138144..0536521fa6ccc 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -1202,7 +1202,8 @@ static void switchtec_ntb_init_mw(struct switchtec_ntb *sndev)
 				       sndev->mmio_self_ctrl);
 
 	sndev->nr_lut_mw = ioread16(&sndev->mmio_self_ctrl->lut_table_entries);
-	sndev->nr_lut_mw = rounddown_pow_of_two(sndev->nr_lut_mw);
+	if (sndev->nr_lut_mw)
+		sndev->nr_lut_mw = rounddown_pow_of_two(sndev->nr_lut_mw);
 
 	dev_dbg(&sndev->stdev->dev, "MWs: %d direct, %d lut\n",
 		sndev->nr_direct_mw, sndev->nr_lut_mw);
@@ -1212,7 +1213,8 @@ static void switchtec_ntb_init_mw(struct switchtec_ntb *sndev)
 
 	sndev->peer_nr_lut_mw =
 		ioread16(&sndev->mmio_peer_ctrl->lut_table_entries);
-	sndev->peer_nr_lut_mw = rounddown_pow_of_two(sndev->peer_nr_lut_mw);
+	if (sndev->peer_nr_lut_mw)
+		sndev->peer_nr_lut_mw = rounddown_pow_of_two(sndev->peer_nr_lut_mw);
 
 	dev_dbg(&sndev->stdev->dev, "Peer MWs: %d direct, %d lut\n",
 		sndev->peer_nr_direct_mw, sndev->peer_nr_lut_mw);
-- 
2.51.0

