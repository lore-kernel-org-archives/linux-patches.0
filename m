Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF803168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD57C4339C;
	Mon,  8 May 2023 10:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542245;
	bh=byixTph1G17/Orer4R4OqxBdjvcUT5I2UA8NzHIWazk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cb6ZCoAwoiPH/U5Szjnrz1WhAr1oNTtkjDeVxb/RYKbw/FOTWi53Wtkl9zJtjuEMq
	 iI5OR+1aILsP+V4jytfGElXQRRpesh45igVwAMkdbq5TjONgegHi7b6/4HLNin5S0o
	 OHaOrDxuOelsj+PMARRMBBTMnuQDjNZlkK7uSD04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 373/663] md/raid10: fix leak of r10bio->remaining for recovery
Date: Mon,  8 May 2023 11:43:19 +0200
Message-Id: <20230508094440.232344080@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 26208a7cffd0c7cbf14237ccd20c7270b3ffeb7e ]

raid10_sync_request() will add 'r10bio->remaining' for both rdev and
replacement rdev. However, if the read io fails, recovery_request_write()
returns without issuing the write io, in this case, end_sync_request()
is only called once and 'remaining' is leaked, cause an io hang.

Fix the problem by decreasing 'remaining' according to if 'bio' and
'repl_bio' is valid.

Fixes: 24afd80d99f8 ("md/raid10: handle recovery of replacement devices.")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230310073855.1337560-5-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index db9ee3b637d6f..b1c575859218a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2613,11 +2613,22 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
 	int d;
-	struct bio *wbio, *wbio2;
+	struct bio *wbio = r10_bio->devs[1].bio;
+	struct bio *wbio2 = r10_bio->devs[1].repl_bio;
+
+	/* Need to test wbio2->bi_end_io before we call
+	 * submit_bio_noacct as if the former is NULL,
+	 * the latter is free to free wbio2.
+	 */
+	if (wbio2 && !wbio2->bi_end_io)
+		wbio2 = NULL;
 
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state)) {
 		fix_recovery_read_error(r10_bio);
-		end_sync_request(r10_bio);
+		if (wbio->bi_end_io)
+			end_sync_request(r10_bio);
+		if (wbio2)
+			end_sync_request(r10_bio);
 		return;
 	}
 
@@ -2626,14 +2637,6 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	 * and submit the write request
 	 */
 	d = r10_bio->devs[1].devnum;
-	wbio = r10_bio->devs[1].bio;
-	wbio2 = r10_bio->devs[1].repl_bio;
-	/* Need to test wbio2->bi_end_io before we call
-	 * submit_bio_noacct as if the former is NULL,
-	 * the latter is free to free wbio2.
-	 */
-	if (wbio2 && !wbio2->bi_end_io)
-		wbio2 = NULL;
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
-- 
2.39.2



