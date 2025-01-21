Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627981F7080;
	Tue, 21 Jan 2025 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483116; cv=none; b=O7VgmlBwy053IeJZxbbBAS0SY+k+YLRVFYPVsDqD5kUlF4raa171eRw55U6dN4lpxD/vVa2aDjJ98vdFm6ymqC0yaZJblHlMvTOd14zxeygZpgJOJB3rQ6z/7Ar8kt2N0Qsk6klEjlpAE7puEKX2SBfc1EnTFZfiKUGfRdyQzZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483116; c=relaxed/simple;
	bh=YYnyDiCZTRQmj0n3swrKHqVrz1IGa4HECNNloZjql9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovyIjga8S1fiM6SkfmzJ4t1NnSIXzhuOw28h3wWQZM/va5e5YJKbY6nT0CjpcXTVpgqxDa8703kxFEQdJ+tScV7urYu5/1z/OoiAvpNO+sKgOQSKId9HyiVWE3hzAur5N27puGt/kYKUOrFK+vWXBHh/EHcJoQNw6pGSkrwPob0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulmvuJhg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulmvuJhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF294C4CEDF;
	Tue, 21 Jan 2025 18:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483116;
	bh=YYnyDiCZTRQmj0n3swrKHqVrz1IGa4HECNNloZjql9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulmvuJhge4bRTa3HPRqYYaoDzFS8XdgRlrAN2AGoau4DMSUne7U7fJJwHRGUSR8oX
	 PYAopXUKcLXSt7o3bO+vGLk1Zt2moqIb409vg4ORHnYpa4D9YbszUBMqU4I37nXLU4
	 C+CY4osiuM+p4W0LyFyoiEktPaqiIFHm0HabGM34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Abagail ren <renzezhongucas@gmail.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 121/127] blk-cgroup: Fix UAF in blkcg_unpin_online()
Date: Tue, 21 Jan 2025 18:53:13 +0100
Message-ID: <20250121174534.303943517@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 86e6ca55b83c575ab0f2e105cf08f98e58d3d7af upstream.

blkcg_unpin_online() walks up the blkcg hierarchy putting the online pin. To
walk up, it uses blkcg_parent(blkcg) but it was calling that after
blkcg_destroy_blkgs(blkcg) which could free the blkcg, leading to the
following UAF:

  ==================================================================
  BUG: KASAN: slab-use-after-free in blkcg_unpin_online+0x15a/0x270
  Read of size 8 at addr ffff8881057678c0 by task kworker/9:1/117

  CPU: 9 UID: 0 PID: 117 Comm: kworker/9:1 Not tainted 6.13.0-rc1-work-00182-gb8f52214c61a-dirty #48
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS unknown 02/02/2022
  Workqueue: cgwb_release cgwb_release_workfn
  Call Trace:
   <TASK>
   dump_stack_lvl+0x27/0x80
   print_report+0x151/0x710
   kasan_report+0xc0/0x100
   blkcg_unpin_online+0x15a/0x270
   cgwb_release_workfn+0x194/0x480
   process_scheduled_works+0x71b/0xe20
   worker_thread+0x82a/0xbd0
   kthread+0x242/0x2c0
   ret_from_fork+0x33/0x70
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  ...
  Freed by task 1944:
   kasan_save_track+0x2b/0x70
   kasan_save_free_info+0x3c/0x50
   __kasan_slab_free+0x33/0x50
   kfree+0x10c/0x330
   css_free_rwork_fn+0xe6/0xb30
   process_scheduled_works+0x71b/0xe20
   worker_thread+0x82a/0xbd0
   kthread+0x242/0x2c0
   ret_from_fork+0x33/0x70
   ret_from_fork_asm+0x1a/0x30

Note that the UAF is not easy to trigger as the free path is indirected
behind a couple RCU grace periods and a work item execution. I could only
trigger it with artifical msleep() injected in blkcg_unpin_online().

Fix it by reading the parent pointer before destroying the blkcg's blkg's.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Abagail ren <renzezhongucas@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Fixes: 4308a434e5e0 ("blkcg: don't offline parent blkcg first")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk-cgroup.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -433,10 +433,14 @@ static inline void blkcg_pin_online(stru
 static inline void blkcg_unpin_online(struct blkcg *blkcg)
 {
 	do {
+		struct blkcg *parent;
+
 		if (!refcount_dec_and_test(&blkcg->online_pin))
 			break;
+
+		parent = blkcg_parent(blkcg);
 		blkcg_destroy_blkgs(blkcg);
-		blkcg = blkcg_parent(blkcg);
+		blkcg = parent;
 	} while (blkcg);
 }
 


