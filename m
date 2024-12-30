Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1EB15E8B;
	Mon, 30 Dec 2024 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574355; cv=none; b=Kk7Elrc6OBe8iz3X4mI/i4fT7qdLmHLxqp0gTRD8WBb+M1fr4wQt5wVIX+c1lBLhDD+l8Qz+3kA7NQEfv4+A5Vb/ajD/j/I2UJMNBj2Lb6URb08YFEJzmt2kABrCGr6z5SPgF6s8WMVBtf3ExYWBMcxlOqW4c+0tHeRzf/DW2As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574355; c=relaxed/simple;
	bh=ld7rM/4IB9rEIm5lufNyrbZ6ACTXi5vZ9ivlcBAcg/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t/I3vpxBIgmdSRlcFJf5b4WdEuuRe5jixQtuLADXQhJE8RKDZVOtsHbEnRpb1ktzuorsOYaqLaFPysInhdKUoWgDNT8Y6tBQWQLIKslf1i7xqu4YVT6iBW3F4mvWozWI8sE63VZYAphZoAib68CSZMi6XdFouxkZSoV3cClp8Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/jpDm8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/jpDm8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C0BC4CED0;
	Mon, 30 Dec 2024 15:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574354;
	bh=ld7rM/4IB9rEIm5lufNyrbZ6ACTXi5vZ9ivlcBAcg/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/jpDm8fRr5ubrR01C9OQ4iQs6DWNiaV8/kkrqTnMQMp2T3ars4QJEwP+suTwnHP4
	 GBWhkeRRRe7cakd2sU1DZ1rZRLrwJjEExzZ0aonZX7JcTM0UdCWHtFBdGJ0bkXzY5Y
	 MHvcbYA5NiqiL5MOyzJ8eHbDatTpSX++8f+q96lg=
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
Subject: [PATCH 6.12 085/114] tracing: Constify string literal data member in struct trace_event_call
Date: Mon, 30 Dec 2024 16:43:22 +0100
Message-ID: <20241230154221.362324852@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -379,7 +379,7 @@ struct trace_event_call {
 	struct list_head	list;
 	struct trace_event_class *class;
 	union {
-		char			*name;
+		const char		*name;
 		/* Set TRACE_EVENT_FL_TRACEPOINT flag when using "tp" */
 		struct tracepoint	*tp;
 	};


