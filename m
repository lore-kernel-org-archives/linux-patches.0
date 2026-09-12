Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B191EB5FD;
	Sat, 12 Sep 2026 08:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200316; cv=none; b=lCVsaphLPLtB2SZrk6YO/l4jX6l8d78rxcuip4mLSWoFnuESKI+0H8CkyaSnVDyKmm4WwiP5U5bEWJSV7Y3Q0dU+U7HJD5uu2+LI13JwbPDATkVjEl6Nzw3Gunq6aJGOMxUBmc3VvOc1vvkCy/ojNAZbrRANIwMk9yeEyjQQ5Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200316; c=relaxed/simple;
	bh=RMbRuWoPfGA3Un1qM87RLmWBmXLv++fsvVbzTNOQhcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqSmAHzg4FMiwhzq3IamMU4xtMCRZH8d8+VIRabrifwxcgrZiz7f9IZfVjfxb8wK+5JICKqVUfODMeM16xNor4O7QDUIJj/0YikoehwiFqY2rVyLP8GsSXT2iR2rutNkwPQa5kTDaBfgYylaBczCxIjGst5hQ6EsSHfaW+KT+j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGuUrwmJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGuUrwmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4321F000FF;
	Sat, 12 Sep 2026 08:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200314;
	bh=wAdYUHntSIrRFysWZqezUud3tE9TSW+1xtW30MPk1fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sGuUrwmJKGrJAYpk8H7lqExxBy7nkCyw0IqdhqQrNH6uzpvfH/5Tr+I6WaRDfoOge
	 PVCO5IE4QgmadH5Au+q2PlcRTOkpaBCfWa97BywKufcnkvL6fvpmM/n54aKoCd9mCA
	 viO0tC41saiw0BvQY/NazpQbBouDBOk1G0fP8oFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0764/1815] md/raid5: fix lockless max_nr_stripes reads
Date: Sat, 12 Sep 2026 08:41:54 +0200
Message-ID: <20260912065706.844076761@linuxfoundation.org>
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

[ Upstream commit 6cb6ab75bdf2f49c0adb0fd6971886b082932eaa ]

max_nr_stripes is updated under cache_size_mutex in the stripe cache
grow/shrink paths, while is_inactive_blocked() and
raid5_end_read_request() read it without that lock.

Use READ_ONCE() for those reads in lockless path to match the WRITE_ONCE()
updates and avoid KCSAN data race reports.

A similar issue was previously fixed in commit-id:
	dfd2bf436709b2bccb78c2dda550dde93700efa7.

Fixes: 0009fad03337 ("raid5 improve too many read errors msg by adding limits")
Fixes: 3514da58be9c ("md/raid5: Make is_inactive_blocked() helper")

KCSAN report:
=================

BUG: KCSAN: data-race in grow_one_stripe / is_inactive_blocked

write (marked) to 0xffff8f01f0b5a268 of 4 bytes by task 12616 on cpu 9:
 grow_one_stripe+0x2d8/0x320
 raid5d+0xb57/0xba0
 md_thread+0x15a/0x2d0
 [..........]

read to 0xffff8f01f0b5a268 of 4 bytes by task 12670 on cpu 11:
 is_inactive_blocked+0x97/0xc0
 raid5_get_active_stripe+0x2fd/0xa70
 raid5_make_request+0x4aa/0x2940
 [..........]

value changed: 0x000003b9 -> 0x000003ba

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260624024042.2561803-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a6c52fb1fe68e..992d0b14822e7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -801,7 +801,7 @@ static bool is_inactive_blocked(struct r5conf *conf, int hash)
 		return true;
 
 	return (atomic_read(&conf->active_stripes) <
-		(conf->max_nr_stripes * 3 / 4));
+		(READ_ONCE(conf->max_nr_stripes) * 3 / 4));
 }
 
 struct stripe_head *raid5_get_active_stripe(struct r5conf *conf,
@@ -2785,6 +2785,7 @@ static void raid5_end_read_request(struct bio * bi)
 	} else {
 		int retry = 0;
 		int set_bad = 0;
+		int max_nr_stripes = READ_ONCE(conf->max_nr_stripes);
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		if (!(bi->bi_status == BLK_STS_PROTECTION))
@@ -2810,13 +2811,12 @@ static void raid5_end_read_request(struct bio * bi)
 				mdname(conf->mddev),
 				(unsigned long long)s,
 				rdev->bdev);
-		} else if (atomic_read(&rdev->read_errors)
-			 > conf->max_nr_stripes) {
+		} else if (atomic_read(&rdev->read_errors) > max_nr_stripes) {
 			if (!test_bit(Faulty, &rdev->flags)) {
 				pr_warn("md/raid:%s: %d read_errors > %d stripes\n",
 				    mdname(conf->mddev),
 				    atomic_read(&rdev->read_errors),
-				    conf->max_nr_stripes);
+				    max_nr_stripes);
 				pr_warn("md/raid:%s: Too many read errors, failing device %pg.\n",
 				    mdname(conf->mddev), rdev->bdev);
 			}
-- 
2.53.0



