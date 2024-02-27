Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7AD78B61;
	Tue, 27 Feb 2024 14:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043412; cv=none; b=VeEvmvwScK5v/79hfXHilnZWOhw3SQwa6q2YWu4YHIuQ0XgspWdUq2NMbjCDueCf1QX9DwY2ZQk35UudLZUxotLBugrSFOwidIo+Um568VIlDlI6W4hsrV+tky+b+xWDBu2jy3ETorOVQi8JD4knDgNc2GGGejCnenBLRZXlxzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043412; c=relaxed/simple;
	bh=LrOthxNILau0lMEHEK5+dZD0+SVoohuBkvHgY1pnyQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gefuAjPqF3NvbX3cki2RixZNczCLRv8VJg+C7Ni+lFUtMlY6bz6i2o+h8VSa9A5cOjIrS9zf11aLw97zvl8gUNlF1eWmzzY/m/4BhJff2D5efCIfv16Lu8NzIBSIeBbVlea1jEc6EttUF0HOtF5N+Gl3X3YjzcPZjWu1rJbYSjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogBzNq6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogBzNq6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA852C433F1;
	Tue, 27 Feb 2024 14:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043412;
	bh=LrOthxNILau0lMEHEK5+dZD0+SVoohuBkvHgY1pnyQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogBzNq6nJW8yxUKD5ByqQY4zn8j1ExiwGvjSpVKDlqiuxspBvQqS9ElbVDEhGQBvU
	 +ZOu2ad+QjE7eli7kKGL5bDUT16MeZPReKwBdbuwuHMEH4tKHrS1ac7dH7YWzooiRH
	 YuaDNBcphi0qVedorfXj+3zGMPA7R9d3Hoq3U7bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 097/195] mm/damon/lru_sort: fix quota status loss due to online tunings
Date: Tue, 27 Feb 2024 14:25:58 +0100
Message-ID: <20240227131613.676788177@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 13d0599ab3b2ff17f798353f24bcbef1659d3cfc upstream.

For online parameters change, DAMON_LRU_SORT creates new schemes based on
latest values of the parameters and replaces the old schemes with the new
one.  When creating it, the internal status of the quotas of the old
schemes is not preserved.  As a result, charging of the quota starts from
zero after the online tuning.  The data that collected to estimate the
throughput of the scheme's action is also reset, and therefore the
estimation should start from the scratch again.  Because the throughput
estimation is being used to convert the time quota to the effective size
quota, this could result in temporal time quota inaccuracy.  It would be
recovered over time, though.  In short, the quota accuracy could be
temporarily degraded after online parameters update.

Fix the problem by checking the case and copying the internal fields for
the status.

Link: https://lkml.kernel.org/r/20240216194025.9207-3-sj@kernel.org
Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/lru_sort.c |   43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -185,9 +185,21 @@ static struct damos *damon_lru_sort_new_
 	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_DEPRIO);
 }
 
+static void damon_lru_sort_copy_quota_status(struct damos_quota *dst,
+		struct damos_quota *src)
+{
+	dst->total_charged_sz = src->total_charged_sz;
+	dst->total_charged_ns = src->total_charged_ns;
+	dst->charged_sz = src->charged_sz;
+	dst->charged_from = src->charged_from;
+	dst->charge_target_from = src->charge_target_from;
+	dst->charge_addr_from = src->charge_addr_from;
+}
+
 static int damon_lru_sort_apply_parameters(void)
 {
-	struct damos *scheme;
+	struct damos *scheme, *hot_scheme, *cold_scheme;
+	struct damos *old_hot_scheme = NULL, *old_cold_scheme = NULL;
 	unsigned int hot_thres, cold_thres;
 	int err = 0;
 
@@ -195,18 +207,35 @@ static int damon_lru_sort_apply_paramete
 	if (err)
 		return err;
 
+	damon_for_each_scheme(scheme, ctx) {
+		if (!old_hot_scheme) {
+			old_hot_scheme = scheme;
+			continue;
+		}
+		old_cold_scheme = scheme;
+	}
+
 	hot_thres = damon_max_nr_accesses(&damon_lru_sort_mon_attrs) *
 		hot_thres_access_freq / 1000;
-	scheme = damon_lru_sort_new_hot_scheme(hot_thres);
-	if (!scheme)
+	hot_scheme = damon_lru_sort_new_hot_scheme(hot_thres);
+	if (!hot_scheme)
 		return -ENOMEM;
-	damon_set_schemes(ctx, &scheme, 1);
+	if (old_hot_scheme)
+		damon_lru_sort_copy_quota_status(&hot_scheme->quota,
+				&old_hot_scheme->quota);
 
 	cold_thres = cold_min_age / damon_lru_sort_mon_attrs.aggr_interval;
-	scheme = damon_lru_sort_new_cold_scheme(cold_thres);
-	if (!scheme)
+	cold_scheme = damon_lru_sort_new_cold_scheme(cold_thres);
+	if (!cold_scheme) {
+		damon_destroy_scheme(hot_scheme);
 		return -ENOMEM;
-	damon_add_scheme(ctx, scheme);
+	}
+	if (old_cold_scheme)
+		damon_lru_sort_copy_quota_status(&cold_scheme->quota,
+				&old_cold_scheme->quota);
+
+	damon_set_schemes(ctx, &hot_scheme, 1);
+	damon_add_scheme(ctx, cold_scheme);
 
 	return damon_set_region_biggest_system_ram_default(target,
 					&monitor_region_start,


