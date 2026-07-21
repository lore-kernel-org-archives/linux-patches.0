Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1027D47125D;
	Tue, 21 Jul 2026 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657525; cv=none; b=OLGEljnrYY4S2NKJcusX63kCpkY2yPV/crn3WDS8EmYCH7cQRrRjIIzqdscFLvQ1G0v8+zdbbG0aNOENmaV2+dAydULE/FsvzyGIiGuG4reXQDUS9IR+BRv/uJkhRmJEgCYZIWoj5xi6wmFntX+8Ccd/6CK2Kk9bcy4Eaizxnvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657525; c=relaxed/simple;
	bh=ZKQ/eFOumwoOJdt1zOWVJYh0IcDpX+kdT2QXfdJPsi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hrNeDU8MuJP7QBnrmJlNyR31wfV17NHv00SPRlY81h6Zod1sloDirrTnuhkhXuSFzJEvI7KZ0btRyowxTFtoSBRSROlhFthKRh0/UI5S7LHOVkMjH8MLN2/gPCtAj4M5DmIteEGAos2stqBi50c2itXcuSP/jSJ71y7r2LoCvSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRSf8P6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRSf8P6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278A51F000E9;
	Tue, 21 Jul 2026 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657523;
	bh=BZkb6Z6CVT3tNs1YxvxSpqD/ki6+lUmSKCrGkhpD7dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRSf8P6h8WK0GlKTDC5mZSVwmrTxdeShywFU57QMZCvST2fqI9kxg74O3bXHqpAFw
	 9+H4RFtYuxYg9gyCa5JOS8mO9GafrdCif3TomGBj/BT2Ab2i/HuCGy9ZVqsq1BroTc
	 jcQVKLTmYfrP0V5zUriJYAGQT7BIRYgGuJm7yryE=
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
Subject: [PATCH 6.18 0798/1611] perf cs-etm: Bounds-check CPU in cs_etm__get_queue()
Date: Tue, 21 Jul 2026 17:15:14 +0200
Message-ID: <20260721152533.336337735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f2ea3cbea0fdfe..7a3c122fbcaebc 100644
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
@@ -3155,6 +3173,9 @@ static int cs_etm__queue_aux_fragment(struct perf_session *session, off_t file_o
 	    aux_offset + aux_size <= auxtrace_event->offset + auxtrace_event->size) {
 		struct cs_etm_queue *etmq = cs_etm__get_queue(etm, auxtrace_event->cpu);
 
+		if (!etmq)
+			return -EINVAL;
+
 		/*
 		 * If this AUX event was inside this buffer somewhere, create a new auxtrace event
 		 * based on the sizes of the aux event, and queue that fragment.
-- 
2.53.0



