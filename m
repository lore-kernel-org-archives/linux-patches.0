Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602C3174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7889C433C8;
	Wed,  9 Aug 2023 11:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579029;
	bh=Zyl2TsRFo6xG9QTn6JXHh8R6JmKmvFSHWQSAEkmElhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgN5MG/PhQlcqLZdSbLEkTKtINWPGhtAau1fhTykuWub40bEv9tX61FL3pwkjr11m
	 m/f56SgkD3GAp7OiM5DxVJBrFgUUbRrXyqMxqex2n2QGi3vxaBZFVx+EoTM/qeSJZy
	 XUVMSFNJXYeNuyyb5sbJuj5i2PVOF1lqWcv0Jm0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 011/204] md/raid10: fix io loss while replacement replace rdev
Date: Wed,  9 Aug 2023 12:39:09 +0200
Message-ID: <20230809103642.957299233@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 2ae6aaf76912bae53c74b191569d2ab484f24bf3 ]

When removing a disk with replacement, the replacement will be used to
replace rdev. During this process, there is a brief window in which both
rdev and replacement are read as NULL in raid10_write_request(). This
will result in io not being submitted but it should be.

  //remove				//write
  raid10_remove_disk			raid10_write_request
   mirror->rdev = NULL
					 read rdev -> NULL
   mirror->rdev = mirror->replacement
   mirror->replacement = NULL
					 read replacement -> NULL

Fix it by reading replacement first and rdev later, meanwhile, use smp_mb()
to prevent memory reordering.

Fixes: 475b0321a4df ("md/raid10: writes should get directed to replacement as well as original.")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230602091839.743798-3-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 95c3a21cd7335..25c8f3e3d2edb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -775,8 +775,16 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 		disk = r10_bio->devs[slot].devnum;
 		rdev = rcu_dereference(conf->mirrors[disk].replacement);
 		if (rdev == NULL || test_bit(Faulty, &rdev->flags) ||
-		    r10_bio->devs[slot].addr + sectors > rdev->recovery_offset)
+		    r10_bio->devs[slot].addr + sectors >
+		    rdev->recovery_offset) {
+			/*
+			 * Read replacement first to prevent reading both rdev
+			 * and replacement as NULL during replacement replace
+			 * rdev.
+			 */
+			smp_mb();
 			rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		}
 		if (rdev == NULL ||
 		    test_bit(Faulty, &rdev->flags))
 			continue;
@@ -1366,9 +1374,15 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	for (i = 0;  i < conf->copies; i++) {
 		int d = r10_bio->devs[i].devnum;
-		struct md_rdev *rdev = rcu_dereference(conf->mirrors[d].rdev);
-		struct md_rdev *rrdev = rcu_dereference(
-			conf->mirrors[d].replacement);
+		struct md_rdev *rdev, *rrdev;
+
+		rrdev = rcu_dereference(conf->mirrors[d].replacement);
+		/*
+		 * Read replacement first to prevent reading both rdev and
+		 * replacement as NULL during replacement replace rdev.
+		 */
+		smp_mb();
+		rdev = rcu_dereference(conf->mirrors[d].rdev);
 		if (rdev == rrdev)
 			rrdev = NULL;
 		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
-- 
2.39.2



