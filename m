Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DC013AD11;
	Mon,  6 Jan 2025 15:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178809; cv=none; b=gXxDVDWtlNxhjHA+j8lW8LTfwovrqWQDHNwdeW+kVqVMnwnYQE8z1HZ0IMeipKQNZ4MKPLGNfXcL+tLe6/QHgMlig5kXCAbhN7Jiqcfs0ApJoUaXh0CfP3aUZwRrSCQBjm110ybnGF/VIVC+KmpQOTZ/r1rb+xZiXD6XvvaSESM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178809; c=relaxed/simple;
	bh=ZXlGAn6oL3JtqRvNbp+gAHBorNj7O/kJkYHunlNIkZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PKCWpZkQBTlwaTardVSuTdGJsyW9UGlG/MQ3dFnzfnsdHUIsJXNNwtpWiPmRM7/7hXvxnVTdc95tmrRJ12jcxkR4rotZdggg2Mrew70wbVkHOyBWpbD1qukfjXIVCZ9A5k7V9G9iothfi4d+lcZGRU3E1+6ezsxY7tOW0jpbXyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZTVNDtR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZTVNDtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A704C4CED2;
	Mon,  6 Jan 2025 15:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178808;
	bh=ZXlGAn6oL3JtqRvNbp+gAHBorNj7O/kJkYHunlNIkZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZTVNDtRS88C5yaw0WI80gv5WEX4rPkQhRYcIRij97tLQl8+q/NbtFvssI0Q2b4x9
	 Rri6bh4IKUljVuH+PQdOTPsaq6BCa3olVWVt0jCh5MqTWDiJLCxl+OLmy+O6COARz/
	 ai0/FM4S0prNyJ5TSPcrZ8hxY/fUe/BYOb1RAYNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 098/168] tracing: Constify string literal data member in struct trace_event_call
Date: Mon,  6 Jan 2025 16:16:46 +0100
Message-ID: <20250106151142.164378213@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

commit 452f4b31e3f70a52b97890888eeb9eaa9a87139a upstream.

The name member of the struct trace_event_call is assigned with
generated string literals; declare them pointer to read-only.

Reported by clang:

    security/landlock/syscalls.c:179:1: warning: initializing 'char *' with an expression of type 'const char[34]' discards qualifiers [-Wincompatible-pointer-types-discards-qualifiers]
      179 | SYSCALL_DEFINE3(landlock_create_ruleset,
          | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      180 |                 const struct landlock_ruleset_attr __user *const, attr,
          |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      181 |                 const size_t, size, const __u32, flags)
          |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ./include/linux/syscalls.h:226:36: note: expanded from macro 'SYSCALL_DEFINE3'
      226 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
          |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ./include/linux/syscalls.h:234:2: note: expanded from macro 'SYSCALL_DEFINEx'
      234 |         SYSCALL_METADATA(sname, x, __VA_ARGS__)                 \
          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ./include/linux/syscalls.h:184:2: note: expanded from macro 'SYSCALL_METADATA'
      184 |         SYSCALL_TRACE_ENTER_EVENT(sname);                       \
          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ./include/linux/syscalls.h:151:30: note: expanded from macro 'SYSCALL_TRACE_ENTER_EVENT'
      151 |                         .name                   = "sys_enter"#sname,    \
          |                                                   ^~~~~~~~~~~~~~~~~

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Günther Noack <gnoack@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/20241125105028.42807-1-cgoettsche@seltendoof.de
Fixes: b77e38aa240c3 ("tracing: add event trace infrastructure")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/trace_events.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -347,7 +347,7 @@ struct trace_event_call {
 	struct list_head	list;
 	struct trace_event_class *class;
 	union {
-		char			*name;
+		const char		*name;
 		/* Set TRACE_EVENT_FL_TRACEPOINT flag when using "tp" */
 		struct tracepoint	*tp;
 	};


