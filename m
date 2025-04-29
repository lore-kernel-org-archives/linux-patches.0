Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84701247280;
	Tue, 29 Apr 2025 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949563; cv=none; b=mBgOOe7JeSFb9C073ihSSqWyPjzxdpIUQMeXbZforv8gaUS4BA3+LQ3OoqoqDXbJF62+yE3CJuRza/50x//iK1JMXC5aCPMAcOEGkwj0bAaskFXWldV7T4i8/slTRTXmId0h9ZYsa2HPouBFI6YFqFfkVrEP/144/Z5TrrpMMp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949563; c=relaxed/simple;
	bh=Kv3HBNj6oc3d+euSv3M5AM+oEnKXlgoCqzImhUr5YMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7wxFon9KucRLREYgEKr3h5baCg60TjOlpF32iN6P5VGPdpQQOjhNX1MMK2Bgk2yA81anbl8b1mC4bugjT67/t25OR3armuTT1Q4G4wlNYyZxnVD7tytZ2c8d1S6l5LV6Mu2HZS9KN8SndLRGE3ifT/nIEkeTSFD83nP/A1too4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVElm4J/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVElm4J/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F175BC4CEE3;
	Tue, 29 Apr 2025 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949563;
	bh=Kv3HBNj6oc3d+euSv3M5AM+oEnKXlgoCqzImhUr5YMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVElm4J/e4qfoeqpIhsS4qKBijo/VQ5jtGonIb6uWzr3RMvtC7NfAUA//t81q1lL1
	 SbjlGy+EufQXl4+q2DgtKBq84/I+Z91CaIhgmbjrV5yVW4SDZUZaBEK31f2/h2YToM
	 ngDkY0mOy0A/rCvg4qPAaNqyNI4oH62DtN3l+Ics=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meir Elisha <meir.elisha@volumez.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/373] md/raid1: Add check for missing source disk in process_checks()
Date: Tue, 29 Apr 2025 18:43:56 +0200
Message-ID: <20250429161137.900341268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Meir Elisha <meir.elisha@volumez.com>

[ Upstream commit b7c178d9e57c8fd4238ff77263b877f6f16182ba ]

During recovery/check operations, the process_checks function loops
through available disks to find a 'primary' source with successfully
read data.

If no suitable source disk is found after checking all possibilities,
the 'primary' index will reach conf->raid_disks * 2. Add an explicit
check for this condition after the loop. If no source disk was found,
print an error message and return early to prevent further processing
without a valid primary source.

Link: https://lore.kernel.org/linux-raid/20250408143808.1026534-1-meir.elisha@volumez.com
Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8427c9767a61b..de87606b2e04c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2063,14 +2063,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				if (!rdev_set_badblocks(rdev, sect, s, 0))
 					abort = 1;
 			}
-			if (abort) {
-				conf->recovery_disabled =
-					mddev->recovery_disabled;
-				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_done_sync(mddev, r1_bio->sectors, 0);
-				put_buf(r1_bio);
+			if (abort)
 				return 0;
-			}
+
 			/* Try next page */
 			sectors -= s;
 			sect += s;
@@ -2210,10 +2205,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 	int disks = conf->raid_disks * 2;
 	struct bio *wbio;
 
-	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
-		/* ouch - failed to read all of that. */
-		if (!fix_sync_read_error(r1_bio))
+	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+		/*
+		 * ouch - failed to read all of that.
+		 * No need to fix read error for check/repair
+		 * because all member disks are read.
+		 */
+		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
+		    !fix_sync_read_error(r1_bio)) {
+			conf->recovery_disabled = mddev->recovery_disabled;
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+			md_done_sync(mddev, r1_bio->sectors, 0);
+			put_buf(r1_bio);
 			return;
+		}
+	}
 
 	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 		process_checks(r1_bio);
-- 
2.39.5



