Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C8313AA43;
	Tue, 27 Feb 2024 14:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042917; cv=none; b=ADorN5b+WRtyIL1qdFdSPujNZ/Ywp3dFy/EsCz/iW1s4jW315NO3Q8eGDGxfsVKcF4nJPAjdPNXbpbPric5CVoOWDvX3EBo+0r59hIvQf4F1G15Bqq99FOZmMqx9yeGzDdnFFlQZzH1NcbXUmCOGPdbn0bwOuQhdW6WN9fVNENU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042917; c=relaxed/simple;
	bh=GjpxITBdhQrg5j4GCczYo35lpx4qHDUmxaO+xueHbcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEoNwt74kOd2wXACS7h9+T3kK0sHm1uLnV9+a72xYRedKcqBIhXJQu5cZDyjEnwnUqoKQbXIvFwLK51VPn9Omrhi/cQgJxh4f2E2o2yddXlruv9Ow+9bo4Rspq2P6vagm+s16uEt8zMhVwqA4qLXbmMP2GMRiYTC6QIUoEfzLC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yh2O6BKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yh2O6BKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E255C433F1;
	Tue, 27 Feb 2024 14:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042917;
	bh=GjpxITBdhQrg5j4GCczYo35lpx4qHDUmxaO+xueHbcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yh2O6BKUd5BDL+HL1CdEePYNlj/TH0nhIZK2svvD0TH/NnyqxrIgCnLkOFbF5RhO4
	 rFLq5275s3sM7VXrtfMK5knMarOsFE68i9byYoayCv1tpdxSzMwdG6V2RV2s7rinKk
	 RoZJGz7xAfdTkSH1ryIGGFBmL/zfjETsVqKOfIF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/245] md/raid10: prevent soft lockup while flush writes
Date: Tue, 27 Feb 2024 14:25:56 +0100
Message-ID: <20240227131620.669853308@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 010444623e7f4da6b4a4dd603a7da7469981e293 ]

Currently, there is no limit for raid1/raid10 plugged bio. While flushing
writes, raid1 has cond_resched() while raid10 doesn't, and too many
writes can cause soft lockup.

Follow up soft lockup can be triggered easily with writeback test for
raid10 with ramdisks:

watchdog: BUG: soft lockup - CPU#10 stuck for 27s! [md0_raid10:1293]
Call Trace:
 <TASK>
 call_rcu+0x16/0x20
 put_object+0x41/0x80
 __delete_object+0x50/0x90
 delete_object_full+0x2b/0x40
 kmemleak_free+0x46/0xa0
 slab_free_freelist_hook.constprop.0+0xed/0x1a0
 kmem_cache_free+0xfd/0x300
 mempool_free_slab+0x1f/0x30
 mempool_free+0x3a/0x100
 bio_free+0x59/0x80
 bio_put+0xcf/0x2c0
 free_r10bio+0xbf/0xf0
 raid_end_bio_io+0x78/0xb0
 one_write_done+0x8a/0xa0
 raid10_end_write_request+0x1b4/0x430
 bio_endio+0x175/0x320
 brd_submit_bio+0x3b9/0x9b7 [brd]
 __submit_bio+0x69/0xe0
 submit_bio_noacct_nocheck+0x1e6/0x5a0
 submit_bio_noacct+0x38c/0x7e0
 flush_pending_writes+0xf0/0x240
 raid10d+0xac/0x1ed0

Fix the problem by adding cond_resched() to raid10 like what raid1 did.

Note that unlimited plugged bio still need to be optimized, for example,
in the case of lots of dirty pages writeback, this will take lots of
memory and io will spend a long time in plug, hence io latency is bad.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230529131106.2123367-2-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 910e7db7d5736..ae84aaa1645c2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -903,6 +903,7 @@ static void flush_pending_writes(struct r10conf *conf)
 			else
 				submit_bio_noacct(bio);
 			bio = next;
+			cond_resched();
 		}
 		blk_finish_plug(&plug);
 	} else
@@ -1116,6 +1117,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 		else
 			submit_bio_noacct(bio);
 		bio = next;
+		cond_resched();
 	}
 	kfree(plug);
 }
-- 
2.43.0



