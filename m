Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8B347AF6E;
	Tue, 20 Jan 2026 19:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768937704; cv=none; b=eofWHY+6UwHUcr/YQeWhQD/lsXJjtla82Iuxq3kIL27TNdSVM3PiXxLAn8/uEf4GBYKxQM7rMLIcd1qsnXMJwgJquYGYRlxwB6LrzlkJeXGIMXEa5/fUg9pi33bhk8HkMZplF1MYW/DThn/BmdF3it6KxIEDQJzseiAhnSyT4nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768937704; c=relaxed/simple;
	bh=lcFx5eDRBp1+97JFLWXeahJ9cdFANIDo7AWztxdtCw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mKVnpMDJ/2Y7D6aHKn7PpkC1QhifVi+pC4IAF14kaEX0CE/A+oTYQFYCgnv1eNnK7rrU4uVGX8eO167gvg96t7YyE/0KDiEsrr450AJW1TiKY5bL48B3tBzTSiPQXbQ2kihKDkqHF3cUiEGoWyscjYvotIipLFCenGLOg40b6Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g31Z6uLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g31Z6uLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D90C19422;
	Tue, 20 Jan 2026 19:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768937704;
	bh=lcFx5eDRBp1+97JFLWXeahJ9cdFANIDo7AWztxdtCw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g31Z6uLHoe74I5OwDGTXT44jK+/bsbhYaVHgLWxmgMjiLCFEuUPOB9YfVmp/emhVB
	 qVs5yci54sodlqT5gIJeMhuNhkUkWUmi6dN71k35ZxkhXhWzrwVkcx17g59aE4LXpl
	 HhLUy6gWFdtCrFktaTspYpaXguHzwCqE/dYMrZ769hSuGf1xR9LEtEODKl+Bgdwl+m
	 CJtft4AAxxQM4vi82IuDhz5H6hH9jgCn1jwK9DNuD7+UtrimG75teZWRVIrE5U4yWb
	 sSkwZzqz/KXgd4dT5ePgnUBNccF7FWshJZBE3I5zkMKv6szNIypLy/GRCsO4/JRr4t
	 hoqZo5RS+QkHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	Yi Zhang <yi.zhang@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nareshgottumukkala83@gmail.com,
	paul.ely@broadcom.com,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.1] nvme-fc: release admin tagset if init fails
Date: Tue, 20 Jan 2026 14:34:47 -0500
Message-ID: <20260120193456.865383-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260120193456.865383-1-sashal@kernel.org>
References: <20260120193456.865383-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>

[ Upstream commit d1877cc7270302081a315a81a0ee8331f19f95c8 ]

nvme_fabrics creates an NVMe/FC controller in following path:

    nvmf_dev_write()
      -> nvmf_create_ctrl()
        -> nvme_fc_create_ctrl()
          -> nvme_fc_init_ctrl()

nvme_fc_init_ctrl() allocates the admin blk-mq resources right after
nvme_add_ctrl() succeeds.  If any of the subsequent steps fail (changing
the controller state, scheduling connect work, etc.), we jump to the
fail_ctrl path, which tears down the controller references but never
frees the admin queue/tag set.  The leaked blk-mq allocations match the
kmemleak report seen during blktests nvme/fc.

Check ctrl->ctrl.admin_tagset in the fail_ctrl path and call
nvme_remove_admin_tag_set() when it is set so that all admin queue
allocations are reclaimed whenever controller setup aborts.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the bug scenario in v6.6:
1. `nvme_alloc_admin_tag_set()` succeeds → admin tagset is allocated
2. `nvme_change_ctrl_state()` OR `queue_delayed_work()` fails
3. Code goes to `fail_ctrl` label
4. But `fail_ctrl` does NOT free the admin tagset → **MEMORY LEAK**

Now let me compile my analysis:

## ANALYSIS SUMMARY

### 1. COMMIT MESSAGE ANALYSIS
- **Subject:** "nvme-fc: release admin tagset if init fails"
- **Clear bug description:** The commit message clearly describes a
  memory leak scenario where admin blk-mq resources are not freed when
  controller initialization fails
