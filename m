Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2763803D7;
	Thu, 20 Aug 2026 17:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247873; cv=none; b=pcthR4EZ8PHWGwQSNdYEY9PJEBnjVtZdWu1FiXKmoE7aSfn7vx8Gio/kR72jAiXYj2ij3R7VbX6vVgr/KnIKd+6JvzJbdYt9y5cgyv0WuncFpJ8kdUUgQDtFpAwwb/1OPjOOPmo/rdekHjmEkU9LWqLRQ/u49O7e5Cml9ukfWZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247873; c=relaxed/simple;
	bh=iyOC27GNlJsUflLuurbxhIgy7db/w663ezZcAfxA4Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=harcRyRtAlo2CUcioccbn9wwT2vUdqDKQ6fZv+RzYRySJMXZsnhOcJ6uJdTSgr9cYVFWRFaLOAAjKNI/X0TiyCf4+4R4G2A1P2dS5BsAjJKzWsWQAGZgHiFEwxne5QTqqvqdqlYyncallreW78/fJcTRBPoN5ghLcfpB+ojOQ7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDJCR/Mf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDJCR/Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522881F000E9;
	Thu, 20 Aug 2026 17:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247871;
	bh=7jgcLqixqfDHT1cPnsYfmAQadaL/MeZN5EkQduVyX6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xDJCR/MfHPYchJGegfXoiPnpeqXpIjlL6CwlbxkrilDCVye6CPl6YO6eghpBZfkqr
	 1tV53Dz8wfuCT3sLMWteM/GJEevpq4nuV4AbD83xOIOevKIvf0yLfNzdxnhHF0o5NI
	 egEPo0HrzfhS/NqT8O3o5KPcS6e6HqFPHe01WDzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 032/303] ftrace: Fix off-by-one fentry site disable in ftrace_free_mem()
Date: Thu, 20 Aug 2026 16:52:48 +0200
Message-ID: <20260820145254.154925587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 8b8292d6487c81bd57c2605a9b404b1cf8f1edfb upstream.

When a module's init text is freed, do_init_module() calls
ftrace_free_mem() with a half-open [start, end) range.  However the
ftrace_cmp_recs() comparator treats the upper bound as inclusive, as all
its other users do, passing 'ip + size - 1'.  So ftrace_free_mem() can
delete a record sitting exactly at 'end', which is outside the freed
range.

For a kernel without CFI or IBT, the first record of a function is at
the function start, which for the first function in a module is also the
base of its text allocation.  As the module allocator packs its regions,
that address is often the 'end' passed by a neighboring module's
do_init_module(), causing the first function's ftrace location to get
disabled, preventing an attempt to livepatch it:

  livepatch: failed to find location for function 'pcspkr_probe'

Convert the exclusive end to the inclusive 'end - 1' the comparator
expects, and return early for an empty range to avoid the subtraction
from underflowing when the init text size is zero.

Cc: stable@vger.kernel.org
Fixes: 42c269c88dc1 ("ftrace: Allow for function tracing to record init functions on boot up")
Link: https://patch.msgid.link/1b5ccfa8095bdb1277f84af1c2c2e2205aca03ae.1785992188.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7384,7 +7384,8 @@ static void add_to_clear_hash_list(struc
 void ftrace_free_mem(struct module *mod, void *start_ptr, void *end_ptr)
 {
 	unsigned long start = (unsigned long)(start_ptr);
-	unsigned long end = (unsigned long)(end_ptr);
+	/* end is inclusive and end_ptr is exclusive */
+	unsigned long end = (unsigned long)(end_ptr) - 1;
 	struct ftrace_page **last_pg = &ftrace_pages_start;
 	struct ftrace_page *tmp_page = NULL;
 	struct ftrace_page *pg;
@@ -7396,6 +7397,9 @@ void ftrace_free_mem(struct module *mod,
 
 	INIT_LIST_HEAD(&clear_hash);
 
+	if (start_ptr >= end_ptr)
+		return;
+
 	key.ip = start;
 	key.flags = end;	/* overload flags, as it is unsigned long */
 


