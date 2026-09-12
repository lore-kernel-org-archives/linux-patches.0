Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6543E3B7B8C;
	Sat, 12 Sep 2026 07:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196810; cv=none; b=g0qXisGiAIkSQaTFZS4jfDS+MJGVF00lpuFY/gPp2aklHbXqAesMjQlpHW6uordU5iOOuLGfsFYBQ4xvf/4mmFyjhH6wXYudN/EFl2uRdNncnWykYrYtiBVp6xd4bIc5zz+Pr6rqWo+VdojvhlprEw9q5Gp6DL6FGz3dssPD+xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196810; c=relaxed/simple;
	bh=muuDk+BqhI/MUVJ2X6q/qYkMqP3tNCSc2C6XnV8wp9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QA0fe6n7RlKmD9PLvFMeXVNAbRmajJ/DbJg0uWUMPip3VmVlwCzwAt/x2lx4Ar61EU4iqtDxqwUeisGO8PG8HaTQ5w+2E6j9HDG/OPEC5xbI4yyJ6amf+1N7xNJgyMPu5uK5dpAglZjxB88I8JUlUkKoWbqX4ZqpoO8ij0/Ear8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPUeZ7Cr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPUeZ7Cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1A31F000FF;
	Sat, 12 Sep 2026 07:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196807;
	bh=AZIFDTikgZjhj6TauUnkyEuWn4igiZGjVdrtJgoFWRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPUeZ7CrG8yXfqXBiGU949//bmLOuqNHUd697SHn9DqprrfjG4SWbwMqSqzU67a1V
	 qc4QBsarpulMdNkeGpjTt7/I39qTt8rmOUqkSHusfyD6UjpQLlsbblkYOLiRRJPuUA
	 sAE9b0RDX1Ha3BBZsvM15A0S9VMeJBT0nIYEEY28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0004/1815] mm/damon/core: skip aging from repeated aggressive merging
Date: Sat, 12 Sep 2026 08:29:14 +0200
Message-ID: <20260912065649.111189596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/core.c             | 21 +++++++++++++--------
 mm/damon/tests/core-kunit.h |  2 +-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a86812d457c14..372ca1161c57d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3118,18 +3118,20 @@ static void damon_verify_merge_regions_of(struct damon_region *r)
  * sz_limit	size upper limit of each region
  */
 static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
-				   unsigned long sz_limit)
+		unsigned long sz_limit, bool count_age)
 {
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
 		damon_verify_merge_regions_of(r);
-		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
-			r->age = 0;
-		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
-			r->age = 0;
-		else
-			r->age++;
+		if (count_age) {
+			if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
+				r->age = 0;
+			else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
+				r->age = 0;
+			else
+				r->age++;
+		}
 
 		if (prev && prev->ar.end == r->ar.start &&
 		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
@@ -3163,15 +3165,18 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	struct damon_target *t;
 	unsigned int nr_regions;
 	unsigned int max_thres;
+	bool count_age = true;
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
 	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit);
+			damon_merge_regions_of(t, threshold, sz_limit,
+					count_age);
 			nr_regions += damon_nr_regions(t);
 		}
+		count_age = false;
 		if (nr_regions <= c->attrs.max_nr_regions ||
 				max_thres <= threshold)
 			break;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index fbcc882dccc94..e543cfff15909 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -261,7 +261,7 @@ static void damon_test_merge_regions_of(struct kunit *test)
 		damon_add_region(r, t);
 	}
 
-	damon_merge_regions_of(t, 9, 9999);
+	damon_merge_regions_of(t, 9, 9999, true);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
 	if (damon_nr_regions(t) != 6)
-- 
2.53.0



