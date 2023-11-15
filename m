Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05C53A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJmJfLa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07B3C433C9;
	Wed, 15 Nov 2023 19:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077387;
	bh=8Xz5mjRyaYbn5XtL98RcVYM128T/xuYwWpRjxl9DExc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJmJfLa0Y+RT4UEbJ8i3xBot7jZ3zlVQbQKb0o+beyM8NOYt+PCqalctm/KKB9uv9
	 +Bj1OmxBnniTyV5J8kbY972XU2O3ebAc35ggBCkFBeVjMhErm74oId9W1zsY7oXTu7
	 tZgM75mAZz29tc6iKsgwh4zNdxNTDa+5RShiK80Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 272/603] perf/arm-cmn: Fix DTC domain detection
Date: Wed, 15 Nov 2023 14:13:37 -0500
Message-ID: <20231115191632.166022452@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit e3e73f511c49c741f6309862c2248958ad77bbaa ]

It transpires that dtm_unit_info is another register which got shuffled
in CMN-700 without me noticing. Fix that in a way which also proactively
fixes the fragile laziness of its consumer, just in case any further
fields ever get added alongside dtc_domain.

Fixes: 23760a014417 ("perf/arm-cmn: Add CMN-700 support")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Link: https://lore.kernel.org/r/3076ee83d0554f6939fbb6ee49ab2bdb28d8c7ee.1697824215.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 6b50bc5519846..caae2d3e9d3ea 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -112,7 +112,9 @@
 
 #define CMN_DTM_PMEVCNTSR		0x240
 
-#define CMN_DTM_UNIT_INFO		0x0910
+#define CMN650_DTM_UNIT_INFO		0x0910
+#define CMN_DTM_UNIT_INFO		0x0960
+#define CMN_DTM_UNIT_INFO_DTC_DOMAIN	GENMASK_ULL(1, 0)
 
 #define CMN_DTM_NUM_COUNTERS		4
 /* Want more local counters? Why not replicate the whole DTM! Ugh... */
@@ -2117,6 +2119,16 @@ static int arm_cmn_init_dtcs(struct arm_cmn *cmn)
 	return 0;
 }
 
+static unsigned int arm_cmn_dtc_domain(struct arm_cmn *cmn, void __iomem *xp_region)
+{
+	int offset = CMN_DTM_UNIT_INFO;
+
+	if (cmn->part == PART_CMN650 || cmn->part == PART_CI700)
+		offset = CMN650_DTM_UNIT_INFO;
+
+	return FIELD_GET(CMN_DTM_UNIT_INFO_DTC_DOMAIN, readl_relaxed(xp_region + offset));
+}
+
 static void arm_cmn_init_node_info(struct arm_cmn *cmn, u32 offset, struct arm_cmn_node *node)
 {
 	int level;
@@ -2248,7 +2260,7 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 		if (cmn->part == PART_CMN600)
 			xp->dtc = 0xf;
 		else
-			xp->dtc = 1 << readl_relaxed(xp_region + CMN_DTM_UNIT_INFO);
+			xp->dtc = 1 << arm_cmn_dtc_domain(cmn, xp_region);
 
 		xp->dtm = dtm - cmn->dtms;
 		arm_cmn_init_dtm(dtm++, xp, 0);
-- 
2.42.0



