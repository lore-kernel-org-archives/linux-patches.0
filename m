Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83506405C3F;
	Fri,  4 Sep 2026 06:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501901; cv=none; b=TN/Hw6nqNlCKCHxVpUQKvm5T6DLiEBnLvj+qg1QIhYxMbDdxMnhffZkQLvJvIvfENCbVzKt27HcdUHIzwDYTwMkkYpPmgLm9KiOvQcELpymNAWgUy+cBHYQxEGF7l4B6PUpdZo/FA6SvmIGqAbBwWfmuHflF8bh5Ld+4xeuGAHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501901; c=relaxed/simple;
	bh=tSqQ1eJBu1U4xQ4auJLd8/PKYzEcsfirjMedk5rTbDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNdjb71HDZlf9QD560NDppWQfuBNjkCt0GET15oAwqSEaXSXj9FnEFLiUz1/2VTBWR5uUtLcb4IkgXMI5Vi3q/5lbr7Nt7OyVW2uMEKfHUdFwwaLvk2GJkCniqLRtMYLK1j8VZtt+O1y8xKP+lYdWqF9PeMD0odGSbce6/I/3DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kndeJ/o8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kndeJ/o8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99071F00A3D;
	Fri,  4 Sep 2026 06:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501900;
	bh=mpgLxLf4/AbXFyGnwM0d77oQHAfJ1RjWju/aPR76gGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kndeJ/o8nFtZXMcgRztdqTYUgjnRNcGwdAEC5UjG/42HRbbvcjQw3sdqDc8PWBh6q
	 csb2NfjqJ4YInxQdAmY2f2IM1fGD0EMHj1yahCM9oBuPUXvYf4VBQUA6PYKUSMuFRl
	 Cqj0LrBfTrEdSvYDOai67A+y6lOLC8RDzF5a9v8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/403] md: make rdev_addable usable for rcu mode
Date: Fri,  4 Sep 2026 06:56:45 +0200
Message-ID: <20260904045734.863346883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit 13017b427118f4311471ee47df74872372ca8482 ]

Our testcase trigger panic:

BUG: kernel NULL pointer dereference, address: 00000000000000e0
...
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 2 UID: 0 PID: 85 Comm: kworker/2:1 Not tainted 6.16.0+ #94
PREEMPT(none)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.1-2.fc37 04/01/2014
Workqueue: md_misc md_start_sync
RIP: 0010:rdev_addable+0x4d/0xf0
...
Call Trace:
 <TASK>
 md_start_sync+0x329/0x480
 process_one_work+0x226/0x6d0
 worker_thread+0x19e/0x340
 kthread+0x10f/0x250
 ret_from_fork+0x14d/0x180
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in: raid10
CR2: 00000000000000e0
---[ end trace 0000000000000000 ]---
RIP: 0010:rdev_addable+0x4d/0xf0

md_spares_need_change in md_start_sync will call rdev_addable which
protected by rcu_read_lock/rcu_read_unlock. This rcu context will help
protect rdev won't be released, but rdev->mddev will be set to NULL
before we call synchronize_rcu in md_kick_rdev_from_array. Fix this by
using READ_ONCE and check does rdev->mddev still alive.

Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
Fixes: 570b9147deb6 ("md: use RCU lock to protect traversal in md_spares_need_change()")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250731114530.776670-1-yangerkun@huawei.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1aff3e541ceb5..60a07d7264d83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9373,6 +9373,12 @@ static bool rdev_is_spare(struct md_rdev *rdev)
 
 static bool rdev_addable(struct md_rdev *rdev)
 {
+	struct mddev *mddev;
+
+	mddev = READ_ONCE(rdev->mddev);
+	if (!mddev)
+		return false;
+
 	/* rdev is already used, don't add it again. */
 	if (test_bit(Candidate, &rdev->flags) || rdev->raid_disk >= 0 ||
 	    test_bit(Faulty, &rdev->flags))
@@ -9383,7 +9389,7 @@ static bool rdev_addable(struct md_rdev *rdev)
 		return true;
 
 	/* Allow to add if array is read-write. */
-	if (md_is_rdwr(rdev->mddev))
+	if (md_is_rdwr(mddev))
 		return true;
 
 	/*
-- 
2.53.0



