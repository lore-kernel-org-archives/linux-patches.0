Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1966C1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D21EC433C7;
	Mon, 11 Sep 2023 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441914;
	bh=jltHfP2ZgMuN5mzA4Rxh9j6RyRWvtKpqOWxE6svlMTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqFnGxvUhLsA8gx9iwISQ7UZgbxtHftl8bSez48ed4VwkTqAh2vLPvkmiThnotU4g
	 H962fqgwlpwQZFH8Tv1y9XYCcJ7Ybbr3Zf6SleXO1G/VLoSuFPWWfbCtVft8yV9HR0
	 XYOXLN57+xrkhVwJc/1brsb+IMXac9rR6VwWL1to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 553/739] f2fs: check zone type before sending async reset zone command
Date: Mon, 11 Sep 2023 15:45:52 +0200
Message-ID: <20230911134706.534388822@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 3cb88bc15937990177df1f7eac6f22ebbed19312 ]

The commit 25f9080576b9 ("f2fs: add async reset zone command support")
introduced "async reset zone commands" by calling
__submit_zone_reset_cmd() in async discard operations. However,
__submit_zone_reset_cmd() is called regardless of zone type of discard
target zone. When devices have conventional zones, zone reset commands
are sent to the conventional zones and cause I/O errors.

Avoid the I/O errors by checking that the discard target zone type is
sequential write required. If not, handle the discard operation in same
manner as non-zoned, regular block devices. For that purpose, add a new
helper function f2fs_bdev_index() which gets index of the zone reset
target device.

Fixes: 25f9080576b9 ("f2fs: add async reset zone command support")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    | 16 ++++++++++++++++
 fs/f2fs/segment.c | 39 ++++++++++++++++++++++++++++-----------
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d372bedb0fe4e..a52830927cb49 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4423,6 +4423,22 @@ static inline bool f2fs_blkz_is_seq(struct f2fs_sb_info *sbi, int devi,
 }
 #endif
 
+static inline int f2fs_bdev_index(struct f2fs_sb_info *sbi,
+				  struct block_device *bdev)
+{
+	int i;
+
+	if (!f2fs_is_multi_device(sbi))
+		return 0;
+
+	for (i = 0; i < sbi->s_ndevs; i++)
+		if (FDEV(i).bdev == bdev)
+			return i;
+
+	WARN_ON(1);
+	return -1;
+}
+
 static inline bool f2fs_hw_should_discard(struct f2fs_sb_info *sbi)
 {
 	return f2fs_sb_has_blkzoned(sbi);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index cbb4bd95ea198..b127c3d96dbb0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1258,8 +1258,16 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 
 #ifdef CONFIG_BLK_DEV_ZONED
 	if (f2fs_sb_has_blkzoned(sbi) && bdev_is_zoned(bdev)) {
-		__submit_zone_reset_cmd(sbi, dc, flag, wait_list, issued);
-		return 0;
+		int devi = f2fs_bdev_index(sbi, bdev);
+
+		if (devi < 0)
+			return -EINVAL;
+
+		if (f2fs_blkz_is_seq(sbi, devi, dc->di.start)) {
+			__submit_zone_reset_cmd(sbi, dc, flag,
+						wait_list, issued);
+			return 0;
+		}
 	}
 #endif
 
@@ -1785,15 +1793,24 @@ static void f2fs_wait_discard_bio(struct f2fs_sb_info *sbi, block_t blkaddr)
 	dc = __lookup_discard_cmd(sbi, blkaddr);
 #ifdef CONFIG_BLK_DEV_ZONED
 	if (dc && f2fs_sb_has_blkzoned(sbi) && bdev_is_zoned(dc->bdev)) {
-		/* force submit zone reset */
-		if (dc->state == D_PREP)
-			__submit_zone_reset_cmd(sbi, dc, REQ_SYNC,
-						&dcc->wait_list, NULL);
-		dc->ref++;
-		mutex_unlock(&dcc->cmd_lock);
-		/* wait zone reset */
-		__wait_one_discard_bio(sbi, dc);
-		return;
+		int devi = f2fs_bdev_index(sbi, dc->bdev);
+
+		if (devi < 0) {
+			mutex_unlock(&dcc->cmd_lock);
+			return;
+		}
+
+		if (f2fs_blkz_is_seq(sbi, devi, dc->di.start)) {
+			/* force submit zone reset */
+			if (dc->state == D_PREP)
+				__submit_zone_reset_cmd(sbi, dc, REQ_SYNC,
+							&dcc->wait_list, NULL);
+			dc->ref++;
+			mutex_unlock(&dcc->cmd_lock);
+			/* wait zone reset */
+			__wait_one_discard_bio(sbi, dc);
+			return;
+		}
 	}
 #endif
 	if (dc) {
-- 
2.40.1



