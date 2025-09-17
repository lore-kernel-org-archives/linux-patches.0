Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C85189F5C;
	Wed, 17 Sep 2025 12:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112805; cv=none; b=uFp8jXYytqFWATHUkGP7LG+96M8FB6yf/h8z/GQ3bOf+6lAFUk/F9sDlyZcysPxlAM1l4Vfb1BeANbzIs+xVxzXPlUI+vBOCLQDL3nmjvdufm9tXibx05FER93M1wBJ0yM8bg2e7zpp8Z3IVNYB63wPAuvPRZnNU77eG+hm3mdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112805; c=relaxed/simple;
	bh=hcyN68oHH9DHCZx58vlJ9yH6H4YoKxxKHFxpSwT3f5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFhzW7mWuXGt2AbrDEf9MvwXNohhfHNXq1W+RzadBILIXZngtbk2X95cEa5nyuCSAMMSrdTIQ08eRjUpPrIWBU+r7l7WaoGjZM/itkp5hfpO1wOprzS1zVrMZpf5e3PwZ8luozH2ciOfTz8HX3fOOHlWoFQ5lHQwho51Wmy1e5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFkOV9BS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFkOV9BS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F67C4CEF0;
	Wed, 17 Sep 2025 12:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112805;
	bh=hcyN68oHH9DHCZx58vlJ9yH6H4YoKxxKHFxpSwT3f5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFkOV9BS/6ipHJJxpjV0NeNIZgGEmBMvrCJpS57BJokUpege3jGFWNRX1I996Iftk
	 RRHoX4hpNXsFRzKBhcrBlmeM/H6xakPYUhS8nMXxAZ5uSwMdDxNGpNQ+IAwe7quYib
	 4VdexUay5asQt7KOznKbhIshAB0apXUXcVpA229E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sj@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	ze zuo <zuoze1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 082/189] mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
Date: Wed, 17 Sep 2025 14:33:12 +0200
Message-ID: <20250917123353.865987404@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/lru_sort.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -198,6 +198,11 @@ static int damon_lru_sort_apply_paramete
 	if (err)
 		return err;
 
+	if (!damon_lru_sort_mon_attrs.sample_interval) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		goto out;


