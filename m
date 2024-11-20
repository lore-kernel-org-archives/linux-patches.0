Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAC21C830B;
	Wed, 20 Nov 2024 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107607; cv=none; b=EoiW+g0731nsTfjFFqG0sL8xNI20VtX153AzsFGCbqObMGVBbjmJhzSEiOlEgDVwH6CZilNNFPyve2fLm6SmCz2c8T1JLM9PbowJqlZQ9dEoaXolFvE9rXMYumZZzcmPELJfMCGjvzETZZEVJ2Kn+9htZzfW3+juif3phDnsVBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107607; c=relaxed/simple;
	bh=poOgLjJURqHizdHszuMrxzKRqUBdcMyAPFQB9KWCIYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qC4bVBMTXtIt4XG7229zyQLDRPoR2uA2DMj4TzacekvPavVVJbSxURZEHVCIR7oa2tL7Q7ixbcMI0obm3lArt7jaO3D96ivS4PiTVBbmKHwk/p+++AV4ghE4Uykvx69UzJDqqjoz1qdi/tMQpeOeA14BX68fckQVGl6YVqYMB/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxqJzB4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxqJzB4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0E6C4CECD;
	Wed, 20 Nov 2024 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107605;
	bh=poOgLjJURqHizdHszuMrxzKRqUBdcMyAPFQB9KWCIYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxqJzB4QE6Z8jlzd8iNi4BToRf940V/XcxWekGxIGDSCugh2MfpDzdOnD0n5s4Qtb
	 blUR4JacV8hY6tWfk1iUzfvFVbQ0xw2WzZc/M+vlu97BwqB55wC2F1ZMc2Ye7WNgZe
	 VI0NSgxSA3sST/Qf6RviknIWVsRQR37tAZLQiADc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 56/82] mm/damon/core: handle zero {aggregation,ops_update} intervals
Date: Wed, 20 Nov 2024 13:57:06 +0100
Message-ID: <20241120125630.873747470@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit 3488af0970445ff5532c7e8dc5e6456b877aee5e ]

Patch series "mm/damon/core: fix handling of zero non-sampling intervals".

DAMON's internal intervals accounting logic is not correctly handling
non-sampling intervals of zero values for a wrong assumption.  This could
cause unexpected monitoring behavior, and even result in infinite hang of
DAMON sysfs interface user threads in case of zero aggregation interval.
Fix those by updating the intervals accounting logic.  For details of the
root case and solutions, please refer to commit messages of fixes.

This patch (of 2):

DAMON's logics to determine if this is the time to do aggregation and ops
update assumes next_{aggregation,ops_update}_sis are always set larger
than current passed_sample_intervals.  And therefore it further assumes
continuously incrementing passed_sample_intervals every sampling interval
will make it reaches to the next_{aggregation,ops_update}_sis in future.
The logic therefore make the action and update
next_{aggregation,ops_updaste}_sis only if passed_sample_intervals is same
to the counts, respectively.

If Aggregation interval or Ops update interval are zero, however,
next_aggregation_sis or next_ops_update_sis are set same to current
passed_sample_intervals, respectively.  And passed_sample_intervals is
incremented before doing the next_{aggregation,ops_update}_sis check.
Hence, passed_sample_intervals becomes larger than
next_{aggregation,ops_update}_sis, and the logic says it is not the time
to do the action and update next_{aggregation,ops_update}_sis forever,
until an overflow happens.  In other words, DAMON stops doing aggregations
or ops updates effectively forever, and users cannot get monitoring
results.

Based on the documents and the common sense, a reasonable behavior for
such inputs is doing an aggregation and an ops update for every sampling
interval.  Handle the case by removing the assumption.

Note that this could incur particular real issue for DAMON sysfs interface
users, in case of zero Aggregation interval.  When user starts DAMON with
zero Aggregation interval and asks online DAMON parameter tuning via DAMON
sysfs interface, the request is handled by the aggregation callback.
Until the callback finishes the work, the user who requested the online
tuning just waits.  Hence, the user will be stuck until the
passed_sample_intervals overflows.

Link: https://lkml.kernel.org/r/20241031183757.49610-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20241031183757.49610-2-sj@kernel.org
Fixes: 4472edf63d66 ("mm/damon/core: use number of passed access sampling as a timer")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a29390fd55935..d0441e24a8ed5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1454,7 +1454,7 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (ctx->passed_sample_intervals == next_aggregation_sis) {
+		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
@@ -1472,7 +1472,7 @@ static int kdamond_fn(void *data)
 
 		sample_interval = ctx->attrs.sample_interval ?
 			ctx->attrs.sample_interval : 1;
-		if (ctx->passed_sample_intervals == next_aggregation_sis) {
+		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
 			ctx->next_aggregation_sis = next_aggregation_sis +
 				ctx->attrs.aggr_interval / sample_interval;
 
@@ -1482,7 +1482,7 @@ static int kdamond_fn(void *data)
 				ctx->ops.reset_aggregated(ctx);
 		}
 
-		if (ctx->passed_sample_intervals == next_ops_update_sis) {
+		if (ctx->passed_sample_intervals >= next_ops_update_sis) {
 			ctx->next_ops_update_sis = next_ops_update_sis +
 				ctx->attrs.ops_update_interval /
 				sample_interval;
-- 
2.43.0



