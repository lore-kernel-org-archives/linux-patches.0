Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11F21A9FA4;
	Wed, 11 Feb 2026 12:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813113; cv=none; b=NufQpQbLlSSwdyNLaRYHXUitYL5Q729bSM6gEuFSQA75WfQDR9wtYQHOodTgpNYxggJUTcJVbaTpmLyZoYQ/hLOC7gFERrcPMwWxvWzM2eBR0dASN5EmH5E+g9t13DfWqdV6yztsobBFY4Qe6RoD8dAtpWd53BaZBJfUYqwGfms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813113; c=relaxed/simple;
	bh=4ggeXx2n4hxp6kS5RyhZtD/erQO6Uv3vJgYKYv/qXN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q2UHDV3dVj562Td6y/wtv05P6VQ6eQ8g36v3Ey0jG5hPMSEiYC2N/iHimTNyx7DkdhujgrTze9h542gp8eOwu15vFHW71lxsabwAbPdmHidn99JYyusz/26YgyQ4mt2qfww47LGTQ2QZSyfu++CakEhqURTr4ph8J2H39//gDJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ssiWNPQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ssiWNPQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3FFC19424;
	Wed, 11 Feb 2026 12:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813113;
	bh=4ggeXx2n4hxp6kS5RyhZtD/erQO6Uv3vJgYKYv/qXN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ssiWNPQ4UKHjBRHDwVxj3iU+JyJ031L9VJyhfYnFz3x5oEV/rYv/+3OJyIFiYeIKe
	 RoaRqX8d97Dzc7lRaJSa6SPC+izdc4dIFmfN+DKv4pXjra6832A4BMbrklcWpchHGm
	 60zzijDZjXCY4svI4gX6OZrHgTr8KR4fAqNBrm251ffrbMOW+yPAGS5jXIgJ7OXiXH
	 cXdlNKyaeslqJul7r6pvFBjrJKdQap5UacCgmButwVEtnbEtnl+uIO91kwq06QbjHZ
	 oQl6reyRiBfEHBuuE7Dui7GgUDGil2nTYE474WAZnZD/gKqv23uOXktaHeS1qwrkHx
	 GpdQbIFAZlF/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heinz Mauelshagen <heinzm@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] md raid: fix hang when stopping arrays with metadata through dm-raid
Date: Wed, 11 Feb 2026 07:30:30 -0500
Message-ID: <20260211123112.1330287-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
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

From: Heinz Mauelshagen <heinzm@redhat.com>

[ Upstream commit cefcb9297fbdb6d94b61787b4f8d84f55b741470 ]

When using device-mapper's dm-raid target, stopping a RAID array can cause
the system to hang under specific conditions.

This occurs when:

- A dm-raid managed device tree is suspended from top to bottom
   (the top-level RAID device is suspended first, followed by its
    underlying metadata and data devices)

- The top-level RAID device is then removed

Removing the top-level device triggers a hang in the following sequence:
the dm-raid destructor calls md_stop(), which tries to flush the
write-intent bitmap by writing to the metadata sub-devices. However, these
devices are already suspended, making them unable to complete the write-intent
operations and causing an indefinite block.

Fix:

- Prevent bitmap flushing when md_stop() is called from dm-raid
destructor context
  and avoid a quiescing/unquescing cycle which could also cause I/O

- Still allow write-intent bitmap flushing when called from dm-raid
suspend context

This ensures that RAID array teardown can complete successfully even when the
underlying devices are in a suspended state.

This second patch uses md_is_rdwr() to distinguish between suspend and
destructor paths as elaborated on above.

Link: https://lore.kernel.org/linux-raid/CAM23VxqYrwkhKEBeQrZeZwQudbiNey2_8B_SEOLqug=pXxaFrA@mail.gmail.com
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Complete Analysis

### 1. What the Bug Is

This commit fixes a **system hang** (indefinite block/deadlock) when
stopping dm-raid managed RAID arrays. The hang scenario is:

1. A dm-raid device tree is suspended top-to-bottom (top-level RAID
   device first, then underlying metadata/data devices)
2. The top-level RAID device is removed (`raid_dtr` destructor)
3. `raid_dtr()` → `md_stop()` → `__md_stop_writes()` tries to:
   - Quiesce the RAID personality (`pers->quiesce()`)
   - Flush the write-intent bitmap to metadata devices
     (`bitmap_ops->flush()`)
4. But the metadata devices are already suspended and **cannot complete
   I/O**
5. The flush waits indefinitely → **system hang**

This is a real, user-reported bug (Link in commit message points to a
lore report).

### 2. The Fix

The fix adds a conditional guard around the quiesce and bitmap flush in
`__md_stop_writes()`:

```c
if (md_is_rdwr(mddev) || !mddev_is_dm(mddev)) {
    // quiesce + bitmap flush
}
```

This condition skips the quiesce and bitmap flush **only** when:
- The device is a dm-raid device (`mddev_is_dm()` returns true), AND
- The device is NOT in read-write mode (`md_is_rdwr()` returns false)

The clever trick: `raid_postsuspend()` (suspend path) already calls
`md_stop_writes()` while the device is still `MD_RDWR`, so the bitmap
flush proceeds normally during suspend. Then it sets `rs->md.ro =
MD_RDONLY`. Later when `raid_dtr()` calls `md_stop()` →
`__md_stop_writes()`, the device is `MD_RDONLY`, so the condition is
false and the dangerous I/O is skipped.

