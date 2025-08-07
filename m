Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B352733993
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542709; cv=none; b=F7/xOY5ylvU3/V6PUkKdFoeTa1qCQ4lmGjuvhiDPAelABNfWOhMoMQPdh6F1v6EgnlRrCODon5WfHmt3y/AxBMquE6qtbYFQ+nTejzAVfuSgkBKZhKQZqdGExmFt5DWSr6CigBd9l4ZGddBqXKiOA9gHrEompl+/QT4mGathUbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542709; c=relaxed/simple;
	bh=uST/0Z4WyrCa6m+ay/OtP5+I15YQGzYPvPpx+OqNUfI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rxoe9ljyhhKZH1T5boT3hlnc+CVDyI88zSdOUfzf/9G2Sle86RAnWqlaSLE94MYBu4Ov/+gaeWLrBLtkKT0ZjXlBQYVEovO17+XKuAMSdHE8vk7u6UYv9XOP6TtfUPJ+Y2M7RegevNVzOM7uULWuuZPBXNq4Nn+4Ht3v5HlUfko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WvxoaAem; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WvxoaAem"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250807045826epoutp024532196f2450fb7e23c29e43c28f81a2~ZY0uOiDs_2611226112epoutp02Q
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250807045826epoutp024532196f2450fb7e23c29e43c28f81a2~ZY0uOiDs_2611226112epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542706;
	bh=dw8aukTtZ/zLtcfpP/Loa8IeVui1SjSnxag81j1Oaf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvxoaAemqCjyvJtcCcMdIQGU0wt5MUVp9OgF86ojLuUM5hRDUH2NKdmNVVNGcfuta
	 jwT+fZ475DsAknZiPxKlqc2RzFWwFPoeOPR3+klH/Hn/cLJaXSphsDzLorgTw4rbrj
	 Ca1aVllfpwsb+ugSyItjlShwVyvHwtCpMABMRsJI=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250807045825epcas5p43a63de918e6d24939292c2c4d1b7d970~ZY0tygi2Z0196301963epcas5p4f;
	Thu,  7 Aug 2025 04:58:25 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.92]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4byFKq5Rfbz2SSKd; Thu,  7 Aug
	2025 04:58:23 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250807045815epcas5p306d778d3c2e774a27423d6077595712b~ZY0kC_7RK0168901689epcas5p3c;
	Thu,  7 Aug 2025 04:58:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045814epsmtip1aa4549d6c1cbea287cf2edd2612aa648~ZY0jdFqx81580815808epsmtip1M;
	Thu,  7 Aug 2025 04:58:14 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 05/15] writeback: modify bdi_writeback search logic to
 search across all wb ctxs
Date: Thu,  7 Aug 2025 10:26:56 +0530
Message-Id: <20250807045706.2848-6-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045815epcas5p306d778d3c2e774a27423d6077595712b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045815epcas5p306d778d3c2e774a27423d6077595712b
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045815epcas5p306d778d3c2e774a27423d6077595712b@epcas5p3.samsung.com>

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

