Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB4817BED0;
	Sat, 17 Oct 2026 16:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254655; cv=none; b=A0QSI1Rx6P/QYXT2GMV72Na8NexmPpQecWgyEMj9JJ7/cCifffDBYD8jXhP+riuY+b0pwqKKrVPkmC3MCwtrRphlmu80KkEQL0Iu5FWTc3pfUEHbr0IyCVFZFQVZtY8C+OjyxDbVJhvQpszZEcxp0AH6MuXftsPylHG6h6d01c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254655; c=relaxed/simple;
	bh=IyWy8sCVZ9iUOw9FtFCwLL4qrsPkhToQs/dy7qxT4pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5+3ZjTLPX5R5GYIe9N+yM5JDKhW9JhThHmxepq38QQJKKz+km/ArNO3E9vhpipf85xtiNUeX/JttNN8FTean86LFVgL94TkOkHNga5MQrxGimzBdjP8ep9nfMfYP/zIaNslmUDleGeZ1EpAgS3z48O4hGKZesbi/DYp/Q9sJ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvNuUf+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvNuUf+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D731F000C4;
	Sat, 17 Oct 2026 16:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254654;
	bh=bFKMJIbGb1Jd41yI5rau133f0lb2LUJq5Sg7YMPhPkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvNuUf+vJHqQI9MBw51RyYQAw6tVytUJoMfJ0rWSd5fiLZbBcgaB3gkq85QTbVucC
	 mZhrBw9mMKJWMYChNep59nQ8fDzGCIz1nBs6mV3sRJV7EstWgVChiITwwpLuxiBcYm
	 YdfXJcQaoAqfd6aGLp8DEvSYfiE2o9TtaZcb430E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 475/869] md/raid1,raid10: fix bio accounting for split md cloned bios
Date: Sat, 17 Oct 2026 17:55:16 +0200
Message-ID: <20261017160049.302478711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 91ecf50eba402..b365fd4595228 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1400,7 +1400,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	r1_bio->read_disk = rdisk;
-	if (!r1bio_existed) {
+	if (likely(!md_cloned_bio(mddev, bio))) {
 		md_account_bio(mddev, &bio);
 		r1_bio->master_bio = bio;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fc68e6b05ddfe..fe136080a3798 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1143,7 +1143,7 @@ static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 }
 
 static void raid10_read_request(struct mddev *mddev, struct bio *bio,
-				struct r10bio *r10_bio, bool io_accounting)
+				struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
 	struct bio *read_bio;
@@ -1220,7 +1220,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
-	if (io_accounting) {
+	if (likely(!md_cloned_bio(mddev, bio))) {
 		md_account_bio(mddev, &bio);
 		r10_bio->master_bio = bio;
 	}
@@ -1551,7 +1551,7 @@ static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 
 	ret = true;
 	if (bio_data_dir(bio) == READ)
-		raid10_read_request(mddev, bio, r10_bio, true);
+		raid10_read_request(mddev, bio, r10_bio);
 	else
 		ret = raid10_write_request(mddev, bio, r10_bio);
 
@@ -2889,7 +2889,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
-	raid10_read_request(mddev, r10_bio->master_bio, r10_bio, false);
+	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
 	/*
 	 * allow_barrier after re-submit to ensure no sync io
 	 * can be issued while regular io pending.
-- 
2.53.0



