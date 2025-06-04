Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421E412B73;
	Wed,  4 Jun 2025 00:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998534; cv=none; b=q8D88RLcIL4XD4YOxm87O3AI5N6g4pjD/GlswKEF5WE4Dy5gvnsapqDjhCmyEtumDiBv2Va5OuDkCdQvV7fuuN43Ay7fDjHRKRioI5HbxsZzj/gFd2QmoyUUqTRHVrWtCxF2f9jpI3D9ofO4i8CmUX0js9Xyu9Ph2eLEwVU3yrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998534; c=relaxed/simple;
	bh=SgYSlcG66ivVK1/7rxBWj5jaMZTu8BfNZozofp5MyPY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=lxBE7quTnbhQSuKX6UKI3ctaMUfVFsuLl09Os3j0nxa4KpuuPWe3IHLN/8DnvUgvbhecn+jl2XBTCSsRIcxvks4gMQ8RhPjYlYOBqZPnT4rEzsFrpDRjkCmkzJ2ismAHQivU+nMLV/PXp3u6rLrXabIII2R6oEKmQc0Dr23U6uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QxK+iSAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QxK+iSAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461B3C4CEED;
	Wed,  4 Jun 2025 00:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998534;
	bh=SgYSlcG66ivVK1/7rxBWj5jaMZTu8BfNZozofp5MyPY=;
	h=From:To:Cc:Subject:Date:From;
	b=QxK+iSARRAwYIVtIhudPQ51fS1xXwzNwHVRKhLyWJYFuIy8OALRmY4Lse7SePONV0
	 fVUVFLMwR+Rg915v6MqzyTRhu99OHA+tT7xmVUn6j7yJ02du6JWsTflDu3ERZEvG9o
	 O9E9QpQNhXGFPIruyNQajt6F4N+i6p7mxEI5QLHZ1nLmFVKAFKp/x8EFebEmB5p3PP
	 NG54BeZ0GDMAdD0/7Ekd04wH5QhT6MJNiF4unAVWVizrJZq2CiK4mIqtfnoaBirx6m
	 uJgeH50gjxLrwMPUSwaqGyiTGG545aTakrjBGjr8aTHyXeIVG0JleHYR+Y/aHiwXPW
	 C/Ge7WxUZiiaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sergio Perez Gonzalez <sperezglz@gmail.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nicolas.ferre@microchip.com
Subject: [PATCH AUTOSEL 6.14 001/108] net: macb: Check return value of dma_set_mask_and_coherent()
Date: Tue,  3 Jun 2025 20:53:44 -0400
Message-Id: <20250604005531.4178547-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergio Perez Gonzalez <sperezglz@gmail.com>

[ Upstream commit 3920a758800762917177a6b5ab39707d8e376fe6 ]

Issue flagged by coverity. Add a safety check for the return value
of dma_set_mask_and_coherent, go to a safe exit if it returns error.

Link: https://scan7.scan.coverity.com/#/project-view/53936/11354?selectedIssue=1643754
Signed-off-by: Sergio Perez Gonzalez <sperezglz@gmail.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Link: https://patch.msgid.link/20250526032034.84900-1-sperezglz@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and the codebase context, here's my
assessment: **YES** This commit should be backported to stable kernel
trees. Here's my extensive analysis: ## Code Analysis The commit adds
proper error checking for `dma_set_mask_and_coherent()` in the macb
network driver. Looking at the specific changes: **Before the fix:**
```c if (GEM_BFEXT(DAW64, gem_readl(bp, DCFG6))) {
dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44)); bp->hw_dma_cap
|= HW_DMA_CAP_64B; } ``` **After the fix:** ```c if (GEM_BFEXT(DAW64,
gem_readl(bp, DCFG6))) { err = dma_set_mask_and_coherent(&pdev->dev,
DMA_BIT_MASK(44)); if (err) { dev_err(&pdev->dev, "failed to set DMA
mask\n"); goto err_out_free_netdev; } bp->hw_dma_cap |= HW_DMA_CAP_64B;
} ``` ## Why this should be backported: 1. **Fixes a Real Bug**: The
original code ignores the return value of `dma_set_mask_and_coherent()`.
If this function fails (which can happen on systems with restricted DMA
capabilities), the driver would continue execution assuming 44-bit DMA
addressing is available when it's not, leading to potential memory
corruption or system crashes. 2. **Small, Contained Fix**: This is a
minimal change that only adds proper error checking without changing any
core logic or introducing new features. It follows the stable tree
principle of being a small, targeted bugfix. 3. **Follows Established
Patterns**: Looking at the similar commits provided, this matches
exactly the pattern of commits marked "YES" for backporting (commits #1,
#2, and #5) which all add proper error checking for DMA mask functions.
4. **Critical Network Driver**: The macb driver is used in production
systems, and DMA-related bugs can cause data corruption or system
instability, making this a high-priority fix for stable trees. 5.
**Proper Error Handling Path**: The fix correctly uses the existing
`err_out_free_netdev` label, which properly cleans up allocated
resources (line 5373-5383 in macb_main.c), preventing resource leaks
when DMA setup fails. 6. **Static Analysis Tool Flagged**: The commit
message mentions this was flagged by Coverity, indicating it's a
legitimate code quality issue that could manifest as a runtime bug. 7.
**Matches Stable Tree Criteria**: - Important bugfix ✓ - Minimal risk of
regression ✓ - No architectural changes ✓ - Confined to one
driver/subsystem ✓ - Clear side effects (proper cleanup on failure) ✓
This commit addresses the same class of vulnerability as the other "YES"
examples: ignoring return values of critical DMA functions that can fail
and lead to undefined behavior. The fix is surgical, safe, and addresses
a genuine runtime issue in a widely-used network driver.

 drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e3cc26472c2f1..ec7f85cb0cbfa 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5104,7 +5104,11 @@ static int macb_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	if (GEM_BFEXT(DAW64, gem_readl(bp, DCFG6))) {
-		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
+		if (err) {
+			dev_err(&pdev->dev, "failed to set DMA mask\n");
+			goto err_out_free_netdev;
+		}
 		bp->hw_dma_cap |= HW_DMA_CAP_64B;
 	}
 #endif
-- 
2.39.5

