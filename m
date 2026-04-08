Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C263BB4A;
	Wed,  8 Apr 2026 19:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674979; cv=none; b=od3YOU/JDceznCQ9RAb78LWnwX6oe3NR++r/ZRyNSpXnH/iprAxPfN/AzQR2OtSP5vSRYMwknBWUiVjuYsxEZ2/qcavq8mJyL0iMV0po5/ycvj6XNgDXWfUEAQn7pf9G233cc+Pn7UfunqGe4z75uhHTjCvzVIMTgxzb1J3DE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674979; c=relaxed/simple;
	bh=28YN2TfxQukjKYfLxDZLxHwtdtp6LfhKy1YpJQ25aYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TF5pAlZhpoKlIXxBjcZP/GZGu+zAj5TPyRURtSUWz9aTAm5l8dRaT/KUGBb+aZ0vEfYMzhIukDGN/3W0VTBBK+F4iqN8xOq1CxrMKN4dCawtaNR+ycVLS1wHdHBAfH0se0jSjkVv3/2bz+POkzp1SDzjCFOyJmbPArm5Xgq6ztU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7uLNcXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7uLNcXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4BFC19421;
	Wed,  8 Apr 2026 19:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674979;
	bh=28YN2TfxQukjKYfLxDZLxHwtdtp6LfhKy1YpJQ25aYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7uLNcXDpQVJhlc119sjRNyMCQBgGL2wlu8+X5CUZnGwnF2GHMVvB08Fvf9j3cBVE
	 YxwsrwFevBHde/wSmJC0gnZp81pq9y0/OSHPiYicAwpD3LRK8XqGDyZfn1leBYG4+/
	 tNUy87/UmeuHvXjMTQA+EQGXwa1Nolakt4JTgDno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkman <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Marc Rutland <mark.rutland@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 307/311] kallsyms: clean up @namebuf initialization in kallsyms_lookup_buildid()
Date: Wed,  8 Apr 2026 20:05:07 +0200
Message-ID: <20260408175950.829371856@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Mladek <pmladek@suse.com>

commit 426295ef18c5d5f0b7f75ac89d09022fcfafd25c upstream.

Patch series "kallsyms: Prevent invalid access when showing module
buildid", v3.

We have seen nested crashes in __sprint_symbol(), see below.  They seem to
be caused by an invalid pointer to "buildid".  This patchset cleans up
kallsyms code related to module buildid and fixes this invalid access when
printing backtraces.

I made an audit of __sprint_symbol() and found several situations
when the buildid might be wrong:

  + bpf_address_lookup() does not set @modbuildid

  + ftrace_mod_address_lookup() does not set @modbuildid

  + __sprint_symbol() does not take rcu_read_lock and
    the related struct module might get removed before
    mod->build_id is printed.

This patchset solves these problems:

  + 1st, 2nd patches are preparatory
  + 3rd, 4th, 6th patches fix the above problems
  + 5th patch cleans up a suspicious initialization code.

This is the backtrace, we have seen. But it is not really important.
The problems fixed by the patchset are obvious:

  crash64> bt [62/2029]
  PID: 136151 TASK: ffff9f6c981d4000 CPU: 367 COMMAND: "btrfs"
  #0 [ffffbdb687635c28] machine_kexec at ffffffffb4c845b3
  #1 [ffffbdb687635c80] __crash_kexec at ffffffffb4d86a6a
  #2 [ffffbdb687635d08] hex_string at ffffffffb51b3b61
  #3 [ffffbdb687635d40] crash_kexec at ffffffffb4d87964
  #4 [ffffbdb687635d50] oops_end at ffffffffb4c41fc8
  #5 [ffffbdb687635d70] do_trap at ffffffffb4c3e49a
  #6 [ffffbdb687635db8] do_error_trap at ffffffffb4c3e6a4
  #7 [ffffbdb687635df8] exc_stack_segment at ffffffffb5666b33
  #8 [ffffbdb687635e20] asm_exc_stack_segment at ffffffffb5800cf9
  ...


This patch (of 7)

The function kallsyms_lookup_buildid() initializes the given @namebuf by
clearing the first and the last byte.  It is not clear why.

The 1st byte makes sense because some callers ignore the return code and
expect that the buffer contains a valid string, for example:

  - function_stat_show()
    - kallsyms_lookup()
      - kallsyms_lookup_buildid()

The initialization of the last byte does not make much sense because it
can later be overwritten.  Fortunately, it seems that all called functions
behave correctly:

  -  kallsyms_expand_symbol() explicitly adds the trailing '\0'
     at the end of the function.

  - All *__address_lookup() functions either use the safe strscpy()
    or they do not touch the buffer at all.

Document the reason for clearing the first byte.  And remove the useless
initialization of the last byte.

Link: https://lkml.kernel.org/r/20251128135920.217303-2-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kallsyms.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -355,7 +355,12 @@ static int kallsyms_lookup_buildid(unsig
 {
 	int ret;
 
-	namebuf[KSYM_NAME_LEN - 1] = 0;
+	/*
+	 * kallsyms_lookus() returns pointer to namebuf on success and
+	 * NULL on error. But some callers ignore the return value.
+	 * Instead they expect @namebuf filled either with valid
+	 * or empty string.
+	 */
 	namebuf[0] = 0;
 
 	if (is_ksym_addr(addr)) {


