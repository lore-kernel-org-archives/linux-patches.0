Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F2111719
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B08C433C7;
	Mon, 11 Sep 2023 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446144;
	bh=6oMWxhrb2eS5eANf1mRAKlS9nDPl2F7DHcYgXkoPJLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hz0hdKgK3LLo6VaepL/4xXIHyNbtdg7W03tLbKn9WnK6CpyLlmZdopyxOWRwLwjpL
	 TB+n0pvQ5rkERJIbcqNy7M+dhvPVibBXXlC9XPO0o1g/mJUpWqd16OwbwABl5b29C0
	 2EdiWwwy9skZW4D5kbZuaCvl26A6TVP4/rdJVAbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.1 597/600] md: fix regression for null-ptr-deference in __md_stop()
Date: Mon, 11 Sep 2023 15:50:30 +0200
Message-ID: <20230911134651.280884388@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 433279beba1d4872da10b7b60a539e0cb828b32b upstream.

Commit 3e453522593d ("md: Free resources in __md_stop") tried to fix
null-ptr-deference for 'active_io' by moving percpu_ref_exit() to
__md_stop(), however, the commit also moving 'writes_pending' to
__md_stop(), and this will cause mdadm tests broken:

BUG: kernel NULL pointer dereference, address: 0000000000000038
Oops: 0000 [#1] PREEMPT SMP
CPU: 15 PID: 17830 Comm: mdadm Not tainted 6.3.0-rc3-next-20230324-00009-g520d37
RIP: 0010:free_percpu+0x465/0x670
Call Trace:
 <TASK>
 __percpu_ref_exit+0x48/0x70
 percpu_ref_exit+0x1a/0x90
 __md_stop+0xe9/0x170
 do_md_stop+0x1e1/0x7b0
 md_ioctl+0x90c/0x1aa0
 blkdev_ioctl+0x19b/0x400
 vfs_ioctl+0x20/0x50
 __x64_sys_ioctl+0xba/0xe0
 do_syscall_64+0x6c/0xe0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

And the problem can be reporduced 100% by following test:

mdadm -CR /dev/md0 -l1 -n1 /dev/sda --force
echo inactive > /sys/block/md0/md/array_state
echo read-auto  > /sys/block/md0/md/array_state
echo inactive > /sys/block/md0/md/array_state

Root cause:

// start raid
raid1_run
 mddev_init_writes_pending
  percpu_ref_init

// inactive raid
array_state_store
 do_md_stop
  __md_stop
   percpu_ref_exit

// start raid again
array_state_store
 do_md_run
  raid1_run
   mddev_init_writes_pending
    if (mddev->writes_pending.percpu_count_ptr)
    // won't reinit

// inactive raid again
...
percpu_ref_exit
-> null-ptr-deference

Before the commit, 'writes_pending' is exited when mddev is freed, and
it's safe to restart raid because mddev_init_writes_pending() already make
sure that 'writes_pending' will only be initialized once.

Fix the prblem by moving 'writes_pending' back, it's a litter hard to find
the relationship between alloc memory and free memory, however, code
changes is much less and we lived with this for a long time already.

Fixes: 3e453522593d ("md: Free resources in __md_stop")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230328094400.1448955-1-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6278,7 +6278,6 @@ static void __md_stop(struct mddev *mdde
 	module_put(pers->owner);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 
-	percpu_ref_exit(&mddev->writes_pending);
 	percpu_ref_exit(&mddev->active_io);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
@@ -6293,6 +6292,7 @@ void md_stop(struct mddev *mddev)
 	 */
 	__md_stop_writes(mddev);
 	__md_stop(mddev);
+	percpu_ref_exit(&mddev->writes_pending);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
@@ -7859,6 +7859,7 @@ static void md_free_disk(struct gendisk
 {
 	struct mddev *mddev = disk->private_data;
 
+	percpu_ref_exit(&mddev->writes_pending);
 	mddev_free(mddev);
 }
 


