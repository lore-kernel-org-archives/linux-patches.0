Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453531A76AE;
	Tue, 30 Jul 2024 17:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360083; cv=none; b=Q8dGmSkcMasd+k/gWrP6/qx2Od1wXL4fv1uQ0GkzB5/36HBoV0ksx1ybuNdK9maCswu2r+MPS1sA2h0auyfanlwrIJbmJ8x2ARuEbhP01La6VFMyvNPvm0iWzAfgOA6aYO6qxtrtjfM+3M9yFDTvBTIN72mhGRwjHUp92yZVGWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360083; c=relaxed/simple;
	bh=EqppSayDNs6k9OhVIL780PFVfIGFNoNIkolzO+KweHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxQsRf3ZD2efbyH6NBQ1DY7oYRRGnJksRKs6dyu6axUTEGGJXKVmsqKIB5NnaOY+fng4PaD24/bWEdn8EpdunAioT2htVeYDVqlFYBIEYoRooG0kqGF0GGsN0XhcGPNxz7u4C16K4oWMP9iIQwOlgTzAEQKRsuMu1ItU/dZkcaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfL2Cf22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfL2Cf22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A39C4AF0F;
	Tue, 30 Jul 2024 17:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360083;
	bh=EqppSayDNs6k9OhVIL780PFVfIGFNoNIkolzO+KweHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfL2Cf22onc8CM8AFkrufpGVoc89oTZbRajqlOgr36v9zI5ONovV88WFnmDbHgkhg
	 in6vtleCpW0Fw+tnbJe5uFD+7+KWrW7HmCV7fxHKI99MSY+oN+Hp7ZU8LmuBB5o5FV
	 W7b5zq90sIxee8htArTUqOKkQPxnhY8Q4gAmDZ/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.10 562/809] md/raid5: fix spares errors about rcu usage
Date: Tue, 30 Jul 2024 17:47:18 +0200
Message-ID: <20240730151746.960964067@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 2314c2e3a70521f055dd011245dccf6fd97c7ee0 upstream.

As commit ad8606702f26 ("md/raid5: remove rcu protection to access rdev
from conf") explains, rcu protection can be removed, however, there are
three places left, there won't be any real problems.

drivers/md/raid5.c:8071:24: error: incompatible types in comparison expression (different address spaces):
drivers/md/raid5.c:8071:24:    struct md_rdev [noderef] __rcu *
drivers/md/raid5.c:8071:24:    struct md_rdev *
drivers/md/raid5.c:7569:25: error: incompatible types in comparison expression (different address spaces):
drivers/md/raid5.c:7569:25:    struct md_rdev [noderef] __rcu *
drivers/md/raid5.c:7569:25:    struct md_rdev *
drivers/md/raid5.c:7573:25: error: incompatible types in comparison expression (different address spaces):
drivers/md/raid5.c:7573:25:    struct md_rdev [noderef] __rcu *
drivers/md/raid5.c:7573:25:    struct md_rdev *

Fixes: ad8606702f26 ("md/raid5: remove rcu protection to access rdev from conf")
Cc: stable@vger.kernel.org
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240615085143.1648223-1-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -155,7 +155,7 @@ static int raid6_idx_to_slot(int idx, st
 	return slot;
 }
 
-static void print_raid5_conf (struct r5conf *conf);
+static void print_raid5_conf(struct r5conf *conf);
 
 static int stripe_operations_active(struct stripe_head *sh)
 {
@@ -7580,11 +7580,11 @@ static struct r5conf *setup_conf(struct
 		if (test_bit(Replacement, &rdev->flags)) {
 			if (disk->replacement)
 				goto abort;
-			RCU_INIT_POINTER(disk->replacement, rdev);
+			disk->replacement = rdev;
 		} else {
 			if (disk->rdev)
 				goto abort;
-			RCU_INIT_POINTER(disk->rdev, rdev);
+			disk->rdev = rdev;
 		}
 
 		if (test_bit(In_sync, &rdev->flags)) {
@@ -8066,7 +8066,7 @@ static void raid5_status(struct seq_file
 	seq_printf (seq, "]");
 }
 
-static void print_raid5_conf (struct r5conf *conf)
+static void print_raid5_conf(struct r5conf *conf)
 {
 	struct md_rdev *rdev;
 	int i;
@@ -8080,15 +8080,13 @@ static void print_raid5_conf (struct r5c
 	       conf->raid_disks,
 	       conf->raid_disks - conf->mddev->degraded);
 
-	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
-		rdev = rcu_dereference(conf->disks[i].rdev);
+		rdev = conf->disks[i].rdev;
 		if (rdev)
 			pr_debug(" disk %d, o:%d, dev:%pg\n",
 			       i, !test_bit(Faulty, &rdev->flags),
 			       rdev->bdev);
 	}
-	rcu_read_unlock();
 }
 
 static int raid5_spare_active(struct mddev *mddev)


