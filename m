Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7B3311C35;
	Sat, 14 Feb 2026 21:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104433; cv=none; b=ZzQz/Xc1iZpFri99pAmZfihH9XZ1J/CXZUM6iATzJcB+9o3AYBZm811qIjIOZmj207MbKpJNmML+48TFyfFa1pDrkqCCuPlIXC4xyL0GJkSdTWXfYgNarhSC4Kiugshv2apEqftT+IsgZDljEJx91pHxOTSHL3TnH6w269zd/C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104433; c=relaxed/simple;
	bh=jjUeI65DKfRKw44ufB5viyNZu9uX2y0jcM6x9CaYidU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LSqrvbrqSqFgy8QO3gDyg1hvNtSnedtcIwR1ZWPNK135A9MZFAxsMZ86hQpHJbh22rJBes/uPnFxjZzpmno0d746ZSJ5wZkWCdYJHXqEomEWdQbhivuaV+Jc2u2sWFeGqsDBCLdDAEEx2kN+OBleVyqHNFtuK3jNW7X0zWEmTA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDsClJWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDsClJWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE960C19423;
	Sat, 14 Feb 2026 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104433;
	bh=jjUeI65DKfRKw44ufB5viyNZu9uX2y0jcM6x9CaYidU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDsClJWOVLAKH2152uXkuNUgGyLgQ5YLUSuv9mp1xPy2Y6SMO4vxTSI8rzSmV7oqE
	 Ts3xLf3kD173b3WAYHE+QzOd2SyPlGnxvADAM5zYZKrV/CN7VhzI/Q/3SM00JEvkIx
	 sZtlA/S0jkaxxafxdvmUsRhmH7+s/2xIOzQQyjZ6jMxOhRgIRnQ4O20Bz/4dqWsgBX
	 9+uVeBj+JjhXgFdehggVhUiLiGpgqp0ekqvlHZmvL07OqfxdTvCqSrbdWskk+G24hX
	 5fwGISx4WU+XnEZcUf58maccAbyLNy3IAHetrGT1JE553vinHAA0TUHuouEj93SXtH
	 xwTMqTIsVrWkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jori Koolstra <jkoolstra@xs4all.nl>,
	syzbot+9131ddfd7870623b719f@syzkaller.appspotmail.com,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	jlayton@kernel.org,
	brauner@kernel.org,
	neil.armstrong@linaro.org,
	viro@zeniv.linux.org.uk,
	yelangyan@huaqin.corp-partner.google.com,
	neil@brown.name,
	jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.19-5.10] jfs: nlink overflow in jfs_rename
Date: Sat, 14 Feb 2026 16:23:45 -0500
Message-ID: <20260214212452.782265-80-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
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

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit 9218dc26fd922b09858ecd3666ed57dfd8098da8 ]

If nlink is maximal for a directory (-1) and inside that directory you
perform a rename for some child directory (not moving from the parent),
then the nlink of the first directory is first incremented and later
decremented. Normally this is fine, but when nlink = -1 this causes a
wrap around to 0, and then drop_nlink issues a warning.

After applying the patch syzbot no longer issues any warnings. I also
ran some basic fs tests to look for any regressions.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Reported-by: syzbot+9131ddfd7870623b719f@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=9131ddfd7870623b719f
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of jfs: nlink overflow in jfs_rename

### 1. Commit Message Analysis

The commit message is clear and well-structured:
- **Problem**: When a directory has maximum nlink (`-1` / `UINT_MAX`),
  performing a rename of a child directory within the same parent causes
  nlink to wrap around: first incremented (wraps to 0), then decremented
  via `drop_nlink()` which triggers a kernel WARNING because nlink is
  already 0.
