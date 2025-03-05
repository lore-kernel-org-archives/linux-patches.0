Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA572505A7;
	Wed,  5 Mar 2025 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197080; cv=none; b=SUlJ6Ry6ObgevofjhIJxoZTNim0mQ1lmZOB+GXVb9321+UtgwDPQGyaxt6oWAJOixQaSBs6yDgaJqTgqHYo4tfIpyFxT8SKgLhxHTximWHpLgJVen7KXBzXFH75QhVRwbezAY7GvPeybK8PzHT9MKm59QGOLvyRIJGIhPGz072E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197080; c=relaxed/simple;
	bh=OgmOHbxpeAQH0LEnhtJr4VEJQN0FW0jYDP0U0LKp4OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBsrIjCh+fvvbOo8yCAuJK3IvekKzGVmSDp7YRQLQf0vYGXwXF8TsOX2BB38dU3Q2kCRZBTL6BKFzvMs0f8ZrGHPR0CAZSPpja7bsHhdk3Is0MZmdpBvJry+i/fpyeLw02EoOmSOOkBb0DVx4/WlCMmzeQNSg4NreKgZkv2iI2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQ2NfEcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQ2NfEcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCA8C4CEE2;
	Wed,  5 Mar 2025 17:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197080;
	bh=OgmOHbxpeAQH0LEnhtJr4VEJQN0FW0jYDP0U0LKp4OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQ2NfEcy6Jo7pEjhZwDZsSO8DC7ntiQKow3v7IlrBnkXryLCgEkFynJMr/SUHllzC
	 Af9pixVszUWWRDXWCAQF94ML53xuI5FWL4OdCXnTNVIsvv/1YjwkmNwCpPdMTzQzzZ
	 qekybEqEyiv6tikLvmBqXD9jlhkRSp2q8KPjkFoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/176] md: simplify md_seq_ops
Date: Wed,  5 Mar 2025 18:46:13 +0100
Message-ID: <20250305174505.629628698@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit cf1b6d4441fffd0ba8ae4ced6a12f578c95ca049 ]

Before this patch, the implementation is hacky and hard to understand:

1) md_seq_start set pos to 1;
2) md_seq_show found pos is 1, then print Personalities;
3) md_seq_next found pos is 1, then it update pos to the first mddev;
4) md_seq_show found pos is not 1 or 2, show mddev;
5) md_seq_next found pos is not 1 or 2, update pos to next mddev;
6) loop 4-5 until the last mddev, then md_seq_next update pos to 2;
7) md_seq_show found pos is 2, then print unused devices;
8) md_seq_next found pos is 2, stop;

This patch remove the magic value and use seq_list_start/next/stop()
directly, and move printing "Personalities" to md_seq_start(),
"unsed devices" to md_seq_stop():

1) md_seq_start print Personalities, and then set pos to first mddev;
2) md_seq_show show mddev;
3) md_seq_next update pos to next mddev;
4) loop 2-3 until the last mddev;
5) md_seq_stop print unsed devices;

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230927061241.1552837-3-yukuai1@huaweicloud.com
Stable-dep-of: 8d28d0ddb986 ("md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 100 +++++++++++-------------------------------------
 1 file changed, 22 insertions(+), 78 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 44bac1e7d47e2..743244b06f679 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8250,105 +8250,46 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 }
 
 static void *md_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&all_mddevs_lock)
 {
-	struct list_head *tmp;
-	loff_t l = *pos;
-	struct mddev *mddev;
+	struct md_personality *pers;
 
-	if (l == 0x10000) {
-		++*pos;
-		return (void *)2;
-	}
-	if (l > 0x10000)
-		return NULL;
-	if (!l--)
-		/* header */
-		return (void*)1;
+	seq_puts(seq, "Personalities : ");
+	spin_lock(&pers_lock);
+	list_for_each_entry(pers, &pers_list, list)
+		seq_printf(seq, "[%s] ", pers->name);
+
+	spin_unlock(&pers_lock);
+	seq_puts(seq, "\n");
+	seq->poll_event = atomic_read(&md_event_count);
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each(tmp,&all_mddevs)
-		if (!l--) {
-			mddev = list_entry(tmp, struct mddev, all_mddevs);
-			if (!mddev_get(mddev))
-				continue;
-			spin_unlock(&all_mddevs_lock);
-			return mddev;
-		}
-	spin_unlock(&all_mddevs_lock);
-	if (!l--)
-		return (void*)2;/* tail */
-	return NULL;
+
+	return seq_list_start(&all_mddevs, *pos);
 }
 
 static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct list_head *tmp;
-	struct mddev *next_mddev, *mddev = v;
-	struct mddev *to_put = NULL;
-
-	++*pos;
-	if (v == (void*)2)
-		return NULL;
-
-	spin_lock(&all_mddevs_lock);
-	if (v == (void*)1) {
-		tmp = all_mddevs.next;
-	} else {
-		to_put = mddev;
-		tmp = mddev->all_mddevs.next;
-	}
-
-	for (;;) {
-		if (tmp == &all_mddevs) {
-			next_mddev = (void*)2;
-			*pos = 0x10000;
-			break;
-		}
-		next_mddev = list_entry(tmp, struct mddev, all_mddevs);
-		if (mddev_get(next_mddev))
-			break;
-		mddev = next_mddev;
-		tmp = mddev->all_mddevs.next;
-	}
-	spin_unlock(&all_mddevs_lock);
-
-	if (to_put)
-		mddev_put(to_put);
-	return next_mddev;
-
+	return seq_list_next(v, &all_mddevs, pos);
 }
 
 static void md_seq_stop(struct seq_file *seq, void *v)
+	__releases(&all_mddevs_lock)
 {
-	struct mddev *mddev = v;
-
-	if (mddev && v != (void*)1 && v != (void*)2)
-		mddev_put(mddev);
+	status_unused(seq);
+	spin_unlock(&all_mddevs_lock);
 }
 
 static int md_seq_show(struct seq_file *seq, void *v)
 {
-	struct mddev *mddev = v;
+	struct mddev *mddev = list_entry(v, struct mddev, all_mddevs);
 	sector_t sectors;
 	struct md_rdev *rdev;
 
-	if (v == (void*)1) {
-		struct md_personality *pers;
-		seq_printf(seq, "Personalities : ");
-		spin_lock(&pers_lock);
-		list_for_each_entry(pers, &pers_list, list)
-			seq_printf(seq, "[%s] ", pers->name);
-
-		spin_unlock(&pers_lock);
-		seq_printf(seq, "\n");
-		seq->poll_event = atomic_read(&md_event_count);
+	if (!mddev_get(mddev))
 		return 0;
-	}
-	if (v == (void*)2) {
-		status_unused(seq);
-		return 0;
-	}
 
+	spin_unlock(&all_mddevs_lock);
 	spin_lock(&mddev->lock);
 	if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks)) {
 		seq_printf(seq, "%s : %sactive", mdname(mddev),
@@ -8419,6 +8360,9 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "\n");
 	}
 	spin_unlock(&mddev->lock);
+	spin_lock(&all_mddevs_lock);
+	if (atomic_dec_and_test(&mddev->active))
+		__mddev_put(mddev);
 
 	return 0;
 }
-- 
2.39.5



