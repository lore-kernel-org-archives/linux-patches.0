Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000AB1E522;
	Thu, 30 Jan 2025 14:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247169; cv=none; b=NcOKlvx1EhCSLEt7UvaXu8xQlwSaTOcLu83GlqVotv97c7XbWF5Or3B9bLgqcobjmmhS6buSt3U6/uvUhyo/skGUwFbF4AcOYOYMQacuk5bUi2+tUeZ+3MsT9kVd0t8078XJ2Hc85N6Al0Kfk9vPgp5GMqFBztJha3ukjaseJOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247169; c=relaxed/simple;
	bh=mj05R9ycKLZelLZyEsf6zEL5CzECNq9HdDbKNiCcBaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXSmoirqRLn/TN935XGjqNVRpPzad4zgVNI8T3W1f+avVcKdQi5hOa/hnVIelgeM8ZXuJxUVJr6RbmnbKfVhqghhL42qutdO7BMrMFWhMTkTIwDH+Ios5PPyE+ZbZRR3/kM1gQVUFTJFaYLv41FTTjGL4QN2mo+7TvAyb74TvVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UINeGbOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UINeGbOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767B5C4CEE0;
	Thu, 30 Jan 2025 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247168;
	bh=mj05R9ycKLZelLZyEsf6zEL5CzECNq9HdDbKNiCcBaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UINeGbOJvx5SnMz/nUWbnifSiBP27F1U0XFedkBWIjilK4gtJKebEOjzAD43VnWCV
	 8o3PXe225tM5pSjG4LGGSdEP9gjGKUSx+gbLhbl80hntRdcmP+ITFtx14C8C4Dg0bd
	 jAgmcUnZ048d6MvG+1rFtbubwtQ+jlJM3jS3EWso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Abagail ren <renzezhongucas@gmail.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 106/133] blk-cgroup: Fix UAF in blkcg_unpin_online()
Date: Thu, 30 Jan 2025 15:01:35 +0100
Message-ID: <20250130140146.804744141@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,10 +428,14 @@ static inline void blkcg_pin_online(stru
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
 


