Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB8519539F;
	Wed,  5 Feb 2025 15:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768633; cv=none; b=W+qKMfY699CIyvv3u4WX3AeISiMBpSAr5jW++R8BLuYz+tqpvCR+t+ILvxOUfwd2GdVixljmlUqx9KXoe69BE8CbZp2HgfR9tap4aNKt3JXzKdhbzzqqj7WWmlnOaJn5SSSr6qfFCEHOQ6sikeAU7s5+YhxlwQTUaeQv2DbStC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768633; c=relaxed/simple;
	bh=2JA+cB1Q61buXmlWvPjEPsbBMk9eyajoFHM8tCZdqiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaa/o0ig7o/KAweJ7//Z9jKoPKmKZv/Pzjf3utrVeUMOz3H55BJfwimkbcmjiyKZDDQEwpKyoQD0ZsNyJsa+652LMpWwDxd7std7NxCoq2P5F/liHnBvwGxMQyzQVdlB0EiujpnfbM8EoRaWjPIjrcHqWgzoLb/iCVgBz/XBR5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnYkRWwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnYkRWwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E8BC4CED1;
	Wed,  5 Feb 2025 15:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768633;
	bh=2JA+cB1Q61buXmlWvPjEPsbBMk9eyajoFHM8tCZdqiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnYkRWwFDkt5kQuhZlcONYh3xMiMRn+9eQzRpNyX595mOfW7QMLUYYPSYp0OJVFMF
	 kIjqItzymLxYfbgTXWHn2v8wvro0LyAA5mJ3uWtagOK1sXxPOVvJierMqlJK65Juls
	 s48+UiMNna/0PIRhRa59JEqL3flxO+NhV8CrD4f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.13 612/623] md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime
Date: Wed,  5 Feb 2025 14:45:54 +0100
Message-ID: <20250205134519.630524584@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


