Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAFA33C77D;
	Wed, 17 Sep 2025 13:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114064; cv=none; b=sWElOor0RoRT22rRi5MAZK230V1t3n9oa9vtzDJ9uspjhJ5ZSUcR/mWybq4rva0PAMucPgb7YXrn3AifOrjH9XWQBOcEeDm0mFhwTCDgm9tL4D473aElfyb79GVeiw6K8YBXsEXvI6wU7j8JSVWXsLCHmtFIJYwfv3vG7xu0Q0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114064; c=relaxed/simple;
	bh=7o2nfqK5kWRFRH5jufGydSIMlPv2aOvjRbMAzH574zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px7N0P+FkXnRwAAH6MJL+C9LFO7nOdJToJ7wrmuGreiAV9wLRTl2y1Gp0+SdMpOtmfz83oVx0e1aHFmZmNPWBuOyY2sMA4cTJd2K7SpTk/s2nBsj0+4nKqwouYyBTg70iHrs0EzyEw4QlZNsfLfBqLKMVtAHvSw6TjW8CVcKnnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+7HWlEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+7HWlEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD93C4CEF0;
	Wed, 17 Sep 2025 13:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114064;
	bh=7o2nfqK5kWRFRH5jufGydSIMlPv2aOvjRbMAzH574zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+7HWlEHTL9Yxc5dC9AB6ty/qdhvrwt1fPYbhL6GymBiAcnkvLkslZiXQ+odBFWRc
	 LoR6SUy0gh4vydFIN260MlEO9F7sL2qtwDtcJMaVO4fI71DoCE4cKK0zG66xUgXcl1
	 Sq655y7rNrMJW5e++C3WQXqP8h7f+ENUFbeRk5wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sj@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	ze zuo <zuoze1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 36/78] mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
Date: Wed, 17 Sep 2025 14:34:57 +0200
Message-ID: <20250917123330.442121745@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Quanmin Yan <yanquanmin1@huawei.com>

commit 711f19dfd783ffb37ca4324388b9c4cb87e71363 upstream.

Patch series "mm/damon: avoid divide-by-zero in DAMON module's parameters
application".

DAMON's RECLAIM and LRU_SORT modules perform no validation on
user-configured parameters during application, which may lead to
division-by-zero errors.

Avoid the divide-by-zero by adding validation checks when DAMON modules
attempt to apply the parameters.


This patch (of 2):

During the calculation of 'hot_thres' and 'cold_thres', either
'sample_interval' or 'aggr_interval' is used as the divisor, which may
lead to division-by-zero errors.  Fix it by directly returning -EINVAL
when such a case occurs.  Additionally, since 'aggr_interval' is already
required to be set no smaller than 'sample_interval' in damon_set_attrs(),
only the case where 'sample_interval' is zero needs to be checked.

Link: https://lkml.kernel.org/r/20250827115858.1186261-2-yanquanmin1@huawei.com
Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: <stable@vger.kernel.org>	[6.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/lru_sort.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -203,6 +203,9 @@ static int damon_lru_sort_apply_paramete
 	unsigned int hot_thres, cold_thres;
 	int err = 0;
 
+	if (!damon_lru_sort_mon_attrs.sample_interval)
+		return -EINVAL;
+
 	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		return err;


