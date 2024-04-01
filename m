Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40561DFFC;
	Mon,  1 Apr 2024 16:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988219; cv=none; b=cyQuhCsuv4xaos7wfawL7PtlOa7zHhBObivO0UCkA56vTbE0PIkNGJn3ZNklEJMPUERhhVuWYIul9XznXrZA9BblwfBU6BTAORZHIS4f4nF4LSCPBBDznfDELgqsFhVPB3b9KsFNEnoHqHlemg9S60JatgPVyl1nyAj7Xqt2yuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988219; c=relaxed/simple;
	bh=aR9Ty0OeCGEQD+1GSpH0wP+5VJbbIG5QjzI5Y58Lhl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQfx0mkrtxdU2UabzFMMCHLOoUVOo9vRhdD1U8D1v5Z9hzMTBvOfpaMtzpciJkGbV3Ty3GUGFKMVIabSLvLflJLyjdEq+2YeWUWHApFSGKnG6tu/ogpSFFnGvZyKWjvq1W3zc06AcHFa8JA2gxitFoqvsD5N7IfIqVHYGw7WUWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEwAycTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEwAycTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D7FC433C7;
	Mon,  1 Apr 2024 16:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988219;
	bh=aR9Ty0OeCGEQD+1GSpH0wP+5VJbbIG5QjzI5Y58Lhl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEwAycTWsxTTdn1UiBnGOI/lBxgUMM8GYvdzdxCAY0esHaiTMZTvxQ62mlVwew+RJ
	 mWVJm9U7LSsV2EMSs4CKZTlzSQf1a00kqjAUHcBh6pWJlX9n5M9akMOA2wyVAkWKMp
	 KApflrosZf7hMkJINc37zdKvZZshyBBvWyHRj+zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 102/432] md: export helper md_is_rdwr()
Date: Mon,  1 Apr 2024 17:41:29 +0200
Message-ID: <20240401152556.168536420@linuxfoundation.org>
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
index 740541f6cad98..bae513018849a 100644
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



