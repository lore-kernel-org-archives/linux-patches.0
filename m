Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EF847126C;
	Tue, 21 Jul 2026 18:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657620; cv=none; b=pUXtR/i4P58j+qenHkFmEHN0/rLXVGak2xMneE0HRhDqvBnHPzrjmQMOns96cMpR1spmPk+VaKL0iJK0U5k3Yz1l15yuecp8rI6qLy/8G8ehmk2KVvAjKRYFoSROnyQcNAWxAGXf2pN1D6CazhnJZnf0SkRvx+N/2kJS3AM48IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657620; c=relaxed/simple;
	bh=jjtx0goVQn0hFbf1cPfzl0ZKoagpRpqWrYcaVcLJgy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvWBx+qz7MRMzDSj+lKBmXUYImLpF52TvCkYNxQ6pEbGzFcSduN6aah0X6wYS2bKSzcrs9fOuu/CrdxqEMZT2DXcBVkrg6Mo1i2AZe5cmbzRRcSHllKvqTO1GUNufwHmGmuW4vp1mfbI6DGidzpRgKyD2g4HLLy8bfmLYUTo6PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ptxqdm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ptxqdm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E921F000E9;
	Tue, 21 Jul 2026 18:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657619;
	bh=8sU0NhF8lnCZCtABmwxkdGit1Msc2VkjfqvF7jutNSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Ptxqdm4YA/CJH8wtAs8yz697jpsgM7HppjwgoQ6Qt/wVcOSmcUo9DfXoFav9Tezi
	 uLimFj4C4Z9LFTP5sBlTIBN9lYheZ7D4ioXysivV6/KZMtZV6kyjLry/dj2p2TZWHV
	 XwFrN0UKRasU7UeuqoHVhtAyLBAdrmPoPgmKL7Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0831/1611] md: merge mddev has_superblock into mddev_flags
Date: Tue, 21 Jul 2026 17:15:47 +0200
Message-ID: <20260721152534.081298217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit fba4a980403d2f489bc680dbff7d7d2514e669f9 ]

There is not need to use a separate field in struct mddev, there are no
functional changes.

Link: https://lore.kernel.org/linux-raid/20260114171241.3043364-3-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Stable-dep-of: a286cb88ddb2 ("md/raid1: honor REQ_NOWAIT when waiting for behind writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 6 +++---
 drivers/md/md.h | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b7d47c018a12f5..a26dde7bdecdd5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6537,7 +6537,7 @@ int md_run(struct mddev *mddev)
 	 * the only valid external interface is through the md
 	 * device.
 	 */
-	mddev->has_superblocks = false;
+	clear_bit(MD_HAS_SUPERBLOCK, &mddev->flags);
 	rdev_for_each(rdev, mddev) {
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
@@ -6550,7 +6550,7 @@ int md_run(struct mddev *mddev)
 		}
 
 		if (rdev->sb_page)
-			mddev->has_superblocks = true;
+			set_bit(MD_HAS_SUPERBLOCK, &mddev->flags);
 
 		/* perform some consistency tests on the device.
 		 * We don't want the data to overlap the metadata,
@@ -9173,7 +9173,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 	rcu_read_unlock();
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
-	if (!mddev->has_superblocks)
+	if (!test_bit(MD_HAS_SUPERBLOCK, &mddev->flags))
 		return;
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
diff --git a/drivers/md/md.h b/drivers/md/md.h
index da312d4692858d..ce639f2b1d0a68 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -340,6 +340,7 @@ struct md_cluster_operations;
  *		   array is ready yet.
  * @MD_BROKEN: This is used to stop writes and mark array as failed.
  * @MD_DELETED: This device is being deleted
+ * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -356,6 +357,7 @@ enum mddev_flags {
 	MD_BROKEN,
 	MD_DO_DELETE,
 	MD_DELETED,
+	MD_HAS_SUPERBLOCK,
 };
 
 enum mddev_sb_flags {
@@ -622,7 +624,6 @@ struct mddev {
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
 
-	bool	has_superblocks:1;
 	bool	fail_last_dev:1;
 	bool	serialize_policy:1;
 };
-- 
2.53.0



