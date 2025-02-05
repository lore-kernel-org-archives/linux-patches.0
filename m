Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99BF1DC19F;
	Wed,  5 Feb 2025 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768257; cv=none; b=KjqasOu9HdaLZ5ug6qVB99vHcxxVaRYxJWRwyrxfDKeXFXdJUqudaCOGOyversEan4nHL/r0apgq8fkq5dx152Xu1YISWU3+Rc8S046igEPwtb8+Du8jb0s2s9/CnN0mzBzL1h3YR1Xi9HYQ/XCh4PUym6lrRg6d/KB0Gu38CUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768257; c=relaxed/simple;
	bh=dWtOlbqt6mx2TVlh/vqNomMFE1dCKAe9fpHyAhdKQIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ji2yHQ0ET1FtaUP+ZB7F1q5rg2KOrleZVSYF8Ftad9Cs0GRK8qEfDrm6RhP1nO8i4vRkdrmRlhaFnDDfjgeo1RbV10+RZUb/nrfBzfJ4OSOS+8za1TuebamVDgUyW/BWiNiz4RGNYaPoc7WEfyR+6gMe4Y88vG5hVglMITlkf60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/bWg8B0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/bWg8B0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6842C4CED6;
	Wed,  5 Feb 2025 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768256;
	bh=dWtOlbqt6mx2TVlh/vqNomMFE1dCKAe9fpHyAhdKQIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/bWg8B0cohW1vlZifsDjvr1nlZeDnMgpmDLB2TuB6qxC5YROM8Ma05eoNrJKkKPY
	 RBs6oY1uMo09a+F4HdtlwRNW6NpXy0llZliCENcjXC5jGTwpl4AjOkienici4jB4F+
	 1x8zvYALpYRxPqOewerL4Rh49ve7HIEdce7v13s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 574/590] md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime
Date: Wed,  5 Feb 2025 14:45:29 +0100
Message-ID: <20250205134517.226476671@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 8d28d0ddb986f56920ac97ae704cc3340a699a30 upstream.

After commit ec6bb299c7c3 ("md/md-bitmap: add 'sync_size' into struct
md_bitmap_stats"), following panic is reported:

Oops: general protection fault, probably for non-canonical address
RIP: 0010:bitmap_get_stats+0x2b/0xa0
Call Trace:
 <TASK>
 md_seq_show+0x2d2/0x5b0
 seq_read_iter+0x2b9/0x470
 seq_read+0x12f/0x180
 proc_reg_read+0x57/0xb0
 vfs_read+0xf6/0x380
 ksys_read+0x6c/0xf0
 do_syscall_64+0x82/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Root cause is that bitmap_get_stats() can be called at anytime if mddev
is still there, even if bitmap is destroyed, or not fully initialized.
Deferenceing bitmap in this case can crash the kernel. Meanwhile, the
above commit start to deferencing bitmap->storage, make the problem
easier to trigger.

Fix the problem by protecting bitmap_get_stats() with bitmap_info.mutex.

Cc: stable@vger.kernel.org # v6.12+
Fixes: 32a7627cf3a3 ("[PATCH] md: optimised resync using Bitmap based intent logging")
Reported-and-tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Closes: https://lore.kernel.org/linux-raid/ca3a91a2-50ae-4f68-b317-abd9889f3907@oracle.com/T/#m6e5086c95201135e4941fe38f9efa76daf9666c5
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250124092055.4050195-1-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-bitmap.c |    5 ++++-
 drivers/md/md.c        |    5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2355,7 +2355,10 @@ static int bitmap_get_stats(void *data,
 
 	if (!bitmap)
 		return -ENOENT;
-
+	if (bitmap->mddev->bitmap_info.external)
+		return -ENOENT;
+	if (!bitmap->storage.sb_page) /* no superblock */
+		return -EINVAL;
 	sb = kmap_local_page(bitmap->storage.sb_page);
 	stats->sync_size = le64_to_cpu(sb->sync_size);
 	kunmap_local(sb);
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8376,6 +8376,10 @@ static int md_seq_show(struct seq_file *
 		return 0;
 
 	spin_unlock(&all_mddevs_lock);
+
+	/* prevent bitmap to be freed after checking */
+	mutex_lock(&mddev->bitmap_info.mutex);
+
 	spin_lock(&mddev->lock);
 	if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks)) {
 		seq_printf(seq, "%s : ", mdname(mddev));
@@ -8451,6 +8455,7 @@ static int md_seq_show(struct seq_file *
 		seq_printf(seq, "\n");
 	}
 	spin_unlock(&mddev->lock);
+	mutex_unlock(&mddev->bitmap_info.mutex);
 	spin_lock(&all_mddevs_lock);
 
 	if (mddev == list_last_entry(&all_mddevs, struct mddev, all_mddevs))


