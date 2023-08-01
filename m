Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC765E545
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB4BC433C8;
	Tue,  1 Aug 2023 09:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882516;
	bh=fTKllKbEwv5kyVyIOz0CaOFxiDJp2W7rtAozxdXLQes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6t9Y9quKDmwFAFfP5ZDFr1AOZZ158icdkwGQuidMRks4uq9uv75xsiZbMZFvvT57
	 VNN6KUdzJMRhoflZCa+iEkiQaMyadoUPMYMVfS3T1PzGG4nxj6ayyTZy7gzZ13JgYc
	 5WbCmJ6JrZO0AEv0qbj7i+zRhOBWHfsfOPIk/RdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/228] dm raid: protect md_stop() with reconfig_mutex
Date: Tue,  1 Aug 2023 11:19:51 +0200
Message-ID: <20230801091927.537776505@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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

[ Upstream commit 7d5fff8982a2199d49ec067818af7d84d4f95ca0 ]

__md_stop_writes() and __md_stop() will modify many fields that are
protected by 'reconfig_mutex', and all the callers will grab
'reconfig_mutex' except for md_stop().

Also, update md_stop() to make certain 'reconfig_mutex' is held using
lockdep_assert_held().

Fixes: 9d09e663d550 ("dm: raid456 basic support")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 4 +++-
 drivers/md/md.c      | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c3736d1f72310..4b7528dc2fd08 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3301,8 +3301,8 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	return 0;
 
 bad_unlock:
-	mddev_unlock(&rs->md);
 	md_stop(&rs->md);
+	mddev_unlock(&rs->md);
 bad:
 	raid_set_free(rs);
 
@@ -3313,7 +3313,9 @@ static void raid_dtr(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
+	mddev_lock_nointr(&rs->md);
 	md_stop(&rs->md);
+	mddev_unlock(&rs->md);
 	raid_set_free(rs);
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 829e1bd9bcbf9..45daba0eb9310 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6269,6 +6269,8 @@ static void __md_stop(struct mddev *mddev)
 
 void md_stop(struct mddev *mddev)
 {
+	lockdep_assert_held(&mddev->reconfig_mutex);
+
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
-- 
2.40.1



