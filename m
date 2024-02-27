Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7228913B293;
	Tue, 27 Feb 2024 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041085; cv=none; b=DWSDtG0GK97+0APGMoNGImACPjIFHf6QalEBJoeg0N1MCqUN8l75JWBa4vjd+mgpq7Iq3cA4pbBqfmk2rFU9N/OiIEyUTSjThXc/CKohgRrjuiGYlMyGQiuX3ALXG9KHT49gdYEFYq66ABy7xAysy9PXS0sBYXXPxuV4GGuxzZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041085; c=relaxed/simple;
	bh=6H//1oSBSCmlEZGb5Ep3QbeqEW9gzkOFWIEtqiveX/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozMOlZL1ghgmMg3yrYbTW8IaPn7i6Jf4mqvOPJhyzVEFiTfMxmkJqzr4iqdT6jQ1vqLb+2AeTZoib2IoHDgl3shUraots2zIYGyWIbjpq0uv8s3dBdXjQzBWY6pwp8SKf1zFRCUvjzGdjlBJuaBpUHUL7P2WdilZLscibEBZnF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zod/z4Im; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zod/z4Im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27A1C43394;
	Tue, 27 Feb 2024 13:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041085;
	bh=6H//1oSBSCmlEZGb5Ep3QbeqEW9gzkOFWIEtqiveX/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zod/z4ImAWxbkEu/xGFJf8r4/gsXAKGyXt7HNdxT9ikGf7ASKxC+pJShMHBn0KDQP
	 qRK2XcDYcPFDRaD0drIQ7SwukfISdxsZdrNkHXb4RX2h+nhmDTiBfT9CFoqvf/Zm6/
	 h3KDq0WXFFpZUzxu6wDSNEYC/3n48fKkbC/IEWdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.7 185/334] md: Dont register sync_thread for reshape directly
Date: Tue, 27 Feb 2024 14:20:43 +0100
Message-ID: <20240227131636.620793397@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit ad39c08186f8a0f221337985036ba86731d6aafe upstream.

Currently, if reshape is interrupted, then reassemble the array will
register sync_thread directly from pers->run(), in this case
'MD_RECOVERY_RUNNING' is set directly, however, there is no guarantee
that md_do_sync() will be executed, hence stop_sync_thread() will hang
because 'MD_RECOVERY_RUNNING' can't be cleared.

Last patch make sure that md_do_sync() will set MD_RECOVERY_DONE,
however, following hang can still be triggered by dm-raid test
shell/lvconvert-raid-reshape.sh occasionally:

[root@fedora ~]# cat /proc/1982/stack
[<0>] stop_sync_thread+0x1ab/0x270 [md_mod]
[<0>] md_frozen_sync_thread+0x5c/0xa0 [md_mod]
[<0>] raid_presuspend+0x1e/0x70 [dm_raid]
[<0>] dm_table_presuspend_targets+0x40/0xb0 [dm_mod]
[<0>] __dm_destroy+0x2a5/0x310 [dm_mod]
[<0>] dm_destroy+0x16/0x30 [dm_mod]
[<0>] dev_remove+0x165/0x290 [dm_mod]
[<0>] ctl_ioctl+0x4bb/0x7b0 [dm_mod]
[<0>] dm_ctl_ioctl+0x11/0x20 [dm_mod]
[<0>] vfs_ioctl+0x21/0x60
[<0>] __x64_sys_ioctl+0xb9/0xe0
[<0>] do_syscall_64+0xc6/0x230
[<0>] entry_SYSCALL_64_after_hwframe+0x6c/0x74

Meanwhile mddev->recovery is:
MD_RECOVERY_RUNNING |
MD_RECOVERY_INTR |
MD_RECOVERY_RESHAPE |
MD_RECOVERY_FROZEN

Fix this problem by remove the code to register sync_thread directly
from raid10 and raid5. And let md_check_recovery() to register
sync_thread.

Fixes: f67055780caa ("[PATCH] md: Checkpoint and allow restart of raid5 reshape")
Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240201092559.910982-5-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c     |    5 ++++-
 drivers/md/raid10.c |   16 ++--------------
 drivers/md/raid5.c  |   29 ++---------------------------
 3 files changed, 8 insertions(+), 42 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9422,6 +9422,7 @@ static void md_start_sync(struct work_st
 	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
 	int spares = 0;
 	bool suspend = false;
+	char *name;
 
 	if (md_spares_need_change(mddev))
 		suspend = true;
@@ -9454,8 +9455,10 @@ static void md_start_sync(struct work_st
 	if (spares)
 		md_bitmap_write_all(mddev->bitmap);
 
+	name = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
+			"reshape" : "resync";
 	rcu_assign_pointer(mddev->sync_thread,
-			   md_register_thread(md_do_sync, mddev, "resync"));
+			   md_register_thread(md_do_sync, mddev, name));
 	if (!mddev->sync_thread) {
 		pr_warn("%s: could not start resync thread...\n",
 			mdname(mddev));
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4307,11 +4307,7 @@ static int raid10_run(struct mddev *mdde
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-		rcu_assign_pointer(mddev->sync_thread,
-			md_register_thread(md_do_sync, mddev, "reshape"));
-		if (!mddev->sync_thread)
-			goto out_free_conf;
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
 
 	return 0;
@@ -4707,16 +4703,8 @@ out:
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-
-	rcu_assign_pointer(mddev->sync_thread,
-			   md_register_thread(md_do_sync, mddev, "reshape"));
-	if (!mddev->sync_thread) {
-		ret = -EAGAIN;
-		goto abort;
-	}
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_wakeup_thread(mddev->sync_thread);
 	md_new_event();
 	return 0;
 
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8002,11 +8002,7 @@ static int raid5_run(struct mddev *mddev
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-		rcu_assign_pointer(mddev->sync_thread,
-			md_register_thread(md_do_sync, mddev, "reshape"));
-		if (!mddev->sync_thread)
-			goto abort;
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
 
 	/* Ok, everything is just fine now */
@@ -8585,29 +8581,8 @@ static int raid5_start_reshape(struct md
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-	rcu_assign_pointer(mddev->sync_thread,
-			   md_register_thread(md_do_sync, mddev, "reshape"));
-	if (!mddev->sync_thread) {
-		mddev->recovery = 0;
-		spin_lock_irq(&conf->device_lock);
-		write_seqcount_begin(&conf->gen_lock);
-		mddev->raid_disks = conf->raid_disks = conf->previous_raid_disks;
-		mddev->new_chunk_sectors =
-			conf->chunk_sectors = conf->prev_chunk_sectors;
-		mddev->new_layout = conf->algorithm = conf->prev_algo;
-		rdev_for_each(rdev, mddev)
-			rdev->new_data_offset = rdev->data_offset;
-		smp_wmb();
-		conf->generation --;
-		conf->reshape_progress = MaxSector;
-		mddev->reshape_position = MaxSector;
-		write_seqcount_end(&conf->gen_lock);
-		spin_unlock_irq(&conf->device_lock);
-		return -EAGAIN;
-	}
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_wakeup_thread(mddev->sync_thread);
 	md_new_event();
 	return 0;
 }


