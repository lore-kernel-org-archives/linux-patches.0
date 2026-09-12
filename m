Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0400E37E5D1;
	Sat, 12 Sep 2026 12:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216456; cv=none; b=fMtyCQL/V7QoqA91X4Y+HCx647meA+YeictgkMyx9veBU6vg6n52lp6ngvG4FL3AR8TxnMIrk3uL3i4rif3KyKYi68tmpga0F2Xe4O0dp3ALmUDIJuN59VxxXHtjsXRtN0cnyftGdJKTm0fcfDuRRlmFocGRVgaLnavYnEwLjHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216456; c=relaxed/simple;
	bh=GRi3ad7GiCdT0/WybdYfxSj+7VjpD4bjo6z6pOBOWfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgAK3G0MWdHZwSkXrCPdHCCAY7o/tOATc0VoMenDIkD33HPA1GDUWQBdv0b+8RzLwjl8bo0hSax6GDgMfs89IbvEhTIsqKQ1nyOMwkfgLzumr/qoZc+UBdTl0RKtl8T5M8oQJNhyaSe65wzm5EzDnw2PxazWg/JVfCu5O4X67js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSiwdCDl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSiwdCDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7F01F00893;
	Sat, 12 Sep 2026 12:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216454;
	bh=HXYSY3afPnEwPZi+wQppdDHRjkZogjYnBBnTY5STdF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DSiwdCDl01xOGSJFN+/X6MlyQssYrtC6jpLwerLGj/wIKF8/SYiKwqukckX1WyidC
	 a5gaReq8jwgD1+NIzlUmFZbrAQhqIpbh2+b+2HdtnvOV5MjMkZJbHkG74kjjVwTXsK
	 axPismCpAWhTn8pt9xgew1Ge6lx4ceGgw1SN0zXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0738/1376] md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency
Date: Sat, 12 Sep 2026 08:52:44 +0200
Message-ID: <20260912065623.991505080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index b315d36b7f500..6e42366b15ca1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3545,7 +3545,7 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
 		 sh->dev[dd_idx].sector);
 
 	if (conf->mddev->bitmap && firstwrite && !sh->batch_head) {
-		sh->bm_seq = conf->seq_flush+1;
+		sh->bm_seq = READ_ONCE(conf->seq_flush) + 1;
 		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
 }
@@ -5751,7 +5751,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		}
 		spin_unlock_irq(&sh->stripe_lock);
 		if (conf->mddev->bitmap) {
-			sh->bm_seq = conf->seq_flush + 1;
+			sh->bm_seq = READ_ONCE(conf->seq_flush) + 1;
 			set_bit(STRIPE_BIT_DELAY, &sh->state);
 		}
 
@@ -6788,11 +6788,13 @@ static void raid5d(struct md_thread *thread)
 		if (
 		    !list_empty(&conf->bitmap_list)) {
 			/* Now is a good time to flush some bitmap updates */
-			conf->seq_flush++;
+			int seq = conf->seq_flush + 1;
+
+			WRITE_ONCE(conf->seq_flush, seq);
 			spin_unlock_irq(&conf->device_lock);
 			mddev->bitmap_ops->unplug(mddev, true);
 			spin_lock_irq(&conf->device_lock);
-			conf->seq_write = conf->seq_flush;
+			conf->seq_write = seq;
 			activate_bit_delay(conf, conf->temp_inactive_list);
 		}
 		raid5_activate_delayed(conf);
-- 
2.53.0



