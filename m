Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E5023DB;
	Tue, 23 Jan 2024 00:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969840; cv=none; b=UMv4BLut2oSJH6K07znKR7C0GyGpptwZe9SgEWZfnurNVXLfGlSsXumfRqvm44VJ39qX8TceiIMTOzAKDxUxvNlVj/UZOfRKPGY4UMfxOoSiEAT4a8kCaJfLm/zdjMN+0onuDGeAhrsWiMT49t3M9h1InWCQFb2MJcAioUKV7Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969840; c=relaxed/simple;
	bh=8wipFKPVz2ZVu4TachhBa9fARkSuWo8q8ABGwYIpL54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYgI1FVayNKiqiwlVLmBJWBQb1rsvFmT047YH+HH0A6fQmaYPv6l4JFWF4rpOYnpvaLa69/eB5o5UZ+12k5M9Cb9TWBajuutn2JSM1AtgV3hgId3Oy4vsz+O0pDxdv27RUjHBcoUy7HUCqTKGo7mm8T6RkQz5MCRrI+XS27/wcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IoUleSSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IoUleSSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D88C43390;
	Tue, 23 Jan 2024 00:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969839;
	bh=8wipFKPVz2ZVu4TachhBa9fARkSuWo8q8ABGwYIpL54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoUleSSAz7bb54X2dOcVWVW25kely6kvQZrzUR+ADdSNcl5w3ZE+BCc24Gt9SR31Y
	 7WEOyrOp+mHYvy/s6h2jIhNLy/pr93hufWhyxWqzZebamnqYi+wy+QvzjuW8/+xVDN
	 372iFvxGevhNON/vhyrxyOEjwCAiJkAemBSnHep8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	kernel test robot <lkp@intel.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6.7 447/641] md/raid1: Use blk_opf_t for read and write operations
Date: Mon, 22 Jan 2024 15:55:51 -0800
Message-ID: <20240122235832.008200584@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 7dab24554dedd4e6f408af8eb2d25c89997a6a1f upstream.

Use the type blk_opf_t for read and write operations instead of int. This
patch does not affect the generated code but fixes the following sparse
warning:

drivers/md/raid1.c:1993:60: sparse: sparse: incorrect type in argument 5 (different base types)
     expected restricted blk_opf_t [usertype] opf
     got int rw

Cc: Song Liu <song@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 3c5e514db58f ("md/raid1: Use the new blk_opf_t type")
Cc: stable@vger.kernel.org # v6.0+
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401080657.UjFnvQgX-lkp@intel.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240108001223.23835-1-bvanassche@acm.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1984,12 +1984,12 @@ static void end_sync_write(struct bio *b
 }
 
 static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
-			   int sectors, struct page *page, int rw)
+			   int sectors, struct page *page, blk_opf_t rw)
 {
 	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
 		/* success */
 		return 1;
-	if (rw == WRITE) {
+	if (rw == REQ_OP_WRITE) {
 		set_bit(WriteErrorSeen, &rdev->flags);
 		if (!test_and_set_bit(WantReplacement,
 				      &rdev->flags))
@@ -2106,7 +2106,7 @@ static int fix_sync_read_error(struct r1
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    pages[idx],
-					    WRITE) == 0) {
+					    REQ_OP_WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
 			}
@@ -2121,7 +2121,7 @@ static int fix_sync_read_error(struct r1
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    pages[idx],
-					    READ) != 0)
+					    REQ_OP_READ) != 0)
 				atomic_add(s, &rdev->corrected_errors);
 		}
 		sectors -= s;
@@ -2333,7 +2333,7 @@ static void fix_read_error(struct r1conf
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
 				r1_sync_page_io(rdev, sect, s,
-						conf->tmppage, WRITE);
+						conf->tmppage, REQ_OP_WRITE);
 				rdev_dec_pending(rdev, mddev);
 			} else
 				rcu_read_unlock();
@@ -2350,7 +2350,7 @@ static void fix_read_error(struct r1conf
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
 				if (r1_sync_page_io(rdev, sect, s,
-						    conf->tmppage, READ)) {
+						conf->tmppage, REQ_OP_READ)) {
 					atomic_add(s, &rdev->corrected_errors);
 					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %pg)\n",
 						mdname(mddev), s,


