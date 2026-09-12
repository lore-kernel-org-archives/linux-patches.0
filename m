Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3A2288B2;
	Sat, 12 Sep 2026 10:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208892; cv=none; b=Ivb8Ts+5eF1KHjrNEGODAmrIX0UqS0d5cQf6H1DMYmlTDK/JjZsDwiRImtQzp/jfMS8Ab2nB4nS6E5solQ2xrUEqkp7FNP+89DWAV5P9fW/C/gcNk0KsBWjSKP7ABu4mb45uWj8IqbYLr+7IJpJIZgS4iEVl1MCAMcL/PG+zD3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208892; c=relaxed/simple;
	bh=ngFumisuZDfm1firR8Xnrdxd3GQNYyjSJv85kwCGngk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmZPIKgOEpqUCv7QrxIUTBguLBTSTkTnwYkLI+JXUOprYDe58/jd2c+uXHvZt7++O4A/7kHkjOUPZTEWVKBUWk3ly5ly3Asv6IXkDPsI3wv3KaLQfZRwTKDiyKUs1AMP2mI5wygD4qx+SGRYCzoWdhDYciOdSb3Ko5fB4or74Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAtp6ySU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAtp6ySU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26591F000FF;
	Sat, 12 Sep 2026 10:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208890;
	bh=y9SJguJ3AGFuB/gqhh6puenS9f5Hb+0shGzCcs30XvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAtp6ySUoWuhRhl0Crkfm3anAsgxAK2y1TZipJvDdaTdl60zar8/rAeuOa09BJkmv
	 c/pbgv6JzXfRRQXWZTqD5W7Yj1SnAtAkpmuQ53AZKX4+Lrfo5DMVMgeqPQlQdVnu/M
	 /1ZlSrUDWIejKdBHn0cWVsl0x9fvE7kBAt7g+gMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0710/1518] md: skip redundant raid_disks update when value is unchanged
Date: Sat, 12 Sep 2026 08:47:59 +0200
Message-ID: <20260912065639.493638618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit abaf4783822851678632e5cea98aa5aead99852f ]

Calling update_raid_disks() with the same value as the current one
can trigger unnecessary work. For example, RAID1 will reallocate
resources such as the mempool for r1bio.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260428130524.448063-1-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Stable-dep-of: bace2010dd7a ("md: scope memalloc_noio to allocation critical sections")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 93e5774618126..debe07631d6ba 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4421,9 +4421,10 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
-	if (mddev->pers)
-		err = update_raid_disks(mddev, n);
-	else if (mddev->reshape_position != MaxSector) {
+	if (mddev->pers) {
+		if (n != mddev->raid_disks)
+			err = update_raid_disks(mddev, n);
+	} else if (mddev->reshape_position != MaxSector) {
 		struct md_rdev *rdev;
 		int olddisks = mddev->raid_disks - mddev->delta_disks;
 
-- 
2.53.0



