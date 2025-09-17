Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AB172602;
	Wed, 17 Sep 2025 12:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113786; cv=none; b=ou1kZsqYzAL76aycfyiRfZ0dhHKu0Ffrkt0cGW2XBzt2bij1iiJbXIV1/NMSc7noUd6HcymTyG+MeWlxd8bgkY5DG/7p9SUU9cFN5pDprSuQmE7f5GiMA0IPtbOMqpy6CGtKDnDUW2LbX/bS7/Cfq7eReFuXoL+67b978LpR/Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113786; c=relaxed/simple;
	bh=vOPZkPbCLznUDJiqSEJ3uFZT4P5zg0AZGGPUJ27X84E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlEhieE4nCUdEeAFB/wY+59pw+aXnpAO493AMRwOXrqP+truVf+SAEKC4kt3f5Wq2IrmLaZfFiuQGdTUX6aBmA8qUX6NWeBAtF6jPxlNGwTm264ABqNu5qkhwZ+3XXsMS/Wcqi5HsDWTlv2ZUTqnCiQUfbqEB7JzkpjXiohOl+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZECM5VJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZECM5VJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8548C4CEF5;
	Wed, 17 Sep 2025 12:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113786;
	bh=vOPZkPbCLznUDJiqSEJ3uFZT4P5zg0AZGGPUJ27X84E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZECM5VJqZzUf5VlRPxNlV/YolLDCiXglN/LDEAVUfB+aB9XhJ2KGZ5md1772SE8x
	 zeU3cWywwF0yMiWuzDgbOK5Lmc+IVdu4cWvIVYt9CwIQwUxRADgg4mEViCywYALrWr
	 nhjLx8yuEBVFny4GvvxMsTD/d/+kVIHNZvMbpkUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sj@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	ze zuo <zuoze1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 051/101] mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()
Date: Wed, 17 Sep 2025 14:34:34 +0200
Message-ID: <20250917123338.076537544@linuxfoundation.org>
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
@@ -167,6 +167,9 @@ static int damon_reclaim_apply_parameter
 	struct damos_filter *filter;
 	int err = 0;
 
+	if (!damon_reclaim_mon_attrs.aggr_interval)
+		return -EINVAL;
+
 	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
 	if (err)
 		return err;


