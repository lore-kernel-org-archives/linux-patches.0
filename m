Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F911774B;
	Thu, 18 Jan 2024 10:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575452; cv=none; b=F/jf/vbjf+Va76MG2nKgdjJ9tFQiF67H+kd/kLBbge6zbjPjhYwF7LVCb0LmA3BN4qrrFRb81NZgFGzF5ZPLdIkDa+nmZ5navExKlB8135sXU+6+XXbOcMqdwMP/WMY+eUdAQzFsYYu4x80/vdyRZtMreTD1k45HIa6cnrwvm4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575452; c=relaxed/simple;
	bh=s4v6moDL3072uoFs+GrdPStM08R8NOVL9tbOPqMtcEc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=HOX6MZtBAbXLSoVpfD/b3uBuVfZmycpNfBz0GnQXOou+B19VXsLwtBtxabZdzEP4RpMFEe3RYtYeq9k2ztoySR6AUjax4Qhs3dEHNAhvmplr99MYRfMFbzmUp/HIcjNOXY6wuGxmgjQZs/zNL9VzSod385rkhS9WKzyukxVvu+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5OAyqLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5OAyqLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8439C433F1;
	Thu, 18 Jan 2024 10:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575452;
	bh=s4v6moDL3072uoFs+GrdPStM08R8NOVL9tbOPqMtcEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5OAyqLChvkMH0EPB+DMvfSht57apPdi2Vi96XMf5r86QNFaK3nz11PyKIGr4woU7
	 Z36drC44bN8HaeypmOOegnEq3kcBPfCgpH6Rfza+0GpQ/R5m43Gcd/GGHYTWbfgT/I
	 BA3O8uEJhWrsy4VLpNYOkQLIHy9gcNX5NHqg5AWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.6 138/150] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"
Date: Thu, 18 Jan 2024 11:49:20 +0100
Message-ID: <20240118104326.440578789@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

commit bed9e27baf52a09b7ba2a3714f1e24e17ced386d upstream.

This reverts commit 5e2cf333b7bd5d3e62595a44d598a254c697cd74.

That commit introduced the following race and can cause system hung.

 md_write_start:             raid5d:
 // mddev->in_sync == 1
 set "MD_SB_CHANGE_PENDING"
                            // running before md_write_start wakeup it
                             waiting "MD_SB_CHANGE_PENDING" cleared
                             >>>>>>>>> hung
 wakeup mddev->thread
 ...
 waiting "MD_SB_CHANGE_PENDING" cleared
 >>>> hung, raid5d should clear this flag
 but get hung by same flag.

The issue reverted commit fixing is fixed by last patch in a new way.

Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231108182216.73611-2-junxiao.bi@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -36,7 +36,6 @@
  */
 
 #include <linux/blkdev.h>
-#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -6843,18 +6842,7 @@ static void raid5d(struct md_thread *thr
 			spin_unlock_irq(&conf->device_lock);
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
-
-			/*
-			 * Waiting on MD_SB_CHANGE_PENDING below may deadlock
-			 * seeing md_check_recovery() is needed to clear
-			 * the flag when using mdmon.
-			 */
-			continue;
 		}
-
-		wait_event_lock_irq(mddev->sb_wait,
-			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
-			conf->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
 


