Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18DF22A81D;
	Tue, 29 Apr 2025 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946504; cv=none; b=EXRDXZZJHZzAx2f0czaNHzNHjLPuj4k9LxiFQJ0zqRjMY6c12TN9gwEI1r8yaGLwGwvrOvmrL7B0rm/PQ3wM7z/EW+lWFHhczpR8HNuIa7qu700jtgM9d1rVX/71fb+c9zvyiSOibmFr7uTUZtLaAFtJLrgWXci3gJB0HT3PB1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946504; c=relaxed/simple;
	bh=xd0K4xUxtZ9DDlz+3Juv0zYjyooiJc+WM/aavORjJDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpamxDNy5lpg70jgtyKLxiub/9E/APZMoXC4A67HxsU1fkb9/yBo/zCrIfPvysvfXmNkWiRlXWWEaPq1Lx4aM0NFNXQWlwZNEx5CDxygKr0zTO6oghF1TBKgY8Keb7jVFapBDQduEuc7REhJABPKV9twJZ4zpUsh+zNui6gYSr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0vuj3Ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0vuj3Ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B60C4CEE9;
	Tue, 29 Apr 2025 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946503;
	bh=xd0K4xUxtZ9DDlz+3Juv0zYjyooiJc+WM/aavORjJDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0vuj3Eat4AwiNI7p/MwZBNXAd9GaospKibyN8seAVCv0xhgVYzGzab8m6apfYNGa
	 65h/vH4ozeZ4mB9JY7fKXpWY19MAzrMOgo7xH52wpnT2ALr9Y+u20IUynykMVYfj6x
	 6kQnK+cx+516xKpWvOASGYRA/lMn+xsfhutUcdXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meir Elisha <meir.elisha@volumez.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 289/311] md/raid1: Add check for missing source disk in process_checks()
Date: Tue, 29 Apr 2025 18:42:06 +0200
Message-ID: <20250429161132.842909451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meir Elisha <meir.elisha@volumez.com>

[ Upstream commit b7c178d9e57c8fd4238ff77263b877f6f16182ba ]

During recovery/check operations, the process_checks function loops
through available disks to find a 'primary' source with successfully
read data.

If no suitable source disk is found after checking all possibilities,
the 'primary' index will reach conf->raid_disks * 2. Add an explicit
check for this condition after the loop. If no source disk was found,
print an error message and return early to prevent further processing
without a valid primary source.

Link: https://lore.kernel.org/linux-raid/20250408143808.1026534-1-meir.elisha@volumez.com
Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 15829ab192d2b..7373dff023d0f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2199,14 +2199,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				if (!rdev_set_badblocks(rdev, sect, s, 0))
 					abort = 1;
 			}
-			if (abort) {
-				conf->recovery_disabled =
-					mddev->recovery_disabled;
-				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_done_sync(mddev, r1_bio->sectors, 0);
-				put_buf(r1_bio);
+			if (abort)
 				return 0;
-			}
+
 			/* Try next page */
 			sectors -= s;
 			sect += s;
@@ -2345,10 +2340,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 	int disks = conf->raid_disks * 2;
 	struct bio *wbio;
 
-	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
-		/* ouch - failed to read all of that. */
-		if (!fix_sync_read_error(r1_bio))
+	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+		/*
+		 * ouch - failed to read all of that.
+		 * No need to fix read error for check/repair
+		 * because all member disks are read.
+		 */
+		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
+		    !fix_sync_read_error(r1_bio)) {
+			conf->recovery_disabled = mddev->recovery_disabled;
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+			md_done_sync(mddev, r1_bio->sectors, 0);
+			put_buf(r1_bio);
 			return;
+		}
+	}
 
 	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 		process_checks(r1_bio);
-- 
2.39.5



