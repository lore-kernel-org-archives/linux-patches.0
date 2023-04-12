Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF932F2C
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD7DC433EF;
	Wed, 12 Apr 2023 08:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288779;
	bh=eNHfDyvvXn4PpOPv28aukeBF+WCIiEupDR1H02KaPB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=el6ZbI4+cQdC9pBcGqTelgjXwI5+j/3zIWB91bCFDqdzKrXbxEKZRo1g8idYVdAbt
	 aAObyNgntAZT9sqzgqcx8GRCHR+0hiVFPr9P6p/qMzilf/5ta5jVMw79DiacuxU8KJ
	 sRge1KDnJVTSfqlA6KepmFD6z3A0pCtFZ02ZgJA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orange Kao <orange@aiven.io>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/164] dm: fix improper splitting for abnormal bios
Date: Wed, 12 Apr 2023 10:32:06 +0200
Message-Id: <20230412082836.949089010@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit f7b58a69fad9d2c4c90cab0247811155dd0d48e7 ]

"Abnormal" bios include discards, write zeroes and secure erase. By no
longer passing the calculated 'len' pointer, commit 7dd06a2548b2 ("dm:
allow dm_accept_partial_bio() for dm_io without duplicate bios") took a
senseless approach to disallowing dm_accept_partial_bio() from working
for duplicate bios processed using __send_duplicate_bios().

It inadvertently and incorrectly stopped the use of 'len' when
initializing a target's io (in alloc_tio). As such the resulting tio
could address more area of a device than it should.

For example, when discarding an entire DM striped device with the
following DM table:
 vg-lvol0: 0 159744 striped 2 128 7:0 2048 7:1 2048
 vg-lvol0: 159744 45056 striped 2 128 7:2 2048 7:3 2048

Before this fix:

 device-mapper: striped: target_stripe=0, bdev=7:0, start=2048 len=102400
 blkdiscard: attempt to access beyond end of device
 loop0: rw=2051, sector=2048, nr_sectors = 102400 limit=81920

 device-mapper: striped: target_stripe=1, bdev=7:1, start=2048 len=102400
 blkdiscard: attempt to access beyond end of device
 loop1: rw=2051, sector=2048, nr_sectors = 102400 limit=81920

After this fix;

 device-mapper: striped: target_stripe=0, bdev=7:0, start=2048 len=79872
 device-mapper: striped: target_stripe=1, bdev=7:1, start=2048 len=79872

Fixes: 7dd06a2548b2 ("dm: allow dm_accept_partial_bio() for dm_io without duplicate bios")
Cc: stable@vger.kernel.org
Reported-by: Orange Kao <orange@aiven.io>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5e6584cc76c33..24284d22f15bc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1475,7 +1475,8 @@ static void setup_split_accounting(struct clone_info *ci, unsigned int len)
 }
 
 static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
-				struct dm_target *ti, unsigned int num_bios)
+				struct dm_target *ti, unsigned int num_bios,
+				unsigned *len)
 {
 	struct bio *bio;
 	int try;
@@ -1486,7 +1487,7 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 		if (try)
 			mutex_lock(&ci->io->md->table_devices_lock);
 		for (bio_nr = 0; bio_nr < num_bios; bio_nr++) {
-			bio = alloc_tio(ci, ti, bio_nr, NULL,
+			bio = alloc_tio(ci, ti, bio_nr, len,
 					try ? GFP_NOIO : GFP_NOWAIT);
 			if (!bio)
 				break;
@@ -1524,7 +1525,7 @@ static int __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 		if (len)
 			setup_split_accounting(ci, *len);
 		/* dm_accept_partial_bio() is not supported with shared tio->len_ptr */
-		alloc_multiple_bios(&blist, ci, ti, num_bios);
+		alloc_multiple_bios(&blist, ci, ti, num_bios, len);
 		while ((clone = bio_list_pop(&blist))) {
 			dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
 			__map_bio(clone);
-- 
2.39.2



