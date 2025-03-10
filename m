Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55B722154C;
	Mon, 10 Mar 2025 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627281; cv=none; b=EhLWXMRNqTqT32aSyKqaS6Nr6t/ftSI7Yl1XvbEnzI04rIiFsq3OCCQtAL5DtRbiLoiK8/KdSJ/2haGUVEWYVVLIrlwwppInP3YyaTc4kMhFk1jqGYlx62rO+U/6o9em8/kdpmfj0B9sSkF5iMI19PIRKIVggbDRElQEX81wD9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627281; c=relaxed/simple;
	bh=042pO3tJrH3DhAUpMQ1cCf0eLJk3WKEnBepJxGJbXQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADnOey3llZG1sMdZ3eyHEzKlUqPS+cOqP8qubuqOqhgahhjKr5S7+u3zWjuqvMBe6w0XWRTJssneRkZcjojRmpT5+o7Xvysb9jpzks30f9cS1VX/NUMcKhY3MpQYEJ13bNL2XMVuz1+IDXtZVUUWVy1ogTwgSnomBdeHyK1gOWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LauLr+Vt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LauLr+Vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688A8C4CEE5;
	Mon, 10 Mar 2025 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627280;
	bh=042pO3tJrH3DhAUpMQ1cCf0eLJk3WKEnBepJxGJbXQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LauLr+VtagpwQQAFm1e04LZ8pbydWdMnoozbWwT9qqsaxn+5jG7tZEuLHV6nlkk70
	 yWMBNjyc0qNjoPCq1Q7+mSyfQDxgHyT6AaZEDtETSeuWu9Eb9XiS3vWYa2zWfkyWmL
	 J0rKD0D5+8uuax0pOyZp6aigaGH0GwIGdgp6WX0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 074/269] tracing: tprobe-events: Reject invalid tracepoint name
Date: Mon, 10 Mar 2025 18:03:47 +0100
Message-ID: <20250310170500.677330765@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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


