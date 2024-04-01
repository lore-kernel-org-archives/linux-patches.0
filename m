Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B1F482D1;
	Mon,  1 Apr 2024 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988184; cv=none; b=R4jPCcr8tlsiJRj1uN9tCVJe6JxfvBqn1eDof3QgHTHqU1v0+647B7fZo9oizI5RQXzZOMm007GJZJ/du4YHDUYKIyKk1l46lNAJE44tfeGnZxx9W2PfIVxsE4sR/VXRfDJPLtn+8UByPOMsnoB5MgifynhM0Rk2HDBusJAz3G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988184; c=relaxed/simple;
	bh=CNd17Tu/Hm0mcmtmBT8mK25EMlSmUCARQbM3v3P+I3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAcnmg1Bhz+nLfClOgI89vMU4CQ38eT0f7IkEJ+XmB01p9r0/8FDl0iUiO7T3Lj0hUw8KGrhnNhmC9pk9LuHlJnHi59irAMSeiC48zW6JSU4lbit9ymATOm4UGMVwGPxwLR3GU+tiiP+piYxRiJRK/elrvPmgNsUWw49IOoFBwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PD/R6Jdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PD/R6Jdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4334FC433C7;
	Mon,  1 Apr 2024 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988182;
	bh=CNd17Tu/Hm0mcmtmBT8mK25EMlSmUCARQbM3v3P+I3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PD/R6JddQAIpBGpEcycTz4UuhfURyNhFCAa2Cq9mKwxV/fWr9H4nRMzf97SNmMrAU
	 zK0RzqrmR9nNjHh0oTdXAFbd04terDrF0mxNTtfzfM9kn6bF7AFlUDXuJfI6LY+Kr5
	 0YVuP/P7IahCK91FHvqrIDl8LGdFwHlyrV3YbYfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 101/432] md: export helpers to stop sync_thread
Date: Mon,  1 Apr 2024 17:41:28 +0200
Message-ID: <20240401152556.137567289@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 007fd071b44ed..740541f6cad98 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4945,6 +4945,35 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
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



