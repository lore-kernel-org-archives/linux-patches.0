Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447B115E8B;
	Mon, 30 Dec 2024 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574377; cv=none; b=IstPtmZTM94Fk4gIo+zCPZMQH9PjnXWykJGMbNCZtdEuNIFf1R0mvryMRum7hSZYkcUt2jvRnAv1eRLUhENBonjWzIDwBxAck8o+rnTnUhp1+qzmeSmhXg+R0Q7rJY+nitKsVUrjuHSoQUQPOaKphQ4dBNC+eSiXLg0waGJTMJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574377; c=relaxed/simple;
	bh=tOB5TMq5MvSqrEB5LhjZzvXmrZG1r6wuJbcQEqa9mBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfP1JZr1hK8eboQWxDW2/B8zVIe8ClYNjWLncUF9kXvSzfgdQM/Py7+tBL6kpyZT08TH2Dr+w7dfefziTeCvgRyNevPtaVWh8E8ZAeEYqutB30+tSDnga5RKEF5QfkeJv2aJN3KHko04DvlFFUaePYchYVt1cvDz1jE/aDpM0h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+z4LJo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+z4LJo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A894FC4CED0;
	Mon, 30 Dec 2024 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574377;
	bh=tOB5TMq5MvSqrEB5LhjZzvXmrZG1r6wuJbcQEqa9mBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+z4LJo6fe/xTv33wVAKYiMEhgk+Q9U7eyOukvdxrk+W3ZmKTXvUj30rTCKUcxypw
	 3rFPn2dsQ49voKq0f6gSlYmBlKvUl3YO77hpd16GGDTAwe2ppkcQCtn5/vSk3oQzMo
	 TauYecIhAEWHgLFhMO9lpUqVBByS062ykxX1uEmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 087/114] rtla/timerlat: Fix histogram ALL for zero samples
Date: Mon, 30 Dec 2024 16:43:24 +0100
Message-ID: <20241230154221.443264320@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Tomas Glozar <tglozar@redhat.com>

commit 6cc45f8c1f898570916044f606be9890d295e129 upstream.

rtla timerlat hist currently computers the minimum, maximum and average
latency even in cases when there are zero samples. This leads to
nonsensical values being calculated for maximum and minimum, and to
divide by zero for average.

