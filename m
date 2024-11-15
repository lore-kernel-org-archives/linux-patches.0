Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6561E18873E;
	Fri, 15 Nov 2024 06:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653932; cv=none; b=suepEwgJLZJ6jHxRkbUqQxlPo3rHBdAu07VtjufI7ylSIZhPlyZqvdtKntrTqI0QQRTzeMb+wMsxmuEypjaB/obtnSD+gD6UE3gEcIWg5+NUqM57C61md4Vd3bpVLK4ziKkB3s466IYYQTMN65FTjEK4kPGC0Cd1XOKDE2nf1Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653932; c=relaxed/simple;
	bh=1vYns9+5ZupdtkZSsYe7KvxONS/YzzpLHiMD1WeFI5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ5Il+DV920HbeSeGc9qWWpcoNU60uVnT7JHPmceMbevHyGu+XxNZJRV/CGLmRh7r6KfzCJ8BVeC3UuT2Cgr5IqG+rI9frEE/0PEcO/R+1sQRM7qNCUH0Wj9Pw2Tizs1FFVeLmnsfH414yZUT+g7YfPJev+Q4SNlSOg0EcsECNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jD0+xSfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jD0+xSfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5C9C4CECF;
	Fri, 15 Nov 2024 06:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653932;
	bh=1vYns9+5ZupdtkZSsYe7KvxONS/YzzpLHiMD1WeFI5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jD0+xSfS4pBGkPt2HCzP7gUsxqsaITdBuQOwTwXtaTDh57O43Q1KQ6Uyw9S/Y7GGn
	 2PYfMnrSlu2TNAT3+DbeukjaJZ7GoZdB26idqGzHbFDke3nTnj3o392/mZ/XgbVmla
	 sAYBq+7p+pd1HCzVLEjtgogaud9uNiXy25q9TKb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Hagar Gamal Halim <hagarhem@amazon.de>
Subject: [PATCH 5.10 79/82] md/raid10: improve code of mrdev in raid10_sync_request
Date: Fri, 15 Nov 2024 07:38:56 +0100
Message-ID: <20241115063728.392812347@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

commit 59f8f0b54c8ffb4521f6bbd1cb6f4dfa5022e75e upstream.

'need_recover' and 'mrdev' are equivalent in raid10_sync_request(), and
inc mrdev->nr_pending is unreasonable if don't need recovery. Replace
'need_recover' with 'mrdev', and only inc nr_pending when needed.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230527072218.2365857-3-linan666@huaweicloud.com
Cc: Hagar Gamal Halim <hagarhem@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3052,7 +3052,6 @@ static sector_t raid10_sync_request(stru
 			sector_t sect;
 			int must_sync;
 			int any_working;
-			int need_recover = 0;
 			struct raid10_info *mirror = &conf->mirrors[i];
 			struct md_rdev *mrdev, *mreplace;
 
@@ -3060,14 +3059,13 @@ static sector_t raid10_sync_request(stru
 			mrdev = rcu_dereference(mirror->rdev);
 			mreplace = rcu_dereference(mirror->replacement);
 
-			if (mrdev != NULL &&
-			    !test_bit(Faulty, &mrdev->flags) &&
-			    !test_bit(In_sync, &mrdev->flags))
-				need_recover = 1;
+			if (mrdev && (test_bit(Faulty, &mrdev->flags) ||
+			    test_bit(In_sync, &mrdev->flags)))
+				mrdev = NULL;
 			if (mreplace && test_bit(Faulty, &mreplace->flags))
 				mreplace = NULL;
 
-			if (!need_recover && !mreplace) {
+			if (!mrdev && !mreplace) {
 				rcu_read_unlock();
 				continue;
 			}
@@ -3101,7 +3099,8 @@ static sector_t raid10_sync_request(stru
 				rcu_read_unlock();
 				continue;
 			}
-			atomic_inc(&mrdev->nr_pending);
+			if (mrdev)
+				atomic_inc(&mrdev->nr_pending);
 			if (mreplace)
 				atomic_inc(&mreplace->nr_pending);
 			rcu_read_unlock();
@@ -3188,7 +3187,7 @@ static sector_t raid10_sync_request(stru
 				r10_bio->devs[1].devnum = i;
 				r10_bio->devs[1].addr = to_addr;
 
-				if (need_recover) {
+				if (mrdev) {
 					bio = r10_bio->devs[1].bio;
 					bio->bi_next = biolist;
 					biolist = bio;
@@ -3233,7 +3232,7 @@ static sector_t raid10_sync_request(stru
 					for (k = 0; k < conf->copies; k++)
 						if (r10_bio->devs[k].devnum == i)
 							break;
-					if (!test_bit(In_sync,
+					if (mrdev && !test_bit(In_sync,
 						      &mrdev->flags)
 					    && !rdev_set_badblocks(
 						    mrdev,
@@ -3259,12 +3258,14 @@ static sector_t raid10_sync_request(stru
 				if (rb2)
 					atomic_dec(&rb2->remaining);
 				r10_bio = rb2;
-				rdev_dec_pending(mrdev, mddev);
+				if (mrdev)
+					rdev_dec_pending(mrdev, mddev);
 				if (mreplace)
 					rdev_dec_pending(mreplace, mddev);
 				break;
 			}
-			rdev_dec_pending(mrdev, mddev);
+			if (mrdev)
+				rdev_dec_pending(mrdev, mddev);
 			if (mreplace)
 				rdev_dec_pending(mreplace, mddev);
 			if (r10_bio->devs[0].bio->bi_opf & MD_FAILFAST) {


