Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23A13D9530;
	Wed, 30 Sep 2026 19:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796056; cv=none; b=F/b99kZAvec9MS7iERZ0k48va7Su435KAHUgPsok/pXwgOnG/r2tTWLmUOOs7ekttSAvjVFZknELsZrzse60/7CeHxV08JcBEme+o0ntVpSczyDJ3uIBIVAPjWMn9rbnvXllMxpl22irqyhkUBnLWdE4IBm3X2oiFlYunFga4KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796056; c=relaxed/simple;
	bh=bob66pWpXNZGh6pIrC+GnhoZvOzlFIv1ybKX7MI8M50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJgV4J3Lz3MWn9YEvUN55LKyjXYcRD65/79RgQgytlA2fKQwU0kYIHM/HfaXuur6uTG6OZBPxi8i5nZA6X0iVYN2A5dHQW/bjAIxWGsUGC2RXsiYpIXVW7I3uRNXEVNtH0EAfpyKR/CIKva7ZP2BaKBs+7feHVXLF64+f57qeVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3SI+btU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3SI+btU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290C81F00898;
	Wed, 30 Sep 2026 19:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796054;
	bh=0ivXq7oAg6TaeH7/MMS2GL7BryHzv1Fi0mOIjbGG91g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3SI+btUqTrdvOOGzFPfaGTPLnQFJ2PMgRKtX4LXTrlGZctLUr+E4JUfqSSyliaUL
	 jr3/sYR8XqM2rS5QhYD23qbN0PIKPwjJHo1BKH/XgSNFVPLTNcHCXjzyhEeQUL8rYg
	 MTkcBMJHaUJ8vd/Y3DBR5466VZ7M20PoCfeNOKqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shouping Wang <allen.wang@hj-micro.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0778/1193] perf/arm-cmn: Fix wp_dev_sel2 setting for multi-DTM configurations
Date: Wed, 30 Sep 2026 17:24:22 +0200
Message-ID: <20260930152451.538578334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Shouping Wang <allen.wang@hj-micro.com>

[ Upstream commit 49daa3d668b69a5454b5aba0078848a479f79f1c ]

When MXP_MULTIPLE_DTM_EN is TRUE, each DTM will monitor at most
two device ports. In this case, {wp_dev_sel2, wp_dev_sel} will
only use values 2'b00 and 2'b01 per DTM.

Previously the setting allowed values beyond the supported range
per DTM, which could cause each DTM to select invalid ports when
MXP_MULTIPLE_DTM_EN is TRUE.

Fix this by only setting CMN_DTM_WPn_CONFIG_WP_DEV_SEL2 when
!multi_dtm.

Fixes: 60d1504070c2 ("perf/arm-cmn: Support new IP features")
Signed-off-by: Shouping Wang <allen.wang@hj-micro.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 9ca6fd7402100..8ecffe663f6cd 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1326,18 +1326,22 @@ static int arm_cmn_wp_idx(struct perf_event *event)
 
 static u32 arm_cmn_wp_config(struct perf_event *event)
 {
+	struct arm_cmn *cmn = to_cmn(event->pmu);
 	u32 config;
 	u32 dev = CMN_EVENT_WP_DEV_SEL(event);
 	u32 chn = CMN_EVENT_WP_CHN_SEL(event);
 	u32 grp = CMN_EVENT_WP_GRP(event);
 	u32 exc = CMN_EVENT_WP_EXCLUSIVE(event);
 	u32 combine = CMN_EVENT_WP_COMBINE(event);
-	bool is_cmn600 = to_cmn(event->pmu)->part == PART_CMN600;
+	bool is_cmn600 = cmn->part == PART_CMN600;
 
 	config = FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_DEV_SEL, dev) |
 		 FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_CHN_SEL, chn) |
-		 FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_GRP, grp) |
-		 FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_DEV_SEL2, dev >> 1);
+		 FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_GRP, grp);
+
+	if (!cmn->multi_dtm)
+		config |= FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_DEV_SEL2, dev >> 1);
+
 	if (exc)
 		config |= is_cmn600 ? CMN600_WPn_CONFIG_WP_EXCLUSIVE :
 				      CMN_DTM_WPn_CONFIG_WP_EXCLUSIVE;
-- 
2.53.0



