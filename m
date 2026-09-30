Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC86372B5E;
	Wed, 30 Sep 2026 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795698; cv=none; b=DlRvIiDLyS0DBDbeLHSzKSel83mFD52EVS4Y/jzV69hKmQxFKB6mUhrK4qbM0l8gYJUu7pUwjSHng6DiVU9Vi8Qhqi7Y/Lot+lZDHoI1UwlPz2OYVrtESweO6XrYeRaD1jzyUfdqfif8htdkqsfDzZmMwio3uBsSztvcdmOkb48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795698; c=relaxed/simple;
	bh=fJhjwjjRj9UuXNNfiAoi6ClcBcrpQ0TVBtaqfkE16rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeCmglzYEdrCYCr0GOMvX70UfSA1x4g5U9a2JhOzwmTPAFvAP7VHiNGB7Qim8nyD/m3rLW6opEOZ0tWku2bVX3nV83RhSUAw/KLkBK/0/703GKx0Kup7eVgURgQgf6x0hX6i4CzURyimbE0HGpx8U5kwRdj2UHSLBcpglRtym5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QODsi74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QODsi74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9BB1F000FF;
	Wed, 30 Sep 2026 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795697;
	bh=4HKCGudEjS5inz06owAYYBav2RmuteqSRfpjveuY5Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QODsi74wu1rKVCVC8r8BzttyJnAmsM/uRleDTnGL/vP1q+VTfiBkVzeKMtA+Vi4m
	 ibvIu+eNpqFmtQDID/DtYvOmMUQE9MnQRt/1lgKk/8WAEDcq5fzU18ndTnNro3oG6H
	 9Osy1BuBI78rlXelPabtNvZK4KLSHI/n8MBYQ/hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 0615/1193] tracing: Let histogram values keep the percent and graph modifiers
Date: Wed, 30 Sep 2026 17:21:39 +0200
Message-ID: <20260930152447.909630254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -4265,8 +4265,7 @@ static int __create_val_field(struct his
 			goto err;
 	} else {
 		/* Value */
-		if (hist_field->flags & (HIST_FIELD_FL_GRAPH | HIST_FIELD_FL_PERCENT |
-					 HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
+		if (hist_field->flags & (HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
 					 HIST_FIELD_FL_SYM | HIST_FIELD_FL_SYM_OFFSET |
 					 HIST_FIELD_FL_SYSCALL | HIST_FIELD_FL_STACKTRACE))
 			goto err;


