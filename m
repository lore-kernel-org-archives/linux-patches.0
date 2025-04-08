Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFC0268C65;
	Tue,  8 Apr 2025 11:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111764; cv=none; b=k4A/mp486AIptlVL82Dtx8/7bT5xF8VVU2xEc0AGgu7b0qjJ0/r9sQTVS+Yt5v06hhw+fiNyIpeiUC0GA4a/opxgEZUUpPI11jfHG+iB6VjuuzEqbiWFZGBGW+Ba1NwWYuapm1xRGQPQ2JaIj4xCNDRbX56yqrGXTMrAwojH/zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111764; c=relaxed/simple;
	bh=87iV5ymvT40tGSqam+Jc3oqE7iXFnNUT/WeWZ5cq65I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0GCsI5kqLv0gg5UEfRKQRlkhB12cW+Lw6MMcFyo+t/8wioGxrRF38daNNFKqyZum0h8XkxZDIuJSgS9Qtv8TpkFlXT3Zlnp62DGexkp2nZoIe8au5OzOqH52+/rPiE1/vComCAFmS/U03S3qVh34D6oPLGmhxPMa8fdOhquebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yx74MhMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yx74MhMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52328C4CEE5;
	Tue,  8 Apr 2025 11:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111764;
	bh=87iV5ymvT40tGSqam+Jc3oqE7iXFnNUT/WeWZ5cq65I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yx74MhMdanM3NmxUjDFVfTkXi8baCRkimlC+uteiMzFsY57eBiKALyi+IKHKSi8y2
	 7rH5WJdOhPj13dDLUssLrUGF8pVVAHTB4HoH0FZRghSurvTXAQOPNiBARZz158FaDJ
	 eDQM+/9d9ZN6xP0oVy7bN/xzOFfonV1dU4VLQV10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jan Kara <jack@suse.cz>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 512/731] writeback: let trace_balance_dirty_pages() take struct dtc as parameter
Date: Tue,  8 Apr 2025 12:46:49 +0200
Message-ID: <20250408104926.184904964@linuxfoundation.org>
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

From: Tang Yizhou <yizhou.tang@shopee.com>

[ Upstream commit f1ab2831e2a4312046bca79256b2efc41d373eaf ]

Patch series "Fix calculations in trace_balance_dirty_pages() for cgwb", v2.

In my experiment, I found that the output of trace_balance_dirty_pages()
in the cgroup writeback scenario was strange because
trace_balance_dirty_pages() always uses global_wb_domain.dirty_limit for
related calculations instead of the dirty_limit of the corresponding
memcg's wb_domain.

The basic idea of the fix is to store the hard dirty limit value computed
in wb_position_ratio() into struct dirty_throttle_control and use it for
calculations in trace_balance_dirty_pages().

This patch (of 3):

Currently, trace_balance_dirty_pages() already has 12 parameters.  In the
patch #3, I initially attempted to introduce an additional parameter.
However, in include/linux/trace_events.h, bpf_trace_run12() only supports
up to 12 parameters and bpf_trace_run13() does not exist.

To reduce the number of parameters in trace_balance_dirty_pages(), we can
make it accept a pointer to struct dirty_throttle_control as a parameter.
To achieve this, we need to move the definition of struct
dirty_throttle_control from mm/page-writeback.c to
include/linux/writeback.h.

