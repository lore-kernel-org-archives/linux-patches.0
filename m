Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19079221DB3;
	Tue, 24 Jun 2025 04:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738294; cv=none; b=NDRplFCaIv0A/E43fzYoiFHdyiB5jJaH2tDdcUSfjZuqYTkqBCPYFQh2ykTYQ5XTnaqlrn6OE1pPY8eFST5aAE8iLlWhVdniAzkb0azOxX1baJN+H1JtSjmkShNpRn0i/5SRFmcxQEYwcolIBwY1R58+IAU2PIzRKyfgumneaFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738294; c=relaxed/simple;
	bh=EnoerV/xxx91jhOZdHJKKtLWyi7IcO86p6wzJFGUMZc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aBNNIUcXffFdlXkQ7l6TJX2q3wZP3yhBMe/mLefbmSjtdXOAStPzSU3Fe4oshO1KUIws25C/97VHhZ8BatGoj2jKzPS34eDDtLsuLtQK9JC2IAtP7dxu0tphaIBXM5tBUuAF/9EGFB5VUfJRebbchg4IrjHBWlVANpfXbL0F24g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=um3I8FlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="um3I8FlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F921C4CEEF;
	Tue, 24 Jun 2025 04:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738293;
	bh=EnoerV/xxx91jhOZdHJKKtLWyi7IcO86p6wzJFGUMZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=um3I8FlZWLvpQ1qgMe0+2y9cM4f6x+6T+pn8fkv2GBQmfZKLtiQaIgYavui5rqLQW
	 YqLqTZCwzEunS+YqZrMk1lWfFPARJNs0U8I3K4Dz9l7CT3vA2nr5BAXyWPy1w8/4bU
	 YaXuy6Nwb3BGJ40RNQk5zsrSGEbvbCgXjcz5CrCWkORfPkG6E3DmY7lvmgiYcxRYWe
	 TfvIiR4HILL9hBUGI2Ppy1LSXxErXV9d3H0TgcpAskAa+8+P+wRpZ3ebBUWnRev9DI
	 lz+K7ty6WqfPmdFMPDU5FpO84ppu9fcGKqXIw/H3uw9EiG2i/BXzuAxXrP0v04BhRM
	 oxRSLWKCQox/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gyeyoung Baek <gye976@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	linus.walleij@linaro.org,
	bartosz.golaszewski@linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 10/20] genirq/irq_sim: Initialize work context pointers properly
Date: Tue, 24 Jun 2025 00:11:09 -0400
Message-Id: <20250624041120.83191-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041120.83191-1-sashal@kernel.org>
References: <20250624041120.83191-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.3
Content-Transfer-Encoding: 8bit

From: Gyeyoung Baek <gye976@gmail.com>

[ Upstream commit 8a2277a3c9e4cc5398f80821afe7ecbe9bdf2819 ]

Initialize `ops` member's pointers properly by using kzalloc() instead of
kmalloc() when allocating the simulation work context. Otherwise the
pointers contain random content leading to invalid dereferencing.

Signed-off-by: Gyeyoung Baek <gye976@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250612124827.63259-1-gye976@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees, specifically to
the v6.11 stable series and any newer stable branches.

## Detailed Explanation:

### 1. **Critical Bug Fix**
The commit fixes a serious uninitialized memory bug. The code change
from `kmalloc()` to `kzalloc()` is critical because:

```c
// Before (buggy):
struct irq_sim_work_ctx *work_ctx __free(kfree) =
    kmalloc(sizeof(*work_ctx), GFP_KERNEL);

// After (fixed):
struct irq_sim_work_ctx *work_ctx __free(kfree) =
    kzalloc(sizeof(*work_ctx), GFP_KERNEL);
```

### 2. **The Bug Impact**
The `irq_sim_work_ctx` structure contains an `ops` member with function
pointers:
- `ops.irq_sim_irq_requested`
- `ops.irq_sim_irq_released`

When `irq_domain_create_sim_full()` is called with `ops=NULL` (which
happens when using the older `irq_domain_create_sim()` API), these
pointers are left uninitialized with random memory content.

### 3. **Potential Consequences**
The uninitialized pointers are checked in:
- `irq_sim_request_resources()`: `if
  (work_ctx->ops.irq_sim_irq_requested)`
- `irq_sim_release_resources()`: `if
  (work_ctx->ops.irq_sim_irq_released)`

If these random values are non-zero, the kernel will attempt to call
garbage function pointers, leading to:
- **Kernel crashes/panics**
- **Security vulnerabilities** (jumping to arbitrary memory)
- **Unpredictable behavior**

### 4. **Simple and Safe Fix**
The fix is minimal (changing one function call) with no side effects:
- `kzalloc()` guarantees all fields are zero-initialized
- This ensures function pointers are NULL when not explicitly set
- No performance impact (negligible difference for a one-time
  allocation)

### 5. **Affected Versions**
Based on my repository analysis:
- The bug was introduced in v6.11-rc1 (commit 011f583781fa)
- Only kernels v6.11 and newer are affected
- The fix should be backported to v6.11.y stable series

### 6. **Missing Fixes Tag**
The commit should have included:
```
Fixes: 011f583781fa ("genirq/irq_sim: add an extended irq_sim
initializer")
```

This is a textbook example of a commit that meets stable backport
criteria:
- Fixes a real bug that can cause crashes
- Small, contained change
- No new features or architectural changes
- Clear bugfix with minimal regression risk

 kernel/irq/irq_sim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/irq_sim.c b/kernel/irq/irq_sim.c
index 1a3d483548e2f..ae4c9cbd1b4b9 100644
--- a/kernel/irq/irq_sim.c
+++ b/kernel/irq/irq_sim.c
@@ -202,7 +202,7 @@ struct irq_domain *irq_domain_create_sim_full(struct fwnode_handle *fwnode,
 					      void *data)
 {
 	struct irq_sim_work_ctx *work_ctx __free(kfree) =
-				kmalloc(sizeof(*work_ctx), GFP_KERNEL);
+				kzalloc(sizeof(*work_ctx), GFP_KERNEL);
 
 	if (!work_ctx)
 		return ERR_PTR(-ENOMEM);
-- 
2.39.5

