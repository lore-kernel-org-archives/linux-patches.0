Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A674FD26C;
	Tue, 13 Oct 2026 12:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893706; cv=none; b=jbjKRAoJME1i1SF1O4zjqqVWMIu4HaTHqq5C+RqCGKZEaVNv5izGTZQV2Hxh++Qynwhrg7+ohNbtXZxI25WOPhfxWeC/n+/uFUTl7C6/ArlJWKcCTiKe5HJTBCxhj6nPmyRFazYmMfbAEjT/4jWmz2QNFYjyqrmhucHOlIxkmT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893706; c=relaxed/simple;
	bh=hP9NvJqZ7E/mhCdbiuIYZY72m3eOQhIzNwv38OpuTEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lw0lPdORTijvdNwd0wmRKPlWvMCx4YL1HhiEa/vH/Klr3hkMsTDyOZHSn8+9IlEwJPNVveuaThHi1jk+msaUAnzLaGQSXJKaXq3hM5Rm72r+6VyKb5EVi2e+aLSJ+y22tjgzasaAwmmQxX94gN+NK6nyBV98zpL569FsZDjZ4/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmEa/ISC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmEa/ISC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3371F00898;
	Tue, 13 Oct 2026 12:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893704;
	bh=dQNmaTTorEtz2FhWr1A4MDKCd8MmksfXdpWzjMpKSG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmEa/ISCgRwCOlD9lOtBhtSQNGc2Fp64qGp/njMRISpfeGrwdmALVbSTwNcre/mSu
	 2zg8MgPG4hnpdaiN6ZP5ms3Vmd6XmCSllQ5SGujMnJ/vEzHfV2UbzPgw1Z5u2Zk6K5
	 XObMmmDKeidofc5p4JZ+z0ZpmzeqhEn+09YKdqik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 315/621] md/raid1,raid10: fix bio accounting for split md cloned bios
Date: Tue, 13 Oct 2026 13:35:10 +0200
Message-ID: <20261013112928.329320082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 333ac4fbe59bc..e92e3ac9ba775 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1399,7 +1399,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	r1_bio->read_disk = rdisk;
-	if (!r1bio_existed) {
+	if (likely(!md_cloned_bio(mddev, bio))) {
 		md_account_bio(mddev, &bio);
 		r1_bio->master_bio = bio;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 425ea36da24f2..88acdd980f192 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1146,7 +1146,7 @@ static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 }
 
 static void raid10_read_request(struct mddev *mddev, struct bio *bio,
-				struct r10bio *r10_bio, bool io_accounting)
+				struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
 	struct bio *read_bio;
@@ -1218,7 +1218,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
-	if (io_accounting) {
+	if (likely(!md_cloned_bio(mddev, bio))) {
 		md_account_bio(mddev, &bio);
 		r10_bio->master_bio = bio;
 	}
@@ -1542,7 +1542,7 @@ static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 
 	ret = true;
 	if (bio_data_dir(bio) == READ)
-		raid10_read_request(mddev, bio, r10_bio, true);
+		raid10_read_request(mddev, bio, r10_bio);
 	else
 		ret = raid10_write_request(mddev, bio, r10_bio);
 
@@ -2871,7 +2871,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
-	raid10_read_request(mddev, r10_bio->master_bio, r10_bio, false);
+	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
 	/*
 	 * allow_barrier after re-submit to ensure no sync io
 	 * can be issued while regular io pending.
-- 
2.53.0



