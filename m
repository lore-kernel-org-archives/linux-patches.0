Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DB8388890;
	Tue, 21 Jul 2026 19:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662765; cv=none; b=Wn/yGLV2bMdQDuaJjZLgkRZu3ImosyEIDlOV4cGvt9fNXiPcAy6vzv4zmsjRs6de2biGE7TFVt10H5UI0aYi8clbdlLMOEqm7KqWxU754lJjcVHTE9UcvuD8gfW03MEig3RwxCeFlkzoM/fjM2tMolNgCSj1eqtaur/W6fAn8+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662765; c=relaxed/simple;
	bh=ulsA9YSQcnjxpV0cGvlsFTMEYH44Qv+8MDCs16ZBI4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VK6O4AhLa1ZkaNj81uWFtMhRvB613LKql2wbl1qejsm8r4nttkNsBCvJ1PvWqlilXJmiUcKU69Sru1/SEwicUyvE1ETuDlNr0ruigwxfjr/QKtL2bNGhvyTdKRFe5yhputnMv/lYxQb5UUwISxPNCKpa/zOnUksfoL+pJsIfu74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0NH40BF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0NH40BF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD261F000E9;
	Tue, 21 Jul 2026 19:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662764;
	bh=t++s21FS1+1hrHXM4Abzxta9Ss/B1mEAAnB/DiGmp0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0NH40BFgXW94u0fq7eAlLy22ebhQed76MFfNSBPs3/qp9qtXm+ecty6ib5xWXAsn
	 vHlJdoeXCT5XI9CQiRps2wHQqsalq+lSEvrK4uZlPCnimCCRqedPzGxIgbP4T+Lmgq
	 HrWb0CMRH3E8i0SKui/cj1EEjnqPMulYSggTAslw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@arm.com>,
	Leo Yan <leo.yan@linaro.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0569/1276] perf cs-etm: Bounds-check CPU in cs_etm__get_queue()
Date: Tue, 21 Jul 2026 17:16:52 +0200
Message-ID: <20260721152458.850050585@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 9a989e60cc6e29d98aed2087425cba53bf4b392d ]

cs_etm__get_queue() indexes etm->queues.queue_array[cpu] without
validating that cpu is within nr_queues.  When processing
AUX_OUTPUT_HW_ID events, the cpu value comes from untrusted perf.data
trace payload and flows through cs_etm__process_trace_id_v0_1() and
cs_etm__queue_aux_fragment() without bounds checking, allowing an
out-of-bounds read with a crafted file.

Add a bounds check in cs_etm__get_queue() and NULL checks in all
callers.

Also add NULL checks for queue_array[i].priv in the queue iteration
loops in cs_etm__map_trace_id_v0() and cs_etm__process_trace_id_v0_1()
— after auxtrace_queues__grow() new entries are zero-initialized so
.priv can be NULL.  Add a get_cpu_data() NULL check in
cs_etm__process_trace_id_v0_1(), matching the existing check in
cs_etm__process_trace_id_v0().

Fixes: 77c123f53e97ad4b ("perf: cs-etm: Move traceid_list to each queue")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 9e12084f66099f..36e9e6dc9b526a 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -292,8 +292,11 @@ static struct cs_etm_queue *cs_etm__get_queue(struct cs_etm_auxtrace *etm, int c
 {
 	if (etm->per_thread_decoding)
 		return etm->queues.queue_array[0].priv;
-	else
-		return etm->queues.queue_array[cpu].priv;
+
+	if (cpu < 0 || cpu >= (int)etm->queues.nr_queues)
+		return NULL;
+
+	return etm->queues.queue_array[cpu].priv;
 }
 
 static int cs_etm__map_trace_id_v0(struct cs_etm_auxtrace *etm, u8 trace_chan_id,
@@ -306,6 +309,9 @@ static int cs_etm__map_trace_id_v0(struct cs_etm_auxtrace *etm, u8 trace_chan_id
 	 * queue associated with that CPU so only one decoder is made.
 	 */
 	etmq = cs_etm__get_queue(etm, cpu_metadata[CS_ETM_CPU]);
+	if (!etmq)
+		return -EINVAL;
+
 	if (etmq->format == UNFORMATTED)
 		return cs_etm__insert_trace_id_node(etmq, trace_chan_id,
 						    cpu_metadata);
@@ -318,6 +324,9 @@ static int cs_etm__map_trace_id_v0(struct cs_etm_auxtrace *etm, u8 trace_chan_id
 		int ret;
 
 		etmq = etm->queues.queue_array[i].priv;
+		if (!etmq)
+			continue;
+
 		ret = cs_etm__insert_trace_id_node(etmq, trace_chan_id,
 						   cpu_metadata);
 		if (ret)
@@ -358,6 +367,9 @@ static int cs_etm__process_trace_id_v0_1(struct cs_etm_auxtrace *etm, int cpu,
 	u32 sink_id = FIELD_GET(CS_AUX_HW_ID_SINK_ID_MASK, hw_id);
 	u8 trace_id = FIELD_GET(CS_AUX_HW_ID_TRACE_ID_MASK, hw_id);
 
+	if (!etmq)
+		return -EINVAL;
+
 	/*
 	 * Check sink id hasn't changed in per-cpu mode. In per-thread mode,
 	 * let it pass for now until an actual overlapping trace ID is hit. In
@@ -375,6 +387,9 @@ static int cs_etm__process_trace_id_v0_1(struct cs_etm_auxtrace *etm, int cpu,
 	for (unsigned int i = 0; i < etm->queues.nr_queues; ++i) {
 		struct cs_etm_queue *other_etmq = etm->queues.queue_array[i].priv;
 
+		if (!other_etmq)
+			continue;
+
 		/* Different sinks, skip */
 		if (other_etmq->sink_id != etmq->sink_id)
 			continue;
@@ -396,6 +411,9 @@ static int cs_etm__process_trace_id_v0_1(struct cs_etm_auxtrace *etm, int cpu,
 	}
 
 	cpu_data = get_cpu_data(etm, cpu);
+	if (!cpu_data)
+		return -EINVAL;
+
 	ret = cs_etm__insert_trace_id_node(etmq, trace_id, cpu_data);
 	if (ret)
 		return ret;
@@ -3146,6 +3164,9 @@ static int cs_etm__queue_aux_fragment(struct perf_session *session, off_t file_o
 	    aux_offset + aux_size <= auxtrace_event->offset + auxtrace_event->size) {
 		struct cs_etm_queue *etmq = etm->queues.queue_array[auxtrace_event->idx].priv;
 
+		if (!etmq)
+			return -EINVAL;
+
 		/*
 		 * If this AUX event was inside this buffer somewhere, create a new auxtrace event
 		 * based on the sizes of the aux event, and queue that fragment.
-- 
2.53.0



