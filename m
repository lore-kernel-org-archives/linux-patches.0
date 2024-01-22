Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BFB5D909;
	Tue, 23 Jan 2024 00:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969771; cv=none; b=RIqNOKxcI6n+L//4QNnwSL2jK1h7ICPmy+UbU74hIjNiSnVMt17aXZpg4V6Tb2zmV3Z+WZ3CU55+rZluA8/y/CqlTTtgvor5Qii3bHLgPGzX/GqAY/SGdLEXwa70xtoj+7YJnYqinc/KrEaeNdtqx43zu+l0HGGfvBTPPM0b8wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969771; c=relaxed/simple;
	bh=kRwuIpKxgKz+6RpYRijGQjIlOSYrOv/1ayU4mJ1cksA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZcgD0cfePrAyy2YuRLfkWdBRlWw3btAbrfMywB04SJXF9COcs9zKDgVagC406hBuk/TC41DKPLlPW7A5nJxnFcIv4Uyz4V4zWK3hOaIpHiJuj/xzfRBEKIJIqCAl2gq/TvMw5U0pknVwHCGPuZMQ6VTDoRvzl0HdEmTj0bgJtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuqONe+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuqONe+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80631C43390;
	Tue, 23 Jan 2024 00:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969770;
	bh=kRwuIpKxgKz+6RpYRijGQjIlOSYrOv/1ayU4mJ1cksA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuqONe+bgmmnhiVcmFzFL9OH4FtQL2BxldKuIeItrRtkepzpeujcgG4FaHZmD3jTr
	 eEM63LOQ88axlW9q1sJQ8ZOmBcore29qUhgdv/3+fsRVof4L3cEH6Q4yoWktfPuXlQ
	 E/CsTevsmWYm4MuAAylvaENuJndu1kG4wOSsQMUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.7 439/641] md: Fix md_seq_ops() regressions
Date: Mon, 22 Jan 2024 15:55:43 -0800
Message-ID: <20240122235831.752230131@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

commit f9cfe7e7f96a9414a17d596e288693c4f2325d49 upstream.

Commit cf1b6d4441ff ("md: simplify md_seq_ops") introduce following
regressions:

1) If list all_mddevs is emptly, personalities and unused devices won't
   be showed to user anymore.
2) If seq_file buffer overflowed from md_seq_show(), then md_seq_start()
   will be called again, hence personalities will be showed to user
   again.
3) If seq_file buffer overflowed from md_seq_stop(), seq_read_iter()
   doesn't handle this, hence unused devices won't be showed to user.

Fix above problems by printing personalities and unused devices in
md_seq_show().

Fixes: cf1b6d4441ff ("md: simplify md_seq_ops")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240109133957.2975272-1-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |   40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8123,6 +8123,19 @@ static void status_unused(struct seq_fil
 	seq_printf(seq, "\n");
 }
 
+static void status_personalities(struct seq_file *seq)
+{
+	struct md_personality *pers;
+
+	seq_puts(seq, "Personalities : ");
+	spin_lock(&pers_lock);
+	list_for_each_entry(pers, &pers_list, list)
+		seq_printf(seq, "[%s] ", pers->name);
+
+	spin_unlock(&pers_lock);
+	seq_puts(seq, "\n");
+}
+
 static int status_resync(struct seq_file *seq, struct mddev *mddev)
 {
 	sector_t max_sectors, resync, res;
@@ -8264,20 +8277,10 @@ static int status_resync(struct seq_file
 static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(&all_mddevs_lock)
 {
-	struct md_personality *pers;
-
-	seq_puts(seq, "Personalities : ");
-	spin_lock(&pers_lock);
-	list_for_each_entry(pers, &pers_list, list)
-		seq_printf(seq, "[%s] ", pers->name);
-
-	spin_unlock(&pers_lock);
-	seq_puts(seq, "\n");
 	seq->poll_event = atomic_read(&md_event_count);
-
 	spin_lock(&all_mddevs_lock);
 
-	return seq_list_start(&all_mddevs, *pos);
+	return seq_list_start_head(&all_mddevs, *pos);
 }
 
 static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
@@ -8288,16 +8291,23 @@ static void *md_seq_next(struct seq_file
 static void md_seq_stop(struct seq_file *seq, void *v)
 	__releases(&all_mddevs_lock)
 {
-	status_unused(seq);
 	spin_unlock(&all_mddevs_lock);
 }
 
 static int md_seq_show(struct seq_file *seq, void *v)
 {
-	struct mddev *mddev = list_entry(v, struct mddev, all_mddevs);
+	struct mddev *mddev;
 	sector_t sectors;
 	struct md_rdev *rdev;
 
+	if (v == &all_mddevs) {
+		status_personalities(seq);
+		if (list_empty(&all_mddevs))
+			status_unused(seq);
+		return 0;
+	}
+
+	mddev = list_entry(v, struct mddev, all_mddevs);
 	if (!mddev_get(mddev))
 		return 0;
 
@@ -8373,6 +8383,10 @@ static int md_seq_show(struct seq_file *
 	}
 	spin_unlock(&mddev->lock);
 	spin_lock(&all_mddevs_lock);
+
+	if (mddev == list_last_entry(&all_mddevs, struct mddev, all_mddevs))
+		status_unused(seq);
+
 	if (atomic_dec_and_test(&mddev->active))
 		__mddev_put(mddev);
 


