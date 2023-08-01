Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED9A1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616F0C433C7;
	Tue,  1 Aug 2023 09:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883212;
	bh=7FNHI+Q2fO0wDoJdAoqj9PfOnsF8ShCtskHPWBjbxLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoXAhnKCHTyN3OWnjTWc4s0yz05wKFL0B4tEXrYtAVp2BvdiEzNkA/x5LI2hT5NDV
	 gws+6TIvOWktL7uHrHTa2Xy1G5Uopgccf0vw+RFSQhNiNda48f+kis5xamGQZg9i6V
	 3x6omehYfb8JwE05Z5GgpvOu8FIAXKbkgshHjjPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 126/239] dm raid: fix missing reconfig_mutex unlock in raid_ctr() error paths
Date: Tue,  1 Aug 2023 11:19:50 +0200
Message-ID: <20230801091930.263846864@linuxfoundation.org>
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

[ Upstream commit bae3028799dc4f1109acc4df37c8ff06f2d8f1a0 ]

In the error paths 'bad_stripe_cache' and 'bad_check_reshape',
'reconfig_mutex' is still held after raid_ctr() returns.

Fixes: 9dbd1aa3a81c ("dm raid: add reshaping support to the target")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c8821fcb82998..85221a94c2073 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3271,15 +3271,19 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/* Try to adjust the raid4/5/6 stripe cache size to the stripe size */
 	if (rs_is_raid456(rs)) {
 		r = rs_set_raid456_stripe_cache(rs);
-		if (r)
+		if (r) {
+			mddev_unlock(&rs->md);
 			goto bad_stripe_cache;
+		}
 	}
 
 	/* Now do an early reshape check */
 	if (test_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
 		r = rs_check_reshape(rs);
-		if (r)
+		if (r) {
+			mddev_unlock(&rs->md);
 			goto bad_check_reshape;
+		}
 
 		/* Restore new, ctr requested layout to perform check */
 		rs_config_restore(rs, &rs_layout);
@@ -3288,6 +3292,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			r = rs->md.pers->check_reshape(&rs->md);
 			if (r) {
 				ti->error = "Reshape check failed";
+				mddev_unlock(&rs->md);
 				goto bad_check_reshape;
 			}
 		}
-- 
2.40.1



