Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EB511710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF28DC433C7;
	Mon, 11 Sep 2023 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445255;
	bh=gk/VvbyfazW5ljzD4b+4KoRjRd55L8GHQGH24vTOUFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyoZVfFmkAAerhSE1Mj4Lpo+BFpfIUYAxMam9Ayqgbko8HMRwEoJulVW7V93nzZt3
	 SZtUKqPBEkEraYc/iV8MSp/Q2QUvrEz2lNtnGoHY/WXThHA+Dw5UD2hJqCsFYMK7HG
	 EI/WLX/NqhPpyd04sGCNQmM5/8kHUuYf6S1zWxYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 281/600] md/md-bitmap: hold reconfig_mutex in backlog_store()
Date: Mon, 11 Sep 2023 15:45:14 +0200
Message-ID: <20230911134641.901896917@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 44abfa6a95df425c0660d56043020b67e6d93ab8 ]

Several reasons why 'reconfig_mutex' should be held:

1) rdev_for_each() is not safe to be called without the lock, because
   rdev can be removed concurrently.
2) mddev_destroy_serial_pool() and mddev_create_serial_pool() should not
   be called concurrently.
3) mddev_suspend() from mddev_destroy/create_serial_pool() should be
   protected by the lock.

Fixes: 10c92fca636e ("md-bitmap: create and destroy wb_info_pool with the change of backlog")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20230706083727.608914-3-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 8553f028825a1..5200bba63708e 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2481,6 +2481,10 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	if (backlog > COUNTER_MAX)
 		return -EINVAL;
 
+	rv = mddev_lock(mddev);
+	if (rv)
+		return rv;
+
 	/*
 	 * Without write mostly device, it doesn't make sense to set
 	 * backlog for max_write_behind.
@@ -2494,6 +2498,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!has_write_mostly) {
 		pr_warn_ratelimited("%s: can't set backlog, no write mostly device available\n",
 				    mdname(mddev));
+		mddev_unlock(mddev);
 		return -EINVAL;
 	}
 
@@ -2509,6 +2514,8 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	if (old_mwb != backlog)
 		md_bitmap_update_sb(mddev->bitmap);
+
+	mddev_unlock(mddev);
 	return len;
 }
 
-- 
2.40.1