Link: https://lkml.kernel.org/r/20250304110318.159567-1-yizhou.tang@shopee.com
Link: https://lkml.kernel.org/r/20250304110318.159567-2-yizhou.tang@shopee.com
Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Tang Yizhou <yizhou.tang@shopee.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 6cc4c3aa714b ("writeback: fix calculations in trace_balance_dirty_pages() for cgwb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/writeback.h        | 23 +++++++++++++++++++++
 include/trace/events/writeback.h | 16 ++++++---------
 mm/page-writeback.c              | 35 ++------------------------------
 3 files changed, 31 insertions(+), 43 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index d11b903c2edb8..32095928365ce 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -313,6 +313,29 @@ static inline void cgroup_writeback_umount(struct super_block *sb)
 /*
  * mm/page-writeback.c
  */
+/* consolidated parameters for balance_dirty_pages() and its subroutines */
+struct dirty_throttle_control {
+#ifdef CONFIG_CGROUP_WRITEBACK
+	struct wb_domain	*dom;
+	struct dirty_throttle_control *gdtc;	/* only set in memcg dtc's */
+#endif
+	struct bdi_writeback	*wb;
+	struct fprop_local_percpu *wb_completions;
+
+	unsigned long		avail;		/* dirtyable */
+	unsigned long		dirty;		/* file_dirty + write + nfs */
+	unsigned long		thresh;		/* dirty threshold */
+	unsigned long		bg_thresh;	/* dirty background threshold */
+
+	unsigned long		wb_dirty;	/* per-wb counterparts */
+	unsigned long		wb_thresh;
+	unsigned long		wb_bg_thresh;
+
+	unsigned long		pos_ratio;
+	bool			freerun;
+	bool			dirty_exceeded;
+};
+
 void laptop_io_completion(struct backing_dev_info *info);
 void laptop_sync_completion(void);
 void laptop_mode_timer_fn(struct timer_list *t);
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index a261e86e61fac..3213b90237944 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -629,11 +629,7 @@ TRACE_EVENT(bdi_dirty_ratelimit,
 TRACE_EVENT(balance_dirty_pages,
 
 	TP_PROTO(struct bdi_writeback *wb,
-		 unsigned long thresh,
-		 unsigned long bg_thresh,
-		 unsigned long dirty,
-		 unsigned long bdi_thresh,
-		 unsigned long bdi_dirty,
+		 struct dirty_throttle_control *dtc,
 		 unsigned long dirty_ratelimit,
 		 unsigned long task_ratelimit,
 		 unsigned long dirtied,
@@ -641,7 +637,7 @@ TRACE_EVENT(balance_dirty_pages,
 		 long pause,
 		 unsigned long start_time),
 
-	TP_ARGS(wb, thresh, bg_thresh, dirty, bdi_thresh, bdi_dirty,
+	TP_ARGS(wb, dtc,
 		dirty_ratelimit, task_ratelimit,
 		dirtied, period, pause, start_time),
 
@@ -664,16 +660,16 @@ TRACE_EVENT(balance_dirty_pages,
 	),
 
 	TP_fast_assign(
-		unsigned long freerun = (thresh + bg_thresh) / 2;
+		unsigned long freerun = (dtc->thresh + dtc->bg_thresh) / 2;
 		strscpy_pad(__entry->bdi, bdi_dev_name(wb->bdi), 32);
 
 		__entry->limit		= global_wb_domain.dirty_limit;
 		__entry->setpoint	= (global_wb_domain.dirty_limit +
 						freerun) / 2;
-		__entry->dirty		= dirty;
+		__entry->dirty		= dtc->dirty;
 		__entry->bdi_setpoint	= __entry->setpoint *
-						bdi_thresh / (thresh + 1);
-		__entry->bdi_dirty	= bdi_dirty;
+						dtc->wb_thresh / (dtc->thresh + 1);
+		__entry->bdi_dirty	= dtc->wb_dirty;
 		__entry->dirty_ratelimit = KBps(dirty_ratelimit);
 		__entry->task_ratelimit	= KBps(task_ratelimit);
 		__entry->dirtied	= dirtied;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eb55ece39c565..e980b2aec3529 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -120,29 +120,6 @@ EXPORT_SYMBOL(laptop_mode);
 
 struct wb_domain global_wb_domain;
 
-/* consolidated parameters for balance_dirty_pages() and its subroutines */
-struct dirty_throttle_control {
-#ifdef CONFIG_CGROUP_WRITEBACK
-	struct wb_domain	*dom;
-	struct dirty_throttle_control *gdtc;	/* only set in memcg dtc's */
-#endif
-	struct bdi_writeback	*wb;
-	struct fprop_local_percpu *wb_completions;
-
-	unsigned long		avail;		/* dirtyable */
-	unsigned long		dirty;		/* file_dirty + write + nfs */
-	unsigned long		thresh;		/* dirty threshold */
-	unsigned long		bg_thresh;	/* dirty background threshold */
-
-	unsigned long		wb_dirty;	/* per-wb counterparts */
-	unsigned long		wb_thresh;
-	unsigned long		wb_bg_thresh;
-
-	unsigned long		pos_ratio;
-	bool			freerun;
-	bool			dirty_exceeded;
-};
-
 /*
  * Length of period for aging writeout fractions of bdis. This is an
  * arbitrarily chosen number. The longer the period, the slower fractions will
@@ -1962,11 +1939,7 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
 		 */
 		if (pause < min_pause) {
 			trace_balance_dirty_pages(wb,
-						  sdtc->thresh,
-						  sdtc->bg_thresh,
-						  sdtc->dirty,
-						  sdtc->wb_thresh,
-						  sdtc->wb_dirty,
+						  sdtc,
 						  dirty_ratelimit,
 						  task_ratelimit,
 						  pages_dirtied,
@@ -1991,11 +1964,7 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
 
 pause:
 		trace_balance_dirty_pages(wb,
-					  sdtc->thresh,
-					  sdtc->bg_thresh,
-					  sdtc->dirty,
-					  sdtc->wb_thresh,
-					  sdtc->wb_dirty,
+					  sdtc,
 					  dirty_ratelimit,
 					  task_ratelimit,
 					  pages_dirtied,
-- 
2.39.5



