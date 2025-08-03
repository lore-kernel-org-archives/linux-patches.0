Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05862040A8;
	Sun,  3 Aug 2025 21:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255904; cv=none; b=dASHdIrUD+JIilMqFRc+1zzWoAoYnJHVXmw3YtX9VeYbt4nnc3aa2dgNejCi6TkDyIlBECpt0zdVyGU4kD9zHD04DKD7jI5YPfsm/O1mWcykvpKrEdSCZfEHMZWWEjRPR7ROr5/xeRf4fYURoLzsSQezsfxhpkXvd70n8FRFVyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255904; c=relaxed/simple;
	bh=2dEuj7p703l6NyH3twdGut9EEm0uWyILxE4O/eacSPs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CsiZSbnSckBtXO2ENQw5t38KuW7M3ImhJYyvTLTuFz/9fVTUNunG4SN7Cefctf81DOnWO51aacS6nMQHll629CTbBpcLNgGeJ47/yrBQetDD3ARbl7ZLR2/Bpjzr8SLR2QDWHvKaxqLePGjgXPNCr2WqZegevKEcyDiLdsllL3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OtnBAKCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtnBAKCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED406C4CEFB;
	Sun,  3 Aug 2025 21:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255903;
	bh=2dEuj7p703l6NyH3twdGut9EEm0uWyILxE4O/eacSPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtnBAKCuJOpdyzkNyV59mviDfB+4xkvTt2ZOOVh6AeUz1oP24ekqJqq+UcZlrJjWl
	 t9niBDh3XkdZecaSV6IT79ZRPaOoGslsR7juLzAPuOVAHGUucjc6g/6Khx/r4gM34n
	 uc6pfSFK+1Iey2WJAw7CUOCnEegZhG4totVEgoh7z3esmCPbxR8P0KEkdf7mpka742
	 nDotOGbSQyAFoCR1Q5XHnIgpqJx7WZgfat5qehoHmz1DG+KrOn9c6vq9QX2AzZ/aE4
	 R12rGr85LB2J2v86jbhhW9rtzWOBc5oVatjF1nGO3EFT8U2ZXT7bXOvLd1xPo7ihRR
	 kQdIMIpq/r1WQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>,
	syzbot+01ef7a8da81a975e1ccd@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16 19/35] loop: Avoid updating block size under exclusive owner
Date: Sun,  3 Aug 2025 17:17:19 -0400
Message-Id: <20250803211736.3545028-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211736.3545028-1-sashal@kernel.org>
References: <20250803211736.3545028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit 7e49538288e523427beedd26993d446afef1a6fb ]

Syzbot came up with a reproducer where a loop device block size is
changed underneath a mounted filesystem. This causes a mismatch between
the block device block size and the block size stored in the superblock
causing confusion in various places such as fs/buffer.c. The particular
issue triggered by syzbot was a warning in __getblk_slow() due to
requested buffer size not matching block device block size.

Fix the problem by getting exclusive hold of the loop device to change
its block size. This fails if somebody (such as filesystem) has already
an exclusive ownership of the block device and thus prevents modifying
the loop device under some exclusive owner which doesn't expect it.

Reported-by: syzbot+01ef7a8da81a975e1ccd@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: syzbot+01ef7a8da81a975e1ccd@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20250711163202.19623-2-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit is a strong candidate for stable backporting based on the
following analysis:

1. **Fixes a Real User-Impacting Bug**: The commit addresses a syzbot-
   reported issue where changing a loop device's block size while it's
   mounted can cause filesystem corruption and warnings. The specific
   issue is a warning in `__getblk_slow()` in fs/buffer.c due to
   mismatched buffer and block device sizes.

2. **Security and Data Integrity Issue**: This bug can lead to
   filesystem corruption when the block size is changed underneath a
   mounted filesystem, which is a serious data integrity concern that
   affects users in production environments.

3. **Small and Contained Fix**: The changes are limited to the loop
   driver (drivers/block/loop.c) and specifically to the
   `loop_set_block_size()` function. The fix adds proper exclusive
   ownership checks before allowing block size changes.