- **Reporter**: syzbot (Google's kernel fuzzer) — a strong indicator of
  a real, reproducible bug.
- **Testing**: Author confirms syzbot warning is resolved and ran basic
  fs regression tests.
- **Maintainer sign-off**: Dave Kleikamp (JFS maintainer) signed off.

### 2. Code Change Analysis

The fix is in `fs/jfs/namei.c` in the `jfs_rename()` function. Two
changes:

**Change 1** (line ~1231):
```c
- if (S_ISDIR(old_ip->i_mode))
+ if (S_ISDIR(old_ip->i_mode) && old_dir != new_dir)
     inc_nlink(new_dir);
```
When renaming a directory within the **same parent** (`old_dir ==
new_dir`), there's no need to increment nlink on the new directory
because the directory isn't gaining a new subdirectory — the
subdirectory is just being renamed in place. The `inc_nlink` should only
happen when moving a directory to a **different** parent.

**Change 2** (lines ~1245-1247):
```c
- drop_nlink(old_dir);
+ if (new_ip || old_dir != new_dir)
+     drop_nlink(old_dir);
```
Similarly, `drop_nlink` on `old_dir` should only happen when the
directory is actually losing a subdirectory (either it's being moved to
a different parent, or it's replacing an existing entry `new_ip`). When
renaming within the same directory and not replacing anything, nlink
shouldn't change.

### 3. Bug Mechanism

The bug is an nlink integer overflow/underflow:
1. Directory has nlink = `UINT_MAX` (maximum value)
2. A child directory rename within the same parent triggers
   `inc_nlink()` → nlink wraps to 0
3. Then `drop_nlink()` is called on nlink=0, which triggers a `WARN_ON`
   in the VFS layer
4. This causes a kernel WARNING — a clear stability issue

The fix is logically correct: when renaming within the same directory,
nlink shouldn't be touched at all since the number of subdirectories
hasn't changed.

### 4. Classification

- **Bug fix**: YES — fixes an nlink overflow/underflow that triggers
  kernel warnings
- **Syzbot-reported**: YES — reproducible fuzzer-found bug
- **Security relevance**: MEDIUM — nlink corruption could potentially be
  exploited, and triggering kernel warnings is itself a stability
  concern

### 5. Scope and Risk Assessment

- **Lines changed**: ~6 lines of actual logic change (very small)
- **Files touched**: 1 file (`fs/jfs/namei.c`)
- **Subsystem**: JFS filesystem — mature, stable filesystem
- **Risk**: LOW — the conditions added (`old_dir != new_dir` and
  `new_ip`) are standard checks already used elsewhere in the same
  function. The logic is straightforward: don't modify nlink when the
  directory count isn't actually changing.
- **Regression risk**: MINIMAL — this makes JFS consistent with how
  other filesystems handle same-directory renames

### 6. Stable Kernel Criteria Check

- **Obviously correct and tested**: YES — logic is clear, tested by
  author, verified by syzbot
- **Fixes a real bug**: YES — kernel WARNING trigger, nlink corruption
- **Important issue**: YES — kernel WARNING, potential filesystem
  metadata corruption
- **Small and contained**: YES — 6 lines in one file
- **No new features**: Correct — pure bug fix
- **No new APIs**: Correct

### 7. Dependencies

The fix is self-contained. It modifies conditions around existing
`inc_nlink()` and `drop_nlink()` calls. No dependency on other commits.
The affected code (`jfs_rename`) has been stable for years and exists in
all stable trees that include JFS.

### 8. User Impact

JFS users who encounter the maximum nlink scenario (which syzbot can
trigger) will see kernel warnings. While the scenario requires nlink to
be at maximum, this is a correctness issue in filesystem metadata
handling. Filesystem bugs are always high-priority for stable because
they can lead to data corruption or loss.

### Conclusion

This is a textbook stable backport candidate: a small, surgical fix to a
syzbot-reported bug in filesystem code, fixing an nlink overflow that
triggers kernel warnings. It's obviously correct, well-tested,
maintainer-approved, and carries minimal regression risk.

**YES**

 fs/jfs/namei.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 65a218eba8faf..7879c049632b3 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1228,7 +1228,7 @@ static int jfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 				jfs_err("jfs_rename: dtInsert returned -EIO");
 			goto out_tx;
 		}
-		if (S_ISDIR(old_ip->i_mode))
+		if (S_ISDIR(old_ip->i_mode) && old_dir != new_dir)
 			inc_nlink(new_dir);
 	}
 	/*
@@ -1244,7 +1244,9 @@ static int jfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		goto out_tx;
 	}
 	if (S_ISDIR(old_ip->i_mode)) {
-		drop_nlink(old_dir);
+		if (new_ip || old_dir != new_dir)
+			drop_nlink(old_dir);
+
 		if (old_dir != new_dir) {
 			/*
 			 * Change inode number of parent for moved directory
-- 
2.51.0

