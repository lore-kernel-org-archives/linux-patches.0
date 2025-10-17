Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08020330B00;
	Fri, 17 Oct 2025 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716270; cv=none; b=omFnjfQ9edxb2eZI1hI8FLEhzjxO7fQnwqi7P+l87Q3drv3egkyD2WGC82NTYj3rOEyBp189nXyjLxKq9w16HcsjCg+VzSBHqp+V59+jYqV824dqiTNMAcrq8rFgLiKHclvjepAqhkq3JUW+A1NZOTAFPSTNNtzFMgQIdo/gimY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716270; c=relaxed/simple;
	bh=T/FTYqw+cii1Ir02UOT08q3sbOYilg5F8OK6kodWyo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vou12KLHHx4ZLq+i7qGHFJQzLGQeTR1+tKObw58VXVwWxl/YORdX1UjnGK9Qr40UMXxd4PKOXNnpeMNDCH+jGKDu8IsehO/A5CCn/pcyGRcx6TdIJOsOA3lMkFlvJNT9/6EmoKDa7EwHP5goYbm8jr8NzhSxRfCW7OA2YRrECYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLDjkLI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLDjkLI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD8FC4CEE7;
	Fri, 17 Oct 2025 15:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716269;
	bh=T/FTYqw+cii1Ir02UOT08q3sbOYilg5F8OK6kodWyo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLDjkLI3fjZzkXD+1UFjtx4Q1kznqHYizlnsgU/sGkpjMP8Q7K0BLD3DBT/h4GJPd
	 A47FV9O0i2ATjoVWBrPq6XiDtB1oxhz/LWF2UevcrjFJbmKVFFTQNo9Vy046167koc
	 fiDz9TRmFIrHErh0AX87niLkRypUimqe6O1aP2Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@linaro.org>,
	German Gomez <german.gomez@arm.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman.Khandual@arm.com,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	James Clark <james.clark@arm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/276] perf arm-spe: Refactor arm-spe to support operation packet type
Date: Fri, 17 Oct 2025 16:53:45 +0200
Message-ID: <20251017145147.300787844@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: German Gomez <german.gomez@arm.com>

[ Upstream commit 0066015a3d8f9c01a17eb04579edba7dac9510af ]

Extend the decoder of Arm SPE records to support more fields from the
operation packet type.

Not all fields are being decoded by this commit. Only those needed to
support the use-case SVE load/store/other operations.

