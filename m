Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BE83164C1;
	Mon,  2 Feb 2026 21:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068848; cv=none; b=SHUKpTHouMXSBxZu9yo7hAs9iKcrPpBE2LsQWOaAoEGRJUOtR51eUtX26aIUuYeREkWERJctvOD1D31TlhemLVcCqoYxM25V9+IftDSZYyBL8CNa351dUXmqEs2Hh3l2xHSl8C3Bc5IQIqjXsj1vKKAn8OTsdRCVsn1rrGO84UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068848; c=relaxed/simple;
	bh=9FNYbSajliKQ80x4jgX5YNUAuU69EDRTeqWnRx2tesM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsFyHuzkQdR4gsftLcaSiu6Sr3ynLSunIoEkPdQVTsnwljBNbNajlOqoXKos7mQOWWzdVlg8uuZALK4Jmyo3h8+Zwozc0adpdYkL1kD/QSNHfL3O1Yi11yim7eCqCKIJzwI8Ela2DuWgmLK1aL+QQrU19EgRhXXMPfnBBPtpG7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pdoN6bjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pdoN6bjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5711AC19421;
	Mon,  2 Feb 2026 21:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068848;
	bh=9FNYbSajliKQ80x4jgX5YNUAuU69EDRTeqWnRx2tesM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdoN6bjxvVcOMvRCWBv4qSnJhY0PMbGggb3sltRmNcjGNY1dF5AZvIZoTar0p81xx
	 BgesdRNxqoakCUENs7t4eFvjMGXYIiM6bVl1YChj562BMp2DeNVFPOjoQ9V49YiAER
	 eHsBR+3+2eotZQGZ2N4Zr9Pz7y6XR+wjiFvIIRtSbw3uoV52SZiNMGF1uULwpCsAmH
	 LtsofeoU5YjxI0jtFCBuMbiAHaAGMEl4x9qR7NyWbRd1jMU2pTDE+gXxWDa2mbHxpS
	 D/xCrTuC4yA36obm8OQsQJOBnZ+Kf0/Wd78bl++oZdF5tXd3OG9E/sh9AOOuDYs385
	 dj5giasMbDDDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+9c4e33e12283d9437c25@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mjguzik@gmail.com
Subject: [PATCH AUTOSEL 6.18-5.10] romfs: check sb_set_blocksize() return value
Date: Mon,  2 Feb 2026 16:46:17 -0500
Message-ID: <20260202214643.212290-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202214643.212290-1-sashal@kernel.org>
References: <20260202214643.212290-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Transfer-Encoding: 8bit

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit ab7ad7abb3660c58ffffdf07ff3bb976e7e0afa0 ]

romfs_fill_super() ignores the return value of sb_set_blocksize(), which
can fail if the requested block size is incompatible with the block
device's configuration.

This can be triggered by setting a loop device's block size larger than
PAGE_SIZE using ioctl(LOOP_SET_BLOCK_SIZE, 32768), then mounting a romfs
filesystem on that device.

When sb_set_blocksize(sb, ROMBSIZE) is called with ROMBSIZE=4096 but the
device has logical_block_size=32768, bdev_validate_blocksize() fails
because the requested size is smaller than the device's logical block
size. sb_set_blocksize() returns 0 (failure), but romfs ignores this and
continues mounting.

The superblock's block size remains at the device's logical block size
(32768). Later, when sb_bread() attempts I/O with this oversized block
size, it triggers a kernel BUG in folio_set_bh():

    kernel BUG at fs/buffer.c:1582!
    BUG_ON(size > PAGE_SIZE);

Fix by checking the return value of sb_set_blocksize() and failing the
mount with -EINVAL if it returns 0.

Reported-by: syzbot+9c4e33e12283d9437c25@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9c4e33e12283d9437c25
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260113084037.1167887-1-kartikey406@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The bug has existed since 2009 when romfs was originally written. The
pattern of not checking `sb_set_blocksize()` return value has been there
from the beginning.

## Analysis Summary

### 1. COMMIT MESSAGE ANALYSIS
- **Clear bug description**: The commit message explains that
  `romfs_fill_super()` ignores the return value of `sb_set_blocksize()`,
  which can fail when the requested block size is incompatible with the
  block device's configuration.
- **Reproducibility**: The bug can be triggered by setting a loop
  device's block size larger than PAGE_SIZE using
  `ioctl(LOOP_SET_BLOCK_SIZE, 32768)`, then mounting a romfs filesystem.
