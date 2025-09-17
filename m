Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374DC319603;
	Wed, 17 Sep 2025 13:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114212; cv=none; b=Ey3tqKrAsxB4jAJzQr8BIrd7Cd8w5lc6plYRNZTFyrMq0kfkFWnreAJE2G9tL9N3GxLtGwhQBa+yLAymSTOdyQrCcULtRbPHFyq4Czs1cszU4rXp/cgYkVOdYpWg3IGp7tML1gfcOJpHA87HARuM2vSMTzFJAwu9irhAGK9yGfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114212; c=relaxed/simple;
	bh=YwgUT+UAxxHbVci3qLZS8JC04p3EkPBUXQhBAqEnxW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx5i6nYdTC394SXU8jG6iFTGydQrwTOx4tqCw58mvvZ9+Sbar9JZ0NaqGk2LoYwBpoN3bJZ2YysszPWR1HXsLlku+AA+g4FAzknrhyuqpdGChNtjfiEwgn9GLXl3QBR4V+xI1sU2FXXfqIHMkzGYkGddHFLNqA++XjdetokEVIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6Yc9Rkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6Yc9Rkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5872C4CEF0;
	Wed, 17 Sep 2025 13:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114212;
	bh=YwgUT+UAxxHbVci3qLZS8JC04p3EkPBUXQhBAqEnxW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6Yc9RklgAPlyBBfbhvFPEfNaIQBSVME9R58elPCyArlBSs/CezEbtXvWORanjUou
	 Ul0mpNARGBG0stsP9Ir3rI2SprBv9qCnY7oYPgtLgZmPD2lOnanefWY/PYYOAunjrY
	 O1/bQc+T4ZiB2D5TSGVf9PdZSJGTkZv/1zD3pBFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sj@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	ze zuo <zuoze1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 35/78] mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()
Date: Wed, 17 Sep 2025 14:34:56 +0200
Message-ID: <20250917123330.417400846@linuxfoundation.org>
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

commit e6b543ca9806d7bced863f43020e016ee996c057 upstream.

When creating a new scheme of DAMON_RECLAIM, the calculation of
'min_age_region' uses 'aggr_interval' as the divisor, which may lead to
division-by-zero errors.  Fix it by directly returning -EINVAL when such a
case occurs.

Link: https://lkml.kernel.org/r/20250827115858.1186261-3-yanquanmin1@huawei.com
Fixes: f5a79d7c0c87 ("mm/damon: introduce struct damos_access_pattern")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/reclaim.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -157,6 +157,9 @@ static int damon_reclaim_apply_parameter
 	struct damos *scheme, *old_scheme;
 	int err = 0;
 
+	if (!damon_reclaim_mon_attrs.aggr_interval)
+		return -EINVAL;
+
 	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
 	if (err)
 		return err;


