Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDDE35E93B;
	Sat, 17 Oct 2026 18:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260349; cv=none; b=TGCOO/hW5L0Gh5Uva2UDccdruRWm4b+JwHKPR3M7x9Ll/ta6Tv4XZxJ6UdhKOrSf4j9IiDPxFuHqfU3Heb1LPlYkYSgcvGlyJR6vl77bJB4wE+oSmma6qGYjq5ah4Hi9SUk2RSA1tvw2zBvhmKN/v1e6q3pnp9zuGE6j82rxpXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260349; c=relaxed/simple;
	bh=cY//FTYtqZRuzb7slawNegUS//1MOrMW4Eq40sWkt3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xsfx9hAPYWInhjfQvhjMW4P5kB2dgak89MszwMhJ8hmUWw2DmPZ99nSyGpfmXk/of67TudMRn8xI9QIIv0/2pRMPwPjAgFxtgDqNd8Mjs2pvJ92SNvVx+VMOoNIcrQJ/YjgW3r9ZC77AdEGODvVborveSWkh7Rx4e1MAkkO74BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0ddtkgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0ddtkgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DC11F000C4;
	Sat, 17 Oct 2026 18:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260347;
	bh=hX/3pg9Pr3adTRXWn3sIWX/7P/v9zL5LlsMiW9lB+PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0ddtkgJlyBX1K4/4dVLCIxFZOpk24A29SqTD4eEUXKeJ5xr+9MS1QzKdSfRpTu79
	 cqWKYUwVBDo0fJHu2C9iJXrmNRgRqyyRnZPlao0tUTP/fSEC799thqRA1P6pMGt+cM
	 DBY3mfENEgo0TAZKD2FZ7A69hJI0MAvCo1d8sTpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yi Lai <yi1.lai@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1515/1674] perf/x86/intel/pt: Fix stop/start with no update
Date: Sat, 17 Oct 2026 18:03:07 +0200
Message-ID: <20261017160510.008608161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 2e17bf3a469a41457a3bc31b1f8fd66b6ce94a6d ]

If pt_event_stop() is called without PERF_EF_UPDATE flag, then
perf_aux_output_end() is not called.  A subsequent call to pt_event_start()
will call perf_aux_output_begin() again which violates the rule against
nesting and triggers a WARNING in perf_aux_output_begin().

Originally, pt_event_stop() was never called without PERF_EF_UPDATE,
because the only code paths to do so are from event overflow, and Intel PT
does not do that.

However the introduction of group throttling by commit 9734e25fbf5ae
("perf: Fix the throttle logic for a group") meant that an Intel PT event
could be throttled if it was part of a group.  Throttling calls PMU
 ->stop() / ->start() callbacks without flags.

An example is when AUX area sampling is used. The following commands
hit the issue:

  echo 10000 > /proc/sys/kernel/perf_event_max_sample_rate

  perf record -F32000 --aux-sample -e '{intel_pt//u,cycles:u}' \
  -- bash -c 'for i in `seq 1 100000` ; do true ; done'

Use PERF_HES_UPTODATE to track whether perf_aux_output_begin() and
perf_aux_output_end() are balanced.  A cleared PERF_HES_UPTODATE bit
indicates that an AUX output context is still open.

Amend pt_event_start() / pt_event_stop() accordingly so that begin/end
stay balanced:

 - In non-snapshot mode, stop() always closes the buffer (the buffer may
   have run out of space, and that accounting is done by the update), so
   a following start() opens a fresh one as before.

 - In snapshot/overwrite mode, stop() without PERF_EF_UPDATE leaves the
   buffer open so that pt_event_snapshot_aux() can still copy from it,
   and start() then only re-enables tracing instead of calling
   perf_aux_output_begin() again.

Note that pt_event_del() calls pt_event_stop() with PERF_EF_UPDATE flag set
(as is required by the documentation), so a final call to
perf_aux_output_end() is assured.

Fixes: 52ca9ced3f707 ("perf/x86/intel/pt: Add Intel PT PMU driver")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Yi Lai <yi1.lai@intel.com>
Link: https://patch.msgid.link/20260721070254.13557-4-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 56 ++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 7ee8dc80a3593..57ed4e052167a 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1506,12 +1506,14 @@ void intel_pt_interrupt(void)
 
 	perf_aux_output_end(&pt->handle, local_xchg(&buf->data_size, 0));
 
