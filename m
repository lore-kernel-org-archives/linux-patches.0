Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB3572602;
	Wed, 17 Sep 2025 12:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113789; cv=none; b=KWMMnuFN4alhdeBKGQRAqBiiGaecK4ixVyEfpZyphrkMQvpLom4C2ETI9c4vVXlinSSq5pGQhhNjL1hE+Rs2m8MVZZa5YXcekHgk/pLn+Z+mD5gupDUepf+5gJfXD6xtlSGOchB/uqAzd/b7kkSEvQzVjqy0T2vdICSmWUPpFhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113789; c=relaxed/simple;
	bh=gqMK87WtcRSDc0RZaXYkxKYJeama7l7cchXVpdWX650=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+X68PB9QehDe8E8PpZ3heY0/3VimsozQhTIuRoMdbJD//nHHbeBhWy9C2MzHFXCfHQoGUCcnF3bdXNHaAWE570zLiZ84NJ72BX71wscGs6UM3Ro7hS/XIbmqXMF2/tL+vyorXYtTytMMFkn4loFohJ9zqedGMhED1U7sAxJlFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fys+dozH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fys+dozH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2424C4CEF5;
	Wed, 17 Sep 2025 12:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113789;
	bh=gqMK87WtcRSDc0RZaXYkxKYJeama7l7cchXVpdWX650=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fys+dozHVSwN2RSBKRMbi0SlhU4Wkf3XmccTw0Q3AlIAfwAaQbNBI229GuYIQCig/
	 p5cmLVngw0V3Dv8ZlxprekjlO20yOZ72Ioc4aDjfeAPhlz+Uizh0UMEI9q9Na1kdk1
	 xtv0XzGycPg8aqMt9uCHWZb4292uZwIwKY8cNRuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sj@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	ze zuo <zuoze1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 052/101] mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
Date: Wed, 17 Sep 2025 14:34:35 +0200
Message-ID: <20250917123338.100857133@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