For non-dm md arrays (`!mddev_is_dm()` is true), the condition is always
true and behavior is unchanged.

### 3. Code Change Scope

- **1 file changed**: `drivers/md/md.c`
- **8 insertions, 6 deletions** (net +2 lines)
- Only touches the `__md_stop_writes()` function
- Small and surgical

### 4. Critical Dependency Issue

The commit message explicitly says **"This second patch"**, indicating
it's part of a 2-patch series. The first patch is `55dcfdf8af9c3` ("dm
raid: use proper md_ro_state enumerators"), which:
- Added `rs->md.ro = MD_RDONLY;` to `raid_postsuspend()` in `dm-raid.c`
- Without this line, when `raid_dtr` runs, `mddev->ro` is still
  `MD_RDWR` (from `raid_resume`), so `md_is_rdwr()` returns true, and
  the quiesce/flush is NOT skipped → the hang still occurs!

**This means the fix (`cefcb9297fbdb`) CANNOT work without the
prerequisite (`55dcfdf8af9c3`).**

The prerequisite `55dcfdf8af9c3` was merged for v6.18. It is:
- Present in 6.18.y
- **NOT** present in 6.12.y, 6.6.y, 6.1.y, or 5.15.y

### 5. Additional Backport Complications

For older stable trees (6.12.y and earlier), the code context has
changed significantly:
- v6.12+: `bitmap_ops->flush()` (ops-based interface)
- v6.11 and earlier: `md_bitmap_flush()` (direct function call)
- The `md_bitmap_enabled()` guard was added between v6.12 and current
- The `serialize_policy` field changed to a flag bit
- `md_stop_writes()` in v6.6 includes `set_bit(MD_RECOVERY_FROZEN)` and
  sync thread reaping, which was later moved to the callers

### 6. Is the Bug Present in Older Stable Trees?

**Yes**, the underlying bug (bitmap flush blocking on suspended metadata
devices) exists in all kernel versions with dm-raid. In v6.6/v6.1,
`__md_stop_writes()` also calls `md_bitmap_flush()` and
`pers->quiesce()` unconditionally, and the same hang can occur when
`raid_dtr` runs after `raid_postsuspend`.

However, to fix it in older trees, you would need BOTH:
1. The prerequisite that sets `ro = MD_RDONLY` in `raid_postsuspend`
   (equivalent of `55dcfdf8af9c3`)
2. This fix that checks `md_is_rdwr()` in `__md_stop_writes` (this
   commit)

And both would need adaptation to the different code context.

### 7. Risk Assessment

- **Severity of bug**: HIGH — system hang is a serious issue, especially
  for enterprise users of dm-raid (LVM RAID, etc.)
- **Risk of regression**: LOW-MEDIUM — the fix only changes behavior for
  dm-raid devices in the destructor path (when `!md_is_rdwr &&
  mddev_is_dm`); all other paths are unchanged
- **Size**: Very small (8 insertions, 6 deletions)
- **Dependency complexity**: HIGH — requires prerequisite commit and
  significant code context differences across versions

### 8. Verdict

This commit fixes a **real, user-reported system hang** in dm-raid
teardown, which is clearly important for stable. The fix itself is
small, surgical, and well-understood. However, it has a **hard
dependency** on `55dcfdf8af9c3` ("dm raid: use proper md_ro_state
enumerators") which adds the critical `rs->md.ro = MD_RDONLY` line in
`raid_postsuspend()`. Without that prerequisite, the `md_is_rdwr()`
check in this fix would never distinguish between suspend and destructor
paths, and the fix would be completely ineffective.

For 6.18.y, the prerequisite is present and this patch could apply
(possibly with minor context adjustments). For older LTS trees (6.12.y,
6.6.y, 6.1.y), both this commit and the prerequisite (with appropriate
context adaptations) would need to be backported together.

Given that:
1. It fixes a definite system hang (high severity)
2. It's small and well-contained
3. It has a clear dependency that must also be backported
4. dm-raid (LVM RAID) is widely used in enterprise environments
5. The author is from Red Hat (enterprise focus) and it was reported by
   a real user

This is a **YES** for backporting, with the strong caveat that the
prerequisite commit `55dcfdf8af9c3` must be included in any backport.

**YES**

 drivers/md/md.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6d73f6e196a9f..ac71640ff3a81 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6848,13 +6848,15 @@ static void __md_stop_writes(struct mddev *mddev)
 {
 	timer_delete_sync(&mddev->safemode_timer);
 
-	if (mddev->pers && mddev->pers->quiesce) {
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
-	}
+	if (md_is_rdwr(mddev) || !mddev_is_dm(mddev)) {
+		if (mddev->pers && mddev->pers->quiesce) {
+			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 0);
+		}
 
-	if (md_bitmap_enabled(mddev, true))
-		mddev->bitmap_ops->flush(mddev);
+		if (md_bitmap_enabled(mddev, true))
+			mddev->bitmap_ops->flush(mddev);
+	}
 
 	if (md_is_rdwr(mddev) &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
-- 
2.51.0

