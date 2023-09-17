Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779B57469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4620C433C8;
	Sun, 17 Sep 2023 20:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982229;
	bh=d3YS2hd80VNgz+RFjzoHo6/5gpVaV7QMFkLYg7ZjpwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsW6gIP0aOMi7il8BwxFt70ebNRvxlpG4cNyC9WDJp8nF4n/sJTbg0po9x30DohRV
	 oDhgnrVSYB1BK2TTgkP3hwiqZjDwDnt2Vtkb38CrxLqiTzgTDb0yGC7fQoxQ6t+ayR
	 nK/Xs25uVALYbnOTuk1p1VxrFRTtHtGuWIlHUmKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/511] md/raid10: use dereference_rdev_and_rrdev() to get devices
Date: Sun, 17 Sep 2023 21:09:49 +0200
Message-ID: <20230917191117.757757218@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 673643490b9a0eb3b25633abe604f62b8f63dba1 ]

Commit 2ae6aaf76912 ("md/raid10: fix io loss while replacement replace
rdev") reads replacement first to prevent io loss. However, there are same
issue in wait_blocked_dev() and raid10_handle_discard(), too. Fix it by
using dereference_rdev_and_rrdev() to get devices.

Fixes: d30588b2731f ("md/raid10: improve raid10 discard request")
Fixes: f2e7e269a752 ("md/raid10: pull the code that wait for blocked dev into one function")
Signed-off-by: Li Nan <linan122@huawei.com>
Link: https://lore.kernel.org/r/20230701080529.2684932-4-linan666@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ff3c97cde7699..a3a3a02d48b17 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1345,11 +1345,9 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 	blocked_rdev = NULL;
 	rcu_read_lock();
 	for (i = 0; i < conf->copies; i++) {
-		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
-		struct md_rdev *rrdev = rcu_dereference(
-			conf->mirrors[i].replacement);
-		if (rdev == rrdev)
-			rrdev = NULL;
+		struct md_rdev *rdev, *rrdev;
+
+		rdev = dereference_rdev_and_rrdev(&conf->mirrors[i], &rrdev);
 		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
 			atomic_inc(&rdev->nr_pending);
 			blocked_rdev = rdev;
@@ -1785,10 +1783,9 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	 */
 	rcu_read_lock();
 	for (disk = 0; disk < geo->raid_disks; disk++) {
-		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
-		struct md_rdev *rrdev = rcu_dereference(
-			conf->mirrors[disk].replacement);
+		struct md_rdev *rdev, *rrdev;
 
+		rdev = dereference_rdev_and_rrdev(&conf->mirrors[disk], &rrdev);
 		r10_bio->devs[disk].bio = NULL;
 		r10_bio->devs[disk].repl_bio = NULL;
 
-- 
2.40.1



