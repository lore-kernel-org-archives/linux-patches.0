Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B56A3EA83;
	Mon,  1 Apr 2024 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986945; cv=none; b=DSFmJ/CVZNAE8EJBVk8GECf/lxvIzkV0tEAW3225IoZX3T0073mX2uFcd72q50EGygW57y83e46hKp8bhimxFn5WJOcMCDtRv2h5J4F+2l3hTE6oWVfmFzbyj0h61HUfk88qfJqmV4FU6cEYNUh63P/bauqdFSVhAr5mM2G614o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986945; c=relaxed/simple;
	bh=tia22adUKPUSOu2+B32NNHNWQquSPnDzM15ZWg+MqHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+6WY51jMjH5B7w+WtVBY4lRW/D3a/AHJMujDa5WSu13qnfMLhOI0Bfkksz9y87RxlkmY17TSA/WLU6V2kbAsqPtbF6QwIxL7wzHdB44PIyCmSHu/NS+ikLGxsVFsFlDICKhETDnsruxXOa/qqB+Sj7ICnRiTwB+dqIroka0ll8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eD138f1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eD138f1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1942C433C7;
	Mon,  1 Apr 2024 15:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986945;
	bh=tia22adUKPUSOu2+B32NNHNWQquSPnDzM15ZWg+MqHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eD138f1mptV4VgE/N0AQObcSLxROFuep+biGr7Kf7IR9qlaTzxOeBMclpJ9a/m74h
	 HN8tby4nnG2jhkREk1b2AU8wlG06LGYF4+3XFiZpKz9Di30YFOeHnGHCNMw2XsIgC6
	 +eUcxx8EOCWU9p8t+wzLenz4eiS5Wq2BbzznWD9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 105/399] md: export helpers to stop sync_thread
Date: Mon,  1 Apr 2024 17:41:11 +0200
Message-ID: <20240401152552.321475777@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 7a2347e284d7ec2f0759be4db60fa7ca937284fc ]

Add new helpers:

  void md_idle_sync_thread(struct mddev *mddev);
  void md_frozen_sync_thread(struct mddev *mddev);
  void md_unfrozen_sync_thread(struct mddev *mddev);

The helpers will be used in dm-raid in later patches to fix regressions
and prevent calling md_reap_sync_thread() directly.

Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240305072306.2562024-3-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 29 +++++++++++++++++++++++++++++
 drivers/md/md.h |  3 +++
 2 files changed, 32 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3d3a419190042..7255678608e7c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4920,6 +4920,35 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
 		mddev_lock_nointr(mddev);
 }
 
+void md_idle_sync_thread(struct mddev *mddev)
+{
+	lockdep_assert_held(&mddev->reconfig_mutex);
+
+	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	stop_sync_thread(mddev, true, true);
+}
+EXPORT_SYMBOL_GPL(md_idle_sync_thread);
+
+void md_frozen_sync_thread(struct mddev *mddev)
+{
+	lockdep_assert_held(&mddev->reconfig_mutex);
+
+	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	stop_sync_thread(mddev, true, false);
+}
+EXPORT_SYMBOL_GPL(md_frozen_sync_thread);
+
+void md_unfrozen_sync_thread(struct mddev *mddev)
+{
+	lockdep_assert_held(&mddev->reconfig_mutex);
+
+	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
+	sysfs_notify_dirent_safe(mddev->sysfs_action);
+}
+EXPORT_SYMBOL_GPL(md_unfrozen_sync_thread);
+
 static void idle_sync_thread(struct mddev *mddev)
 {
 	mutex_lock(&mddev->sync_mutex);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 27d187ca6258a..0d06d640aa06d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -782,6 +782,9 @@ extern void md_rdev_clear(struct md_rdev *rdev);
 extern void md_handle_request(struct mddev *mddev, struct bio *bio);
 extern int mddev_suspend(struct mddev *mddev, bool interruptible);
 extern void mddev_resume(struct mddev *mddev);
+extern void md_idle_sync_thread(struct mddev *mddev);
+extern void md_frozen_sync_thread(struct mddev *mddev);
+extern void md_unfrozen_sync_thread(struct mddev *mddev);
 
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
-- 
2.43.0



