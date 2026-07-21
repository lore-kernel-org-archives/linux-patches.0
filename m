Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E230C3B42EF;
	Tue, 21 Jul 2026 20:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666426; cv=none; b=LiqmuGL5G4WCzZWds4kX/LzDyuvQHbWSWL1UMTGYGBkBe0DzFj+ARxiybkPvoFyYbUWHSVfPOxMB7YGip3C1vg2Ft38gHkBALdDZ716LPLdLbEgMHBnuHdblhT+YFDMqm7Ht2qHFqhSHKCVfNbwymrLwQvxFF6EnZYPy/A9ncRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666426; c=relaxed/simple;
	bh=xJBTUhcZrCm0Ydpimqdmd6bxltf/4H/Ve3ULkAcfC24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WM/V4I4SEPNxIjPi35vDiHWyyIugFA22q+x8E0RxRCeyxp5wbANbC198AnbX0EysI8phXkHlvaI7mBbdLcCOFxsj/B+eQ8VzWPjRBpWQf5jMMli2SE4TVImDlGdr4yz0Lqoes3BXIULRDxwBW24Mu+7EQZ3yiyQOZ5XbziKRxOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zErBHtFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zErBHtFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF8F1F00A3A;
	Tue, 21 Jul 2026 20:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666424;
	bh=AcdEzncU3ftQKZf36FlokIZRDhmTqCouwvyYSKyfiQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zErBHtFfxz4VQbeq1GeY70lKAGGffRbNOGJPiulgWnVvaDknvDjBdhELUpgf4ODwt
	 7NuPTvpeKB1ouMMyRUT6IbrIXSltlKVFeQOk2Y2wQd3izCMQroie+AwHRDftOWc9bx
	 muLuz2ZsQcqwNSCWtt3mghEpD81+r8TMdqXaQNeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Besar Wicaksono <bwicaksono@nvidia.com>,
	James Clark <james.clark@arm.com>,
	suzuki.poulose@arm.com,
	mike.leach@linaro.org,
	jonathanh@nvidia.com,
	rwiley@nvidia.com,
	treding@nvidia.com,
	vsethi@nvidia.com,
	ywan@nvidia.com,
	linux-arm-kernel@lists.infradead.org,
	coresight@lists.linaro.org,
	linux-tegra@vger.kernel.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0677/1266] perf cs-etm: Fix incorrect or missing decoder for raw trace
Date: Tue, 21 Jul 2026 17:18:34 +0200
Message-ID: <20260721152457.005189941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Besar Wicaksono <bwicaksono@nvidia.com>

[ Upstream commit a16afcc58a8c5ebc65c852faf001f8f61f05e4ef ]

The decoder creation for raw trace uses metadata from the first CPU.
On per-cpu mode, this metadata is incorrectly used for every decoder.
On per-process/per-thread traces, the first CPU is CPU0. If CPU0 trace
is not enabled, its metadata will be marked unused and the decoder is
not created. Perf report dump skips the decoding part because the
decoder is missing.

To fix this, use metadata of the CPU associated with sample object.

Signed-off-by: Besar Wicaksono <bwicaksono@nvidia.com>
Reviewed-by: James Clark <james.clark@arm.com>
Cc: suzuki.poulose@arm.com
Cc: mike.leach@linaro.org
Cc: jonathanh@nvidia.com
Cc: rwiley@nvidia.com
Cc: treding@nvidia.com
Cc: vsethi@nvidia.com
Cc: ywan@nvidia.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: coresight@lists.linaro.org
Cc: linux-tegra@vger.kernel.org
Link: https://lore.kernel.org/r/20231010234803.5419-1-bwicaksono@nvidia.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 68ca50bc0fa6 ("perf cs-etm: Queue context packets for frontend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 106 ++++++++++++++++++++++++---------------
 1 file changed, 65 insertions(+), 41 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 799c104901b4ff..1fb104357eebb8 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -283,22 +283,31 @@ static int cs_etm__metadata_set_trace_id(u8 trace_chan_id, u64 *cpu_metadata)
 }
 
 /*
- * Get a metadata for a specific cpu from an array.
+ * Get a metadata index for a specific cpu from an array.
  *
  */
