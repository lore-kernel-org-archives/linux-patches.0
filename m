Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48B126A09F;
	Tue,  8 Apr 2025 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116656; cv=none; b=M8DDZfy3QtofC0QVQ2HQmLhgX1fiJZrYfigEBbMBoPqsgVMmSasCQy6xXNEikC0ukhb+FvaMeZN464671rAhqB0dQwQdgqViCUPOA/DabcgCqU8occieHdPyrVtoLURAt9ubXAIs7wL4N5tGFNbGy/jOtGYnnJN5G52ra7lSujU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116656; c=relaxed/simple;
	bh=aPDPSS4GIZG+MhZvhp3uK26fcf9GjGbqXtZKqw6wWVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnFPB8EisgiBxxRuPNl30NvNT4aJbR4sdg642otIomP1+7G//xRpeth+W/CeUaGsKy9cwd5RtWrCmCezrWHUb+jf1f8lPRQ5GBr7rTF12t2vska9Wxfrzdsa0FYDYLi+JyOzLY+nmiYztnMumlVkzsYLQCCxJvJFlHYIysioA/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjAG1uNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjAG1uNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9D5C4CEE5;
	Tue,  8 Apr 2025 12:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116655;
	bh=aPDPSS4GIZG+MhZvhp3uK26fcf9GjGbqXtZKqw6wWVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjAG1uNp/S5ixOpxF+o3CFqZQRrUfTKRQRy3kSO7N1O6Tp2N/vh3DV9IEoDehdzpm
	 /QTd0eqZ8lgo+NZJt99y4zxtLKoio32+cS6ZhEHEnJXQaOxTTq9fv0bvPIBQYOP885
	 EwR7eUXF6hw5t/UiNy1RWQIAn999gjczzVJ7HLh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/423] perf arm-spe: Fix load-store operation checking
Date: Tue,  8 Apr 2025 12:48:27 +0200
Message-ID: <20250408104849.957416991@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 138ffc71b32dd..2c06f2a85400e 100644
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
@@ -520,6 +522,10 @@ static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 m
 	union perf_mem_data_src	data_src = { .mem_op = PERF_MEM_OP_NA };
 	bool is_neoverse = is_midr_in_range_list(midr, neoverse_spe);
 
+	/* Only synthesize data source for LDST operations */
+	if (!is_ldst_op(record->op))
+		return 0;
+
 	if (record->op & ARM_SPE_OP_LD)
 		data_src.mem_op = PERF_MEM_OP_LOAD;
 	else if (record->op & ARM_SPE_OP_ST)
@@ -619,7 +625,7 @@ static int arm_spe_sample(struct arm_spe_queue *speq)
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



