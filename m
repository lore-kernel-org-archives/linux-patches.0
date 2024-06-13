Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E763143C5D;
	Thu, 13 Jun 2024 11:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279128; cv=none; b=u6o9yVAFEj36V9rcpH52orh4WEYXNZh8+t8plgii6XGHE2teUFcVllIHnVXDgYbCNNGMBBl4QEZ/dqj7ruI9DKjer9KcvFyDokia9+Fjr+BtwJYlSNUoSgywpBcSg9P6hZoX4gG+WS/QKfbM+f14p/2g94iwoIjRQY7zDEL6/Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279128; c=relaxed/simple;
	bh=tt+wgC28sn/B4wlrN3QcONwQVsT52YIMGcUQC/vwrIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFAVxTs5RK8WrTCamZixfoHfG/THJb1yFPxA3MJA6/kzYh01KEkZ/KFJYuPFY9EWUTZGuE0j+fYiFHAXqtwCuhNbF/jqenjpr4vBEMTzfPnc8QiAZLLPWD6NYvMRZtB/of+krRGDdkGop0sk/h3U7QGHbVxIkqbvz2nvAunddzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DB7QhEdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DB7QhEdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E69C2BBFC;
	Thu, 13 Jun 2024 11:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279127;
	bh=tt+wgC28sn/B4wlrN3QcONwQVsT52YIMGcUQC/vwrIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DB7QhEdvAJX1ru37EYRTHKdCCk14BgthFAtiVB5Nfzcvkh4/1aaquA5WWmKO7ZpaK
	 Ggu+YaWDhdVR+cqXsyAwKo2HtmZ1hKmqMKh/p5QWisedp4Pk5EMYBQZLSNxS6fttau
	 VhT7G+E7253K5tBamjfiuDCsMs+HkrcuYhDAzGDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Dan Moulding <dan@danm.net>,
	Junxiao Bi <junxiao.bi@oracle.com>
Subject: [PATCH 4.19 153/213] md/raid5: fix deadlock that raid5d() wait for itself to clear MD_SB_CHANGE_PENDING
Date: Thu, 13 Jun 2024 13:33:21 +0200
Message-ID: <20240613113233.889736589@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -44,7 +44,6 @@
  */
 
 #include <linux/blkdev.h>
-#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -6294,6 +6293,9 @@ static void raid5d(struct md_thread *thr
 		int batch_size, released;
 		unsigned int offset;
 
+		if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
+			break;
+
 		released = release_stripe_list(conf, conf->temp_inactive_list);
 		if (released)
 			clear_bit(R5_DID_ALLOC, &conf->cache_state);
@@ -6330,18 +6332,7 @@ static void raid5d(struct md_thread *thr
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
 


