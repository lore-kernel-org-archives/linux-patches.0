Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32B81DE887;
	Sat, 14 Feb 2026 00:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030718; cv=none; b=mm5FmwC/w0hwqwEkokdnZe6MtUIxhz2W4ka034r7xjPO+S1HhFpqd3lIUXsDWVLzLDqZANkN96f/fNApf46Iv9GKU03O1DmKWK29LT+Z0sw2yHqLulwhPA6JNC3EAixupqL/zqaVtgtzRN+5sZEZv4qXu/HCAkM9fY+IWzj7yWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030718; c=relaxed/simple;
	bh=oJk5DkIzIOcPUBLFNrFEmh7/x9GuEfuX178fRIzZMwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s5rvxWYuIMzZmZjitFdqofupeWMfYVqL+a1ubUVk1ncPLko28rLiwy3/CM/o/FvzpKrQdTMHom9Hkos9zWPWl4dX6PGRmnnr0fTQEbO/VMHzs4sXMLsX+U7fY6YYLtIdvYfh4fVWr3Rpi9a/ySCBy+lT4ipx5ty3kccqdN3cVoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbgsOnKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbgsOnKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D757FC2BC9E;
	Sat, 14 Feb 2026 00:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030717;
	bh=oJk5DkIzIOcPUBLFNrFEmh7/x9GuEfuX178fRIzZMwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbgsOnKvNGoeM8gsCJjbgpA4VJ5Ol+CkxSQwNWDpAbt/dFdDCP+Hc/uoaZ40xwF5o
	 fCI8oRpgAIgNNgru8t2L8+E8a33SHfW10kwyoaXEG1BA9vkMH6MHSuQyMlR8+HARD8
	 cuo7e4H7k0BX1Dy9w1dwiaScg99M2sJX7eRu9NBYxhuD18xOvZIyK5ZGywQ2u6RuhP
	 PUTzdrtDFs7hktatKeOWqMylKPl9653rkRdahPt0ykv4n2bhPagIL1l7c0IbYkD9Xq
	 r+wfLQmeIrr+ZLNhzWOgLJzEp0gsWwRXpP21GvHF820ANvNoSBa1j0qSzthGJjXvV6
	 JKPvPciL9qnhg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	sudeep.holla@kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.12] firmware: arm_ffa: Unmap Rx/Tx buffers on init failure
Date: Fri, 13 Feb 2026 19:58:11 -0500
Message-ID: <20260214005825.3665084-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214005825.3665084-1-sashal@kernel.org>
References: <20260214005825.3665084-1-sashal@kernel.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 9fda364cb78c8b9e1abe4029f877300c94655742 ]

ffa_init() maps the Rx/Tx buffers via ffa_rxtx_map() but on the
partition setup failure path it never unmaps them.

Add the missing ffa_rxtx_unmap() call in the error path so that
the Rx/Tx buffers are properly released before freeing the backing
pages.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Message-Id: <20251210031656.56194-1-lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### 1. Commit Message Analysis

The commit message clearly describes a **resource leak on an error
path**: `ffa_init()` maps Rx/Tx buffers via `ffa_rxtx_map()`, but when
`ffa_setup_partitions()` fails, the error path frees the backing pages
without first unmapping the buffers from the firmware. The fix adds the
missing `ffa_rxtx_unmap()` call. The commit was accepted by the FF-A
subsystem maintainer Sudeep Holla.

### 2. Code Change Analysis

The fix is a **single line addition**:

```2071:2071:drivers/firmware/arm_ffa/driver.c
        ffa_rxtx_unmap(drv_info->vm_id);
```

inserted between `ffa_notifications_cleanup()` and the `free_pages:`
label.

**Understanding the bug mechanism:**

The `ffa_init()` function follows this flow:
1. Allocates Rx/Tx buffer pages (lines 2038-2048)
2. Maps them to firmware via `ffa_rxtx_map()` (line 2050) — this is an
   FF-A SMC/HVC call to the secure firmware (e.g., TrustZone / Hafnium
   hypervisor)
3. Sets up partitions via `ffa_setup_partitions()` (line 2065)
4. If partition setup fails, falls through to `free_pages:` which frees
   the backing pages

