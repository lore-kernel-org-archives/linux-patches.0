Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1B91D2A5
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A91C433D2;
	Wed,  7 Jun 2023 20:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170784;
	bh=HQip4JU2ufGbBFmngswCvZNg0p8jcFaaxwD0tcaw8/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZIbua1oCTqeCDI2tyojhtE/IfE24C2+ef2jP63w4+jlyBPeqNJxJxooY856SmtWN
	 SKqxwBAmZnssvyP7SBXqA/bTj5sKMCM6uuExo6z2g4xRBxj9Vlv3m9Mq6T2MEWBw0V
	 6CPbNb2yVm25Z0Y71XGtyaeaCTj2f3TjbI8qFaao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Tom Zanussi <zanussi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 187/225] tracing/histograms: Allow variables to have some modifiers
Date: Wed,  7 Jun 2023 22:16:20 +0200
Message-ID: <20230607200920.500955751@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit e30fbc618e97b38dbb49f1d44dcd0778d3f23b8c upstream.

Modifiers are used to change the behavior of keys. For instance, they
can grouped into buckets, converted to syscall names (from the syscall
identifier), show task->comm of the current pid, be an array of longs
that represent a stacktrace, and more.

It was found that nothing stopped a value from taking a modifier. As
values are simple counters. If this happened, it would call code that
was not expecting a modifier and crash the kernel. This was fixed by
having the ___create_val_field() function test if a modifier was present
and fail if one was. This fixed the crash.

Now there's a problem with variables. Variables are used to pass fields
from one event to another. Variables are allowed to have some modifiers,
as the processing may need to happen at the time of the event (like
stacktraces and comm names of the current pid). The issue is that it too
uses __create_val_field(). Now that fails on modifiers, variables can no
longer use them (this is a regression).

As not all modifiers are for variables, have them use a separate check.

Link: https://lore.kernel.org/linux-trace-kernel/20230523221108.064a5d82@rorschach.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Fixes: e0213434fe3e4 ("tracing: Do not let histogram values have some modifiers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4193,13 +4193,19 @@ static int __create_val_field(struct his
 		goto out;
 	}
 
-	/* Some types cannot be a value */
-	if (hist_field->flags & (HIST_FIELD_FL_GRAPH | HIST_FIELD_FL_PERCENT |
-				 HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
-				 HIST_FIELD_FL_SYM | HIST_FIELD_FL_SYM_OFFSET |
-				 HIST_FIELD_FL_SYSCALL | HIST_FIELD_FL_STACKTRACE)) {
-		hist_err(file->tr, HIST_ERR_BAD_FIELD_MODIFIER, errpos(field_str));
-		ret = -EINVAL;
+	/* values and variables should not have some modifiers */
+	if (hist_field->flags & HIST_FIELD_FL_VAR) {
+		/* Variable */
+		if (hist_field->flags & (HIST_FIELD_FL_GRAPH | HIST_FIELD_FL_PERCENT |
+					 HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2))
+			goto err;
+	} else {
+		/* Value */
+		if (hist_field->flags & (HIST_FIELD_FL_GRAPH | HIST_FIELD_FL_PERCENT |
+					 HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
+					 HIST_FIELD_FL_SYM | HIST_FIELD_FL_SYM_OFFSET |
+					 HIST_FIELD_FL_SYSCALL | HIST_FIELD_FL_STACKTRACE))
+			goto err;
 	}
 
 	hist_data->fields[val_idx] = hist_field;
@@ -4211,6 +4217,9 @@ static int __create_val_field(struct his
 		ret = -EINVAL;
  out:
 	return ret;
+ err:
+	hist_err(file->tr, HIST_ERR_BAD_FIELD_MODIFIER, errpos(field_str));
+	return -EINVAL;
 }
 
 static int create_val_field(struct hist_trigger_data *hist_data,


