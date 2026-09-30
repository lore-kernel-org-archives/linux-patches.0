Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0224F3EAA;
	Wed, 30 Sep 2026 17:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788335; cv=none; b=nxWjnt0LvHivlTtO2ChaaICdKyQLFvExPltxXeNGHuKFOJ4ZeI55QN91rvnILt2c17KLrvqF4F9+LTCwI7ZKjxMly/ZAYyD0XZtJCIzWggmEmoIRe4F1C9Lb6hPSf2oReWXOlENNvU92lJ9qn//26VqnKRBR1y8Tz51PLUyaYDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788335; c=relaxed/simple;
	bh=kUPqvkG9mI6CR+rmF6l3JkGXCAvj0K66ybT27epA8hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1IH7LpTkpxPDBd+PlKPYG+FIc+jESlGXuLLo0MlqaNQ7XjL21L1RO7b6pPD3GLm71EAFIAAgQqYTv6KVfLR6YCxrOLw095rlrqFxwTfC5EW9zwHJeKRpRCLnTidoG1WFKMMO7NM3kAp84KpTCdOLZ+Ifp8Z+6h7YelNlkSXP+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8Kw5tPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8Kw5tPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7788D1F000FF;
	Wed, 30 Sep 2026 17:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788334;
	bh=4KpeVbHye84kal23nk+h2oebRG0kz6bk8Lq58Himjd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8Kw5tPk5wSLgz8GwGzR8P4QtjsV78E/h4UCWES7pI3Pu7SgDFCMNa0B1FZgbRBq0
	 hOBYUApW4vpy24puzd6aCvJFZlXI/qOOvCK3flLsQP453b34AgjGuSoXNu5lMF0jq7
	 RDGWerxoPIiVOz4dGcgvr1kBh1n6sh/qQeCSNXkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shouping Wang <allen.wang@hj-micro.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/877] perf/arm-cmn: Fix wp_dev_sel2 setting for multi-DTM configurations
Date: Wed, 30 Sep 2026 17:16:39 +0200
Message-ID: <20260930152416.638324374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 892bc6b5875a7..3a4541c51863b 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1395,13 +1395,14 @@ static void arm_cmn_claim_wp_idx(struct arm_cmn_dtm *dtm,
 
 static u32 arm_cmn_wp_config(struct perf_event *event, int wp_idx)
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
 
 	/* CMN-600 supports only primary and secondary matching groups */
 	if (is_cmn600)
@@ -1409,8 +1410,11 @@ static u32 arm_cmn_wp_config(struct perf_event *event, int wp_idx)
 
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



