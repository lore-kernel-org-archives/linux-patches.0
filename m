Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10371DDCE;
	Tue, 16 Jul 2024 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145256; cv=none; b=KM6EUZy3bRNNIQZkhWKP+3BSmxGX9Brb+bNdDZYyRGBBiSawN38dlBJRetk1vg6L/RABmAqdxKLhdbM39lgIXmK9XhaM2HnjynH7DwpQLdsAEFR0I0o+n+ifovLkFxn7lhxa8gEOnjE5UsOe6xfd7XUdI1tj5A7bpgwfEeQyg0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145256; c=relaxed/simple;
	bh=jcecMMV2KSOUelF/ZAlgOk9RczeeosVnn2TjQyHtPOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFSzaCwpJJTBxpyPOYBCF6mmsn/hZQVcK0qQmB0Zn36W7NSWeMZmBLmxtzGdH6KOR3vsBM7NQdJmJgsc0UX4UeiabtIu+cTxFWciXEjqu9yaWWeUeHeA2JLfrztJ/O9OaRh7W13bd4zbKLzg7IAjQJkooUHnYz1XQW5GpHwVfb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTJoO+qE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTJoO+qE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5977EC116B1;
	Tue, 16 Jul 2024 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145256;
	bh=jcecMMV2KSOUelF/ZAlgOk9RczeeosVnn2TjQyHtPOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTJoO+qEJUDdshuLiVGMx0Efbd73e8WYfbu8Q7GLowVQDMA0iPh0pC+cbzlUAe/vd
	 CAjANoSSpbtmbPeCGvDJDQ2OsegeAdEWV4/TUyOfgwdzo2YothROiLwC2iJG2oNYJq
	 rz+7ld0iEomnh6jdZwILHEOB4m//+sP3sst+rzXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 132/143] mm/damon/core: merge regions aggressively when max_nr_regions is unmet
Date: Tue, 16 Jul 2024 17:32:08 +0200
Message-ID: <20240716152801.068704820@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 310d6c15e9104c99d5d9d0ff8e5383a79da7d5e6 upstream.

DAMON keeps the number of regions under max_nr_regions by skipping regions
split operations when doing so can make the number higher than the limit.
It works well for preventing violation of the limit.  But, if somehow the
violation happens, it cannot recovery well depending on the situation.  In
detail, if the real number of regions having different access pattern is
higher than the limit, the mechanism cannot reduce the number below the
limit.  In such a case, the system could suffer from high monitoring
overhead of DAMON.

The violation can actually happen.  For an example, the user could reduce
max_nr_regions while DAMON is running, to be lower than the current number
of regions.  Fix the problem by repeating the merge operations with
increasing aggressiveness in kdamond_merge_regions() for the case, until
the limit is met.

[sj@kernel.org: increase regions merge aggressiveness while respecting min_nr_regions]
  Link: https://lkml.kernel.org/r/20240626164753.46270-1-sj@kernel.org
[sj@kernel.org: ensure max threshold attempt for max_nr_regions violation]
  Link: https://lkml.kernel.org/r/20240627163153.75969-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240624175814.89611-1-sj@kernel.org
Fixes: b9a6ac4e4ede ("mm/damon: adaptively adjust regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1357,14 +1357,31 @@ static void damon_merge_regions_of(struc
  * access frequencies are similar.  This is for minimizing the monitoring
  * overhead under the dynamically changeable access pattern.  If a merge was
  * unnecessarily made, later 'kdamond_split_regions()' will revert it.
+ *
+ * The total number of regions could be higher than the user-defined limit,
+ * max_nr_regions for some cases.  For example, the user can update
+ * max_nr_regions to a number that lower than the current number of regions
+ * while DAMON is running.  For such a case, repeat merging until the limit is
+ * met while increasing @threshold up to possible maximum level.
  */
 static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 				  unsigned long sz_limit)
 {
 	struct damon_target *t;
+	unsigned int nr_regions;
+	unsigned int max_thres;
 
-	damon_for_each_target(t, c)
-		damon_merge_regions_of(t, threshold, sz_limit);
+	max_thres = c->attrs.aggr_interval /
+		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
+	do {
+		nr_regions = 0;
+		damon_for_each_target(t, c) {
+			damon_merge_regions_of(t, threshold, sz_limit);
+			nr_regions += damon_nr_regions(t);
+		}
+		threshold = max(1, threshold * 2);
+	} while (nr_regions > c->attrs.max_nr_regions &&
+			threshold / 2 < max_thres);
 }
 
 /*


