Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748C523497B;
	Mon, 30 Jun 2025 20:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317175; cv=none; b=caVX06AUzU7T3gF8X/Ft4WBDvpr5tI/ZgUWoJNQDmi9kjSz9nF1MrFdowk3oHkcW8E8fjfTycfYw8OD1x6+JCDa1jdRp/dM9SIjAWwFFg6viWrgDmZKVd8mNGE2fNjVBoPs3c5kjIQkKCaELLi+tgPT/i0KNEjqJ6wms0wbl+xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317175; c=relaxed/simple;
	bh=VcXM6MWhX67m9iQoxsLoEBnOs9uQDNeogGuIMdObaJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Row/Jg2Mb0jm7Uqt0eYEZAG6BL9FrxBcGwwIKIRLBvbE5mAZaM+JKVCVkrQrEiVE9Vn1f4l2HbSb2LPCvlM76Sxk8BsDSUInA3c6+co1szdQEH3crkOB5IKMLRVMSBvYoy3aD9A4doHcyc3sx+cSuDvqJGPfY5kQIIYPCTe1DKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pQ3m7ASc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pQ3m7ASc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE0EC4CEE3;
	Mon, 30 Jun 2025 20:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317175;
	bh=VcXM6MWhX67m9iQoxsLoEBnOs9uQDNeogGuIMdObaJ8=;
	h=From:To:Cc:Subject:Date:From;
	b=pQ3m7ASc1qxIXjaIZYk2+AnHO7oVbOFRJVLRyjlzeMvoyJnog2wz3253a4ofhK8R5
	 LQ1eTpYex11nPvetiY/G5LACCZBerwoeYTsf8shu1uAtcqgjparLlJdzmEoQDdU/xk
	 aWhxHDcRQV7Tuqfr51P4XaireLbENd8l03kznke54i81bdlvApQjVxDQjAmi0dv7ge
	 GRFZA8E2Tpo109r3SCvnT8vla4vHIuiuqwijqfOOgu6JTkrqrPpn1CHVbzymBFx1SI
	 y2vhgkchMI99Gorlf2/HefBTcQje8igBkfMXA+dyaJiOG91M0Ze2gWVwEHm2OH6AoH
	 WAiwuz5qwBxdA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ronnie Sahlberg <rsahlberg@whamcloud.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 01/21] ublk: sanity check add_dev input for underflow
Date: Mon, 30 Jun 2025 16:45:16 -0400
Message-Id: <20250630204536.1358327-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.35
Content-Transfer-Encoding: 8bit

From: Ronnie Sahlberg <rsahlberg@whamcloud.com>

[ Upstream commit 969127bf0783a4ac0c8a27e633a9e8ea1738583f ]

Add additional checks that queue depth and number of queues are
non-zero.

Signed-off-by: Ronnie Sahlberg <rsahlberg@whamcloud.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250626022046.235018-1-ronniesahlberg@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

**1. Fixes a Critical Input Validation Bug**
The commit addresses a serious bug where userspace could pass zero
values for `queue_depth` or `nr_hw_queues`, leading to:
- Memory allocation failures (`kcalloc(0, ubq_size, GFP_KERNEL)` in
  `ublk_init_queues()`)
- Non-functional block devices with zero queues
- Potential kernel crashes or undefined behavior

**2. Minimal and Contained Fix**
The change is extremely minimal - just adding two checks to an existing
validation:
```diff
- if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || info.nr_hw_queues >
  UBLK_MAX_NR_QUEUES)
+       if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || !info.queue_depth
||
+           info.nr_hw_queues > UBLK_MAX_NR_QUEUES ||
!info.nr_hw_queues)
```

**3. Prevents Security/Stability Issues**
Based on the kernel source analysis:
- `ublk_init_queues()` uses these values directly for memory allocation
- Multiple loops iterate based on `nr_hw_queues` - zero would skip all
  initialization
- The block layer's `blk_mq_alloc_tag_set()` expects non-zero values

**4. Similar to Previously Backported Commits**
This is very similar to "block: ublk: extending queue_size to fix
overflow" (Similar Commit #2), which was marked YES for backporting.
Both fix input validation issues that could cause memory/stability
problems.

**5. Clear Bug Fix Following Stable Rules**
- Fixes a real bug (not theoretical)
- No new features or architectural changes
- Minimal risk - simply rejects invalid input
- Confined to the ublk subsystem
- Prevents userspace from creating broken/dangerous kernel state

The commit prevents userspace from triggering undefined behavior in the
kernel by passing invalid parameters, which is exactly the type of bug
fix that belongs in stable kernels.

 drivers/block/ublk_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 746ef36e58df2..3b1a5cdd63116 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2457,7 +2457,8 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	if (copy_from_user(&info, argp, sizeof(info)))
 		return -EFAULT;
 
-	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || info.nr_hw_queues > UBLK_MAX_NR_QUEUES)
+	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || !info.queue_depth ||
+	    info.nr_hw_queues > UBLK_MAX_NR_QUEUES || !info.nr_hw_queues)
 		return -EINVAL;
 
 	if (capable(CAP_SYS_ADMIN))
-- 
2.39.5

