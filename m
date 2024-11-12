Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E4121A4BB;
	Tue, 12 Nov 2024 10:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408403; cv=none; b=PIYuSB2Ia808p1ckQ7zE48SqMl2QoZLUDe7DnJNrCoEDd7nFfDAQfuUIvmIwpjNHgsXCW96VIqyj6bmGyfHBVrmjGobero8mjVR8OgyCWnMR2+d90nURjAfnbo1GX3A4deYd8zD/Sb/GPYMVTTsyRkwb/9IjJLLPiY7asGQsCPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408403; c=relaxed/simple;
	bh=zlSHJPiFuBuRZcSjITiMaWvHjN8rI86nelzCpU6UiB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tfc2YbIkY1v3cRvrquLXdp0rZ0WtteC3td6X6/atcH+fjeaRifqsgwaPdfCIaZQOQD4Vkb5D9e/L6qscBHj25ydkIuoAX7ZgW8P2F2ad5CTNnfZ2FG3p7CDmt1HeAjzDZWk5SJCY0iMh4ifuUJQYF1OzqfyrsqkrPJsbysBe8E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktD0Jw6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktD0Jw6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F8C4CECD;
	Tue, 12 Nov 2024 10:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408403;
	bh=zlSHJPiFuBuRZcSjITiMaWvHjN8rI86nelzCpU6UiB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktD0Jw6ePSXu7BprnPznPdepKrMbV1yOXcmPPyuBXnS6HsLnpl0QHb3oeaxKIitVQ
	 /NxlvG28Vhy+yhZsd/7ySKXml0LlDqrcCMwWMAqSd3e2aX0yeSGIfBWsscDzsFa654
	 9EP0M9dH3RpzbxkRt5PRTpNdNylkIxZdVIZBqWXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 151/184] mm/damon/core: handle zero {aggregation,ops_update} intervals
Date: Tue, 12 Nov 2024 11:21:49 +0100
Message-ID: <20241112101906.665579273@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 3488af0970445ff5532c7e8dc5e6456b877aee5e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2001,7 +2001,7 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (ctx->passed_sample_intervals == next_aggregation_sis) {
+		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
@@ -2019,7 +2019,7 @@ static int kdamond_fn(void *data)
 
 		sample_interval = ctx->attrs.sample_interval ?
 			ctx->attrs.sample_interval : 1;
-		if (ctx->passed_sample_intervals == next_aggregation_sis) {
+		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
 			ctx->next_aggregation_sis = next_aggregation_sis +
 				ctx->attrs.aggr_interval / sample_interval;
 
@@ -2029,7 +2029,7 @@ static int kdamond_fn(void *data)
 				ctx->ops.reset_aggregated(ctx);
 		}
 
-		if (ctx->passed_sample_intervals == next_ops_update_sis) {
+		if (ctx->passed_sample_intervals >= next_ops_update_sis) {
 			ctx->next_ops_update_sis = next_ops_update_sis +
 				ctx->attrs.ops_update_interval /
 				sample_interval;


