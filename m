Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751E829346F;
	Wed,  9 Sep 2026 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964865; cv=none; b=NGr8esNrCDoFuR4nt2YwrDAU9sZYXjc32lIEZ43/MJqXoTDggx5u5/+JvcVxIBtIXTI8wxmZhyZS65lLmPmADK7/BgC/wNoNIXG9kVdFn1R7+Q+h02GfIu5D+nNSaH+J/WnLaUBdRs08HXNVbDkW5Utwe+WfKTSVjIMNP3+RVAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964865; c=relaxed/simple;
	bh=PuvWE4UW53Ntu7YV9v1ZOS6yhyvwhHK4KP/ASwG7/nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbtGKXMPCyfh5c2L6+6aob8X/xiZzVUZ4zHyr41ZSuy1ZqQGb0oxIf2NlS6PDOtSRuskMCWpApveFEBsU9lZReldY2eF0+7OL6Yxv40PqMBz9Mbp4rH2OYxi2zmr0SRq6o5ICYZdIw8fGS/ZXY42x12Bxo+dn5NaJ4RcrX4kdvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zl1vPZ11; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zl1vPZ11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB17A1F00A3A;
	Wed,  9 Sep 2026 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964864;
	bh=1TcAJQRYbbuFARIIqdeiRMk6nwR9BJnvNVhWB5UOOtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zl1vPZ113ko9Yn1ldBRUJsXbmp0vsy8NZMZH+w2kmGIpDrNgfKZTcCmf54GwiDCsz
	 +QQ0y6N9MVMrrl9bRQPdWMZ8ic9cdtlXd4oaO8ZR4a/x1jRMPirfACkcBXoW1VzM5i
	 IHrlSVSioddBQJaE/VL0aF/W6YvW/aEPYjntrsW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 571/583] mm/damon/core: skip aging from repeated aggressive merging
Date: Wed,  9 Sep 2026 15:44:16 +0200
Message-ID: <20260909134257.615801203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 0250dbe08c730d003ef9f484da56ae09a1ea0c4c upstream.

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
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c             |   21 +++++++++++++--------
 mm/damon/tests/core-kunit.h |    2 +-
 2 files changed, 14 insertions(+), 9 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2364,17 +2364,19 @@ static void damon_merge_two_regions(stru
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
@@ -2408,15 +2410,18 @@ static void kdamond_merge_regions(struct
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
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -266,7 +266,7 @@ static void damon_test_merge_regions_of(
 		damon_add_region(r, t);
 	}
 
-	damon_merge_regions_of(t, 9, 9999);
+	damon_merge_regions_of(t, 9, 9999, true);
 	/* 0-112, 114-130, 130-156, 156-170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
 	if (damon_nr_regions(t) != 5)


