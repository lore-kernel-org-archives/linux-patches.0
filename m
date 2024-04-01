Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2722C482F6;
	Mon,  1 Apr 2024 15:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986942; cv=none; b=PWM02nm2E3nN2qkePAaqPiGSw1ioO6UKWegIwB5Pp6pdMBDUkyFIAPX0h0c0dm9kQVJw2K712pY+EAhPykNX82eEPyYOySSb4NenZR7e2cufaSupSicxjep/hoh2K0SIcJxjBm3lp5AMYh8QnEOa5OYeSt8xCER9FxUzi4g1oCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986942; c=relaxed/simple;
	bh=6UjETvatjXJ6EEh8T9MCdwGd6IrgZ+kXaVdRzoRnqdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFOUG1PjONSj3WBZjbHELbQDlYvyg8X4JHO+dgGFU4nGBO1lNacqdJ1tXHqWoyecWXAQl0CYgf38Jy3t1xXK2fE4exJO9X9mI0Mux9R7p7Hu7VV0m4J5EeVS7LBKnjP/uGQiK/VcrhNb54qtpQ9fbosfziAcS9vU4lkqhnYPlTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUAPywPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUAPywPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D055C43390;
	Mon,  1 Apr 2024 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986942;
	bh=6UjETvatjXJ6EEh8T9MCdwGd6IrgZ+kXaVdRzoRnqdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUAPywPJU90HUXT+JkYwwpPC7g+5DkOj17S/WP3Yuyxy5VFtwnBaTnArhCn3453VJ
	 U3ZTrwhxD29uNGlJ+4kso0A+mPgdrUsTOEZI5ZqJ+Xw0U16AnT/lpkDNz8TjQHmivG
	 wWllTXPnBxfeS2MwH+Y6w0fbdycMxzPl2VkJMplA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 104/399] md: dont clear MD_RECOVERY_FROZEN for new dm-raid until resume
Date: Mon,  1 Apr 2024 17:41:10 +0200
Message-ID: <20240401152552.290641664@linuxfoundation.org>
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

[ Upstream commit 2f03d0c2cd451c7ac2f317079d4ec518f0986b55 ]

After commit 9dbd1aa3a81c ("dm raid: add reshaping support to the
target") raid_ctr() will set MD_RECOVERY_FROZEN before md_run() and
expect to keep array frozen until resume. However, md_run() will clear
the flag by setting mddev->recovery to 0.

Before commit 1baae052cccd ("md: Don't ignore suspended array in
md_check_recovery()"), dm-raid actually relied on suspending to prevent
starting new sync_thread.

Fix this problem by keeping 'MD_RECOVERY_FROZEN' for dm-raid in
md_run().

Fixes: 1baae052cccd ("md: Don't ignore suspended array in md_check_recovery()")
Fixes: 9dbd1aa3a81c ("dm raid: add reshaping support to the target")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240305072306.2562024-2-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fbe528ed236f6..3d3a419190042 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6039,7 +6039,10 @@ int md_run(struct mddev *mddev)
 			pr_warn("True protection against single-disk failure might be compromised.\n");
 	}
 
-	mddev->recovery = 0;
+	/* dm-raid expect sync_thread to be frozen until resume */
+	if (mddev->gendisk)
+		mddev->recovery = 0;
+
 	/* may be over-ridden by personality */
 	mddev->resync_max_sectors = mddev->dev_sectors;
 
-- 
2.43.0



