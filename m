Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367FA269830;
	Tue,  8 Apr 2025 11:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111563; cv=none; b=JrfD+2lgo8d3/wN6R1UbOOqBU+2LyToXr4SzrcqLbLFj8Y0+CUTs40KYGqq+2mn1QXlccO/PVeIrncru0qRnPFZJ02XFGgUPZw9Jpx/J3acwIM3wFnJ5uPCg3mZ61rlzFJLuQ1zerR0YqMLcMcqM3ZfoXxPTBjxb0pFsAEvfdV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111563; c=relaxed/simple;
	bh=KaGcvY3l18RidjU7ZllwhZyBWAd7PArk9HuMtXsrMWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iX80p2XYFOAuBKIOCjX2zH4GJBPeknQEc7/h5HWPbxQpI4NJqkvIEvIlTunZ417PdczYrJVVECHF+AN1TXoHky+iumPrjXLuB4wJz6MRbXm9DHGBJBGLf+Bi9FzAnLmfNqISvDdBhfYj7zba96WlE5OZNax+hQhz3ULmmZ4bwYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhNgV+T1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhNgV+T1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED3FC4CEE5;
	Tue,  8 Apr 2025 11:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111563;
	bh=KaGcvY3l18RidjU7ZllwhZyBWAd7PArk9HuMtXsrMWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhNgV+T1zs2yOt21QuHocolPHHCH0oqefrY4bHOuaBMUZoRn6LC8Fp41KgnW20Uak
	 IJDX6z/5+3Gg7whxfC4v94ZVZYHBSj0sgbmvGOSTMlPYAEC43pHnbU5pYJddY56Hck
	 WxfagAdT0xe7g1Lqrx3fRGF4/tp9WaKxhJrTsKO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 477/731] perf arm-spe: Fix load-store operation checking
Date: Tue,  8 Apr 2025 12:46:14 +0200
Message-ID: <20250408104925.372680550@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit e1d47850bbf79a541c9b3bacdd562f5e0112274d ]

The ARM_SPE_OP_LD and ARM_SPE_OP_ST operations are secondary operation
type, they are overlapping with other second level's operation types
belonging to SVE and branch operations.  As a result, a non load-store
operation can be parsed for data source and memory sample.

To fix the issue, this commit introduces a is_ldst_op() macro for
checking LDST operation, and apply the checking when synthesize data
source and memory samples.

Fixes: a89dbc9b988f ("perf arm-spe: Set sample's data source field")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250304111240.3378214-7-leo.yan@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 12761c39788f8..f1365ce69ba08 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -37,6 +37,8 @@
 #include "../../arch/arm64/include/asm/cputype.h"
 #define MAX_TIMESTAMP (~0ULL)
 
+#define is_ldst_op(op)		(!!((op) & ARM_SPE_OP_LDST))
+
 struct arm_spe {
 	struct auxtrace			auxtrace;
 	struct auxtrace_queues		queues;
@@ -669,6 +671,10 @@ static u64 arm_spe__synth_data_source(struct arm_spe_queue *speq,
 {
 	union perf_mem_data_src	data_src = { .mem_op = PERF_MEM_OP_NA };
 
+	/* Only synthesize data source for LDST operations */
+	if (!is_ldst_op(record->op))
+		return 0;
+
 	if (record->op & ARM_SPE_OP_LD)
 		data_src.mem_op = PERF_MEM_OP_LOAD;
 	else if (record->op & ARM_SPE_OP_ST)
@@ -767,7 +773,7 @@ static int arm_spe_sample(struct arm_spe_queue *speq)
 	 * When data_src is zero it means the record is not a memory operation,
 	 * skip to synthesize memory sample for this case.
 	 */
-	if (spe->sample_memory && data_src) {
+	if (spe->sample_memory && is_ldst_op(record->op)) {
 		err = arm_spe__synth_mem_sample(speq, spe->memory_id, data_src);
 		if (err)
 			return err;
-- 
2.39.5



