Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3E04848BF;
	Thu, 17 Sep 2026 18:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670904; cv=none; b=EQ4aO/K4xJ26I22d8ZJvzas/swFTxFbjkldeBn5ZTmVsqFJ302hozYTIIhDqGA8brjRXHM+qvyfuMA3L/ePpugLCr8cl4h3JbFeIKYewHyEZg4h9zyX98XC4/A+8i9D2SnlpO//a8xuqvGKDXt4jAEvSkCKfzfJnIfuv30MMBes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670904; c=relaxed/simple;
	bh=rQw+OhJD5BNZdTxG++JE3+Y4LToGAz+3Aplz5xz8/aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkkIQ04rg4C6u8kC0c9aglt2oJIPzXhjm6TGB1ckYehwvD4GUJVJpkQbp77VMRTmiw5P/5be0HKfl0BzTDuSpiBqtYvYbaCCnEvXZkZRhg4AovOAdEavrnDGxoS4q0mKy3TTXCRFpNwA9IXDGxVTcKSsKCkHJ3r/h5/CGmPxVBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHR0xJJu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHR0xJJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28CF1F000FF;
	Thu, 17 Sep 2026 18:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670903;
	bh=lRVZDfj0lgLNL1KEIm8BSLgdRX6jkN6b0O5rpoc9To8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHR0xJJushxU9faYiTN6M57lWcnUM+TQdOdythMq+QIRZ4ip4UOA0IsmiZesKqycv
	 WsaD6fKoDREPe216PH6cXurtOpjRmrqMbx6yqu9QUES085fb8Uo32Fzehe0HMZ7k0I
	 lEVhDRrU+N4xeAot4BiYZDgO2nIqEziYQFvxwP4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 0808/1102] tracing: Fix memory corruption from the histogram stacktrace modifier
Date: Thu, 17 Sep 2026 16:12:31 +0100
Message-ID: <20260917151600.774710122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit a5e70ba87ca8ebc79b4e63de302d03b0625fe153 upstream.

parse_field() sets HIST_FIELD_FL_STACKTRACE from the ".stacktrace"
modifier before it looks the field name up, and nothing afterwards
checks that the name resolved to a field which holds a stacktrace.
create_hist_field() picks HIST_FIELD_FN_STACK on the strength of the
field pointer alone, which reads a __data_loc word from the record and
follows its low 16 bits as an offset into the same record.
event_hist_trigger() takes the first word there as an entry count and
copies that many longs into a 31 entry array:

	n_entries = *stack;
	memcpy(entries, ++stack, n_entries * sizeof(unsigned long));

Neither end of that copy is bounded, and the count is whatever the event
holds at the offset, so any field will do:

  # cd /sys/kernel/tracing/events/sched/sched_process_fork
  # echo 'hist:keys=parent_pid.stacktrace' > trigger
  # (true)

  BUG: kernel NULL pointer dereference, address: 0000000000000008
  RIP: 0010:rb_insert_color+0x18/0x130
   timerqueue_linked_add+0x7e/0xd0
   enqueue_hrtimer+0x39/0xb0
   __hrtimer_run_queues+0x10f/0x1f0
   </IRQ>
  RIP: 0010:memcpy+0xc/0x30
   event_hist_trigger+0x165/0x690

The timer interrupt landed on the rbtree the copy had already run over.
No debug options are needed for this; KASAN reports the same write as an
out-of-bounds read of 13835058055416381440 bytes.

Documentation/trace/histogram.rst already states the rule, "must be a
long[] type", so enforce it once the name has been resolved. Names which
resolve to no field at all, "hitcount.stacktrace" and the common_*
pseudo-fields, are refused for the same reason: they hold no stacktrace
to read.

Cc: stable@vger.kernel.org
Fixes: cc5fc8bfc961 ("tracing/histogram: Add stacktrace type")
Link: https://patch.msgid.link/20260907155045.692664-2-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2307,6 +2307,7 @@ parse_field(struct hist_trigger_data *hi
 	struct ftrace_event_field *field = NULL;
 	char *field_name, *modifier, *str;
 	struct trace_array *tr = file->tr;
+	bool stack_modifier = false;
 
 	modifier = str = kstrdup(field_str, GFP_KERNEL);
 	if (!modifier)
@@ -2329,9 +2330,10 @@ parse_field(struct hist_trigger_data *hi
 			*flags |= HIST_FIELD_FL_EXECNAME;
 		else if (strcmp(modifier, "syscall") == 0)
 			*flags |= HIST_FIELD_FL_SYSCALL;
-		else if (strcmp(modifier, "stacktrace") == 0)
+		else if (strcmp(modifier, "stacktrace") == 0) {
 			*flags |= HIST_FIELD_FL_STACKTRACE;
-		else if (strcmp(modifier, "log2") == 0)
+			stack_modifier = true;
+		} else if (strcmp(modifier, "log2") == 0)
 			*flags |= HIST_FIELD_FL_LOG2;
 		else if (strcmp(modifier, "usecs") == 0)
 			*flags |= HIST_FIELD_FL_TIMESTAMP_USECS;
@@ -2398,6 +2400,12 @@ parse_field(struct hist_trigger_data *hi
 			}
 		}
 	}
+
+	if (stack_modifier &&
+	    (!field || field->filter_type != FILTER_STACKTRACE)) {
+		hist_err(tr, HIST_ERR_BAD_FIELD_MODIFIER, errpos(field_str));
+		field = ERR_PTR(-EINVAL);
+	}
  out:
 	kfree(str);
 