-static u64 *get_cpu_data(struct cs_etm_auxtrace *etm, int cpu)
+static int get_cpu_data_idx(struct cs_etm_auxtrace *etm, int cpu)
 {
 	int i;
-	u64 *metadata = NULL;
 
 	for (i = 0; i < etm->num_cpu; i++) {
 		if (etm->metadata[i][CS_ETM_CPU] == (u64)cpu) {
-			metadata = etm->metadata[i];
-			break;
+			return i;
 		}
 	}
 
-	return metadata;
+	return -1;
+}
+
+/*
+ * Get a metadata for a specific cpu from an array.
+ *
+ */
+static u64 *get_cpu_data(struct cs_etm_auxtrace *etm, int cpu)
+{
+	int idx = get_cpu_data_idx(etm, cpu);
+
+	return (idx != -1) ? etm->metadata[idx] : NULL;
 }
 
 /*
@@ -641,66 +650,80 @@ static void cs_etm__packet_dump(const char *pkt_string)
 }
 
 static void cs_etm__set_trace_param_etmv3(struct cs_etm_trace_params *t_params,
-					  struct cs_etm_auxtrace *etm, int idx,
-					  u32 etmidr)
+					  struct cs_etm_auxtrace *etm, int t_idx,
+					  int m_idx, u32 etmidr)
 {
 	u64 **metadata = etm->metadata;
 
-	t_params[idx].protocol = cs_etm__get_v7_protocol_version(etmidr);
-	t_params[idx].etmv3.reg_ctrl = metadata[idx][CS_ETM_ETMCR];
-	t_params[idx].etmv3.reg_trc_id = metadata[idx][CS_ETM_ETMTRACEIDR];
+	t_params[t_idx].protocol = cs_etm__get_v7_protocol_version(etmidr);
+	t_params[t_idx].etmv3.reg_ctrl = metadata[m_idx][CS_ETM_ETMCR];
+	t_params[t_idx].etmv3.reg_trc_id = metadata[m_idx][CS_ETM_ETMTRACEIDR];
 }
 
 static void cs_etm__set_trace_param_etmv4(struct cs_etm_trace_params *t_params,
-					  struct cs_etm_auxtrace *etm, int idx)
+					  struct cs_etm_auxtrace *etm, int t_idx,
+					  int m_idx)
 {
 	u64 **metadata = etm->metadata;
 
-	t_params[idx].protocol = CS_ETM_PROTO_ETMV4i;
-	t_params[idx].etmv4.reg_idr0 = metadata[idx][CS_ETMV4_TRCIDR0];
-	t_params[idx].etmv4.reg_idr1 = metadata[idx][CS_ETMV4_TRCIDR1];
-	t_params[idx].etmv4.reg_idr2 = metadata[idx][CS_ETMV4_TRCIDR2];
-	t_params[idx].etmv4.reg_idr8 = metadata[idx][CS_ETMV4_TRCIDR8];
-	t_params[idx].etmv4.reg_configr = metadata[idx][CS_ETMV4_TRCCONFIGR];
-	t_params[idx].etmv4.reg_traceidr = metadata[idx][CS_ETMV4_TRCTRACEIDR];
+	t_params[t_idx].protocol = CS_ETM_PROTO_ETMV4i;
+	t_params[t_idx].etmv4.reg_idr0 = metadata[m_idx][CS_ETMV4_TRCIDR0];
+	t_params[t_idx].etmv4.reg_idr1 = metadata[m_idx][CS_ETMV4_TRCIDR1];
+	t_params[t_idx].etmv4.reg_idr2 = metadata[m_idx][CS_ETMV4_TRCIDR2];
+	t_params[t_idx].etmv4.reg_idr8 = metadata[m_idx][CS_ETMV4_TRCIDR8];
+	t_params[t_idx].etmv4.reg_configr = metadata[m_idx][CS_ETMV4_TRCCONFIGR];
+	t_params[t_idx].etmv4.reg_traceidr = metadata[m_idx][CS_ETMV4_TRCTRACEIDR];
 }
 
 static void cs_etm__set_trace_param_ete(struct cs_etm_trace_params *t_params,
-					  struct cs_etm_auxtrace *etm, int idx)
+					  struct cs_etm_auxtrace *etm, int t_idx,
+					  int m_idx)
 {
 	u64 **metadata = etm->metadata;
 
-	t_params[idx].protocol = CS_ETM_PROTO_ETE;
-	t_params[idx].ete.reg_idr0 = metadata[idx][CS_ETE_TRCIDR0];
-	t_params[idx].ete.reg_idr1 = metadata[idx][CS_ETE_TRCIDR1];
-	t_params[idx].ete.reg_idr2 = metadata[idx][CS_ETE_TRCIDR2];
-	t_params[idx].ete.reg_idr8 = metadata[idx][CS_ETE_TRCIDR8];
-	t_params[idx].ete.reg_configr = metadata[idx][CS_ETE_TRCCONFIGR];
-	t_params[idx].ete.reg_traceidr = metadata[idx][CS_ETE_TRCTRACEIDR];
-	t_params[idx].ete.reg_devarch = metadata[idx][CS_ETE_TRCDEVARCH];
+	t_params[t_idx].protocol = CS_ETM_PROTO_ETE;
+	t_params[t_idx].ete.reg_idr0 = metadata[m_idx][CS_ETE_TRCIDR0];
+	t_params[t_idx].ete.reg_idr1 = metadata[m_idx][CS_ETE_TRCIDR1];
+	t_params[t_idx].ete.reg_idr2 = metadata[m_idx][CS_ETE_TRCIDR2];
+	t_params[t_idx].ete.reg_idr8 = metadata[m_idx][CS_ETE_TRCIDR8];
+	t_params[t_idx].ete.reg_configr = metadata[m_idx][CS_ETE_TRCCONFIGR];
+	t_params[t_idx].ete.reg_traceidr = metadata[m_idx][CS_ETE_TRCTRACEIDR];
+	t_params[t_idx].ete.reg_devarch = metadata[m_idx][CS_ETE_TRCDEVARCH];
 }
 
 static int cs_etm__init_trace_params(struct cs_etm_trace_params *t_params,
 				     struct cs_etm_auxtrace *etm,
+				     bool formatted,
+				     int sample_cpu,
 				     int decoders)
 {
-	int i;
+	int t_idx, m_idx;
 	u32 etmidr;
 	u64 architecture;
 
-	for (i = 0; i < decoders; i++) {
-		architecture = etm->metadata[i][CS_ETM_MAGIC];
+	for (t_idx = 0; t_idx < decoders; t_idx++) {
+		if (formatted)
+			m_idx = t_idx;
+		else {
+			m_idx = get_cpu_data_idx(etm, sample_cpu);
+			if (m_idx == -1) {
+				pr_warning("CS_ETM: unknown CPU, falling back to first metadata\n");
+				m_idx = 0;
+			}
+		}
+
+		architecture = etm->metadata[m_idx][CS_ETM_MAGIC];
 
 		switch (architecture) {
 		case __perf_cs_etmv3_magic:
-			etmidr = etm->metadata[i][CS_ETM_ETMIDR];
-			cs_etm__set_trace_param_etmv3(t_params, etm, i, etmidr);
+			etmidr = etm->metadata[m_idx][CS_ETM_ETMIDR];
+			cs_etm__set_trace_param_etmv3(t_params, etm, t_idx, m_idx, etmidr);
 			break;
 		case __perf_cs_etmv4_magic:
-			cs_etm__set_trace_param_etmv4(t_params, etm, i);
+			cs_etm__set_trace_param_etmv4(t_params, etm, t_idx, m_idx);
 			break;
 		case __perf_cs_ete_magic:
-			cs_etm__set_trace_param_ete(t_params, etm, i);
+			cs_etm__set_trace_param_ete(t_params, etm, t_idx, m_idx);
 			break;
 		default:
 			return -EINVAL;
@@ -1016,7 +1039,7 @@ static u32 cs_etm__mem_access(struct cs_etm_queue *etmq, u8 trace_chan_id,
 }
 
 static struct cs_etm_queue *cs_etm__alloc_queue(struct cs_etm_auxtrace *etm,
-						bool formatted)
+						bool formatted, int sample_cpu)
 {
 	struct cs_etm_decoder_params d_params;
 	struct cs_etm_trace_params  *t_params = NULL;
@@ -1041,7 +1064,7 @@ static struct cs_etm_queue *cs_etm__alloc_queue(struct cs_etm_auxtrace *etm,
 	if (!t_params)
 		goto out_free;
 
-	if (cs_etm__init_trace_params(t_params, etm, decoders))
+	if (cs_etm__init_trace_params(t_params, etm, formatted, sample_cpu, decoders))
 		goto out_free;
 
 	/* Set decoder parameters to decode trace packets */
