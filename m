Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF54435502A;
	Tue, 16 Dec 2025 11:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885831; cv=none; b=pDseSYmFxu+NRf1tm1kMBiCEsX4dh+Hcti74L/Hu2MLcph9BcuMrzExy4kY4B3z3bzuGz5fEHgPJDvIvU5wCKPM2+QGblc8A2D71xz7P3NATK5npfmnmzJRF0VVNz0x/dfjkdj6o6C/SB0u+tyHGmlAR/Mp/zz6WqCT02b4oDrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885831; c=relaxed/simple;
	bh=DhSsYpcT+RGeKU8feUCg/6vGL+gtMmyfPq22gkYZPcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1py/SH1yD9muQnPMQj4hK/npOb82cbgXTrj5KZq5wo65IyrUIxp8/TY1AcA2rC/xpn3upmU12m8wOM9CvnJp0rFshIXhSP76UhgZ/Jj9E+Gz4qcQn84UPRCMDAZJXf01AYZEaeEOvN5fPaA+sJrNoCUNbyk+nxOvk+UEceqgKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1KbPaok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1KbPaok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C848C4CEF1;
	Tue, 16 Dec 2025 11:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885830;
	bh=DhSsYpcT+RGeKU8feUCg/6vGL+gtMmyfPq22gkYZPcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1KbPaok6+a8GDfH1JYrDTfhYTkhi1M2oWH4gp0rlxDjdPixDk1IvqnkObt+eZex/
	 ikDC9xqgg9jjrlotjEDoNS6nlBJ0GXc0mEzMEGbI7blthaJi5IAroXogN1Xdemo4wr
	 LgaqSGTmQnQ9iVU2q01RWSZOUsYr/oOtSt4agIUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Khazhismel Kumykov <khazhy@google.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 258/507] block/blk-throttle: Fix throttle slice time for SSDs
Date: Tue, 16 Dec 2025 12:11:39 +0100
Message-ID: <20251216111354.836793833@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f76581f9f1d29e32e120b0242974ba266e79de58 ]

Commit d61fcfa4bb18 ("blk-throttle: choose a small throtl_slice for SSD")
introduced device type specific throttle slices if BLK_DEV_THROTTLING_LOW
was enabled. Commit bf20ab538c81 ("blk-throttle: remove
CONFIG_BLK_DEV_THROTTLING_LOW") removed support for BLK_DEV_THROTTLING_LOW,
but left the device type specific throttle slices in place. This
effectively changed throttling behavior on systems with SSD which now use
a different and non-configurable slice time compared to non-SSD devices.
Practical impact is that throughput tests with low configured throttle
values (65536 bps) experience less than expected throughput on SSDs,
presumably due to rounding errors associated with the small throttle slice
time used for those devices. The same tests pass when setting the throttle
values to 65536 * 4 = 262144 bps.

The original code sets the throttle slice time to DFL_THROTL_SLICE_HD if
CONFIG_BLK_DEV_THROTTLING_LOW is disabled. Restore that code to fix the
problem. With that, DFL_THROTL_SLICE_SSD is no longer necessary. Revert to
the original code and re-introduce DFL_THROTL_SLICE to replace both
DFL_THROTL_SLICE_HD and DFL_THROTL_SLICE_SSD. This effectively reverts
commit d61fcfa4bb18 ("blk-throttle: choose a small throtl_slice for SSD").

While at it, also remove MAX_THROTL_SLICE since it is not used anymore.

Fixes: bf20ab538c81 ("blk-throttle: remove CONFIG_BLK_DEV_THROTTLING_LOW")
Cc: Yu Kuai <yukuai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 2c5b64b1a724a..c19d052a8f2f1 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -22,9 +22,7 @@
 #define THROTL_QUANTUM 32
 
 /* Throttling is performed over a slice and after that slice is renewed */
-#define DFL_THROTL_SLICE_HD (HZ / 10)
-#define DFL_THROTL_SLICE_SSD (HZ / 50)
-#define MAX_THROTL_SLICE (HZ)
+#define DFL_THROTL_SLICE (HZ / 10)
 
 /* A workqueue to queue throttle related work */
 static struct workqueue_struct *kthrotld_workqueue;
@@ -1341,10 +1339,7 @@ static int blk_throtl_init(struct gendisk *disk)
 		goto out;
 	}
 
-	if (blk_queue_nonrot(q))
-		td->throtl_slice = DFL_THROTL_SLICE_SSD;
-	else
-		td->throtl_slice = DFL_THROTL_SLICE_HD;
+	td->throtl_slice = DFL_THROTL_SLICE;
 	td->track_bio_latency = !queue_is_mq(q);
 	if (!td->track_bio_latency)
 		blk_stat_enable_accounting(q);
-- 
2.51.0



