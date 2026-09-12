Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3423264D4;
	Sat, 12 Sep 2026 14:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222308; cv=none; b=hGzbDSXokv6dq5fPDLxwLQbFZTxVgDAb25qO6PNhbpXN2quQbsAy9IOOF88ilqcBVKIyzmhEM709fBekhIIsFcvssu0gr+TEEeWhzSxfphQlzsL4aJu00N8dBlZhlO6HYiT5VrDvkKwtuv4Qx5ip2IdeFApj0W76CqlOMXwuhAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222308; c=relaxed/simple;
	bh=ippR9xdTb3AGrSDkPNgQLyxU0XTk62AQs1YzMg/YwL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJWrgyHNtnvWtVXPAtBdb4tmWZ9OerL2YAQUy7rkLy60MnyI/K+9E8lJKSivUEhv7qS1TY2mVLDgq4SmB4TsyKWWaMOHQn7W+Ak+Opy2tdZcGhL/LKwLwJPn1rdKcKkF4Wt+mYYzpxs2mNlwK4z5MHtP8+hWVdRV81+yXdxA0ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCKZ8Pu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCKZ8Pu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7551F000FF;
	Sat, 12 Sep 2026 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222307;
	bh=Herh9m9/momacKUuCTqlIistNKyZUS4uoosNThArnns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCKZ8Pu7tkwCLirFLdEHJ1Sg9u0DTY4/1O9/60UOLE2KprWtDMTmOdILKpsIsoEUF
	 TLa3lfsV2CKIXv2Y87HdllCQVczjcs3R9xx+S6jcMM/WBsiaafSpGCT5VFEBrVUe9B
	 /WI0B18c6/JhbgwDjnQmWAf2p8mEd/xDM52T3oKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0560/1424] mm/damon/core: skip aging from repeated aggressive merging
Date: Sat, 12 Sep 2026 08:49:52 +0200
Message-ID: <20260912065619.845186302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 0250dbe08c730d003ef9f484da56ae09a1ea0c4c ]

The number of DAMON regions could temporarily exceed the user-defined
maximum number of regions limit for corner cases.  For example, users
could lower the limit via runtime parameters update.  For such a case,
kdamond_merge_regions() repeats merging regions in the case doubling the
merge threshold.  The repeated merge operation could update the age of
regions multiple times.  This corrupts the monitoring results.  Fix the
issue by asking the merge operation to skip aging for the corner case.

The user impact is degradation of the monitoring quality.  The impact
should be mild, since the degradation is only temporal, and it is not
common to happen in realistic setups.

The issue was discovered [1,2] by Sashiko.

Link: https://lore.kernel.org/20260712165432.87609-1-sj@kernel.org
Link: https://lore.kernel.org/20260621203548.10718-1-sj@kernel.org [1]
Link: https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org [2]
Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.10
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core-test.h |  2 +-
 mm/damon/core.c      | 17 +++++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core-test.h b/mm/damon/core-test.h
index e6c19a23b0806..dd91b0eea61ff 100644
--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -255,7 +255,7 @@ static void damon_test_merge_regions_of(struct kunit *test)
 		damon_add_region(r, t);
 	}
 
-	damon_merge_regions_of(t, 9, 9999);
+	damon_merge_regions_of(t, 9, 9999, true);
 	/* 0-112, 114-130, 130-156, 156-170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
 	if (damon_nr_regions(t) != 5)
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 734ab958ec576..0713fda22682c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1192,15 +1192,17 @@ static void damon_merge_two_regions(struct damon_target *t,
  * sz_limit	size upper limit of each region
  */
 static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
-				   unsigned long sz_limit)
+		unsigned long sz_limit, bool count_age)
 {
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
-			r->age = 0;
-		else
-			r->age++;
+		if (count_age) {
+			if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
+				r->age = 0;
+			else
+				r->age++;
+		}
 
 		if (prev && prev->ar.end == r->ar.start &&
 		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
@@ -1234,15 +1236,18 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	struct damon_target *t;
 	unsigned int nr_regions;
 	unsigned int max_thres;
+	bool count_age = true;
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
 	do {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit);
+			damon_merge_regions_of(t, threshold, sz_limit,
+					count_age);
 			nr_regions += damon_nr_regions(t);
 		}
+		count_age = false;
 		threshold = max(1, threshold * 2);
 	} while (nr_regions > c->attrs.max_nr_regions &&
 			threshold / 2 < max_thres);
-- 
2.53.0