A similar bug is fixed by 01b05fc0e5f3 ("rtla/timerlat: Fix histogram
report when a cpu count is 0") but the bug still remains for printing
the sum over all CPUs in timerlat_print_stats_all.

The issue can be reproduced with this command:

$ rtla timerlat hist -U -d 1s
Index
over:
count:
min:
avg:
max:
Floating point exception (core dumped)

(There are always no samples with -U unless the user workload is
created.)

Fix the bug by omitting max/min/avg when sample count is zero,
displaying a dash instead, just like we already do for the individual
CPUs. The logic is moved into a new function called
format_summary_value, which is used for both the individual CPUs
and for the overall summary.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20241127134130.51171-1-tglozar@redhat.com
Fixes: 1462501c7a8 ("rtla/timerlat: Add a summary for hist mode")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat_hist.c |  189 +++++++++++++++++----------------
 1 file changed, 102 insertions(+), 87 deletions(-)

--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -281,6 +281,21 @@ static void timerlat_hist_header(struct
 }
 
 /*
+ * format_summary_value - format a line of summary value (min, max or avg)
+ * of hist data
+ */
+static void format_summary_value(struct trace_seq *seq,
+				 int count,
+				 unsigned long long val,
+				 bool avg)
+{
+	if (count)
+		trace_seq_printf(seq, "%9llu ", avg ? val / count : val);
+	else
+		trace_seq_printf(seq, "%9c ", '-');
+}
+
+/*
  * timerlat_print_summary - print the summary of the hist data to the output
  */
 static void
@@ -327,29 +342,23 @@ timerlat_print_summary(struct timerlat_h
 		if (!data->hist[cpu].irq_count && !data->hist[cpu].thread_count)
 			continue;
 
-		if (!params->no_irq) {
-			if (data->hist[cpu].irq_count)
-				trace_seq_printf(trace->seq, "%9llu ",
-						data->hist[cpu].min_irq);
-			else
-				trace_seq_printf(trace->seq, "        - ");
-		}
-
-		if (!params->no_thread) {
-			if (data->hist[cpu].thread_count)
-				trace_seq_printf(trace->seq, "%9llu ",
-						data->hist[cpu].min_thread);
-			else
-				trace_seq_printf(trace->seq, "        - ");
-		}
-
-		if (params->user_hist) {
-			if (data->hist[cpu].user_count)
-				trace_seq_printf(trace->seq, "%9llu ",
-						data->hist[cpu].min_user);
-			else
-				trace_seq_printf(trace->seq, "        - ");
-		}
+		if (!params->no_irq)
+			format_summary_value(trace->seq,
+					     data->hist[cpu].irq_count,
+					     data->hist[cpu].min_irq,
+					     false);
+
+		if (!params->no_thread)
+			format_summary_value(trace->seq,
+					     data->hist[cpu].thread_count,
+					     data->hist[cpu].min_thread,
+					     false);
+
+		if (params->user_hist)
+			format_summary_value(trace->seq,
+					     data->hist[cpu].user_count,
+					     data->hist[cpu].min_user,
+					     false);
 	}
 	trace_seq_printf(trace->seq, "\n");
 
@@ -363,29 +372,23 @@ timerlat_print_summary(struct timerlat_h
 		if (!data->hist[cpu].irq_count && !data->hist[cpu].thread_count)
 			continue;
 
-		if (!params->no_irq) {
-			if (data->hist[cpu].irq_count)
-				trace_seq_printf(trace->seq, "%9llu ",
-						 data->hist[cpu].sum_irq / data->hist[cpu].irq_count);
-			else
-				trace_seq_printf(trace->seq, "        - ");
-		}
-
-		if (!params->no_thread) {
-			if (data->hist[cpu].thread_count)
-				trace_seq_printf(trace->seq, "%9llu ",
-						 data->hist[cpu].sum_thread / data->hist[cpu].thread_count);
-			else
-				trace_seq_printf(trace->seq, "        - ");
-		}
-
-		if (params->user_hist) {
-			if (data->hist[cpu].user_count)
-				trace_seq_printf(trace->seq, "%9llu ",
-						 data->hist[cpu].sum_user / data->hist[cpu].user_count);
-			else
-				trace_seq_printf(trace->seq, "        - ");
-		}
+		if (!params->no_irq)
+			format_summary_value(trace->seq,
+					     data->hist[cpu].irq_count,
+					     data->hist[cpu].sum_irq,
+					     true);
+
+		if (!params->no_thread)
+			format_summary_value(trace->seq,
+					     data->hist[cpu].thread_count,
+					     data->hist[cpu].sum_thread,
+					     true);
+
+		if (params->user_hist)
+			format_summary_value(trace->seq,
+					     data->hist[cpu].user_count,
+					     data->hist[cpu].sum_user,
+					     true);
 	}
 	trace_seq_printf(trace->seq, "\n");
 
@@ -399,29 +402,23 @@ timerlat_print_summary(struct timerlat_h
 		if (!data->hist[cpu].irq_count && !data->hist[cpu].thread_count)
 			continue;
 
-		if (!params->no_irq) {
-			if (data->hist[cpu].irq_count)
-				trace_seq_printf(trace->seq, "%9llu ",
-						 data->hist[cpu].max_irq);
-			else
-				trace_seq_printf(trace->seq, "        - ");
-		}
-
-		if (!params->no_thread) {
-			if (data->hist[cpu].thread_count)
-				trace_seq_printf(trace->seq, "%9llu ",
-						data->hist[cpu].max_thread);
-			else
-				trace_seq_printf(trace->seq, "        - ");
-		}
-
-		if (params->user_hist) {
-			if (data->hist[cpu].user_count)
-				trace_seq_printf(trace->seq, "%9llu ",
-						data->hist[cpu].max_user);
-			else
-				trace_seq_printf(trace->seq, "        - ");
-		}
+		if (!params->no_irq)
+			format_summary_value(trace->seq,
+					     data->hist[cpu].irq_count,
+					     data->hist[cpu].max_irq,
+					     false);
+
+		if (!params->no_thread)
+			format_summary_value(trace->seq,
+					     data->hist[cpu].thread_count,
+					     data->hist[cpu].max_thread,
+					     false);
+
+		if (params->user_hist)
+			format_summary_value(trace->seq,
+					     data->hist[cpu].user_count,
+					     data->hist[cpu].max_user,
+					     false);
 	}
 	trace_seq_printf(trace->seq, "\n");
 	trace_seq_do_printf(trace->seq);
@@ -505,16 +502,22 @@ timerlat_print_stats_all(struct timerlat
 		trace_seq_printf(trace->seq, "min:  ");
 
 	if (!params->no_irq)
-		trace_seq_printf(trace->seq, "%9llu ",
-				 sum.min_irq);
+		format_summary_value(trace->seq,
+				     sum.irq_count,
+				     sum.min_irq,
+				     false);
 
 	if (!params->no_thread)
-		trace_seq_printf(trace->seq, "%9llu ",
-				 sum.min_thread);
+		format_summary_value(trace->seq,
+				     sum.thread_count,
+				     sum.min_thread,
+				     false);
 
 	if (params->user_hist)
-		trace_seq_printf(trace->seq, "%9llu ",
-				 sum.min_user);
+		format_summary_value(trace->seq,
+				     sum.user_count,
+				     sum.min_user,
+				     false);
 
 	trace_seq_printf(trace->seq, "\n");
 
@@ -522,16 +525,22 @@ timerlat_print_stats_all(struct timerlat
 		trace_seq_printf(trace->seq, "avg:  ");
 
 	if (!params->no_irq)
-		trace_seq_printf(trace->seq, "%9llu ",
-				 sum.sum_irq / sum.irq_count);
+		format_summary_value(trace->seq,
+				     sum.irq_count,
+				     sum.sum_irq,
+				     true);
 
 	if (!params->no_thread)
-		trace_seq_printf(trace->seq, "%9llu ",
-				 sum.sum_thread / sum.thread_count);
+		format_summary_value(trace->seq,
+				     sum.thread_count,
+				     sum.sum_thread,
+				     true);
 
 	if (params->user_hist)
-		trace_seq_printf(trace->seq, "%9llu ",
-				 sum.sum_user / sum.user_count);
+		format_summary_value(trace->seq,
+				     sum.user_count,
+				     sum.sum_user,
+				     true);
 
 	trace_seq_printf(trace->seq, "\n");
 
@@ -539,16 +548,22 @@ timerlat_print_stats_all(struct timerlat
 		trace_seq_printf(trace->seq, "max:  ");
 
 	if (!params->no_irq)
-		trace_seq_printf(trace->seq, "%9llu ",
-				 sum.max_irq);
+		format_summary_value(trace->seq,
+				     sum.irq_count,
+				     sum.max_irq,
+				     false);
 
 	if (!params->no_thread)
-		trace_seq_printf(trace->seq, "%9llu ",
-				 sum.max_thread);
+		format_summary_value(trace->seq,
+				     sum.thread_count,
+				     sum.max_thread,
+				     false);
 
 	if (params->user_hist)
-		trace_seq_printf(trace->seq, "%9llu ",
-				 sum.max_user);
+		format_summary_value(trace->seq,
+				     sum.user_count,
+				     sum.max_user,
+				     false);
 
 	trace_seq_printf(trace->seq, "\n");
 	trace_seq_do_printf(trace->seq);


