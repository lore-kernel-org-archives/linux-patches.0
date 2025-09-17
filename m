Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61F41EF36C;
	Wed, 17 Sep 2025 12:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113043; cv=none; b=FpAbztBKmVls7wpYl176YtDR6a6byZXv3r4sUpdNHdHWtYgCrJbPIoKTUt0Yo252C9UCdcAQmKug1znsMaCbX0vOpv9TIZnQ+oDvRTt/vCDbI07vsjQlWcK79V1ER44gjJuKM80tf6DtJKxIYimsJRUIlfFxAijylX/nlLFXtME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113043; c=relaxed/simple;
	bh=xUqN0IMnP5wrDoF5GAnaFMyF1/QJAKFCnpd5PdtN8os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vus0ZtEFVBo4W6H4jWcQet7ELSov6tHE1N2sIjJvbfyy4/tpgISxOaGziW0cTBQHX3mzq01cLUXByQuv69Vi5wNFyyEkXo1DTBqGgXMKrNx0gKz0ZyXsq2eJo1p6IltBvwXVo+0HT2X/6jzPhXMNCjHGL0+1CCkY34TAvWahNAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZdBHDXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZdBHDXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC05C4CEF0;
	Wed, 17 Sep 2025 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113043;
	bh=xUqN0IMnP5wrDoF5GAnaFMyF1/QJAKFCnpd5PdtN8os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZdBHDXE6YThVUCDVahCFSNZiRE8ucMiEkKryOpbhQx1Y+8Ae20pSyO4g802jxOPy
	 A1RoG8lghIk7hzZszpVHxWydjS7Fc1/X4boBnqPFnkqt7Z5HpU28xArF2NH0Zeic0q
	 BiIlTyZelL4eSwKeLfVfAdNy02emSVOUvfeWU6HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sj@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	ze zuo <zuoze1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 109/189] mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()
Date: Wed, 17 Sep 2025 14:33:39 +0200
Message-ID: <20250917123354.531410697@linuxfoundation.org>
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
 mm/damon/reclaim.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -194,6 +194,11 @@ static int damon_reclaim_apply_parameter
 	if (err)
 		return err;
 
+	if (!damon_reclaim_mon_attrs.aggr_interval) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
 	if (err)
 		goto out;


