Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050844B44AF;
	Thu, 17 Sep 2026 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658414; cv=none; b=IZqp9H19sQaSbLDPFFAOpJsEG0Lrcn34zhPEsxA++UpEvvzf9dBkh49T3ikwA+vK6hZnnAzKs28l0+0Ilkco0tStOj/xAhoVc/Z6n7ANMHb22rcUCjaem/N12fA8yKoX8LgKxyfzjfYesMtZjx9utFjPSvHu2w3bIuXFFb6KuZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658414; c=relaxed/simple;
	bh=az1VTLp2mW90IBsk7YsFGV8HLrZ235AscPATYyKld0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRbcKOYx/dkPDH4e6fhYyr0En6eV+7IXUWpU3bctrfZlhTPYdNCxmRSdipG1pV081L+FOK+sQBP76+3y4skK093mBI3qlKGKZ3c0gswsQZHyKjOBoZ6t16ILFmeMoP44hp4Sw2wfdzJEl+Eh7JtiIbl0HaoyZBoraF1wn9G6bNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WclPI9Sg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WclPI9Sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4891F00893;
	Thu, 17 Sep 2026 15:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658393;
	bh=OnectFlbgRNPnJ3Vzs/sq27gtZx5AxILj7+5SKWclUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WclPI9Sg6oJvNak233xciDiJMcOl5d+IOkTaEuKwLfboPuU3t5SjWPbaxPjoxtd6N
	 gssh6m/FXgfwX0RpEClazkHYrIpnY5FXW1U+adgrM/iozD/ZfxBjxgYq87Rh4Ma0uU
	 tLv6f4L+LKCPnKXoiX+HUF+cMk/IVFQJLBPAikK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0002/1250] mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
Date: Thu, 17 Sep 2026 15:56:37 +0100
Message-ID: <20260917151551.982317194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

commit 123e4619ab6c8ab1c4cb1d7a58311a2af13929cd upstream.

Patch series "mm/damon: unurgent fixes for infinite loop, NULL de-ref and
races", v1.1.

Sashiko found a few issues in DAMON that could cause infinite loop, NULL
dereference and monitoring results degradation.  The first two sounds
scary but the infinite loop happens only under unreasonable user setup.
The NULL dereference is only in a unit test.  Monitoring results
degradation is trivial since it is only best-effort, and those happens
from only unlikely races.  Still those are bugs that better to fix if
possible.  Fix those.

This patch (of 6):

Due to online parameter update like events, the number of DAMON regions
could be higher than the user-set upper limit.  kdamond_merge_regions()
repeats merge regions until the number meets the limit, while doubling the
merge threshold up to the theoretical maximum threshold.  It is tried only
up to the theoretical maximum threshold because even the aggressive
merging can fail from reducing the number of regions under the
user-defined upper limit.  For example, there could be many user-defined
non-contiguous regions that cannot be merged.

The threshold based loop break condition is evaluated by comparing the
threshold for the next merging try against the theoretical maximum
threshold.  If max_thres is larger than UINT_MAX / 2, doubling the
threshold could make it overflow, and bypass the loop break condition.  In
the case, if the number of regions cannot be reduced under the upper limit
like explained above, the loop will run infinitely.

Prevent the case by doing the break condition check before doubling the
threshold.  Also, prevent the threshold exceeding the maximum threshold,
as it could overflow and apply the wrong merge threshold.

This issue is unlikely to occur in real world, since having the max_thres
higher than UINT_MAX / 2 require unrealistically large aggregation
intervals compared to the sampling interval.  Also, it requires an
unrealistically large number of uncontiguous regions setup.  Nonetheless,
the consequence is bad and the fix is simple.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-1-sj@kernel.org
Link: https://lore.kernel.org/20260715031002.108504-2-sj@kernel.org
Link: https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org [1]
Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.10.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a9168a03b3402..6fa02025d2af1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2415,7 +2415,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
-	do {
+	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
 			damon_merge_regions_of(t, threshold, sz_limit,
@@ -2423,9 +2423,14 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 			nr_regions += damon_nr_regions(t);
 		}
 		count_age = false;
-		threshold = max(1, threshold * 2);
-	} while (nr_regions > c->attrs.max_nr_regions &&
-			threshold / 2 < max_thres);
+		if (nr_regions <= c->attrs.max_nr_regions ||
+				max_thres <= threshold)
+			break;
+		if (threshold < max_thres / 2)
+			threshold = max(1, threshold * 2);
+		else
+			threshold = max_thres;
+	}
 }
 
 /*
-- 
2.53.0



