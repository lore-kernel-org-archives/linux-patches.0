Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B800E545
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBA2C433C8;
	Tue,  1 Aug 2023 09:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882513;
	bh=qFwHa+ksUU3HOAoFjVmHRjxfEVJDqA0qWVCoPhJ7M8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QpsTs80X6Dnd7O+fN3mNnEOKnhyv5Wc0hN9iSO29aRoTHHrYzWvwpuYUg08QVRcg
	 Zd/Eyc9AgAPqvMK6ACOVSytdIUdTjMy5CB+PEkDSI1sXDPK9urAGE6ZtDXSzhPDJcj
	 d5ptujkNIQl4X+F0Y95jJtXc12jyD5ZJixbxV0Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/228] dm raid: clean up four equivalent goto tags in raid_ctr()
Date: Tue,  1 Aug 2023 11:19:50 +0200
Message-ID: <20230801091927.507959843@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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

[ Upstream commit e74c874eabe2e9173a8fbdad616cd89c70eb8ffd ]

There are four equivalent goto tags in raid_ctr(), clean them up to
use just one.

There is no functional change and this is preparation to fix
raid_ctr()'s unprotected md_stop().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Stable-dep-of: 7d5fff8982a2 ("dm raid: protect md_stop() with 'reconfig_mutex'")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index bd0da5bbd57b0..c3736d1f72310 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3254,8 +3254,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	r = md_start(&rs->md);
 	if (r) {
 		ti->error = "Failed to start raid array";
-		mddev_unlock(&rs->md);
-		goto bad_md_start;
+		goto bad_unlock;
 	}
 
 	/* If raid4/5/6 journal mode explicitly requested (only possible with journal dev) -> set it */
@@ -3263,8 +3262,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		r = r5c_journal_mode_set(&rs->md, rs->journal_dev.mode);
 		if (r) {
 			ti->error = "Failed to set raid4/5/6 journal mode";
-			mddev_unlock(&rs->md);
-			goto bad_journal_mode_set;
+			goto bad_unlock;
 		}
 	}
 
@@ -3274,19 +3272,15 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/* Try to adjust the raid4/5/6 stripe cache size to the stripe size */
 	if (rs_is_raid456(rs)) {
 		r = rs_set_raid456_stripe_cache(rs);
-		if (r) {
-			mddev_unlock(&rs->md);
-			goto bad_stripe_cache;
-		}
+		if (r)
+			goto bad_unlock;
 	}
 
 	/* Now do an early reshape check */
 	if (test_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
 		r = rs_check_reshape(rs);
-		if (r) {
-			mddev_unlock(&rs->md);
-			goto bad_check_reshape;
-		}
+		if (r)
+			goto bad_unlock;
 
 		/* Restore new, ctr requested layout to perform check */
 		rs_config_restore(rs, &rs_layout);
@@ -3295,8 +3289,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			r = rs->md.pers->check_reshape(&rs->md);
 			if (r) {
 				ti->error = "Reshape check failed";
-				mddev_unlock(&rs->md);
-				goto bad_check_reshape;
+				goto bad_unlock;
 			}
 		}
 	}
@@ -3307,10 +3300,8 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	mddev_unlock(&rs->md);
 	return 0;
 
-bad_md_start:
-bad_journal_mode_set:
-bad_stripe_cache:
-bad_check_reshape:
+bad_unlock:
+	mddev_unlock(&rs->md);
 	md_stop(&rs->md);
 bad:
 	raid_set_free(rs);
-- 
2.40.1



