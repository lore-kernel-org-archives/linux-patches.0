Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E6529A2;
	Tue, 30 Jul 2024 15:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354979; cv=none; b=Z1nryA9vyC7Mmbq9L1J/ibd/RTKmwRDD19QNvu7SBpc8hZnjo5kLrt/guqYkf9twjevB+ewdKgilGYsnxmAyIAqZ49WavvElMgCJ4AGYaPgFsxbmcIXv973VQz6PchDvWb3SYa4UHjTBTtvHx+I6FJRq30x6H+05KXO8QTvPDN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354979; c=relaxed/simple;
	bh=AN44CGrXuZXp0haZSVaFpgrLgEd8TnqLt2yAVVjwKUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zu5lGBwyZQgTZJEXg+DXrlddY+xkdKbrnXQqdr7qvJhdjIodXCbm6cSqEF6Swc79jdsxfU4MTav4I2+tZuPjofyQLu13yUccUY24Q4T0YNq0/DffwRw6E9bLd2Uyayeyf7Hyks+QsJcr5jhkie8ySfYVHqHu9h9uj2zvSrDsAkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSuC+Pry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSuC+Pry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92ACCC4AF0C;
	Tue, 30 Jul 2024 15:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354979;
	bh=AN44CGrXuZXp0haZSVaFpgrLgEd8TnqLt2yAVVjwKUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSuC+PryUIiHORbsU3lJDhnMvNzxHwLSFd2TL4FZORyQZEx2NegIm46l2fZwwbg9Q
	 w+Z9mvx0Ye42kuS9MyO0CQmeYPWiplC5ju9OkVhpi8MaHevPfCmjfwBklcPHPPxvNZ
	 GBEXDtXRpxJgkoeI07kd6KEYcO+sj79PZnjj/7yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 007/809] md/raid1: dont free conf on raid0_run failure
Date: Tue, 30 Jul 2024 17:38:03 +0200
Message-ID: <20240730151724.947032010@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 17f91ac0843b50462a9c9c8f18df962338bd3db2 ]

The core md code calls the ->free method which already frees conf.

Fixes: 07f1a6850c5d ("md/raid1: fail run raid1 array when active disk less than one")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240604172607.3185916-3-hch@lst.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b8a71ca66dde..1f321826ef02b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3204,7 +3204,6 @@ static int raid1_set_limits(struct mddev *mddev)
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-static void raid1_free(struct mddev *mddev, void *priv);
 static int raid1_run(struct mddev *mddev)
 {
 	struct r1conf *conf;
@@ -3238,7 +3237,7 @@ static int raid1_run(struct mddev *mddev)
 	if (!mddev_is_dm(mddev)) {
 		ret = raid1_set_limits(mddev);
 		if (ret)
-			goto abort;
+			return ret;
 	}
 
 	mddev->degraded = 0;
@@ -3252,8 +3251,7 @@ static int raid1_run(struct mddev *mddev)
 	 */
 	if (conf->raid_disks - mddev->degraded < 1) {
 		md_unregister_thread(mddev, &conf->thread);
-		ret = -EINVAL;
-		goto abort;
+		return -EINVAL;
 	}
 
 	if (conf->raid_disks - mddev->degraded == 1)
@@ -3277,14 +3275,8 @@ static int raid1_run(struct mddev *mddev)
 	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
 	ret = md_integrity_register(mddev);
-	if (ret) {
+	if (ret)
 		md_unregister_thread(mddev, &mddev->thread);
-		goto abort;
-	}
-	return 0;
-
-abort:
-	raid1_free(mddev, conf);
 	return ret;
 }
 
-- 
2.43.0



