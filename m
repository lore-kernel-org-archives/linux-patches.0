Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7753143861;
	Thu, 13 Jun 2024 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281518; cv=none; b=L+ePz9HZ7zi6iZtZUETZlyGLF7bo+mPiyOR0LBiztIkts49TspjFHhwLt6Bug1FeAD4qfv8mVWruSYqQCyIpGC50XR+7imINK+8UJXT/h3cFS/HoAO80jp7+lNbSnzW/AChnV/EO40ZMkEh4AFtOytJsKUFgPNla4NtyQmYfIZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281518; c=relaxed/simple;
	bh=0KGPd60CZwSR2cg2NyzTIq1Votg8FHUF5ndBsE4R0KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3JWteiX6M8IGWWIP8+bCDf9fx4eWBTIP0C+RUkoTfapsL8mlauIgYvT0G2rBy0v13DF/ZhWcfMYuE0WNTkhbBarkicwEkBtuKr9z/Qo8KfQ4lt+8q2CYK9M0fo6MheGzumNJJmIotb6fClIEHIsRjv7TpabK/H8oRi237iVD7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSsK7N4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSsK7N4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3C8C2BBFC;
	Thu, 13 Jun 2024 12:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281518;
	bh=0KGPd60CZwSR2cg2NyzTIq1Votg8FHUF5ndBsE4R0KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSsK7N4RMcYTmi0IKCo/O3vOrAQjla2Jncf6azxofC0O1Xn6vZNy0lkv2XF4vrovj
	 jtc0wns0dRZcQqDfgVQWjidgVQEFVdNSnjkAlp4vZF+2S0jRYHlYrLITd+yC7vO+Ir
	 kXovVTVRnWGUJYkSJ2paCKd5T5DZVcOxRbBxp7l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Dan Moulding <dan@danm.net>,
	Junxiao Bi <junxiao.bi@oracle.com>
Subject: [PATCH 5.10 282/317] md/raid5: fix deadlock that raid5d() wait for itself to clear MD_SB_CHANGE_PENDING
Date: Thu, 13 Jun 2024 13:35:00 +0200
Message-ID: <20240613113258.462028277@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 151f66bb618d1fd0eeb84acb61b4a9fa5d8bb0fa upstream.

Xiao reported that lvm2 test lvconvert-raid-takeover.sh can hang with
small possibility, the root cause is exactly the same as commit
bed9e27baf52 ("Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"")

However, Dan reported another hang after that, and junxiao investigated
the problem and found out that this is caused by plugged bio can't issue
from raid5d().

Current implementation in raid5d() has a weird dependence:

1) md_check_recovery() from raid5d() must hold 'reconfig_mutex' to clear
   MD_SB_CHANGE_PENDING;
2) raid5d() handles IO in a deadloop, until all IO are issued;
3) IO from raid5d() must wait for MD_SB_CHANGE_PENDING to be cleared;

This behaviour is introduce before v2.6, and for consequence, if other
context hold 'reconfig_mutex', and md_check_recovery() can't update
super_block, then raid5d() will waste one cpu 100% by the deadloop, until
'reconfig_mutex' is released.

Refer to the implementation from raid1 and raid10, fix this problem by
skipping issue IO if MD_SB_CHANGE_PENDING is still set after
md_check_recovery(), daemon thread will be woken up when 'reconfig_mutex'
is released. Meanwhile, the hang problem will be fixed as well.

Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
Cc: stable@vger.kernel.org # v5.19+
Reported-and-tested-by: Dan Moulding <dan@danm.net>
Closes: https://lore.kernel.org/all/20240123005700.9302-1-dan@danm.net/
Investigated-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240322081005.1112401-1-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -36,7 +36,6 @@
  */
 
 #include <linux/blkdev.h>
-#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -6484,6 +6483,9 @@ static void raid5d(struct md_thread *thr
 		int batch_size, released;
 		unsigned int offset;
 
+		if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
+			break;
+
 		released = release_stripe_list(conf, conf->temp_inactive_list);
 		if (released)
 			clear_bit(R5_DID_ALLOC, &conf->cache_state);
@@ -6520,18 +6522,7 @@ static void raid5d(struct md_thread *thr
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
 


