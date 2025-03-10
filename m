Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03043233707;
	Mon, 10 Mar 2025 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626579; cv=none; b=mF63VN2Ixq4eqAhxMjZ8jjOOBb4kgUHrF1WoWBiphxCeNhLolZqy33R6OowCj66vdpieD1gi/TEke4njmVM9E+Fz8VA1HE8YguOQoLsfpfZQc/RY9WkeQco7apDkHbIXqA9eHaqCwxwsyme40ACgyQXk5Iaqa3ytV73rj29owas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626579; c=relaxed/simple;
	bh=MVMqa4vKWN/5TKy+GpscO2UK1Ogn0lA6mjzn1Cj51SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIXYSJEzie0Q2JXl3BeQWNySXZC4SGEOkciNESi/rz9PgYs2WcV/t84Xg6YeGJAV/Imt+2KB7hrPZK7mFv7JhtjRIMJq0eRbeouFYrzayAw+JH7ZuBqqQwC6T84wmXXtoENAh2+ywWTM0UtkXc9ShRRjKGCBsyGX2Kr9OE+0l9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESWPuCrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESWPuCrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A98EC4CEE5;
	Mon, 10 Mar 2025 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626578;
	bh=MVMqa4vKWN/5TKy+GpscO2UK1Ogn0lA6mjzn1Cj51SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESWPuCrF2lb3JaHUjrvQB7SPU8di2UedfWJAzfxSHwaKcG8RANmGWKyTAddBmyR/C
	 l2cBRUCRUQGsuQ2jEpOQmQH3pzj8w+qnjNrDS8xf+EUMyELRQ0N0aTx6xXHdQoecBa
	 ZW+pxTxrWoyZNKUX3QJ5XYvkMaj5GG7/fL6yjkuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 009/207] tracing: tprobe-events: Reject invalid tracepoint name
Date: Mon, 10 Mar 2025 18:03:22 +0100
Message-ID: <20250310170448.135844629@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit d0453655b6ddc685a4837f3cc0776ae8eef62d01 upstream.

Commit 57a7e6de9e30 ("tracing/fprobe: Support raw tracepoints on
future loaded modules") allows user to set a tprobe on non-exist
tracepoint but it does not check the tracepoint name is acceptable.
So it leads tprobe has a wrong character for events (e.g. with
subsystem prefix). In this case, the event is not shown in the
events directory.

Reject such invalid tracepoint name.

The tracepoint name must consist of alphabet or digit or '_'.

Link: https://lore.kernel.org/all/174055073461.4079315.15875502830565214255.stgit@mhiramat.tok.corp.google.com/

Fixes: 57a7e6de9e30 ("tracing/fprobe: Support raw tracepoints on future loaded modules")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_fprobe.c |   13 +++++++++++++
 kernel/trace/trace_probe.h  |    1 +
 2 files changed, 14 insertions(+)

--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -1018,6 +1018,19 @@ static int parse_symbol_and_return(int a
 	if (*is_return)
 		return 0;
 
+	if (is_tracepoint) {
+		tmp = *symbol;
+		while (*tmp && (isalnum(*tmp) || *tmp == '_'))
+			tmp++;
+		if (*tmp) {
+			/* find a wrong character. */
+			trace_probe_log_err(tmp - *symbol, BAD_TP_NAME);
+			kfree(*symbol);
+			*symbol = NULL;
+			return -EINVAL;
+		}
+	}
+
 	/* If there is $retval, this should be a return fprobe. */
 	for (i = 2; i < argc; i++) {
 		tmp = strstr(argv[i], "$retval");
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -481,6 +481,7 @@ extern int traceprobe_define_arg_fields(
 	C(NON_UNIQ_SYMBOL,	"The symbol is not unique"),		\
 	C(BAD_RETPROBE,		"Retprobe address must be an function entry"), \
 	C(NO_TRACEPOINT,	"Tracepoint is not found"),		\
+	C(BAD_TP_NAME,		"Invalid character in tracepoint name"),\
 	C(BAD_ADDR_SUFFIX,	"Invalid probed address suffix"), \
 	C(NO_GROUP_NAME,	"Group name is not specified"),		\
 	C(GROUP_TOO_LONG,	"Group name is too long"),		\


