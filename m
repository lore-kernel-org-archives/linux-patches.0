Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB07878B61;
	Tue, 27 Feb 2024 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041079; cv=none; b=ltaPeAEXyRY+99lPt/XvUHlavmTHvLdYPkxfAeWXmnQkRyiGnqz0U6nZ1TuVOhUAcm7JxLbHUU0GWp3gGhxkqTfuw+C4zsdjEOvRL1M8hhFOlAYnJuGmQjyyDU58755Z8aehrnULDdJLBVRPvvnvo6pfnpOVp3PA3V38GaV519U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041079; c=relaxed/simple;
	bh=zZAKCmFTNNMLdglrSyJCwq1NcgURBNnM5XBq4+UJZ2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8SliCOCAhlnI0e8vEJ+GceDGxUGwE2RMhRIcoQ4zHn8Q3TjeWFhx/HHQXzOBNdFd3gZCtYb4Nwxps/RbS7fd4K+5r9Y5WCnwmnoGo4AZvefNYdXUNRifox2ycPId8oPvTK2dqZL8KkDtTHIDDXRrPSc+D/40KLJpND0yR+ubUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tnr62cLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tnr62cLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B65BC433B1;
	Tue, 27 Feb 2024 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041079;
	bh=zZAKCmFTNNMLdglrSyJCwq1NcgURBNnM5XBq4+UJZ2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tnr62cLXxPvuH3GNt9DqyTDgLM0HHA/d2dTJVNqOBSMVFWIwJTwB0eR5Gi6GZhj3a
	 EBpLC8VPyEJG8Yoj1kFFoqd+6lRs1LNbkztadCrvjkJUlHWY/TERHDefY3/FZyX9gQ
	 04ndFELz3v/CqEt2zo3IjJQI8tZzifZrvGDdXJvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.7 183/334] md: Dont ignore read-only array in md_check_recovery()
Date: Tue, 27 Feb 2024 14:20:41 +0100
Message-ID: <20240227131636.539148132@linuxfoundation.org>
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

commit 55a48ad2db64737f7ffc0407634218cc6e4c513b upstream.

Usually if the array is not read-write, md_check_recovery() won't
register new sync_thread in the first place. And if the array is
read-write and sync_thread is registered, md_set_readonly() will
unregister sync_thread before setting the array read-only. md/raid
follow this behavior hence there is no problem.

After commit f52f5c71f3d4 ("md: fix stopping sync thread"), following
hang can be triggered by test shell/integrity-caching.sh:

1) array is read-only. dm-raid update super block:
rs_update_sbs
 ro = mddev->ro
 mddev->ro = 0
  -> set array read-write
 md_update_sb

2) register new sync thread concurrently.

3) dm-raid set array back to read-only:
rs_update_sbs
 mddev->ro = ro

4) stop the array:
raid_dtr
 md_stop
  stop_sync_thread
    set_bit(MD_RECOVERY_INTR, &mddev->recovery);
    md_wakeup_thread_directly(mddev->sync_thread);
    wait_event(..., !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))

5) sync thread done:
 md_do_sync
 set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 md_wakeup_thread(mddev->thread);

6) daemon thread can't unregister sync thread:
 md_check_recovery
  if (!md_is_rdwr(mddev) &&
      !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
   return;
  -> -> MD_RECOVERY_RUNNING can't be cleared, hence step 4 hang;

The root cause is that dm-raid manipulate 'mddev->ro' by itself,
however, dm-raid really should stop sync thread before setting the
array read-only. Unfortunately, I need to read more code before I
can refacter the handler of 'mddev->ro' in dm-raid, hence let's fix
the problem the easy way for now to prevent dm-raid regression.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Closes: https://lore.kernel.org/all/9801e40-8ac7-e225-6a71-309dcf9dc9aa@redhat.com/
Fixes: ecbfb9f118bc ("dm raid: add raid level takeover support")
Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240201092559.910982-3-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9495,6 +9495,20 @@ not_running:
 		sysfs_notify_dirent_safe(mddev->sysfs_action);
 }
 
+static void unregister_sync_thread(struct mddev *mddev)
+{
+	if (!test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
+		/* resync/recovery still happening */
+		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		return;
+	}
+
+	if (WARN_ON_ONCE(!mddev->sync_thread))
+		return;
+
+	md_reap_sync_thread(mddev);
+}
+
 /*
  * This routine is regularly called by all per-raid-array threads to
  * deal with generic issues like resync and super-block update.
@@ -9532,7 +9546,8 @@ void md_check_recovery(struct mddev *mdd
 	}
 
 	if (!md_is_rdwr(mddev) &&
-	    !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
+	    !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) &&
+	    !test_bit(MD_RECOVERY_DONE, &mddev->recovery))
 		return;
 	if ( ! (
 		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
@@ -9554,8 +9569,7 @@ void md_check_recovery(struct mddev *mdd
 			struct md_rdev *rdev;
 
 			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-				/* sync_work already queued. */
-				clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+				unregister_sync_thread(mddev);
 				goto unlock;
 			}
 
@@ -9618,16 +9632,7 @@ void md_check_recovery(struct mddev *mdd
 		 * still set.
 		 */
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-			if (!test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
-				/* resync/recovery still happening */
-				clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-				goto unlock;
-			}
-
-			if (WARN_ON_ONCE(!mddev->sync_thread))
-				goto unlock;
-
-			md_reap_sync_thread(mddev);
+			unregister_sync_thread(mddev);
 			goto unlock;
 		}
 


