Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16E18F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2411BC433C7;
	Sun, 16 Jul 2023 19:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537269;
	bh=DQ4xx/k0Nmyv0i0D3qIVZYPfamOvc+eDRSJwfmMBgt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1DmHCDzbxv9gyvxrNevvYGD9yzAXWbWVMpJjRwXsfWmAWUQJzME14FcXWGFS+j6J
	 FKRW2m3z8dA1F9kUW3Nkr1jAQfx40lDZqbWpE8EpLgz5cNGIwAbcriP1516rtCItht
	 lNcbfyB4TBdgTn9T7HU3OUi1ENRc9JnWkiZvqifk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 036/800] md/raid10: fix null-ptr-deref of mreplace in raid10_sync_request
Date: Sun, 16 Jul 2023 21:38:09 +0200
Message-ID: <20230716194949.934820409@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 34817a2441747b48e444cb0e05d84e14bc9443da ]

There are two check of 'mreplace' in raid10_sync_request(). In the first
check, 'need_replace' will be set and 'mreplace' will be used later if
no-Faulty 'mreplace' exists, In the second check, 'mreplace' will be
set to NULL if it is Faulty, but 'need_replace' will not be changed
accordingly. null-ptr-deref occurs if Faulty is set between two check.

Fix it by merging two checks into one. And replace 'need_replace' with
'mreplace' because their values are always the same.

Fixes: ee37d7314a32 ("md/raid10: Fix raid10 replace hang when new added disk faulty")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230527072218.2365857-2-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4fcfcb350d2b4..0acb4c103c10e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3438,7 +3438,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			int must_sync;
 			int any_working;
 			int need_recover = 0;
-			int need_replace = 0;
 			struct raid10_info *mirror = &conf->mirrors[i];
 			struct md_rdev *mrdev, *mreplace;
 
@@ -3450,11 +3449,10 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			    !test_bit(Faulty, &mrdev->flags) &&
 			    !test_bit(In_sync, &mrdev->flags))
 				need_recover = 1;
-			if (mreplace != NULL &&
-			    !test_bit(Faulty, &mreplace->flags))
-				need_replace = 1;
+			if (mreplace && test_bit(Faulty, &mreplace->flags))
+				mreplace = NULL;
 
-			if (!need_recover && !need_replace) {
+			if (!need_recover && !mreplace) {
 				rcu_read_unlock();
 				continue;
 			}
@@ -3470,8 +3468,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				rcu_read_unlock();
 				continue;
 			}
-			if (mreplace && test_bit(Faulty, &mreplace->flags))
-				mreplace = NULL;
 			/* Unless we are doing a full sync, or a replacement
 			 * we only need to recover the block if it is set in
 			 * the bitmap
@@ -3594,11 +3590,11 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio = r10_bio->devs[1].repl_bio;
 				if (bio)
 					bio->bi_end_io = NULL;
-				/* Note: if need_replace, then bio
+				/* Note: if replace is not NULL, then bio
 				 * cannot be NULL as r10buf_pool_alloc will
 				 * have allocated it.
 				 */
-				if (!need_replace)
+				if (!mreplace)
 					break;
 				bio->bi_next = biolist;
 				biolist = bio;
-- 
2.39.2



