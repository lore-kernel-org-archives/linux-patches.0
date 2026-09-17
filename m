Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999EA4FDA71;
	Thu, 17 Sep 2026 17:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666297; cv=none; b=cJ0sO5kUW7by1D8HoWC47FrDbnaJIjIp8OYpOJ8ynnuA66/t7ifD6IHc1W4DvE6BnyJr3wii8pDY0xyZnuxGYidAHgUFsdVEr/Qq/mJYVtsolrOayRdlqHrL4tFo3CbBMbeS+BYW9Qs1ZkZnWaz8ATmKGU7fnyGyRuziQEsrEIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666297; c=relaxed/simple;
	bh=hymJafLC9HoYpFpItuOuQLivbMNVg409imSoL5h06D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFsL2ILG0CULQohw9SGfzaBFXdj1Os9jJhvKyLHPr5/u6estItHj44EXOoq723k0+IyKwOqhetxWJ6M3nWsoPSg1oRa8b9uwSD2ERndqDx3jzo8vZ6PgfExowfAcBT0WCFfHhevdNgEabj2GPQEcUKq9xbdb4pAnO95A6AwCSks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeJRfVsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeJRfVsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5B31F000FF;
	Thu, 17 Sep 2026 17:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666296;
	bh=0EjNrkoxXbaSn+BNoFhWSSeATE/vJtcWXIXvPggRU64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeJRfVsiYw5pJwMMFxDkuLNZ3v0SUeQhkoEpLnY2O9DMGYkT2CvEfM/jwPLXWqRhe
	 +2uVOKHvenW84OmtJXZ4Zz0W4528IPy9vrLjZbunYWpXHD2RY9Hzgon8CLu/TaQ/Zn
	 WPvMqeo/8CGvTpVncJvOJ9p0Ildv9Wh6Xb9htXHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 0991/1250] tracing: Let histogram values keep the percent and graph modifiers
Date: Thu, 17 Sep 2026 16:13:06 +0100
Message-ID: <20260917151618.891726594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4287,8 +4287,7 @@ static int __create_val_field(struct his
 			goto err;
 	} else {
 		/* Value */
-		if (hist_field->flags & (HIST_FIELD_FL_GRAPH | HIST_FIELD_FL_PERCENT |
-					 HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
+		if (hist_field->flags & (HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
 					 HIST_FIELD_FL_SYM | HIST_FIELD_FL_SYM_OFFSET |
 					 HIST_FIELD_FL_SYSCALL | HIST_FIELD_FL_STACKTRACE))
 			goto err;


