Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3032F37BE8D;
	Wed,  7 Jan 2026 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801241; cv=none; b=qSjbE1JpfGtJD2Q8QMBmjkRkNLxcmNvpwk9RGuFEKTqf3G5r5eBtylRrkhZfJJJF1UjBnbrMfw+HoeuUbv07Ybxod7XrrSaK8zPJ45CF/cmFMb7R4Q0BnpzC3zGSP/eSn/I/lzCFqYwBQX2nukDB7yHkDO7wXoW1+ElU275Ha4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801241; c=relaxed/simple;
	bh=WKo4PZzhnHSlJTo/qquvidCwuvQQyg1xRs1qWr4gyqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROewWz+dXS7X0z/Lwo8II4cFyOAMO7vbzxzGsTWwBHXKDdM5fr7mscCvdrrPjZsXCkO5IE4cgdszI73j2IBIGB392nafYi3eLdtSry4/P+uny3va0QkCD5VohAzyHB24j9gnK/8RJnPuP4YrXdYz34ZyDyPSgI/jO6cljbnMrv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pazkUYrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pazkUYrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732EEC4CEF7;
	Wed,  7 Jan 2026 15:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767801240;
	bh=WKo4PZzhnHSlJTo/qquvidCwuvQQyg1xRs1qWr4gyqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pazkUYrNRTR0YY30bpiau8gpKbJe8JVRXOiiv5jnHJsvwnKtGAW0oPMzZXJwyELQi
	 C+oDITdK80D335g+Nbwh+xFvYWTCfOF8br4VvZ9HZ728AmveTUiDR62ODA1BeQGzYD
	 HvRRXDjsjfMu2HGdJYTtHcnKP13ijPIiNrlhQ5qqpFctWLvZqjVOYveokfhCd9OMo+
	 6Rq90nlNP3IHEZcf/XqL8IHRMI/YmfIn0hqwkhBe2C40TjQcJUwJKLunTnjwcKUS1k
	 Wlie/h2HCyJrfYjnh2JCIcXxyshi91LSRLIVbkWkvY3EZCBpVDPu9m5TdUXBQYpFAM
	 eLZqfMmHpqkcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: FengWei Shih <dannyshih@synology.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] md: suspend array while updating raid_disks via sysfs
Date: Wed,  7 Jan 2026 10:53:16 -0500
Message-ID: <20260107155329.4063936-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260107155329.4063936-1-sashal@kernel.org>
References: <20260107155329.4063936-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.3
Content-Transfer-Encoding: 8bit

From: FengWei Shih <dannyshih@synology.com>

[ Upstream commit 2cc583653bbe050bacd1cadcc9776d39bf449740 ]

In raid1_reshape(), freeze_array() is called before modifying the r1bio
memory pool (conf->r1bio_pool) and conf->raid_disks, and
unfreeze_array() is called after the update is completed.

However, freeze_array() only waits until nr_sync_pending and
(nr_pending - nr_queued) of all buckets reaches zero. When an I/O error
occurs, nr_queued is increased and the corresponding r1bio is queued to
either retry_list or bio_end_io_list. As a result, freeze_array() may
unblock before these r1bios are released.

This can lead to a situation where conf->raid_disks and the mempool have
already been updated while queued r1bios, allocated with the old
raid_disks value, are later released. Consequently, free_r1bio() may
access memory out of bounds in put_all_bios() and release r1bios of the
wrong size to the new mempool, potentially causing issues with the
mempool as well.

Since only normal I/O might increase nr_queued while an I/O error occurs,
suspending the array avoids this issue.

Note: Updating raid_disks via ioctl SET_ARRAY_INFO already suspends
the array. Therefore, we suspend the array when updating raid_disks
via sysfs to avoid this issue too.

Signed-off-by: FengWei Shih <dannyshih@synology.com>
Link: https://lore.kernel.org/linux-raid/20251226101816.4506-1-dannyshih@synology.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit clearly describes a **race condition bug** in the MD RAID
subsystem:
- When updating `raid_disks` via sysfs, `raid1_reshape()` calls
  `freeze_array()` before modifying the memory pool
