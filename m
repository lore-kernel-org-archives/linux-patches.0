Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4A64EC66A;
	Tue, 13 Oct 2026 12:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893340; cv=none; b=ZspNzGMjLq/6m/uEReisZLATzv3VeAwocPqRixEF6JmEHlLaT7DvElWrJs7HAaZMevUGyq/Wvzx0HM4IWPavq9ZzH3FcBtwW+qQ3t93Efk12z8aJAC7rjhmuGEHcT9C226+eWPhBZYsiZ1vDDjdUzPKJh7YREV224REqiZfUJPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893340; c=relaxed/simple;
	bh=xhSkwL/UMDwy2CEcL5G++9a60Pkwj+GD8yQVCnrYedY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxB89ixk6d7yHiBpRpd9VeiNl3M/ZS+b/Z1PCeLhKPwjGe6xNGt1RYttBMmIAd9UMSwwib9aiST2Uob9qlV/es46mBGlXTIUSvVTUjQIP8xOPWcjC4xK8cEd9NJtVcWInba2LCrNJyGym5LpLURE3cQHcSYG7uDg35DtFil7d0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrSnn9yG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrSnn9yG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EDB1F000FF;
	Tue, 13 Oct 2026 12:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893339;
	bh=0VgXbIo9l5LQGBtG/K9Nqn+N0DBjpos7hTbBo3U6JbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrSnn9yG7OdODLeFGPiurmTpQq8/3FwUEJY+6/ffQsCCcsorW55Cxdy+kMv96TZFO
	 SpMP19prqLD4bmNVKvBAFu+rZfJiYjEPPpHtrmKlP6YYM94i7oHw1bS20+/Q2I4czz
	 UCOcJHacoZdC+xGbYVpFpukrTlH6RAC/G1BASpvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 192/621] gfs2: Clean up quotad timeout handling
Date: Tue, 13 Oct 2026 13:33:07 +0200
Message-ID: <20261013112925.417826143@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 94f56488c7e47579aae8f20323c43d27b7b5f4ef ]

Instead of tracking the remaining time, track the deadline of each of
the timeouts.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: da6f5bbc2e79 ("gfs2: fix memory leaks in gfs2_fill_super error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 58 +++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 4620f586411a6..c301901ac392c 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1571,20 +1571,6 @@ static void quotad_error(struct gfs2_sbd *sdp, const char *msg, int error)
 	}
 }
 
-static void quotad_check_timeo(struct gfs2_sbd *sdp, const char *msg,
-			       int (*fxn)(struct super_block *sb, int type),
-			       unsigned long t, unsigned long *timeo,
-			       unsigned int *new_timeo)
-{
-	if (t >= *timeo) {
-		int error = fxn(sdp->sd_vfs, 0);
-		quotad_error(sdp, msg, error);
-		*timeo = gfs2_tune_get_i(&sdp->sd_tune, new_timeo) * HZ;
-	} else {
-		*timeo -= t;
-	}
-}
-
 void gfs2_wake_up_statfs(struct gfs2_sbd *sdp) {
 	if (!sdp->sd_statfs_force_sync) {
 		sdp->sd_statfs_force_sync = 1;
@@ -1602,34 +1588,44 @@ void gfs2_wake_up_statfs(struct gfs2_sbd *sdp) {
 int gfs2_quotad(void *data)
 {
 	struct gfs2_sbd *sdp = data;
-	struct gfs2_tune *tune = &sdp->sd_tune;
-	unsigned long statfs_timeo = 0;
-	unsigned long quotad_timeo = 0;
-	unsigned long t = 0;
+	unsigned long now = jiffies;
+	unsigned long statfs_deadline = now;
+	unsigned long quotad_deadline = now;
 
 	set_freezable();
 	while (!kthread_should_stop()) {
+		unsigned long t;
+
 		if (gfs2_withdrawing_or_withdrawn(sdp))
 			break;
 
-		/* Update the master statfs file */
-		if (sdp->sd_statfs_force_sync) {
-			int error = gfs2_statfs_sync(sdp->sd_vfs, 0);
+		now = jiffies;
+		if (sdp->sd_statfs_force_sync ||
+		    time_after(now, statfs_deadline)) {
+			unsigned int quantum;
+			int error;
+
+			/* Update the master statfs file */
+			error = gfs2_statfs_sync(sdp->sd_vfs, 0);
 			quotad_error(sdp, "statfs", error);
-			statfs_timeo = gfs2_tune_get(sdp, gt_statfs_quantum) * HZ;
+
+			quantum = gfs2_tune_get(sdp, gt_statfs_quantum);
+			statfs_deadline = now + quantum * HZ;
 		}
-		else
-			quotad_check_timeo(sdp, "statfs", gfs2_statfs_sync, t,
-				   	   &statfs_timeo,
-					   &tune->gt_statfs_quantum);
+		if (time_after(now, quotad_deadline)) {
+			unsigned int quantum;
+			int error;
 
-		/* Update quota file */
-		quotad_check_timeo(sdp, "sync", gfs2_quota_sync, t,
-				   &quotad_timeo, &tune->gt_quota_quantum);
+			/* Update the quota file */
+			error = gfs2_quota_sync(sdp->sd_vfs, 0);
+			quotad_error(sdp, "sync", error);
 
-		t = min(quotad_timeo, statfs_timeo);
+			quantum = gfs2_tune_get(sdp, gt_quota_quantum);
+			quotad_deadline = now + quantum * HZ;
+		}
 
-		t -= wait_event_freezable_timeout(sdp->sd_quota_wait,
+		t = min(statfs_deadline - now, quotad_deadline - now);
+		wait_event_freezable_timeout(sdp->sd_quota_wait,
 				sdp->sd_statfs_force_sync ||
 				gfs2_withdrawing_or_withdrawn(sdp) ||
 				kthread_should_stop(),
-- 
2.53.0



