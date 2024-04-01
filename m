Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BFC3EA83;
	Mon,  1 Apr 2024 15:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986948; cv=none; b=aJQlvJ4AVnUXZnKtUcFmjAwSbhOMRF8dwR1ony1kb9Z2J2b682tBh6Ojae+0kB6vS80DTX5B2wDhCpG1MU05U/DAQ12DbTyzn/nQAJhind11fm85DzV9fLBi8QWScpkJcpJP7H45y6Y/JYIJd1NbQb/8lu5Wgc5MNLpd4KBkLTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986948; c=relaxed/simple;
	bh=N0chVQboNw59kKHe/lQfSTJzQ+LE1ymR7TzQQmSfpME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBxE41ESsxhUwKzsq9d8uFMUVzPwAbCBAjeMaOzZCALG0odr/hMzJEgcDADwtkAwN2OdZsPwuW4G4pq4L1t+OSRLBDRyKGvw7C/4xtZ+fLxkcu0SILiajdcAAfYUsFnyX87ynQOj/cQQJSP5U2Td1xWAvEP152gaERewnJnv+9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZq05uyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZq05uyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08595C433F1;
	Mon,  1 Apr 2024 15:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986948;
	bh=N0chVQboNw59kKHe/lQfSTJzQ+LE1ymR7TzQQmSfpME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZq05uyHsxldZtV5lfYXWgoHGRiE23l5rHgbUVCi7INoRAybE1rickCJz9LJHAVXM
	 XpR8IGITlwqZWSByXWIgg2m0/mbUBmKoXicnZLcHAFgFmaEcNh7unlctfmR3f5Gg+D
	 ZUhLJBiyY4g/wWFF0AL///rNizor2M5X5dpbjHzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 106/399] md: export helper md_is_rdwr()
Date: Mon,  1 Apr 2024 17:41:12 +0200
Message-ID: <20240401152552.351501567@linuxfoundation.org>
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

[ Upstream commit 314e9af065513ff86ec9e32eaa96b9bd275cf51d ]

There are no functional changes for now, prepare to fix a deadlock for
dm-raid456.

Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240305072306.2562024-4-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 12 ------------
 drivers/md/md.h | 12 ++++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7255678608e7c..245ef8af8640a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -99,18 +99,6 @@ static void mddev_detach(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
 static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
 
-enum md_ro_state {
-	MD_RDWR,
-	MD_RDONLY,
-	MD_AUTO_READ,
-	MD_MAX_STATE
-};
-
-static bool md_is_rdwr(struct mddev *mddev)
-{
-	return (mddev->ro == MD_RDWR);
-}
-
 /*
  * Default number of read corrections we'll attempt on an rdev
  * before ejecting it from the array. We divide the read error
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 0d06d640aa06d..db0cb00e4c9ac 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -559,6 +559,18 @@ enum recovery_flags {
 	MD_RESYNCING_REMOTE,	/* remote node is running resync thread */
 };
 
+enum md_ro_state {
+	MD_RDWR,
+	MD_RDONLY,
+	MD_AUTO_READ,
+	MD_MAX_STATE
+};
+
+static inline bool md_is_rdwr(struct mddev *mddev)
+{
+	return (mddev->ro == MD_RDWR);
+}
+
 static inline int __must_check mddev_lock(struct mddev *mddev)
 {
 	return mutex_lock_interruptible(&mddev->reconfig_mutex);
-- 
2.43.0



