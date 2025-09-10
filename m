Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC739311955
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499266; cv=none; b=SfKWuo2odu+AdUMAGTHF0dcHmbGuzn2U36EL3344qtYHuJTq1d+WMOcA1XB/TsgJDSdugm0keQI4x1g1rCYebpKLdanfCsWWbAisxtkFI3RWI7nPJd2heZrenLny03nFiOK+X7tq4n0WSuOqH8oBx07+7zcMqM8Z8HvRdy25oO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499266; c=relaxed/simple;
	bh=uST/0Z4WyrCa6m+ay/OtP5+I15YQGzYPvPpx+OqNUfI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ENja21KdDJQvGWX8GaMXBbR2aq+nt98P4QHAU4lSjDMo+6nq0Iu3bCww1HEKZDtDpwfr5p9laM/2cKzK38B7WmRPbRj5PSZXDFLwNKbeSE12D9skuP9G1FC3WSMzL0iNZGshxyUZvKsXChToEvGuTTAcHdCCmdUtB1SWSbPyNA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=USGfI7pz; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="USGfI7pz"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250910101422epoutp0480b3dd7e7111a9513f220f1a8ec21171~j5ESTCbUb1877318773epoutp04h
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250910101422epoutp0480b3dd7e7111a9513f220f1a8ec21171~j5ESTCbUb1877318773epoutp04h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499262;
	bh=dw8aukTtZ/zLtcfpP/Loa8IeVui1SjSnxag81j1Oaf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USGfI7pzNTMU+/PmjbHJCEVrGhWRPR96Pz7NWJkZlG3RJJUd3ONP3X8ncu+lFk6NB
	 sonn+jdfBHJQS0zVxfAL2fvhEf/8cfECTQmlAgWQF7phr68cx3euPAmzM/ipTdRDGg
	 maTIXqwxO0vfA+fr0gG/YFw5kt8ChGpdPF6y6THc=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250910101422epcas5p3459128f9f359a21fb148c9f9bded67e2~j5ESB8_gW3176131761epcas5p3l;
	Wed, 10 Sep 2025 10:14:22 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cMGkj2zN4z2SSKY; Wed, 10 Sep
	2025 10:14:21 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250910101420epcas5p496bf3c5dd4765828e3241e7a7c30d0f1~j5EQSL5bm2642326423epcas5p47;
	Wed, 10 Sep 2025 10:14:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101419epsmtip15067f474da99a3a231b862e3b17799a5~j5EPsVjSV2446624466epsmtip1E;
	Wed, 10 Sep 2025 10:14:19 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 05/16] writeback: modify bdi_writeback search logic to
 search across all wb ctxs
Date: Wed, 10 Sep 2025 15:42:53 +0530
Message-Id: <20250910101304.2588-6-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101420epcas5p496bf3c5dd4765828e3241e7a7c30d0f1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101420epcas5p496bf3c5dd4765828e3241e7a7c30d0f1
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101420epcas5p496bf3c5dd4765828e3241e7a7c30d0f1@epcas5p4.samsung.com>

Since we have multiple cgwb per bdi, embedded in writeback_ctx now, we
iterate over all of them to find the associated writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fs-writeback.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e065cd606b80..60c7c912c7f3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1090,7 +1090,8 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 {
 	struct backing_dev_info *bdi;
 	struct cgroup_subsys_state *memcg_css;
-	struct bdi_writeback *wb;
+	struct bdi_writeback *wb = NULL;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 	struct wb_writeback_work *work;
 	unsigned long dirty;
 	int ret;
@@ -1114,7 +1115,11 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	 * And find the associated wb.  If the wb isn't there already
 	 * there's nothing to flush, don't create one.
 	 */
-	wb = wb_get_lookup(bdi->wb_ctx[0], memcg_css);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		wb = wb_get_lookup(bdi_wb_ctx, memcg_css);
+		if (wb)
+			break;
+	}
 	if (!wb) {
 		ret = -ENOENT;
 		goto out_css_put;
-- 
2.25.1

