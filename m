Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD09C388890;
	Tue, 21 Jul 2026 19:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662403; cv=none; b=JACYu6glemY9ZhC6ou2oO8Y9fPdKmjTIL0zdOz8l4IONenvOXVSWxOXe+tpPyr8utYr4pOdoM/fiAqCQRf69tknht7meS4w/xGuI/8qITSHm1qwGddJiXOxJmorTmIzo41J4+1tzvu/7VdhLnN0XuQvOdDmPseKsZvU56EnVY4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662403; c=relaxed/simple;
	bh=qjAz5cD9nadZL89r+wHrBunAGg6dhMM4jzlMEsx0IL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5UTXmMzb0QrRS5RO5ObdCp50jTSvit7Qms64hbUZ03NoMhIelgG6W8fiHgkVYFtjhtTEr5HJ2YUNAMNjG2kIhuADZJniRzybVjOsqNVyBIbUKHTIGnStfTv5bo1/btYb8IcYUZz4KF6lAnoKnDzaP/IS+PfUJldPMjGttdXt4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhsII0fj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhsII0fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED451F000E9;
	Tue, 21 Jul 2026 19:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662401;
	bh=LDRvdH2HWRDA+Oss5iYV/DmBQw22+ur9gNXL8108bmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhsII0fjqW8nIYApb/TXexbz6+XlNvbLpfeOr7z3QUsa8JExuRdyWzTs88KMn7YSN
	 5ST/IEsCrMLoKg2izQos7Ww3l2SHuR2kQQOxiEH6vtpKNBuXu8AGVTqv7jsOMK8unl
	 IArUOgk38GhpcosNqgwMEER8D2gcvk2+9T1qrWcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0432/1276] perf arm-spe: Use metadata to decide the data source feature
Date: Tue, 21 Jul 2026 17:14:35 +0200
Message-ID: <20260721152455.769878665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit ba5e7169e5483a61899497e23fa18f7ef33aa827 ]

Use the info in the metadata to decide if the data source feature is
supported. The CPU MIDR must be in the CPU list for the common data
source encoding.

For the metadata version 1, it doesn't include info for MIDR. In this
case, due to absent info for making decision, print out warning to
remind users to upgrade tool and returns false.

Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20241003185322.192357-5-leo.yan@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 059e9100d82a ("perf event: Fix size of synthesized sample with branch stacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 67 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 9890b17241c34a..fcacdd87c0d2b4 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -275,6 +275,20 @@ static int arm_spe_set_tid(struct arm_spe_queue *speq, pid_t tid)
 	return 0;
 }
 
+static u64 *arm_spe__get_metadata_by_cpu(struct arm_spe *spe, u64 cpu)
+{
+	u64 i;
+
+	if (!spe->metadata)
+		return NULL;
+
+	for (i = 0; i < spe->metadata_nr_cpu; i++)
+		if (spe->metadata[i][ARM_SPE_CPU] == cpu)
+			return spe->metadata[i];
+
+	return NULL;
+}
+
 static struct simd_flags arm_spe__synth_simd_flags(const struct arm_spe_record *record)
 {
 	struct simd_flags simd_flags = {};
@@ -517,10 +531,57 @@ static void arm_spe__synth_data_source_generic(const struct arm_spe_record *reco
 		data_src->mem_remote = PERF_MEM_REMOTE_REMOTE;
 }
 
-static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 midr)
+static bool arm_spe__is_common_ds_encoding(struct arm_spe_queue *speq)
+{
+	struct arm_spe *spe = speq->spe;
+	bool is_in_cpu_list;
+	u64 *metadata = NULL;
+	u64 midr = 0;
+
+	/*
+	 * Metadata version 1 doesn't contain any info for MIDR.
+	 * Simply return false in this case.
+	 */
+	if (spe->metadata_ver == 1) {
+		pr_warning_once("The data file contains metadata version 1, "
+				"which is absent the info for data source. "
+				"Please upgrade the tool to record data.\n");
+		return false;
+	}
+
+	/* CPU ID is -1 for per-thread mode */
+	if (speq->cpu < 0) {
+		/*
+		 * On the heterogeneous system, due to CPU ID is -1,
+		 * cannot confirm the data source packet is supported.
+		 */
+		if (!spe->is_homogeneous)
+			return false;
+
+		/* In homogeneous system, simply use CPU0's metadata */
+		if (spe->metadata)
+			metadata = spe->metadata[0];
+	} else {
+		metadata = arm_spe__get_metadata_by_cpu(spe, speq->cpu);
+	}
+
+	if (!metadata)
+		return false;
+
+	midr = metadata[ARM_SPE_CPU_MIDR];
+
+	is_in_cpu_list = is_midr_in_range_list(midr, common_ds_encoding_cpus);
+	if (is_in_cpu_list)
+		return true;
+	else
+		return false;
+}
+
+static u64 arm_spe__synth_data_source(struct arm_spe_queue *speq,
+				      const struct arm_spe_record *record)
 {
 	union perf_mem_data_src	data_src = { .mem_op = PERF_MEM_OP_NA };
-	bool is_common = is_midr_in_range_list(midr, common_ds_encoding_cpus);
+	bool is_common = arm_spe__is_common_ds_encoding(speq);
 
 	/* Only synthesize data source for LDST operations */
 	if (!is_ldst_op(record->op))
@@ -557,7 +618,7 @@ static int arm_spe_sample(struct arm_spe_queue *speq)
 	u64 data_src;
 	int err;
 
-	data_src = arm_spe__synth_data_source(record, spe->midr);
+	data_src = arm_spe__synth_data_source(speq, record);
 
 	if (spe->sample_flc) {
 		if (record->type & ARM_SPE_L1D_MISS) {
-- 
2.53.0