Suggested-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: German Gomez <german.gomez@arm.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Anshuman.Khandual@arm.com
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20230320151509.1137462-2-james.clark@arm.com
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: cb300e351505 ("perf arm_spe: Correct memory level for remote access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../util/arm-spe-decoder/arm-spe-decoder.c    | 30 ++++++++++--
 .../util/arm-spe-decoder/arm-spe-decoder.h    | 47 +++++++++++++++----
 tools/perf/util/arm-spe.c                     |  8 ++--
 3 files changed, 67 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/arm-spe-decoder/arm-spe-decoder.c b/tools/perf/util/arm-spe-decoder/arm-spe-decoder.c
index 3e36934477154..3b937e89654f4 100644
--- a/tools/perf/util/arm-spe-decoder/arm-spe-decoder.c
+++ b/tools/perf/util/arm-spe-decoder/arm-spe-decoder.c
@@ -184,11 +184,27 @@ static int arm_spe_read_record(struct arm_spe_decoder *decoder)
 			decoder->record.context_id = payload;
 			break;
 		case ARM_SPE_OP_TYPE:
-			if (idx == SPE_OP_PKT_HDR_CLASS_LD_ST_ATOMIC) {
-				if (payload & 0x1)
-					decoder->record.op = ARM_SPE_ST;
+			switch (idx) {
+			case SPE_OP_PKT_HDR_CLASS_LD_ST_ATOMIC:
+				decoder->record.op |= ARM_SPE_OP_LDST;
+				if (payload & SPE_OP_PKT_ST)
+					decoder->record.op |= ARM_SPE_OP_ST;
 				else
-					decoder->record.op = ARM_SPE_LD;
+					decoder->record.op |= ARM_SPE_OP_LD;
+				if (SPE_OP_PKT_IS_LDST_SVE(payload))
+					decoder->record.op |= ARM_SPE_OP_SVE_LDST;
+				break;
+			case SPE_OP_PKT_HDR_CLASS_OTHER:
+				decoder->record.op |= ARM_SPE_OP_OTHER;
+				if (SPE_OP_PKT_IS_OTHER_SVE_OP(payload))
+					decoder->record.op |= ARM_SPE_OP_SVE_OTHER;
+				break;
+			case SPE_OP_PKT_HDR_CLASS_BR_ERET:
+				decoder->record.op |= ARM_SPE_OP_BRANCH_ERET;
+				break;
+			default:
+				pr_err("Get packet error!\n");
+				return -1;
 			}
 			break;
 		case ARM_SPE_EVENTS:
@@ -216,6 +232,12 @@ static int arm_spe_read_record(struct arm_spe_decoder *decoder)
 			if (payload & BIT(EV_MISPRED))
 				decoder->record.type |= ARM_SPE_BRANCH_MISS;
 
+			if (payload & BIT(EV_PARTIAL_PREDICATE))
+				decoder->record.type |= ARM_SPE_SVE_PARTIAL_PRED;
+
+			if (payload & BIT(EV_EMPTY_PREDICATE))
+				decoder->record.type |= ARM_SPE_SVE_EMPTY_PRED;
+
 			break;
 		case ARM_SPE_DATA_SOURCE:
 			decoder->record.source = payload;
diff --git a/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h b/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h
index c3943eb95e305..fa269c9c53b33 100644
--- a/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h
+++ b/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h
@@ -14,19 +14,46 @@
 #include "arm-spe-pkt-decoder.h"
 
 enum arm_spe_sample_type {
-	ARM_SPE_L1D_ACCESS	= 1 << 0,
-	ARM_SPE_L1D_MISS	= 1 << 1,
-	ARM_SPE_LLC_ACCESS	= 1 << 2,
-	ARM_SPE_LLC_MISS	= 1 << 3,
-	ARM_SPE_TLB_ACCESS	= 1 << 4,
-	ARM_SPE_TLB_MISS	= 1 << 5,
-	ARM_SPE_BRANCH_MISS	= 1 << 6,
-	ARM_SPE_REMOTE_ACCESS	= 1 << 7,
+	ARM_SPE_L1D_ACCESS		= 1 << 0,
+	ARM_SPE_L1D_MISS		= 1 << 1,
+	ARM_SPE_LLC_ACCESS		= 1 << 2,
+	ARM_SPE_LLC_MISS		= 1 << 3,
+	ARM_SPE_TLB_ACCESS		= 1 << 4,
+	ARM_SPE_TLB_MISS		= 1 << 5,
+	ARM_SPE_BRANCH_MISS		= 1 << 6,
+	ARM_SPE_REMOTE_ACCESS		= 1 << 7,
+	ARM_SPE_SVE_PARTIAL_PRED	= 1 << 8,
+	ARM_SPE_SVE_EMPTY_PRED		= 1 << 9,
 };
 
 enum arm_spe_op_type {
-	ARM_SPE_LD		= 1 << 0,
-	ARM_SPE_ST		= 1 << 1,
+	/* First level operation type */
+	ARM_SPE_OP_OTHER	= 1 << 0,
+	ARM_SPE_OP_LDST		= 1 << 1,
+	ARM_SPE_OP_BRANCH_ERET	= 1 << 2,
+
+	/* Second level operation type for OTHER */
+	ARM_SPE_OP_SVE_OTHER		= 1 << 16,
+	ARM_SPE_OP_SVE_FP		= 1 << 17,
+	ARM_SPE_OP_SVE_PRED_OTHER	= 1 << 18,
+
+	/* Second level operation type for LDST */
+	ARM_SPE_OP_LD			= 1 << 16,
+	ARM_SPE_OP_ST			= 1 << 17,
+	ARM_SPE_OP_ATOMIC		= 1 << 18,
+	ARM_SPE_OP_EXCL			= 1 << 19,
+	ARM_SPE_OP_AR			= 1 << 20,
+	ARM_SPE_OP_SIMD_FP		= 1 << 21,
+	ARM_SPE_OP_GP_REG		= 1 << 22,
+	ARM_SPE_OP_UNSPEC_REG		= 1 << 23,
+	ARM_SPE_OP_NV_SYSREG		= 1 << 24,
+	ARM_SPE_OP_SVE_LDST		= 1 << 25,
+	ARM_SPE_OP_SVE_PRED_LDST	= 1 << 26,
+	ARM_SPE_OP_SVE_SG		= 1 << 27,
+
+	/* Second level operation type for BRANCH_ERET */
+	ARM_SPE_OP_BR_COND	= 1 << 16,
+	ARM_SPE_OP_BR_INDIRECT	= 1 << 17,
 };
 
 enum arm_spe_neoverse_data_source {
diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 2d7fc2b01f36b..c86e60b5954c5 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -336,7 +336,7 @@ static void arm_spe__synth_data_source_neoverse(const struct arm_spe_record *rec
 	 * We have no data on the hit level or data source for stores in the
 	 * Neoverse SPE records.
 	 */
-	if (record->op & ARM_SPE_ST) {
+	if (record->op & ARM_SPE_OP_ST) {
 		data_src->mem_lvl = PERF_MEM_LVL_NA;
 		data_src->mem_lvl_num = PERF_MEM_LVLNUM_NA;
 		data_src->mem_snoop = PERF_MEM_SNOOP_NA;
@@ -422,12 +422,12 @@ static void arm_spe__synth_data_source_generic(const struct arm_spe_record *reco
 
 static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 midr)
 {
-	union perf_mem_data_src	data_src = { 0 };
+	union perf_mem_data_src	data_src = { .mem_op = PERF_MEM_OP_NA };
 	bool is_neoverse = is_midr_in_range_list(midr, neoverse_spe);
 
-	if (record->op == ARM_SPE_LD)
+	if (record->op & ARM_SPE_OP_LD)
 		data_src.mem_op = PERF_MEM_OP_LOAD;
-	else if (record->op == ARM_SPE_ST)
+	else if (record->op & ARM_SPE_OP_ST)
 		data_src.mem_op = PERF_MEM_OP_STORE;
 	else
 		return 0;
-- 
2.51.0



