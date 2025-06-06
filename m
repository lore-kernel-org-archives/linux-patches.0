Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801BCEEB5;
	Fri,  6 Jun 2025 15:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224539; cv=none; b=rZIwL5yw7AKB/F0T35Sv/cUbh3gn0cN/u6lFTfRg0qjJ4qc2JwPXsPg+EWoMzNRJa8PYF/xUztNm1UQNnTM4l1i6E+wRdW7At0+afAXLL48W3fEPfXPor4ndV9r4LiZn27F1lWRntIY5RIBqR+dlHDkadOg08n09heLZmmisWXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224539; c=relaxed/simple;
	bh=ZmA5PdSmEf70vUGOOaU9wOsDxwxgasYySGGzHobtmPA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7Gogf7VSaI9ar8ock8C0mrdB7Udj/ZRQQFrMLsQpq3Pm15/NVzzpaAut+p63molaoeBn1MIFDY+6WYRH5p/AzD7eb5ka/oy4rtbquO4u96CzXu7J1JxQ+fE8vFbE+3tzd0oyLLYE0BNhAGqqfJFaGNoFyyvgldHnAASeKyUW2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L30KGyCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L30KGyCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8450C4CEED;
	Fri,  6 Jun 2025 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224539;
	bh=ZmA5PdSmEf70vUGOOaU9wOsDxwxgasYySGGzHobtmPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L30KGyCJqrQ7J7QnVfzzLk9/mAX49n763VIifiQLuWVJEAjpqDVdLBxjqNvS4LE1n
	 DEXPghiGJy0edWHSug/FORX9Val+7k4pBK6jXUI6lTKSN+iEGtAIqC7WbE350uBFbQ
	 TWvqUqgPRKvlJzYHjHImf/alrkkyxEemuMw5y2883gX4DfN6k+UjX+ZRs6HGpe+dq2
	 Z+3uvkjfw+wx35lazPrdrK7dCpTWUQ8Z0M45Mlak0BloazP1rEzp8xIEiXxPUmpZW0
	 esbWAXbXb2fkILiOVvRhf/62+zXeroVrYxQCpkJF9p+IGOtSiRzRdH5GPPsvR6IWIf
	 o1ZS+kCYG2q2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gregory Price <gourry@gourry.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alison.schofield@intel.com,
	ira.weiny@intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	yaoxt.fnst@fujitsu.com
Subject: [PATCH AUTOSEL 6.15 19/21] cxl: core/region - ignore interleave granularity when ways=1
Date: Fri,  6 Jun 2025 11:41:44 -0400
Message-Id: <20250606154147.546388-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154147.546388-1-sashal@kernel.org>
References: <20250606154147.546388-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gregory Price <gourry@gourry.net>

[ Upstream commit ce32b0c9c522e5a69ef9c62a56d6ca08fb036d67 ]

When validating decoder IW/IG when setting up regions, the granularity
is irrelevant when iw=1 - all accesses will always route to the only
target anyway - so all ig values are "correct". Loosen the requirement
that `ig = (parent_iw * parent_ig)` when iw=1.

On some Zen5 platforms, the platform BIOS specifies a 256-byte
interleave granularity window for host bridges when there is only
one target downstream.  This leads to Linux rejecting the configuration
of a region with a x2 root with two x1 hostbridges.

Decoder Programming:
   root - iw:2 ig:256
   hb1  - iw:1 ig:256  (Linux expects 512)
   hb2  - iw:1 ig:256  (Linux expects 512)
   ep1  - iw:2 ig:256
   ep2  - iw:2 ig:256

This change allows all decoders downstream of a passthrough decoder to
also be configured as passthrough (iw:1 ig:X), but still disallows
downstream decoders from applying subsequent interleaves.

e.g. in the above example if there was another decoder south of hb1
attempting to interleave 2 endpoints - Linux would enforce hb1.ig=512
because the southern decoder would have iw:2 and require ig=pig*piw.

