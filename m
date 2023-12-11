Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5DAC8C8;
	Mon, 11 Dec 2023 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeOhtLPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD994C433C7;
	Mon, 11 Dec 2023 18:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319503;
	bh=7C9RWReUn7IMLl6Lfx289XxcbCU8I5P/5e3O7TnfELg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeOhtLPzxPz18NSIX47B88obNa+zL5ZLCkR2yMJHgGMBjUCl4bhfefTrDjwbyRdf4
	 8nu4ZUYObUrzTSI82MjWhFhKlEkzs8Xs1dpHuXfq5Mz2MgbuS6NC3mrGQKWNN9hVfC
	 1QGf/v1e4gn9/dRixLkpfgWMOQE4yF5f1zyQa4YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/244] md: dont leave MD_RECOVERY_FROZEN in error path of md_set_readonly()
Date: Mon, 11 Dec 2023 19:20:22 +0100
Message-ID: <20231211182051.599641455@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit c9f7cb5b2bc968adcdc686c197ed108f47fd8eb0 ]

If md_set_readonly() failed, the array could still be read-write, however
'MD_RECOVERY_FROZEN' could still be set, which leave the array in an
abnormal state that sync or recovery can't continue anymore.
Hence make sure the flag is cleared after md_set_readonly() returns.

Fixes: 88724bfa68be ("md: wait for pending superblock updates before switching to read-only")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231205094215.1824240-3-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2748b0b424cfe..b2ef6af8376a5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6316,6 +6316,9 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 	int err = 0;
 	int did_freeze = 0;
 
+	if (mddev->external && test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
+		return -EBUSY;
+
 	if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
 		did_freeze = 1;
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
@@ -6330,8 +6333,6 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 	 */
 	md_wakeup_thread_directly(mddev->sync_thread);
 
-	if (mddev->external && test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
-		return -EBUSY;
 	mddev_unlock(mddev);
 	wait_event(resync_wait, !test_bit(MD_RECOVERY_RUNNING,
 					  &mddev->recovery));
@@ -6344,29 +6345,30 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 	    mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 		pr_warn("md: %s still in use.\n",mdname(mddev));
-		if (did_freeze) {
-			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-			md_wakeup_thread(mddev->thread);
-		}
 		err = -EBUSY;
 		goto out;
 	}
+
 	if (mddev->pers) {
 		__md_stop_writes(mddev);
 
-		err  = -ENXIO;
-		if (mddev->ro == MD_RDONLY)
+		if (mddev->ro == MD_RDONLY) {
+			err  = -ENXIO;
 			goto out;
+		}
+
 		mddev->ro = MD_RDONLY;
 		set_disk_ro(mddev->gendisk, 1);
+	}
+
+out:
+	if ((mddev->pers && !err) || did_freeze) {
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
-		err = 0;
 	}
-out:
+
 	mutex_unlock(&mddev->open_mutex);
 	return err;
 }
-- 
2.42.0



