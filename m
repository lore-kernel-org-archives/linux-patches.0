Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF24377015
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301646; cv=none; b=uYbn5ViiexxkZQL/R+vwhjTgyBn8hfCGaLSci7p55ysnGyFahbcHZOyErQt3sYwEpJibICS6raUrFt3Mj3L4r8RSEd5jO9Sh0B6+mbeqeUBX5xqxOvShbrdw98/gIwUQwxTYca+2AEtKbde4nC2DVJYl7Bcp1t4CxWRIe5MJbks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301646; c=relaxed/simple;
	bh=3zzcWUOG0ysL4aef0rDj/S1VC4zn8jFJ5UxqEwrBV1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIZ2LtbEiGCPGRk/SmPUyP8OiioaKctp/i/G9xbs5HJfpf1rxTtg+kjOLyiJZ5kftls26zIwjXnpYCFHEFypOELYldmTyj9b7e2k+DN5V3nky4cPxe66FFodX7ppjEWfVM/SyXCjgcG0rRMimvHYCS9PKsV5KqkW8Sr0cZfEuxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdAicpz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdAicpz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F43C19425;
	Sat, 28 Feb 2026 18:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301646;
	bh=3zzcWUOG0ysL4aef0rDj/S1VC4zn8jFJ5UxqEwrBV1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdAicpz4Va9gefZd8wKl+KnniG9KbyoMy4iChi3e8iAHGBUg9RszwxfWSMa+sEyXV
	 xa+SOQJAfODju7y054GDM9Qw/XFmIfKtI65cnSaHaTnCIsS8klZS0qTZtNjK6Ibbeq
	 t3cTCmCTW9qpmyX6SIPq0VmSVz9KZUsusXu18jSmJ9t+DZ+7/u6XAS474iyVU58HRe
	 dn+R/isWHSjr1Os/03jg4Z7XKbQXIcwiJ8pV4ET/VqMWgu41RX5BVbC+70tr8XLRFB
	 4NQTEqep+KaImaa3KKD4u0KlmftPUNr0X5704QgaIAqMBFCv5Ju9wB9LX15LpbSHk9
	 6al94RW4q1rSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/385] md/raid1: fix memory leak in raid1_run() if no active rdev
Date: Sat, 28 Feb 2026 12:54:23 -0500
Message-ID: <20260228180011.1568201-41-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 5fbcf76e0dfe68578ffa2a8a691cc44cf586ae35 ]

When `raid1_set_limits()` fails or when the array has no active
`rdev`, the allocated memory for `conf` is not properly freed.

Add raid1_free() call to properly free the conf in error path.

Fixes: 799af947ed13 ("md/raid1: don't free conf on raid0_run failure")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250215020137.3703757-1-zhengqixing@huaweicloud.com
Singed-off-by: Yu Kuai <yukuai3@huawei.com>
Stable-dep-of: 6abc7d5dcf0e ("md/raid1: fix memory leak in raid1_run()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4c6b1bd6da9bb..f9c18ade06f15 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -45,6 +45,7 @@
 
 static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
 static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
+static void raid1_free(struct mddev *mddev, void *priv);
 
 #define RAID_1_10_NAME "raid1"
 #include "raid1-10.c"
@@ -3245,8 +3246,11 @@ static int raid1_run(struct mddev *mddev)
 
 	if (!mddev_is_dm(mddev)) {
 		ret = raid1_set_limits(mddev);
-		if (ret)
+		if (ret) {
+			if (!mddev->private)
+				raid1_free(mddev, conf);
 			return ret;
+		}
 	}
 
 	mddev->degraded = 0;
@@ -3260,6 +3264,8 @@ static int raid1_run(struct mddev *mddev)
 	 */
 	if (conf->raid_disks - mddev->degraded < 1) {
 		md_unregister_thread(mddev, &conf->thread);
+		if (!mddev->private)
+			raid1_free(mddev, conf);
 		return -EINVAL;
 	}
 
-- 
2.51.0

