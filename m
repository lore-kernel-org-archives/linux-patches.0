Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC751EA72
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9711C433C7;
	Tue, 25 Jul 2023 10:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282146;
	bh=5ASkLiLKJcNtSGllI/99fpPPkZrP9Kv1expKoO6neKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/fB6HqhZ2pLUR4P2RXCOK90yoh8pTant+hi9JSdbLSqip0SxkG/qpos2abOTySEw
	 kFshJmvmdGyyOo+2vH+drO7uC94MopWh0dCEewW3uhNy4Ps804ZN1/gBHpN8hVEoDV
	 GctXtgFyf4aO+RfNK/9FpYIWQ/lkcpuT+Xf0OkQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c0f3acf145cb465426d5@syzkaller.appspotmail.com,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 024/227] btrfs: fix race between balance and cancel/pause
Date: Tue, 25 Jul 2023 12:43:11 +0200
Message-ID: <20230725104515.807299925@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josef Bacik <josef@toxicpanda.com>

commit b19c98f237cd76981aaded52c258ce93f7daa8cb upstream.

Syzbot reported a panic that looks like this:

  assertion failed: fs_info->exclusive_operation == BTRFS_EXCLOP_BALANCE_PAUSED, in fs/btrfs/ioctl.c:465
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/messages.c:259!
  RIP: 0010:btrfs_assertfail+0x2c/0x30 fs/btrfs/messages.c:259
  Call Trace:
   <TASK>
   btrfs_exclop_balance fs/btrfs/ioctl.c:465 [inline]
   btrfs_ioctl_balance fs/btrfs/ioctl.c:3564 [inline]
   btrfs_ioctl+0x531e/0x5b30 fs/btrfs/ioctl.c:4632
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:870 [inline]
   __se_sys_ioctl fs/ioctl.c:856 [inline]
   __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

The reproducer is running a balance and a cancel or pause in parallel.
The way balance finishes is a bit wonky, if we were paused we need to
save the balance_ctl in the fs_info, but clear it otherwise and cleanup.
However we rely on the return values being specific errors, or having a
cancel request or no pause request.  If balance completes and returns 0,
but we have a pause or cancel request we won't do the appropriate
cleanup, and then the next time we try to start a balance we'll trip
this ASSERT.

The error handling is just wrong here, we always want to clean up,
unless we got -ECANCELLED and we set the appropriate pause flag in the
exclusive op.  With this patch the reproducer ran for an hour without
tripping, previously it would trip in less than a few minutes.

Reported-by: syzbot+c0f3acf145cb465426d5@syzkaller.appspotmail.com
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4071,14 +4071,6 @@ static int alloc_profile_is_valid(u64 fl
 	return has_single_bit_set(flags);
 }
 
-static inline int balance_need_close(struct btrfs_fs_info *fs_info)
-{
-	/* cancel requested || normal exit path */
-	return atomic_read(&fs_info->balance_cancel_req) ||
-		(atomic_read(&fs_info->balance_pause_req) == 0 &&
-		 atomic_read(&fs_info->balance_cancel_req) == 0);
-}
-
 /*
  * Validate target profile against allowed profiles and return true if it's OK.
  * Otherwise print the error message and return false.
@@ -4268,6 +4260,7 @@ int btrfs_balance(struct btrfs_fs_info *
 	u64 num_devices;
 	unsigned seq;
 	bool reducing_redundancy;
+	bool paused = false;
 	int i;
 
 	if (btrfs_fs_closing(fs_info) ||
@@ -4398,6 +4391,7 @@ int btrfs_balance(struct btrfs_fs_info *
 	if (ret == -ECANCELED && atomic_read(&fs_info->balance_pause_req)) {
 		btrfs_info(fs_info, "balance: paused");
 		btrfs_exclop_balance(fs_info, BTRFS_EXCLOP_BALANCE_PAUSED);
+		paused = true;
 	}
 	/*
 	 * Balance can be canceled by:
@@ -4426,8 +4420,8 @@ int btrfs_balance(struct btrfs_fs_info *
 		btrfs_update_ioctl_balance_args(fs_info, bargs);
 	}
 
-	if ((ret && ret != -ECANCELED && ret != -ENOSPC) ||
-	    balance_need_close(fs_info)) {
+	/* We didn't pause, we can clean everything up. */
+	if (!paused) {
 		reset_balance_state(fs_info);
 		btrfs_exclop_finish(fs_info);
 	}