- **Impact clearly stated**: Results in a kernel BUG in `folio_set_bh()`
  at fs/buffer.c
- **Syzbot reported**: Has `Reported-by:` tag from syzbot with a link to
  the bug report
- **Signed-off**: Proper sign-off chain from submitter and Christian
  Brauner (VFS maintainer)

### 2. CODE CHANGE ANALYSIS
The fix is straightforward and minimal:
- **Before**: `sb_set_blocksize(sb, ROMBSIZE);` (return value ignored)
- **After**: Checks if `sb_set_blocksize()` returns 0 (failure), prints
  an error message, and returns `-EINVAL`

The bug mechanism:
1. `sb_set_blocksize()` can fail if the requested block size (ROMBSIZE =
   1024) is smaller than the block device's logical block size
2. When it fails, it returns 0 but romfs ignores this and continues
   mounting
3. The superblock retains the device's (larger) block size instead of
   ROMBSIZE
4. Later buffer head allocations use this oversized block size
5. This triggers a BUG_ON condition when the block size exceeds folio
   size

### 3. CLASSIFICATION
- **Bug fix**: This is clearly fixing a bug, not adding a feature
- **Type**: Missing error check leading to kernel BUG/crash
- **Security implications**: Could potentially be triggered by
  unprivileged users via loop device mounting (if permitted)

### 4. SCOPE AND RISK ASSESSMENT
- **Lines changed**: Only 4 lines changed (+3, -1)
- **Files touched**: 1 file (fs/romfs/super.c)
- **Subsystem**: romfs filesystem (simple, mature, read-only FS)
- **Risk**: Very low - the fix simply adds error checking that matches
  the pattern used by all other filesystems
- **Could this break something?**: No - it only fails the mount earlier
  with a clear error message instead of proceeding to a kernel BUG

### 5. USER IMPACT
- **Severity**: HIGH - causes kernel BUG (crash/oops)
- **Affected users**: Anyone using romfs on block devices with non-
  standard block sizes
- **Triggerable by**: Can be triggered through loop device configuration

### 6. STABILITY INDICATORS
- **Reported by syzbot**: Yes, with reproducible test case
- **Maintainer sign-off**: Christian Brauner (VFS maintainer) signed off
- **In mainline**: Merged in v6.19-rc8 cycle
- **Pattern matches other filesystems**: The fix follows the exact same
  pattern used by ext2, ext4, fuse, f2fs, minix, qnx6, ufs, hfs, exfat,
  erofs, gfs2, ocfs2, udf, nilfs2, freevxfs, efs, and many other
  filesystems

### 7. DEPENDENCY CHECK
- **Dependencies**: None - standalone fix
- **Code exists in stable**: Yes - romfs has been in the kernel since
  2.6.x era with this same vulnerable pattern
- **Clean backport**: Should apply cleanly - the fix is self-contained

## Verdict

This commit is an excellent candidate for stable backporting:

1. **Fixes a real bug**: Kernel BUG/crash (oops) when mounting romfs on
   certain block device configurations
2. **Obviously correct**: Simply adds the same error check that every
   other filesystem has
3. **Small and contained**: 4 lines changed in one file
4. **No new features**: Just error handling
5. **Low risk**: The fix is defensive and can only make mount fail early
   with a clear error instead of crashing
6. **Well documented**: Clear commit message with syzbot link
7. **Maintainer approved**: Signed off by VFS maintainer
8. **Long-standing bug**: Has existed since 2009 when romfs gained block
   device support

The fix follows established kernel filesystem patterns and poses
essentially zero risk of regression while fixing a reproducible kernel
BUG.

**YES**

 fs/romfs/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 0addcc849ff2c..e83f9b78d7a16 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -458,7 +458,10 @@ static int romfs_fill_super(struct super_block *sb, struct fs_context *fc)
 
 #ifdef CONFIG_BLOCK
 	if (!sb->s_mtd) {
-		sb_set_blocksize(sb, ROMBSIZE);
+		if (!sb_set_blocksize(sb, ROMBSIZE)) {
+			errorf(fc, "romfs: unable to set blocksize\n");
+			return -EINVAL;
+		}
 	} else {
 		sb->s_blocksize = ROMBSIZE;
 		sb->s_blocksize_bits = blksize_bits(ROMBSIZE);
-- 
2.51.0

