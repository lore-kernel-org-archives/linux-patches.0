Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D13C2FD679;
	Mon, 15 Dec 2025 00:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759317; cv=none; b=NSUpgDJaO+EvYqmOVXgZxlFuzbtAqikbBaR+twnnjfJprW/eYlq49Z+RvmYvwY7C39ipgqCJ2XrRkNrwqBF4qtHebgc4tDvRIfD8sht/2VkZoxcAve4LHS2SEmucIuARgNDEbfnBBpNK8j+h25TguI6aa7cVJTNYCD33tTRlmtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759317; c=relaxed/simple;
	bh=St94AYLnxj05b+K9sUNH/KOIgDw2f1eAqiAnR2OUrdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eb1/M+Kc85sa/sWAC+df565drDnC7eycKHy1zZ5LHbozBXe/YI+f5P6bKEot9a13i3199JVSNTF+osnlTIOg4zDXYDspJRd9QUaD1qULVy6OkPy1197BrGWBC9YNQ4tO0P8Szx65aPmKQkBxcly5BRbPMWd+YGi0U/VCrg9fn+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ve0Yd5uq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ve0Yd5uq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764E8C4CEF1;
	Mon, 15 Dec 2025 00:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765759317;
	bh=St94AYLnxj05b+K9sUNH/KOIgDw2f1eAqiAnR2OUrdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ve0Yd5uq+bbANnSUqkwZohka6PXuKwwdfdCX15bzBdfZJY9zcvNLIcdzpCz8Qzugi
	 bMH2jQxiNuVucGHem0+3IpKoHxZNqAkNr7P9Jgfpi5KUuB5E0F1d+GyQQuLsYCRqPe
	 +AzH326nOHKqN27EnsJPwlS/gdUI5vTiih0o7+CAUjIy3ln3rFDK5C7nhH5P4LOLkQ
	 OV5GbT0DJK9Ym6Kosd/9G4sseOTYKY8n95VFMbQtZzUiNub8XP+7KyFOy2OXChwnYQ
	 bl8rNrkgOk7Md2RbHVZ2/nd0j+0oPKkQrgZO1iIDOIyx5dTkYzzg7QKuRjFfJ0VNkr
	 8UnFes/tmI4fQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	heiko@sntech.de,
	nathan@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.12] ASoC: rockchip: Fix Wvoid-pointer-to-enum-cast warning (again)
Date: Sun, 14 Dec 2025 19:41:21 -0500
Message-ID: <20251215004145.2760442-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215004145.2760442-1-sashal@kernel.org>
References: <20251215004145.2760442-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 57d508b5f718730f74b11e0dc9609ac7976802d1 ]

'version' is an enum, thus cast of pointer on 64-bit compile test with
clang W=1 causes:

  rockchip_pdm.c:583:17: error: cast to smaller integer type 'enum rk_pdm_version' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

This was already fixed in commit 49a4a8d12612 ("ASoC: rockchip: Fix
Wvoid-pointer-to-enum-cast warning") but then got bad in
commit 9958d85968ed ("ASoC: Use device_get_match_data()").

Discussion on LKML also pointed out that 'uintptr_t' is not the correct
type and either 'kernel_ulong_t' or 'unsigned long' should be used,
with several arguments towards the latter [1].

Link: https://lore.kernel.org/r/CAMuHMdX7t=mabqFE5O-Cii3REMuyaePHmqX+j_mqyrn6XXzsoA@mail.gmail.com/ [1]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20251203141644.106459-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary Analysis

### What the commit fixes
This is a **build fix** that prevents a compilation error when building
with clang and W=1:
```
error: cast to smaller integer type 'enum rk_pdm_version' from 'const
void *' [-Werror,-Wvoid-pointer-to-enum-cast]
```

The issue is that on 64-bit systems, casting directly from `const void
*` (64 bits) to an enum (typically 32 bits) triggers a truncation
warning. Using `(unsigned long)` as an intermediate cast avoids this
because `unsigned long` matches the pointer size.

### Classification
This falls clearly into the **BUILD FIX** exception category which is
explicitly allowed for stable trees. Build fixes that prevent
compilation are critical for users who need to build the kernel.

### Scope and Risk
- **Change**: Single line - only changing the cast type
- **Files touched**: 1 file
- **Risk**: Extremely low - the runtime behavior is identical; only the
  compile-time representation differs
- **Functional equivalence**: The value stored in `pdm->version` is the
  same either way

### Applicability to Stable Trees
The regressing commit 9958d85968ed went into v6.7-rc1. Therefore:
- Stable trees **v6.6.y and earlier**: NOT affected (don't have the
  regression)
- Stable trees **v6.7.y and later**: Affected and would benefit from
  this fix

### Stable Criteria Assessment
| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✓ Yes - standard pattern for void pointer to enum
cast |
| Fixes real bug | ✓ Yes - compilation failure |
| Small scope | ✓ Yes - 1 line change |
| No new features | ✓ Correct - pure bug fix |
| Tested | ✓ Accepted by maintainer |

### Additional Factors
- This is a **regression fix** - the same issue was previously fixed in
  commit 49a4a8d12612 but regressed
- LKML discussion confirms `unsigned long` as the appropriate fix
- Signed off by both author and subsystem maintainer (Mark Brown)

### Risk vs Benefit
- **Risk**: Near zero - compile-time only change, no runtime behavior
  modification
- **Benefit**: Enables compilation with clang W=1 on 64-bit platforms

This is an excellent stable backport candidate. It's a minimal, low-risk
build fix that allows users to compile the kernel in a common
configuration. Build fixes are explicitly mentioned as appropriate for
stable trees, and this one is as safe as they come - a single-line cast
change with no runtime impact.

**YES**

 sound/soc/rockchip/rockchip_pdm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index c1ee470ec6079..c69cdd6f24994 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -580,7 +580,7 @@ static int rockchip_pdm_probe(struct platform_device *pdev)
 	if (!pdm)
 		return -ENOMEM;
 
-	pdm->version = (enum rk_pdm_version)device_get_match_data(&pdev->dev);
+	pdm->version = (unsigned long)device_get_match_data(&pdev->dev);
 	if (pdm->version == RK_PDM_RK3308) {
 		pdm->reset = devm_reset_control_get(&pdev->dev, "pdm-m");
 		if (IS_ERR(pdm->reset))
-- 
2.51.0