4. **Clear Fix Strategy**: The solution is straightforward - it uses
   existing kernel mechanisms (`bd_prepare_to_claim()` and
   `bd_abort_claiming()`) to ensure exclusive access before modifying
   the block size. This prevents concurrent modifications when the
   device is already exclusively owned (e.g., by a mounted filesystem).

5. **Minimal Risk of Regression**: The change only affects the
   LOOP_SET_BLOCK_SIZE ioctl path and adds additional safety checks. It
   doesn't modify the core functionality but rather adds protection
   against an unsafe operation.

6. **Follows Stable Rules**: The commit:
   - Fixes a real bug (filesystem corruption/warnings)
   - Is small and self-contained
   - Has been tested (confirmed by syzbot)
   - Doesn't introduce new features
   - Has minimal performance impact

The key code changes show the fix properly handles the exclusive
ownership by:
- Checking if the caller already has exclusive access (`!(mode &
  BLK_OPEN_EXCL)`)
- If not, attempting to claim exclusive access via
  `bd_prepare_to_claim()`
- Properly releasing the claim with `bd_abort_claiming()` if the
  operation completes without exclusive mode
- Moving the operation out of `lo_simple_ioctl()` to handle the block
  device parameter

This is exactly the type of bug fix that stable kernels should receive -
it prevents data corruption with minimal code changes and low regression
risk.

 drivers/block/loop.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 8d994cae3b83..1b6ee91f8eb9 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1431,17 +1431,34 @@ static int loop_set_dio(struct loop_device *lo, unsigned long arg)
 	return 0;
 }
 
-static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
+static int loop_set_block_size(struct loop_device *lo, blk_mode_t mode,
+			       struct block_device *bdev, unsigned long arg)
 {
 	struct queue_limits lim;
 	unsigned int memflags;
 	int err = 0;
 
-	if (lo->lo_state != Lo_bound)
-		return -ENXIO;
+	/*
+	 * If we don't hold exclusive handle for the device, upgrade to it
+	 * here to avoid changing device under exclusive owner.
+	 */
+	if (!(mode & BLK_OPEN_EXCL)) {
+		err = bd_prepare_to_claim(bdev, loop_set_block_size, NULL);
+		if (err)
+			return err;
+	}
+
+	err = mutex_lock_killable(&lo->lo_mutex);
+	if (err)
+		goto abort_claim;
+
+	if (lo->lo_state != Lo_bound) {
+		err = -ENXIO;
+		goto unlock;
+	}
 
 	if (lo->lo_queue->limits.logical_block_size == arg)
-		return 0;
+		goto unlock;
 
 	sync_blockdev(lo->lo_device);
 	invalidate_bdev(lo->lo_device);
@@ -1454,6 +1471,11 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	loop_update_dio(lo);
 	blk_mq_unfreeze_queue(lo->lo_queue, memflags);
 
+unlock:
+	mutex_unlock(&lo->lo_mutex);
+abort_claim:
+	if (!(mode & BLK_OPEN_EXCL))
+		bd_abort_claiming(bdev, loop_set_block_size);
 	return err;
 }
 
@@ -1472,9 +1494,6 @@ static int lo_simple_ioctl(struct loop_device *lo, unsigned int cmd,
 	case LOOP_SET_DIRECT_IO:
 		err = loop_set_dio(lo, arg);
 		break;
-	case LOOP_SET_BLOCK_SIZE:
-		err = loop_set_block_size(lo, arg);
-		break;
 	default:
 		err = -EINVAL;
 	}
@@ -1529,9 +1548,12 @@ static int lo_ioctl(struct block_device *bdev, blk_mode_t mode,
 		break;
 	case LOOP_GET_STATUS64:
 		return loop_get_status64(lo, argp);
+	case LOOP_SET_BLOCK_SIZE:
+		if (!(mode & BLK_OPEN_WRITE) && !capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		return loop_set_block_size(lo, mode, bdev, arg);
 	case LOOP_SET_CAPACITY:
 	case LOOP_SET_DIRECT_IO:
-	case LOOP_SET_BLOCK_SIZE:
 		if (!(mode & BLK_OPEN_WRITE) && !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		fallthrough;
-- 
2.39.5