- `freeze_array()` waits until `nr_pending - nr_queued` reaches a target
  value
- During I/O errors, `nr_queued` is incremented when r1bios are queued
  to `retry_list` or `bio_end_io_list`
- This allows `freeze_array()` to return while r1bios are still queued
- When these queued r1bios (allocated with old `raid_disks` value) are
  later freed after the mempool is resized, it causes:
  - **Out-of-bounds memory access** in `put_all_bios()`
  - **Mempool corruption** from releasing wrong-sized r1bios

### 2. CODE CHANGE ANALYSIS

The fix is minimal - only **2 lines changed**:
```c
// Before:
err = mddev_lock(mddev);
...
mddev_unlock(mddev);

// After:
err = mddev_suspend_and_lock(mddev);
...
mddev_unlock_and_resume(mddev);
```

This ensures the array is fully suspended during the reconfiguration,
stopping ALL I/O (not just waiting for a counter condition). This is the
**same approach the ioctl path already uses** (`SET_ARRAY_INFO`), making
the fix clearly correct.

### 3. CLASSIFICATION

- **Bug fix**: Memory safety issue (out-of-bounds access, memory
  corruption)
- **Not a feature**: No new functionality or APIs added
- **Severity**: HIGH - memory corruption can cause kernel crashes and
  potential data corruption

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 2
- **Files affected**: 1 (`drivers/md/md.c`)
- **Subsystem**: MD RAID - mature and widely used
- **Risk**: VERY LOW - uses existing, well-tested suspend mechanism
  already used by ioctl path
- **Pattern**: Matches existing code pattern for similar operations

### 5. USER IMPACT

- **Who is affected**: MD RAID (software RAID) users - common in servers
  and enterprise deployments
- **Trigger condition**: Resize array via sysfs while I/O errors are
  occurring
- **Consequence of bug**: Kernel crashes, potential data corruption
- **Impact level**: HIGH for affected users (data integrity at risk)

### 6. STABILITY INDICATORS

- Signed-off by two developers
- Has Link to mailing list discussion
- Uses conservative approach matching existing ioctl behavior

### 7. DEPENDENCY CHECK

The helper functions `mddev_suspend_and_lock()` and
`mddev_unlock_and_resume()` were added in commit f45461e24feb
(v6.7-rc1). These are inline functions in `md.h` that simply combine
`mddev_suspend()` + `mddev_lock()` and `mddev_unlock()` +
`mddev_resume()`.

For stable kernels **6.7+**: This patch should apply cleanly.

For stable kernels **< 6.7** (6.6.y, 6.1.y, 5.15.y LTS): Would need
either:
1. Backport of f45461e24feb first, OR
2. An adapted fix using direct calls to `mddev_suspend()` and
   `mddev_resume()`

The bug itself has existed since the `raid_disks_store()` function was
introduced (very old), so all stable kernels are potentially affected.

## Summary

This commit fixes a real, serious memory safety bug in the MD RAID
subsystem that can cause out-of-bounds memory access and mempool
corruption. The fix is:
- Small and surgical (2 lines)
- Obviously correct (uses existing suspend mechanism)
- Consistent with how the ioctl path already handles this
- Low risk (well-tested pattern)

The bug affects software RAID users who resize arrays via sysfs during
I/O errors - a legitimate operational scenario. The consequences (memory
corruption, potential crashes) are severe.

The only consideration is that for pre-6.7 stable kernels, the fix needs
adaptation or dependency backporting, but this is a standard stable
maintenance consideration.

**YES**

 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cef5b2954ac5..d72ce43f0ebc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4399,7 +4399,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err < 0)
 		return err;
 
-	err = mddev_lock(mddev);
+	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
 	if (mddev->pers)
@@ -4424,7 +4424,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	} else
 		mddev->raid_disks = n;
 out_unlock:
-	mddev_unlock(mddev);
+	mddev_unlock_and_resume(mddev);
 	return err ? err : len;
 }
 static struct md_sysfs_entry md_raid_disks =
-- 
2.51.0

