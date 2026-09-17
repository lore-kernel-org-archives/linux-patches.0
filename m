Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1A7207E00;
	Thu, 17 Sep 2026 15:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660281; cv=none; b=hkUA3Zq5ipxZfSaBgf4ZN076U1qJ3OLE7mrC8m1gWSBgBqAGCvw1VdUugg0YHgYE6nAKWr8kia2M/XjpJaEJNewxBTLUQpZVRxVRKFFqoNxd+bhv1JaR/kjYPAG0BcvD22Tr54BbbjPIk9t1wfFw4MgyUP4obMF47kbzZQBMcZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660281; c=relaxed/simple;
	bh=d4aehwuFNHoO4PfO7YvhSiE4Mkj3OC/5Z7dBlVTuDew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjBQ04NxmWyj0uWR2CjJE52v1HglTOlYYz2OtIvjg0eU8YaCW+DfhCMufEIXhZQ0Dg4TWNZ1u26WHvtSsrLBOKE289TyVGDakUxE0ZzGR7ubpu7DRNnjs63Zukwix0uEI/3cfqpJfme7JKuqG8u2je5I2hcftAshcuttNJtonKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hznk9bbN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hznk9bbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71401F000FF;
	Thu, 17 Sep 2026 15:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660280;
	bh=adNUe+WohKtnJT5Z8kyovGmgh7B+t1rkqz9EeaIBAjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hznk9bbNCJB5aZ4gPyEWIf0FxRbZwaPy3cSYudXc2NUImBCyzRElFlvX4SywjYiq6
	 RORPisuBCAV89uWBEPcLcYpDdTlnNJl9gWbddzT+J1q2tyMGmr4trjAi3NcVzXb7/R
	 ejUIoNfR/0896mk4yscTYpKbIFeVD6tNz8OlQDCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 500/733] tracing: Let histogram values keep the percent and graph modifiers
Date: Thu, 17 Sep 2026 16:13:28 +0100
Message-ID: <20260917151404.551224999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 3d617bfd79330ae3acf94862c18bb3ccf5f5a0f9 upstream.

The .percent and .graph modifiers exist only for histogram values, but a
value carrying either of them has been rejected since v6.3. The example
in Documentation/trace/histogram.rst,

  # echo 'hist:keys=prev_comm:vals=hitcount.percent:nohitcount' > \
	 events/sched/sched_switch/trigger

returns -EINVAL.

parse_field() sets the two flags only when the field is neither a key nor
a variable, that is, only on a value:

	} else if (strncmp(modifier, "percent", 7) == 0) {
		if (*flags & (HIST_FIELD_FL_VAR | HIST_FIELD_FL_KEY))
			goto error;
		*flags |= HIST_FIELD_FL_PERCENT;

__create_val_field() then rejects a value for carrying them, so no field
can reach hist_trigger_print_val(), where both are implemented.

commit e0213434fe3e ("tracing: Do not let histogram values have some
modifiers") added the check after a value with .buckets oopsed in
hist_field_name(). That happens because .buckets and .log2 make
create_hist_field() build a nested field in operands[0] which
hist_field_name() then walks into. The percent and graph flags do not
create an operand and are not read by hist_field_name(); they are only
used when printing a value.

Stop rejecting the two flags on a value. The check for variables is left
alone, where they are unreachable anyway because parse_field() rejects a
variable carrying them first.

With the two flags removed, the trigger above installs and prints as
documented:

  { prev_comm: rcu_preempt  }  hitcount (%):   0.00
  { prev_comm: init         }  hitcount (%):  99.98
  Totals:
      Hits: 237896

Cc: stable@vger.kernel.org
Fixes: e0213434fe3e ("tracing: Do not let histogram values have some modifiers")
Link: https://patch.msgid.link/20260907052113.430818-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4288,8 +4288,7 @@ static int __create_val_field(struct his
 			goto err;
 	} else {
 		/* Value */
-		if (hist_field->flags & (HIST_FIELD_FL_GRAPH | HIST_FIELD_FL_PERCENT |
-					 HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
+		if (hist_field->flags & (HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
 					 HIST_FIELD_FL_SYM | HIST_FIELD_FL_SYM_OFFSET |
 					 HIST_FIELD_FL_SYSCALL | HIST_FIELD_FL_STACKTRACE))
 			goto err;


