Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4DF1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D12C433C7;
	Tue,  1 Aug 2023 09:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883215;
	bh=MjqOyaGGkOMwcX1CkxtbDQ+YlUy09bIxID2kzDvMwLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4abFDYGjfEn3oTIhczBs7DCk5FjlBez4suh9nT8fHuAfyuWTMgDg2qQyuRAteOwi
	 jRNT7qpJdhTZSyiyKnUJJgffqY5Y5praFq2ulFV069q9+svaO0Zi8IDyPDSlCzXMCj
	 6MmU452wKSOUpgLGnpn0Kzub8JgS6qUwq2l0eAwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 127/239] dm raid: clean up four equivalent goto tags in raid_ctr()
Date: Tue,  1 Aug 2023 11:19:51 +0200
Message-ID: <20230801091930.294601709@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
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
index 85221a94c2073..156d44f690096 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3251,8 +3251,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	r = md_start(&rs->md);
 	if (r) {
 		ti->error = "Failed to start raid array";
-		mddev_unlock(&rs->md);
-		goto bad_md_start;
+		goto bad_unlock;
 	}
 
 	/* If raid4/5/6 journal mode explicitly requested (only possible with journal dev) -> set it */
@@ -3260,8 +3259,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		r = r5c_journal_mode_set(&rs->md, rs->journal_dev.mode);
 		if (r) {
 			ti->error = "Failed to set raid4/5/6 journal mode";
-			mddev_unlock(&rs->md);
-			goto bad_journal_mode_set;
+			goto bad_unlock;
 		}
 	}
 
@@ -3271,19 +3269,15 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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
@@ -3292,8 +3286,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			r = rs->md.pers->check_reshape(&rs->md);
 			if (r) {
 				ti->error = "Reshape check failed";
-				mddev_unlock(&rs->md);
-				goto bad_check_reshape;
+				goto bad_unlock;
 			}
 		}
 	}
@@ -3304,10 +3297,8 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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



