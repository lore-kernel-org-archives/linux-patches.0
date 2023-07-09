Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA884699
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696FBC433C7;
	Sun,  9 Jul 2023 11:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901446;
	bh=RFPLE0tOY79sih6zxOVN64ckFrVBRFPXUW5JnXzLMfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1hcBdNnVd55BON0ZVuMr3H8aeK7udEo2AlnMoIZOzlmbKu2Bn2g74Z5IqK5UNMz3
	 gvFlKlma8qcjen+4cks+07SOKwWroZzKZCT0YJn4WPCVp4jpsWZ6k9J66OZaqeBipc
	 p/t78LDHuVRM8KWvKOS9RwHqjgwhjvZ/ev/B8Jw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 023/431] md/raid1-10: factor out a helper to add bio to plug
Date: Sun,  9 Jul 2023 13:09:31 +0200
Message-ID: <20230709111451.645677810@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit 5ec6ca140a034682e421e2e808ef5ddfdfd65242 ]

The code in raid1 and raid10 is identical, prepare to limit the number
of plugged bios.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230529131106.2123367-3-yukuai1@huaweicloud.com
Stable-dep-of: 7db922bae3ab ("md/raid1-10: submit write io directly if bitmap is not enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1-10.c | 16 ++++++++++++++++
 drivers/md/raid1.c    | 12 +-----------
 drivers/md/raid10.c   | 11 +----------
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index e61f6cad4e08e..9bf19a3409cef 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -109,3 +109,19 @@ static void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *rp,
 		size -= len;
 	} while (idx++ < RESYNC_PAGES && size > 0);
 }
+
+static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
+				      blk_plug_cb_fn unplug)
+{
+	struct raid1_plug_cb *plug = NULL;
+	struct blk_plug_cb *cb = blk_check_plugged(unplug, mddev,
+						   sizeof(*plug));
+
+	if (!cb)
+		return false;
+
+	plug = container_of(cb, struct raid1_plug_cb, cb);
+	bio_list_add(&plug->pending, bio);
+
+	return true;
+}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 68a9e2d9985b2..131d8fd5ccaab 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1343,8 +1343,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	struct bitmap *bitmap = mddev->bitmap;
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
-	struct blk_plug_cb *cb;
-	struct raid1_plug_cb *plug = NULL;
 	int first_clone;
 	int max_sectors;
 	bool write_behind = false;
@@ -1573,15 +1571,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 					      r1_bio->sector);
 		/* flush_pending_writes() needs access to the rdev so...*/
 		mbio->bi_bdev = (void *)rdev;
-
-		cb = blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
-		if (cb)
-			plug = container_of(cb, struct raid1_plug_cb, cb);
-		else
-			plug = NULL;
-		if (plug) {
-			bio_list_add(&plug->pending, mbio);
-		} else {
+		if (!raid1_add_bio_to_plug(mddev, mbio, raid1_unplug)) {
 			spin_lock_irqsave(&conf->device_lock, flags);
 			bio_list_add(&conf->pending_bio_list, mbio);
 			spin_unlock_irqrestore(&conf->device_lock, flags);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5af4e8aa08e96..a6cc066a86f09 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1288,8 +1288,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
 	unsigned long flags;
-	struct blk_plug_cb *cb;
-	struct raid1_plug_cb *plug = NULL;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
 	int devnum = r10_bio->devs[n_copy].devnum;
@@ -1329,14 +1327,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 
 	atomic_inc(&r10_bio->remaining);
 
-	cb = blk_check_plugged(raid10_unplug, mddev, sizeof(*plug));
-	if (cb)
-		plug = container_of(cb, struct raid1_plug_cb, cb);
-	else
-		plug = NULL;
-	if (plug) {
-		bio_list_add(&plug->pending, mbio);
-	} else {
+	if (!raid1_add_bio_to_plug(mddev, mbio, raid10_unplug)) {
 		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
-- 
2.39.2



