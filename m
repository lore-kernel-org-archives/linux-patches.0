Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B823A7D63;
	Sat, 17 Oct 2026 18:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260528; cv=none; b=NhtBy6fpKy7YMOpWWpI4xhb7zODEiEl1VEmip98xJRyCoelQan1LsB2WN0di+2LMvYN/aQquePPuX77n3lL8tPnWrNPqS8UhKRiE0bcDqBm9cjx+mmSvmswnca1Kj4qvtbAR/hwgn24OjV5jDsDE71V6PlU3jxFO6MWcH59nRQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260528; c=relaxed/simple;
	bh=7qk6Mf7zY30XXII2t2K+/AYRu1XAfma0adAzDMYOiwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwlh3tv/jf2S3MJJGYDSguEI7QY6bBtv+RpCl8nQBs4deiCFzRhtuTwurV+hFrOTEEpoTS4VE8F6EebI8AcSkO9RIn4uOJSuciI00mura/BKs/R2LGg0CfW8PwMXhv/ZExnmRfdpKtW/lL8Duo0y8DExECHdcYWmqjbUlm3SHdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVWMT9BC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVWMT9BC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E231F000C4;
	Sat, 17 Oct 2026 18:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260526;
	bh=6hywGWnY89BPbBQKdIyyday9m3fp/VR7Wzlt7+KHN6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVWMT9BC8E+t5BGNrF51ZWcB5FTXXkzdEcpCS0tLsPTAMaxixAgJj9KD1oD0SMJhv
	 qqnB8XYTOYoYFhIO0lVX7Rx3oTT9YIZZGuy96JiCdzXRBa1NU2KCblFb3fI91SO9WO
	 puzWgwaPYJ90+rFICKD1ttP8dIIdJpBmbjMcH2Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1573/1674] md/raid1,raid10: fix bio accounting for split md cloned bios
Date: Sat, 17 Oct 2026 18:04:05 +0200
Message-ID: <20261017160511.474675244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit ba976e3501111d11c550848b3b7341a73035f582 ]

Use md_cloned_bio() to control bio accounting instead of relying
on r1bio_existed in raid1 or the io_accounting flag in raid10.

The previous logic does not reliably reflect whether a bio is an
md cloned bio. When a failed bio is split and resubmitted via
bio_submit_split_bioset() on the error path, this can lead to either
double accounting for md cloned bios, or missing accounting for bios
returned from bio_submit_split_bioset()

Fix this by using md_cloned_bio() to detect md cloned bios and
skip accounting accordingly.

Fixes: bb2a9acefaf9 ("md/raid1: switch to use md_account_bio() for io accounting")
Fixes: 820455238366 ("md/raid10: switch to use md_account_bio() for io accounting")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Reviewed-by: Xiao Ni <xiao@kernel.org>
Link: https://patch.msgid.link/20260501114652.590037-4-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c  | 2 +-
 drivers/md/raid10.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a07a5ed089e37..86c5319de7ad3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1307,7 +1307,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	r1_bio->read_disk = rdisk;
-	if (!r1bio_existed) {
+	if (likely(!md_cloned_bio(mddev, bio))) {
 		md_account_bio(mddev, &bio);
 		r1_bio->master_bio = bio;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 89a6165ef81de..3e1fabd72dab9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1164,7 +1164,7 @@ static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 }
 
 static void raid10_read_request(struct mddev *mddev, struct bio *bio,
-				struct r10bio *r10_bio, bool io_accounting)
+				struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
 	struct bio *read_bio;
@@ -1241,7 +1241,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
-	if (io_accounting) {
+	if (likely(!md_cloned_bio(mddev, bio))) {
 		md_account_bio(mddev, &bio);
 		r10_bio->master_bio = bio;
 	}
@@ -1604,7 +1604,7 @@ static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 
 	ret = true;
 	if (bio_data_dir(bio) == READ)
-		raid10_read_request(mddev, bio, r10_bio, true);
+		raid10_read_request(mddev, bio, r10_bio);
 	else
 		ret = raid10_write_request(mddev, bio, r10_bio);
 
@@ -3027,7 +3027,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
-	raid10_read_request(mddev, r10_bio->master_bio, r10_bio, false);
+	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
 	/*
 	 * allow_barrier after re-submit to ensure no sync io
 	 * can be issued while regular io pending.
-- 
2.53.0



