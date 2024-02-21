Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D7479DBF;
	Wed, 21 Feb 2024 14:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525737; cv=none; b=T2mRrMECE++i23n7SxoABUpBJgcHWAw9I1gL3qTeRKiQuihyHXITnrFSDCzB/uvms94+7zKzTcxLYPVc0bf5B8Hp/2KXMfnubKquQZOgAmQ86qkK+cEClc71QFcdT6KJYNF4C/i+zK/0w+L5zdBmbDfsMWMt8KeylyzMKGfpUFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525737; c=relaxed/simple;
	bh=n2qSrI+S8QDFseK0p6pSZsXjXmvH9wGkKcGfWudEtSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLftvFtjVb8KF/AZR3CenSfdNkeGCPRKZKKJ5+4F8u3da6hbTH0xYtNAGstZKr5XHe7LSIEjzegaR2JoG8jCP+kUQEHwJmTgCoG8KKGWahetw+t2E5QZ71h/84PTfszKdpJeKUX6pzgwQPuCNgm3qnNgIwgrkpTuzqHsVYYLt9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1B9Vboy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1B9Vboy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CCBC43390;
	Wed, 21 Feb 2024 14:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525737;
	bh=n2qSrI+S8QDFseK0p6pSZsXjXmvH9wGkKcGfWudEtSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1B9Vboy6XdVmaQzbG/urfcmElqKec1XQCrrBESsSiJqx8+467kpr+KkA3Un0jjqeb
	 nOH2zR/ITG/dI5eFAcMbDPxKNzI20AYddxNMw41g781oWqtC4DM9O2MW94ytxGhvsZ
	 fI14fSCogGOzhauUNnDsFaPROvn5fZRDqnplqTv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 248/267] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"
Date: Wed, 21 Feb 2024 14:09:49 +0100
Message-ID: <20240221125948.036528498@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

[ Upstream commit bed9e27baf52a09b7ba2a3714f1e24e17ced386d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f3d60c4b34b8..0bea103f63d5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -36,7 +36,6 @@
  */
 
 #include <linux/blkdev.h>
-#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -6335,18 +6334,7 @@ static void raid5d(struct md_thread *thread)
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
 
-- 
2.43.0