The problem: Step 4 **never calls `ffa_rxtx_unmap()`**, so the firmware
retains stale references to the freed physical pages. The `ffa_exit()`
function (line 2081-2089) correctly calls `ffa_rxtx_unmap()` before
freeing pages, confirming the error path was simply missing this
cleanup.

**Consequences of the bug:**
- The firmware (running in secure world or EL2 hypervisor) still holds
  mappings to physical addresses of freed kernel pages
- Those freed pages can be reallocated for other kernel purposes
- The firmware could write to these stale mappings, causing **memory
  corruption** of unrelated kernel data
- On systems with a stage-2 hypervisor, the mapping entries are also
  leaked

### 3. Bug Origin

The bug was introduced by commit
`0c565d16b80074e57e3e56240d13fc6cd6ed0334` ("firmware: arm_ffa: Handle
partitions setup failures"), which first made `ffa_setup_partitions()`
return an error and added an error path in `ffa_init()`. Before this
commit, `ffa_setup_partitions()` was void and never triggered error
cleanup. This commit landed in **v6.8**. The error path was later
restructured by `be61da9385766` (v6.15), but the missing unmap persisted
through both versions.

### 4. Classification

This is a **resource leak / firmware-side stale mapping fix** on an
error path. It is NOT a new feature, API change, or refactoring — it is
purely adding missing cleanup.

### 5. Scope and Risk Assessment

- **Lines changed**: 1 line added
- **Files changed**: 1 file (`drivers/firmware/arm_ffa/driver.c`)
- **Risk**: Extremely low. The `ffa_rxtx_unmap()` function is already
  used in `ffa_exit()` for normal cleanup. Adding it to the error path
  is the obvious correct fix. The function itself just issues an FF-A
  call to the firmware.
- **Regression potential**: Near zero. This only affects the failure
  path of `ffa_setup_partitions()`, and calling unmap before freeing is
  strictly correct.

### 6. User Impact

This affects ARM platforms using FF-A (Firmware Framework for Arm) —
notably ARM TrustZone/OP-TEE systems, Arm CCA systems, and virtualized
ARM environments with Hafnium. While `ffa_setup_partitions()` failure is
not the most common path, when it does occur, the consequences (firmware
holding stale page references, potential memory corruption) are severe.

### 7. Stable Kernel Criteria Check

| Criterion | Met? |
|---|---|
| Obviously correct and tested | Yes — mirrors `ffa_exit()` cleanup
exactly |
| Fixes a real bug | Yes — resource leak + potential memory corruption |
| Important issue | Yes — firmware-side stale mapping to freed kernel
pages |
| Small and contained | Yes — 1 line in 1 file |
| No new features | Yes — purely error-path cleanup |
| Applies cleanly | Yes — for v6.8+ trees (may need minor adjustment for
v6.8-v6.14 which used `cleanup_notifs:` label) |

### 8. Dependency Check

The fix depends on `0c565d16b80074e57e3e56240d13fc6cd6ed0334` (v6.8) for
the error path to exist, and on `be61da9385766` (v6.15) for the exact
code structure in the diff. For stable trees between v6.8 and v6.14, a
trivially adjusted backport would be needed (placing the unmap call
inside the `cleanup_notifs:` section instead of inline). The fix is
self-contained and has no other dependencies.

### Conclusion

This is a textbook error-path resource leak fix: a single line adding
missing firmware unmap before freeing the backing pages. The bug leaves
the firmware holding stale references to freed kernel memory, which
could lead to memory corruption. The fix is minimal, obviously correct
(mirrors `ffa_exit()`), and accepted by the subsystem maintainer. It
meets all stable kernel criteria.

**YES**

 drivers/firmware/arm_ffa/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index c72ee47565856..7209a630f6d16 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -2068,6 +2068,7 @@ static int __init ffa_init(void)
 
 	pr_err("failed to setup partitions\n");
 	ffa_notifications_cleanup();
+	ffa_rxtx_unmap(drv_info->vm_id);
 free_pages:
 	if (drv_info->tx_buffer)
 		free_pages_exact(drv_info->tx_buffer, rxtx_bufsz);
-- 
2.51.0

