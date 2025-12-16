Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088C426A09B;
	Tue, 16 Dec 2025 11:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884506; cv=none; b=q/SO7AuJepWgH1ODpK3YvG2qyPuzC28ZflFKV0QmTRbluYO7VZwkne67Vd+SpXN0kpQIq6vzntRiYgWaWppPTqcCybnelptCpyEm2EwfJZZzTIF8T6nr8R8ZmWt9XkxhBu6TjeS1fnWuThP3/tbvB/SGPA/WWd1pF+guo3wRy8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884506; c=relaxed/simple;
	bh=rZHaWlAMa/HmLq/sec0jvTWiIVFU2R+JCeZNFVSdna0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ducfRQ3WQvBr4OxXN8IqDTIQ7TBfWHSeN114pDmAEgq3TkNrc2xBchD/Tjc2bSnhlmzSAawpev/5Xf07iiVR93hW6xeULeQJO41JCy4IRfSi44neoUw+mRpB6xzw86UGSQJu6QolK6fawPPV4kVT3LiKeVAL+dfplQrCIIJTCiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoLPmhrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoLPmhrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFF0C4CEF1;
	Tue, 16 Dec 2025 11:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884505;
	bh=rZHaWlAMa/HmLq/sec0jvTWiIVFU2R+JCeZNFVSdna0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoLPmhrYpzFiZm5tQsJpvKIuCgFjvM83IQx3Qhr+OEWj+nalht2I6gxVLT7dxgTMa
	 OYtNF1hIW7es5a3MTsSAszPaPNKgnnJN/HjeMvOAmqpowiBm4Ex344xV8OWI1EZSMy
	 QyStdp0NCtAbx/9oxDhrnjG9iReJbnZVSE76G7SU=
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
Subject: [PATCH 6.12 171/354] block/blk-throttle: Fix throttle slice time for SSDs
Date: Tue, 16 Dec 2025 12:12:18 +0100
Message-ID: <20251216111327.109810007@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6b82fcbd7e774..4aa66c07d2e83 100644
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
@@ -1229,10 +1227,7 @@ static int blk_throtl_init(struct gendisk *disk)
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