-	if (!event->hw.state) {
+	event->hw.state |= PERF_HES_UPTODATE;
+
+	if (!(event->hw.state & PERF_HES_STOPPED)) {
 		int ret;
 
 		buf = perf_aux_output_begin(&pt->handle, event);
 		if (!buf) {
-			event->hw.state = PERF_HES_STOPPED;
+			event->hw.state |= PERF_HES_STOPPED;
 			return;
 		}
 
@@ -1525,6 +1527,8 @@ void intel_pt_interrupt(void)
 
 		pt_config_buffer(buf);
 		pt_config_start(event);
+
+		event->hw.state &= ~PERF_HES_UPTODATE;
 	}
 }
 
@@ -1574,6 +1578,19 @@ static void pt_event_start(struct perf_event *event, int mode)
 	struct pt *pt = this_cpu_ptr(&pt_ctx);
 	struct pt_buffer *buf;
 
+	/*
+	 * Re-start subsequent to a call to pt_event_stop() without the
+	 * PERF_EF_UPDATE flag. Absence of PERF_HES_UPTODATE indicates that
+	 * perf_aux_output_begin() has already been called. This path can
+	 * come about only in snapshot/overwrite mode - see pt_event_stop().
+	 */
+	if (!(hwc->state & PERF_HES_UPTODATE)) {
+		hwc->state &= ~PERF_HES_STOPPED;
+		WRITE_ONCE(pt->handle_nmi, 1);
+		pt_config_start(event);
+		return;
+	}
+
 	buf = perf_aux_output_begin(&pt->handle, event);
 	if (!buf)
 		goto fail_stop;
@@ -1585,7 +1602,7 @@ static void pt_event_start(struct perf_event *event, int mode)
 	}
 
 	WRITE_ONCE(pt->handle_nmi, 1);
-	hwc->state = 0;
+	hwc->state &= ~(PERF_HES_STOPPED | PERF_HES_UPTODATE);
 
 	pt_config_buffer(buf);
 	pt_config(event);
@@ -1595,12 +1612,13 @@ static void pt_event_start(struct perf_event *event, int mode)
 fail_end_stop:
 	perf_aux_output_end(&pt->handle, 0);
 fail_stop:
-	hwc->state = PERF_HES_STOPPED;
+	hwc->state |= PERF_HES_STOPPED | PERF_HES_UPTODATE;
 }
 
 static void pt_event_stop(struct perf_event *event, int mode)
 {
 	struct pt *pt = this_cpu_ptr(&pt_ctx);
+	struct pt_buffer *buf;
 
 	/*
 	 * Protect against the PMI racing with disabling wrmsr,
@@ -1611,17 +1629,24 @@ static void pt_event_stop(struct perf_event *event, int mode)
 
 	pt_config_stop(event);
 
-	if (event->hw.state == PERF_HES_STOPPED)
-		return;
+	event->hw.state |= PERF_HES_STOPPED;
 
-	event->hw.state = PERF_HES_STOPPED;
-
-	if (mode & PERF_EF_UPDATE) {
-		struct pt_buffer *buf = perf_get_aux(&pt->handle);
+	if (event->hw.state & PERF_HES_UPTODATE)
+		return;
 
-		if (!buf)
-			return;
+	buf = perf_get_aux(&pt->handle);
+	if (!buf)
+		return;
 
+	/*
+	 * When not in snapshot/overwrite mode, there is a possibility that the
+	 * buffer has run out of space. The accounting for that is handled by
+	 * the update, so always update in that case. Snapshot/overwrite mode is
+	 * treated differently to allow for pt_event_snapshot_aux() which can
+	 * still get called if the AUX-sampling event is not stopped until after
+	 * PT is stopped.
+	 */
+	if ((mode & PERF_EF_UPDATE) || !buf->snapshot) {
 		if (WARN_ON_ONCE(pt->handle.event != event))
 			return;
 
@@ -1636,6 +1661,7 @@ static void pt_event_stop(struct perf_event *event, int mode)
 				local_xchg(&buf->data_size,
 					   buf->nr_pages << PAGE_SHIFT);
 		perf_aux_output_end(&pt->handle, local_xchg(&buf->data_size, 0));
+		event->hw.state |= PERF_HES_UPTODATE;
 	}
 }
 
@@ -1697,13 +1723,15 @@ static int pt_event_add(struct perf_event *event, int mode)
 	if (pt->handle.event)
 		goto fail;
 
+	event->hw.state |= PERF_HES_UPTODATE;
+
 	if (mode & PERF_EF_START) {
 		pt_event_start(event, 0);
 		ret = -EINVAL;
-		if (hwc->state == PERF_HES_STOPPED)
+		if (hwc->state & PERF_HES_STOPPED)
 			goto fail;
 	} else {
-		hwc->state = PERF_HES_STOPPED;
+		hwc->state |= PERF_HES_STOPPED;
 	}
 
 	ret = 0;
-- 
2.53.0



