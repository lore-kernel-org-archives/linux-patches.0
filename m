Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35643268C7F;
	Sun,  1 Jun 2025 23:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820887; cv=none; b=Y+UMPV6MlPUq6VGe2glQL2821n6dTDWnbwYXHhUfdXTUg5puSPPbFATBc6kFrPbLR0Zci9hdhZo5HOMGhsKKM9SHj01ZHLrCBcLmIGGrkFnB4NO/eUBLVQKFv1csGXfo3i0goX4ZIGmXqm/o+XTzOlR2w8NnAVLINQr3ptjyHbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820887; c=relaxed/simple;
	bh=Sou5GjXRjp6iLFdLLGgx72GtZt/lUHeF6Y8E7Tahgkc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HotKMxNIPHfAJZxG0W0j+pMqQIF8kxaEyZ+GI2RF3x5kJOXfFMKHJWjKXNaiXS7e+LX8FHxlpAlQHcSJbDxo1CfLBqCaWG1/bgAdrvYp/MxQMvkjUkTW1sTmjLBD1E7BPGxy+MCV5sZ6bJ6IybZBXIfdozHe3rWXhM9eVXyFW1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YpTUoNp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YpTUoNp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB22C4CEF6;
	Sun,  1 Jun 2025 23:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820886;
	bh=Sou5GjXRjp6iLFdLLGgx72GtZt/lUHeF6Y8E7Tahgkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpTUoNp6LIjywqNWI21F6+VR6TiJKcNcW+rZrKRLg+Yda+wMMVkiETP8s7E6txnOi
	 JpbtM4eOO86pKI2mEIuEodgIMHEWb0KdmufiI3frBpslNckU3kiqXtNEkXmAQVLTwP
	 wbMJGtqlFnyJkx0Ke8qAZTk9G9p3YQ8SA4UhI91lWBCZuyovtnV7iaXITTh8Vw3qBl
	 7P0PEku9Uq4q5+PZRjG2xOfravLzdGWvbX9gONTHlnq1ll6wUDtmYcSm+ryiG3mL/h
	 wo5Txh+kIbKDy8vtQ1QFF6+wQHcJcIhZY6BmkuNCYEIbQTkiPu4mDRFaHRxxC9gKvk
	 OrP+DZKOXSjDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 16/93] drm/panthor: Don't update MMU_INT_MASK in panthor_mmu_irq_handler()
Date: Sun,  1 Jun 2025 19:32:43 -0400
Message-Id: <20250601233402.3512823-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233402.3512823-1-sashal@kernel.org>
References: <20250601233402.3512823-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 6c4a3fa26799785c1873aacabcfd9b2d27e8dc97 ]

Interrupts are automatically unmasked in
panthor_mmu_irq_threaded_handler() when the handler returns. Unmasking
prematurely might generate spurious interrupts if the IRQ line is
shared.

Changes in v2:
- New patch

Changes in v3:
- Add R-bs

Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250404080933.2912674-6-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees for the
following reasons: ## Analysis of the Bug Fix **Code Change Analysis:**
The commit removes a single line from `panthor_mmu_irq_handler()`: ```c
- gpu_write(ptdev, MMU_INT_MASK, new_int_mask); ``` This line was
prematurely unmasking MMU interrupts within the interrupt handler
itself. **Technical Issue:** 1. **Interrupt Handling Architecture**: The
panthor driver uses a two-stage interrupt handling approach via the
`PANTHOR_IRQ_HANDLER` macro: - **Hardware IRQ handler**: Masks
interrupts (`gpu_write(ptdev, MMU_INT_MASK, 0)`) and wakes the threaded
handler - **Threaded handler**: Processes interrupts and automatically
re-enables them at the end (`gpu_write(ptdev, MMU_INT_MASK,
pirq->mask)`) 2. **The Bug**: The `panthor_mmu_irq_handler()` function
was prematurely unmasking interrupts in the middle of processing, which
could cause: - **Spurious interrupts** if the IRQ line is shared with
other devices - **Race conditions** where new interrupts arrive before
the handler completes - **Interrupt storms** in edge cases ## Backport
Criteria Assessment **✅ Fixes a bug that affects users:** - Could cause
spurious interrupts on shared IRQ lines - Potential for interrupt storms
affecting system stability **✅ Small and contained fix:** - Single line
removal - No architectural changes - Minimal risk of regression **✅
Clear side effects analysis:** - The fix aligns with the designed
interrupt handling pattern - No negative side effects expected since
automatic re-enabling happens at the proper time **✅ Critical
subsystem:** - GPU MMU interrupt handling is critical for memory
management - Affects system stability when GPU is in use **✅ Driver
maturity:** - Panthor driver was introduced in v6.10 (relatively recent)
- This is a bug in the core interrupt handling logic ## Comparison with
Historical Commits This fix follows the same pattern as **Similar Commit
#1** (drm/panthor: Fix ordering in _irq_suspend()) which was also marked
as backport-worthy. Both commits fix interrupt handling ordering issues
in the panthor driver. Unlike the panfrost commits (Similar Commits
#2-5), which involved more complex architectural changes to interrupt
handling, this panthor fix is a simple correction to align with the
existing interrupt handling framework. ## Recommendation This commit
should be backported because it fixes a clear bug in interrupt handling
that could lead to system instability, the fix is minimal and safe, and
it corrects the implementation to match the intended design pattern used
throughout the panthor driver.

 drivers/gpu/drm/panthor/panthor_mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 0e6f94df690dd..a0348da20f114 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1710,7 +1710,6 @@ static void panthor_mmu_irq_handler(struct panthor_device *ptdev, u32 status)
 		 * re-enabled.
 		 */
 		ptdev->mmu->irq.mask = new_int_mask;
-		gpu_write(ptdev, MMU_INT_MASK, new_int_mask);
 
 		if (ptdev->mmu->as.slots[as].vm)
 			ptdev->mmu->as.slots[as].vm->unhandled_fault = true;
-- 
2.39.5