@@ -1081,14 +1104,15 @@ static struct cs_etm_queue *cs_etm__alloc_queue(struct cs_etm_auxtrace *etm,
 static int cs_etm__setup_queue(struct cs_etm_auxtrace *etm,
 			       struct auxtrace_queue *queue,
 			       unsigned int queue_nr,
-			       bool formatted)
+			       bool formatted,
+			       int sample_cpu)
 {
 	struct cs_etm_queue *etmq = queue->priv;
 
 	if (list_empty(&queue->head) || etmq)
 		return 0;
 
-	etmq = cs_etm__alloc_queue(etm, formatted);
+	etmq = cs_etm__alloc_queue(etm, formatted, sample_cpu);
 
 	if (!etmq)
 		return -ENOMEM;
@@ -2827,7 +2851,7 @@ static int cs_etm__process_auxtrace_event(struct perf_session *session,
 		 * formatted in piped mode (true).
 		 */
 		err = cs_etm__setup_queue(etm, &etm->queues.queue_array[idx],
-					  idx, true);
+					  idx, true, -1);
 		if (err)
 			return err;
 
@@ -3033,7 +3057,7 @@ static int cs_etm__queue_aux_fragment(struct perf_session *session, off_t file_o
 		idx = auxtrace_event->idx;
 		formatted = !(aux_event->flags & PERF_AUX_FLAG_CORESIGHT_FORMAT_RAW);
 		return cs_etm__setup_queue(etm, &etm->queues.queue_array[idx],
-					   idx, formatted);
+					   idx, formatted, sample->cpu);
 	}
 
 	/* Wasn't inside this buffer, but there were no parse errors. 1 == 'not found' */
-- 
2.53.0



