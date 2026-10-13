Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817CB4EA367;
	Tue, 13 Oct 2026 12:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893700; cv=none; b=owcrIxWbioc+q9kuJgI3WDBHkXbNZ2d3zpckksp8bRK9deCnNNIiSRX2FHQ8eluatupcMPBWUAkMWpCb9B7z73XxHCZtbz4poE4srRzen9KVaUVB1pbpdoBoRGoCK/cdw6IbIS0scxcjtiU6w6SPlRNSIYZ0iYBumPL/cfA5pbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893700; c=relaxed/simple;
	bh=iwhMCuDETr4yZaxmtIhlolY0j6fP7zbas9iioY5B2mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGtJauO3X84oYJYBZbjPaWMFdTrSel9Ieei/2KXYNo7q6EX/3TgNsBDrifAWyLt4HMlHKWm2nlWkztyiS8b9hDWGAFwTBoqrgv8OsoIcy+EgmJzE8gCQHXr6MalJxZVkfdudUXHxzUo+0lduQocVaV94aTfypn32XNLMGjo5mjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWjO8u1q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWjO8u1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816151F000FF;
	Tue, 13 Oct 2026 12:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893699;
	bh=cJXeY71XhzPemwjYwFvftGXwTKxO9geuUv99JZR7oF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWjO8u1qn97Nj+SasG/irzMJa1zU/2W3wKC1LXfKjN8zc3BcOIH37KPFrJGqiC+0K
	 kLu/6v3P8xKEEBkQILQo8lme6dJT2MS2auz8iJssVlzco/9I3m24+ZDf70QQ0NYLQ0
	 B1GoJ50DFhLKg47cod0jUXV+Bfz4EDby/RRVS3qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 314/621] md/raid1,raid10: fix deadlock in read error recovery path
Date: Tue, 13 Oct 2026 13:35:09 +0200
Message-ID: <20261013112928.306027292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 7b15c24f805339a585cfe7d72f446b7e88b9bcc0 ]

raid1d and raid10d may resubmit a split md cloned bio while handling
a read error. In this case, resubmitting the bio can lead to a deadlock
if the array is suspended before md_handle_request() acquires an
active_io reference via percpu_ref_tryget_live().

Since the cloned bio already holds an active_io reference,
trying to acquire another reference via percpu_ref_tryget_live()
can lead to a deadlock while the array is suspended.

Fix this by using percpu_ref_get() for md cloned bios.

Fixes: bb2a9acefaf9 ("md/raid1: switch to use md_account_bio() for io accounting")
Fixes: 820455238366 ("md/raid10: switch to use md_account_bio() for io accounting")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Reviewed-by: Xiao Ni <xiao@kernel.org>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260501114652.590037-2-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Stable-dep-of: ba976e350111 ("md/raid1,raid10: fix bio accounting for split md cloned bios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 25 ++++++++++++++++---------
 drivers/md/md.h |  5 +++++
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8e96a0ff2b267..ee147b265a661 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -396,17 +396,24 @@ static bool is_suspended(struct mddev *mddev, struct bio *bio)
 bool md_handle_request(struct mddev *mddev, struct bio *bio)
 {
 check_suspended:
-	if (is_suspended(mddev, bio)) {
-		/* Bail out if REQ_NOWAIT is set for the bio */
-		if (bio->bi_opf & REQ_NOWAIT) {
-			bio_wouldblock_error(bio);
-			return true;
+	if (unlikely(md_cloned_bio(mddev, bio))) {
+		/*
+		 * This bio is an MD cloned bio and already holds an
+		 * active_io reference, so percpu_ref_get() is safe here.
+		 */
+		percpu_ref_get(&mddev->active_io);
+	} else {
+		if (is_suspended(mddev, bio)) {
+			/* Bail out if REQ_NOWAIT is set for the bio */
+			if (bio->bi_opf & REQ_NOWAIT) {
+				bio_wouldblock_error(bio);
+				return true;
+			}
+			wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
 		}
-		wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
+		if (!percpu_ref_tryget_live(&mddev->active_io))
+			goto check_suspended;
 	}
-	if (!percpu_ref_tryget_live(&mddev->active_io))
-		goto check_suspended;
-
 	if (!mddev->pers->make_request(mddev, bio)) {
 		percpu_ref_put(&mddev->active_io);
 		if (!mddev->gendisk && mddev->pers->prepare_suspend)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bba0f6790c035..cab3d7360b098 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1043,6 +1043,11 @@ void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
 
 extern const struct block_device_operations md_fops;
 
+static inline bool md_cloned_bio(struct mddev *mddev, struct bio *bio)
+{
+	return bio->bi_pool == &mddev->io_clone_set;
+}
+
 /*
  * MD devices can be used undeneath by DM, in which case ->gendisk is NULL.
  */
-- 
2.53.0



