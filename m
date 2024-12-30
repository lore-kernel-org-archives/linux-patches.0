Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DF72594B6;
	Mon, 30 Dec 2024 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573635; cv=none; b=YY/wfhhxAnQ5oxhtCNJPvzVd79MT+M6Y9F9Dqta5ZVyIjxRYE6DfIOMHnWEcwbRAlRf8nBLJQyzA3mUMUlFVUIh+2EoqntxiIZQoZrLvjUNh30szrGnkCaV/xAap8X/1plG0W2P0m0+FD48QrbECAbknIJpWQMXov0buaB6ahRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573635; c=relaxed/simple;
	bh=eilYYmeiTvc5zI4tJ6/LePwtavRThsC11U3XAlwV3AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pZfnvBlgsGDUs3eaIxuesUBmDu5tKqcxi8+tKUnlUKBFsu2zVaRnUX4dmmJbo9Oc5GjkXW17peA3no8jA7g2D/aCk5eWV91NFPyDGwMY/H7luTQqILWmniRqWPehwdeYbazBrZBkxdl4WeLt6Za6NcnmCBXE5C0SDB9EcaD4c3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNK0mvWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNK0mvWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA7BC4CED0;
	Mon, 30 Dec 2024 15:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573634;
	bh=eilYYmeiTvc5zI4tJ6/LePwtavRThsC11U3XAlwV3AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNK0mvWOGHngkIeLk8MCGbrtRoimEVXc1PZykfdE/n5tAh6EM9Mt5k1jr4SQR77AR
	 i8SuAqg2GNy/rfg5i7RYHJ2SJtdljnbFpUaOpIrXlPisfZ6xXikdHszkbSUAvA0JXL
	 G4yE57NHizEVyl6ilsk6dYeWiXfMB6ejq9N6UXTk=
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
Subject: [PATCH 6.1 49/60] tracing: Constify string literal data member in struct trace_event_call
Date: Mon, 30 Dec 2024 16:42:59 +0100
Message-ID: <20241230154209.133584613@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -355,7 +355,7 @@ struct trace_event_call {
 	struct list_head	list;
 	struct trace_event_class *class;
 	union {
-		char			*name;
+		const char		*name;
 		/* Set TRACE_EVENT_FL_TRACEPOINT flag when using "tp" */
 		struct tracepoint	*tp;
 	};


