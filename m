Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5602629D;
	Mon, 30 Jun 2025 21:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317239; cv=none; b=F5zBWDuGT493HOvhZmlq8GZsko3wm1ScI/luAQUohFsFTqujNrgbgdLxcyhoMK2tnJdwWl3EcVjnmEYpT3rw28YArpT1Q1M4ZYFGTHTlHkrcVbbjdE3MJzCpWT0kNOurcmvNE3Yh9tE9RAcp0kMb1lxt2RJUgpq4PpnGr9/lx7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317239; c=relaxed/simple;
	bh=awAXtSOyE739HVxs+BWTIvQJM8agJwCSO5/mhGJViAY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LOptbXjiQwNUACKoZUxg233F25D/4Vx36vRx0Cuiqdt9QLjW6uxRa1JIfETvtWVMHaNeLgQPBRQRSnf46XWzvsJszxoNhsclXse1CmOQMXmX+FpJMAWa5iURGO+OrJfbeRO1UH8mLZpR96evR847rVsqpJy4UWdmL8cmjmhEvtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXIGfnY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXIGfnY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368F1C4CEE3;
	Mon, 30 Jun 2025 21:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317239;
	bh=awAXtSOyE739HVxs+BWTIvQJM8agJwCSO5/mhGJViAY=;
	h=From:To:Cc:Subject:Date:From;
	b=nXIGfnY/EnGL7d8tHmOmmzEhzVKcR4cMbPUDHdrHnREjSewYbxGYKy8VGOHBMj5lz
	 DKr2xrnvwzKXSrzJwf7kKZKnYlceuI59SZyTw70wq8klzUH66dle6stBpV2346ANKl
	 5gzeZLfWpLwZ17YljDzdshNTUOy5FJevRXcb5EWL+CUNimfx3lb9IfsaNeJjmZcSUN
	 DK0MN9LAmAmK6ExdM9R7noTpTZCVR6Y3LNtuc+3hwCfq9lGQyvUwkWzKn+3TvSPfls
	 kSq+nqdjBzqgKrmN4RZcZgkTDY6ws/u6r6iKVCedsJoYXEFOuEXPbaWY2k/379gIqt
	 GsZr5RgUBOgWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ronnie Sahlberg <rsahlberg@whamcloud.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 01/14] ublk: sanity check add_dev input for underflow
Date: Mon, 30 Jun 2025 16:46:26 -0400
Message-Id: <20250630204639.1358777-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.95
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
index df3e5aab4b5ac..8c873a8e39cd9 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2323,7 +2323,8 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	if (copy_from_user(&info, argp, sizeof(info)))
 		return -EFAULT;
 
-	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || info.nr_hw_queues > UBLK_MAX_NR_QUEUES)
+	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || !info.queue_depth ||
+	    info.nr_hw_queues > UBLK_MAX_NR_QUEUES || !info.nr_hw_queues)
 		return -EINVAL;
 
 	if (capable(CAP_SYS_ADMIN))
-- 
2.39.5

