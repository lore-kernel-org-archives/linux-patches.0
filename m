Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C5137E5D1;
	Sat, 12 Sep 2026 12:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216683; cv=none; b=ilGNp8QEkuxeFLQf+0R9K6awyK2PCVsu3SKAxDd9ZHgxTJFUrewRgR4wbu0qHJVaGpgqOTX4oN+DSQX5wwbX3onLVOI6PpskDXKatrw4+vbhCCwckyLxJiMuJWwUFihWLhnpBJ4/fZXkXJFKj5WmPQ1e79zAuw2VMZpR0Hy3irM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216683; c=relaxed/simple;
	bh=TnwdOicVCEr/Jf5N9qSvTXYAo2U32zOruFRrnIVPcn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTDdhwEpeSB4SymYF5jmpAJnQ7Ia1l+6kPj7J8ZK41IvKowvPe5ByfRlgJMWyvSPnEaJ++TIHSSfnG16ak8ZJENb53q6wFxXXdpt828gDbxB44V1VU7ECXxk7GfFIY0j7eQtP9AVoPbMQPOJmXkAR+pjYQmLgXqUrEN9lt4C+cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9xAIZNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9xAIZNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5901F000FF;
	Sat, 12 Sep 2026 12:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216682;
	bh=3S87onBEUvwK3H12CJSFqI2NgJbDqZsbSYukTRDzXtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9xAIZNIwkqxDPgWcLr7zcaTiU11QCHN/l8DVPcGg2cpJseXbNRTbwsDwuLLFuVjC
	 2qSJzfakqRH3rEdu6riCgBbswzvneyxI6kHC03RicKWjzhCgd9VFaRFIAF8QZHqa0f
	 G4D1/uknoAVsTe1MCEt9muKlWtZLvEXdEiuG7eoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0784/1376] md: skip redundant raid_disks update when value is unchanged
Date: Sat, 12 Sep 2026 08:53:30 +0200
Message-ID: <20260912065625.010629432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 47b5415cd5a3b..27d8b973c89b1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4196,9 +4196,10 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
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



