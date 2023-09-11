Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9220211706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163D2C433C7;
	Mon, 11 Sep 2023 14:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443495;
	bh=1b+DgQRqDW7KKgapGFll2FccB3wYrRYUD1V8IBf0XkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lj+HBSaFqCPy9pkJ+qO59UBAj7DoM11t0oHIVUndoGVM5e+eaMdTqDjWnmWHYQZSK
	 KzUDPVvul6rTRIW2Sf2SRn9RjGhcKALGmpifBA0GYAl5zVs9myZfYmct5/puhlhOFd
	 +AyVtILjp3WtfkHmkmlZmo+6YR0zunDPlYRc08nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xueshi Hu <xueshi.hu@smartx.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 398/737] md/raid1: free the r1bio before waiting for blocked rdev
Date: Mon, 11 Sep 2023 15:44:17 +0200
Message-ID: <20230911134701.718497814@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueshi Hu <xueshi.hu@smartx.com>

[ Upstream commit 992db13a4aee766c8bfbf046ad15c2db5fa7cab8 ]

Raid1 reshape will change mempool and r1conf::raid_disks which are
needed to free r1bio. allow_barrier() make a concurrent raid1_reshape()
possible. So, free the in-flight r1bio before waiting blocked rdev.

Fixes: 6bfe0b499082 ("md: support blocking writes to an array on device failure")
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
Link: https://lore.kernel.org/r/20230814135356.1113639-3-xueshi.hu@smartx.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e51b77a3a8397..ebbe41a33b821 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1370,6 +1370,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		return;
 	}
 
+ retry_write:
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
 
@@ -1385,7 +1386,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	disks = conf->raid_disks * 2;
- retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
 	max_sectors = r1_bio->sectors;
@@ -1465,7 +1465,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		for (j = 0; j < i; j++)
 			if (r1_bio->bios[j])
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
-		r1_bio->state = 0;
+		free_r1bio(r1_bio);
 		allow_barrier(conf, bio->bi_iter.bi_sector);
 
 		if (bio->bi_opf & REQ_NOWAIT) {
-- 
2.40.1



