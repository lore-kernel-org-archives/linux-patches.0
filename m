Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44FF1EB5FD;
	Sat, 12 Sep 2026 08:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200306; cv=none; b=hOAPtD7+IliBVcHJBqo3arQePKPKeXaYXXtEDvC5Bkgz8/cFHzV0XEgN0BRW7PAdjE2hGGeab8SdGggITV7GiPfAF3HZ6Tzc90s2ZXjH7kPwCGlSp81LxhG442n7xhUMvw90Uzv7Y5fmzpi10ZQKLUFoz1ri0vUqd7J9mrOoKV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200306; c=relaxed/simple;
	bh=xqrNe4J7Oizhq0G88RZ+n+FUA8uV/fJbS/SKqpXrXBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlCHez9FnE9GEPvbSZjZdFqEHZGi4gExPU+2h+6wbA9JFyRS00oVkhPvYXSuuP46J72tVMf13oNV+8fFZQLnYgzG7NDmzYmqA/kwCFTiku3cjU78ZeZEOzBOJOTXnYNIwiXohha4uIQrLYiR8sqQPNBNinPo+t9ZmaAWUtUk5mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJwF0D+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJwF0D+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1C41F00893;
	Sat, 12 Sep 2026 08:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200304;
	bh=W9W82WDvWK5xBYOT25dfkOk1t0OqhRCfjdswGMmvXQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJwF0D+c3Q78i+tJSKZiKfIgCrWnC3tfQq5oAClRn6fzuNhEohRodCu6010nCTKVu
	 60Adefl1Ze4RaQEmLHbNCgTuoX2kwBam45rmaUc65flncAdEfDiI985VbY9J562tBO
	 aoHVGsnLFlz2A5b6cckMWVERh92SJ0EUyPUy0Fd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0762/1815] md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency
Date: Sat, 12 Sep 2026 08:41:52 +0200
Message-ID: <20260912065706.797011948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit f565925810cb8bc799421485770e15d922ef766a ]

kcsan detect race :
- raid5d() closes the current bitmap batch by updating
	conf->seq_flush under conf->device_lock.
- __add_stripe_bio() read conf->seq_flush without that
	lock when assigning sh->bm_seq.

so, protect seq_flush/seq_write consistency for multiple CPUs by
READ_ONCE()/WRITE_ONCE() under the path without held device_lock.

re-explain the stripe batch sequence number update flow:
1. sh->bm_seq declare which batch number the stripe belongs to
   when perform bitmap-related write.
	==> bm_seq = seq_flush+1

2. stripe be handled,
	* if sh->bm_seq - conf->seq_write > 0, means the
	  batch stripes **newer than** the last written
	  batch, it cannot proceed yet, queued on bitmap_list.
	* otherwise , has already proceed.

3. raid5d() `++seq_flush` to closes the current batch, means
	* no more stripes join that old batch
	* just-closed batch ready to write-out to disk

4. raid5d() calls bitmap hooks unplug() or writeout, then,
   `++seq_write` to the same as bm_seq.

- seq_flush - for producer, to close batches.
- seq_write - for consumer, the checkpoint number.

the report:
====================================
BUG: KCSAN: data-race in __add_stripe_bio / raid5d

write to 0xffff88ba5625d470 of 4 bytes by task 82401 on cpu 0:
 raid5d+0x1d9/0xba0
 [.....]

read to 0xffff88ba5625d470 of 4 bytes by task 82421 on cpu 8:
 __add_stripe_bio+0x332/0x400
 raid5_make_request+0x6ac/0x2930
 md_handle_request+0x4a2/0xa40
 md_submit_bio+0x109/0x1a0
 __submit_bio+0x2ec/0x390
 [.....]

Fixes: 7c13edc87510 ("md: incorporate new plugging into raid5.")

v1 -> v2:
- remove WRITE_ONCE(conf->seq_write) in held device_lock path.
- remove READ_ONCE(conf->seq_flush) in held device_lock path.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260622124649.1780233-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ffb5fcde54a98..a6c52fb1fe68e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3553,7 +3553,7 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
 		 sh->dev[dd_idx].sector);
 
 	if (conf->mddev->bitmap && firstwrite && !sh->batch_head) {
-		sh->bm_seq = conf->seq_flush+1;
+		sh->bm_seq = READ_ONCE(conf->seq_flush) + 1;
 		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
 }
@@ -5799,7 +5799,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		}
 		spin_unlock_irq(&sh->stripe_lock);
 		if (conf->mddev->bitmap) {
-			sh->bm_seq = conf->seq_flush + 1;
+			sh->bm_seq = READ_ONCE(conf->seq_flush) + 1;
 			set_bit(STRIPE_BIT_DELAY, &sh->state);
 		}
 
@@ -6849,12 +6849,14 @@ static void raid5d(struct md_thread *thread)
 		if (
 		    !list_empty(&conf->bitmap_list)) {
 			/* Now is a good time to flush some bitmap updates */
-			conf->seq_flush++;
+			int seq = conf->seq_flush + 1;
+
+			WRITE_ONCE(conf->seq_flush, seq);
 			spin_unlock_irq(&conf->device_lock);
 			if (md_bitmap_enabled(mddev, true))
 				mddev->bitmap_ops->unplug(mddev, true);
 			spin_lock_irq(&conf->device_lock);
-			conf->seq_write = conf->seq_flush;
+			conf->seq_write = seq;
 			activate_bit_delay(conf, conf->temp_inactive_list);
 		}
 		raid5_activate_delayed(conf);
-- 
2.53.0



