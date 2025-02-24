Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B978B2AD14;
	Mon, 24 Feb 2025 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408243; cv=none; b=Nl2Y66/l1gWylOul79coi3R0F8OK/y0Up3l1+Vo9eCidBPwRP5FWXlKrzUfOVzJlXwmHWjaHuTxuXpBJpZTbd3sEQBKYLErSLXNKM5/cc/s2wadbm0VpgrCdOw66sJBmwRkqr7Th4NgjrqbyVKOs4OPAAsAeJqVW+XycmiIctIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408243; c=relaxed/simple;
	bh=03LoekPb77zKp95DhW1Y80rQZpYZWo+BwrQouH/36Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWtsIoygT/DoQIFAew1WgNcSu6pb3qAEBYcJjEvcDKI7Z0jDjJVZbXy3GzhqpRlJL7GesB1ROmB4Fdp7ambr+v4F8yaw1k7KoSobX5QZoS3Moyhne1c0Q30WUPd87kWpo6w/5O/FwXXByR22xoPMJzRj5yhO7W88y4U80mnXjxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0nyXMRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0nyXMRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253B0C4CEE6;
	Mon, 24 Feb 2025 14:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408243;
	bh=03LoekPb77zKp95DhW1Y80rQZpYZWo+BwrQouH/36Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0nyXMRh3j8dSejzWjUYHMp53A9TtF5v11J5ji+b68XMuc9zhXvaOhx3aGwaIyK0s
	 cmdfCo8XxJnrJbDjL/TTPiG9YnLTircZR/o2j+1eUK/VfQXzM967VcaGZvcmSxJFdJ
	 Dsj/JPgox6Jv+m98+QfxXNNGqNJ0HEI5/wAknwds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.6 134/140] md: Fix md_seq_ops() regressions
Date: Mon, 24 Feb 2025 15:35:33 +0100
Message-ID: <20250224142608.275068758@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8121,6 +8121,19 @@ static void status_unused(struct seq_fil
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
@@ -8262,20 +8275,10 @@ static int status_resync(struct seq_file
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
@@ -8286,7 +8289,6 @@ static void *md_seq_next(struct seq_file
 static void md_seq_stop(struct seq_file *seq, void *v)
 	__releases(&all_mddevs_lock)
 {
-	status_unused(seq);
 	spin_unlock(&all_mddevs_lock);
 }
 
@@ -8319,10 +8321,18 @@ static void md_bitmap_status(struct seq_
 
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
 
@@ -8403,6 +8413,10 @@ static int md_seq_show(struct seq_file *
 	spin_unlock(&mddev->lock);
 	mutex_unlock(&mddev->bitmap_info.mutex);
 	spin_lock(&all_mddevs_lock);
+
+	if (mddev == list_last_entry(&all_mddevs, struct mddev, all_mddevs))
+		status_unused(seq);
+
 	if (atomic_dec_and_test(&mddev->active))
 		__mddev_put(mddev);
 