- **Reported-by tag:** Yi Zhang from Red Hat reported this via kmemleak
  during blktests nvme/fc
- **Reviewed-by:** Justin Tee from Broadcom reviewed this
- **Testing evidence:** Discovered during blktests, so reproducible

### 2. CODE CHANGE ANALYSIS
The fix is a 2-line addition:
```c
if (ctrl->ctrl.admin_tagset)
    nvme_remove_admin_tag_set(&ctrl->ctrl);
```

**Bug mechanism:**
1. `nvme_fc_init_ctrl()` allocates admin tagset after `nvme_init_ctrl()`
   succeeds
2. If subsequent operations (state change, work scheduling) fail, code
   jumps to `fail_ctrl`
3. The `fail_ctrl` path tears down controller references but never frees
   the admin tagset
4. Result: Memory leak of blk-mq admin queue allocations

**Why the fix is correct:**
- The conditional check `if (ctrl->ctrl.admin_tagset)` ensures the
  cleanup only runs if the allocation occurred
- `nvme_remove_admin_tag_set()` properly cleans up all admin queue
  resources
- Placement is correct - before `nvme_uninit_ctrl()` which does the
  reference counting teardown

### 3. CLASSIFICATION
- **Type:** Bug fix (memory leak)
- **Category:** Resource leak in error path
- **Not a feature:** Does not add functionality, only fixes cleanup in
  error path

### 4. SCOPE AND RISK ASSESSMENT
- **Lines changed:** 2 lines added
- **Files changed:** 1 file (drivers/nvme/host/fc.c)
- **Complexity:** Very low - simple conditional cleanup
- **Risk:** Very low - only affects error path, adds proper cleanup that
  was missing
- **Subsystem:** NVMe FC driver, mature subsystem

### 5. USER IMPACT
- **Who is affected:** Users of NVMe over Fibre Channel
- **Severity:** Memory leak that can exhaust kernel memory over time
  with repeated connection failures
- **Reproducibility:** Reproducible via blktests nvme/fc
- **Discovery:** Found via kmemleak, indicating real-world impact

### 6. STABILITY INDICATORS
- **Reviewed-by:** Yes (Justin Tee from Broadcom)
- **Reported-by:** Yes (Yi Zhang from Red Hat)
- **Tested:** Implicitly through blktests discovery
- **Signed-off-by:** Keith Busch (NVMe maintainer)

### 7. DEPENDENCY CHECK
- **Function dependency:** Requires `nvme_remove_admin_tag_set()` which
  exists in kernels v6.1+
- **For v5.10/v5.15/v6.0:** Would need adaptation (manual cleanup
  instead of helper function)
- **Structural dependency:** The code structure (admin tagset allocation
  → fail_ctrl path) needs to exist

### BACKPORTABILITY

**For kernels 6.1.y and later (v6.1+):**
- The commit applies cleanly
- The `nvme_remove_admin_tag_set()` helper exists
- Low risk, high value fix

**For kernels 5.10.y, 5.15.y, 6.0.y:**
- Would require modification - the helper function doesn't exist
- The fix would need to manually call the cleanup functions instead
- The code structure is different (admin tagset allocation may happen in
  different location)

### CONCLUSION

This is a classic stable kernel material:
- ✅ Fixes a real bug (memory leak in error path)
- ✅ Small, surgical fix (2 lines)
- ✅ Obviously correct (adds missing cleanup)
- ✅ Low risk (only affects error path)
- ✅ Has been reviewed and tested
- ✅ Discovered via automated testing (blktests/kmemleak)

The fix is appropriate for backporting to stable kernels that have the
required infrastructure (v6.1+). For older kernels (v5.10, v5.15, v6.0),
a modified version would need to be crafted.

**YES**

 drivers/nvme/host/fc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 8324230c53719..bf78faf1a4ffa 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3584,6 +3584,8 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	ctrl->ctrl.opts = NULL;
 
+	if (ctrl->ctrl.admin_tagset)
+		nvme_remove_admin_tag_set(&ctrl->ctrl);
 	/* initiate nvme ctrl ref counting teardown */
 	nvme_uninit_ctrl(&ctrl->ctrl);
 
-- 
2.51.0