[DJ: Fixed up against 6.15-rc1]

Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20250402232552.999634-1-gourry@gourry.net
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my comprehensive analysis of the commit and the surrounding
codebase, here is my assessment:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Nature of the Fix

This is a **bug fix** that addresses a platform compatibility issue
where valid CXL configurations are incorrectly rejected by Linux. The
fix is for a specific scenario affecting **Zen5 BIOS implementations**
that specify 256-byte interleave granularity for host bridges with
single targets.

## Technical Analysis of the Change

The commit modifies line 1449 in `drivers/cxl/core/region.c`, changing:
```c
cxld->interleave_granularity != ig ||
```
to:
```c
(iw > 1 && cxld->interleave_granularity != ig) ||
```

This change **relaxes the granularity validation** specifically when `iw
== 1` (single interleave way/passthrough decoder). The logic is sound
because:

1. **When iw=1**: All memory accesses route to the single target
   regardless of granularity, making granularity irrelevant for
   addressing
2. **When iw>1**: The granularity validation remains strict to ensure
   correct interleave routing

## Why This Qualifies for Stable Backporting

### 1. **Fixes User-Affecting Bug**
- Affects real hardware platforms (Zen5-based systems)
- Prevents legitimate CXL region configurations from working
- Users experience functional failures, not just degraded performance

### 2. **Minimal and Contained Change**
- Single line modification with clear conditional logic
- No architectural changes or new features
- Focused on a specific validation path in region setup

### 3. **Low Regression Risk**
- Only relaxes validation when it's mathematically unnecessary (iw=1)
- Maintains strict validation for interleaved configurations (iw>1)
- The change aligns with the fundamental CXL addressing principles

### 4. **Clear Stable Tree Criteria Match**
- **Important bugfix**: ✅ Enables CXL functionality on affected
  platforms
- **Minimal risk**: ✅ Highly targeted change with clear conditions
- **Contained to subsystem**: ✅ Only affects CXL region validation logic

## Evidence from Similar Commits

Looking at the historical examples:
- **Similar Commit #2** was marked "YES" and had `Cc:
  <stable@vger.kernel.org>` for a related granularity calculation fix
- The current commit follows the same pattern: targeted fix for
  granularity validation issues
- No architectural changes or new feature introductions

## Platform Impact Assessment

The commit specifically mentions **Zen5 platforms** where BIOS specifies
problematic configurations that should be valid but are currently
rejected. This affects:
- Real shipping hardware
- Valid CXL memory configurations
- System functionality rather than optimization

## Code Quality and Safety

The fix:
- Preserves existing validation for interleaved cases (iw > 1)
- Only bypasses granularity checks when they're logically unnecessary
  (iw = 1)
- Includes comprehensive review signatures from CXL subsystem
  maintainers
- Has been tested according to the commit message

The change is mathematically correct: when there's only one target
(iw=1), granularity is irrelevant because all addresses map to the same
target regardless of the granularity value.

Therefore, this commit represents a **low-risk, high-value bugfix** that
enables proper CXL functionality on affected hardware platforms and
should be backported to stable trees to ensure users don't encounter
functional regressions on valid hardware configurations.

 drivers/cxl/core/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 24b161c7749f9..7585f0302f3a2 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1446,7 +1446,7 @@ static int cxl_port_setup_targets(struct cxl_port *port,
 
 	if (test_bit(CXL_REGION_F_AUTO, &cxlr->flags)) {
 		if (cxld->interleave_ways != iw ||
-		    cxld->interleave_granularity != ig ||
+		    (iw > 1 && cxld->interleave_granularity != ig) ||
 		    !region_res_match_cxl_range(p, &cxld->hpa_range) ||
 		    ((cxld->flags & CXL_DECODER_F_ENABLE) == 0)) {
 			dev_err(&cxlr->dev,
-- 
2.39.5

