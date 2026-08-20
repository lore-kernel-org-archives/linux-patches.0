Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29113307492;
	Thu, 20 Aug 2026 17:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247526; cv=none; b=FZ2DbU50jhxjYzAqdk31yjzhFpijvpkT/Xlm2evpmRPslWXVA8OZ2/byuoN6xpB6auAffLF8/mQzTUo86FTvaisZI0R8rVeMBxcE7cWbn+rUJi2e1mJFH24X/KcLuYbhgc5Ze7edcTZk9wLDycAy43H/4+HJJFEgkJhzV2DHgf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247526; c=relaxed/simple;
	bh=7T87vDU93H1REbZ4wJDbTnQafvXNhSlLIzquypvuvIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfTu/Jh8VbjGN1IVIGq0kZfj0gViWWB75N8s5jQvsfyXUIWmiopsn89P8fj8L2NMof7PMYJk6HXeJc4iw2bpmHKPHkwqZOzlWdoINlLXPk3EajeU4zncWGyUM9OHJ3fl1tCA1kaC73WjA5Jejxv5tLhb808y57LTZE7Z9Qvyz78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KD9nTztX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KD9nTztX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DD71F000E9;
	Thu, 20 Aug 2026 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247524;
	bh=0sSeqe3/Mv44zlnQWJB563/cSU9dty4I2cCqwPMG7MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KD9nTztXHClqS8v7otk9G4nXEVfvwnhDktw0M3/Az/0wnFqAc6igeVTGn3FzyO2BL
	 eEVyGdeBJ4cLntBmO3ZcgW5PBHzisSPIF8fEBeIvSfQhCyR8xonJ0mphvvjf0vXHqq
	 lx5zhY7Hpd7pAu4hMHRPPzbv35o7M+2q9L7VmZFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 037/166] ftrace: Fix off-by-one fentry site disable in ftrace_free_mem()
Date: Thu, 20 Aug 2026 16:54:56 +0200
Message-ID: <20260820145212.293196765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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
@@ -7250,7 +7250,8 @@ static void add_to_clear_hash_list(struc
 void ftrace_free_mem(struct module *mod, void *start_ptr, void *end_ptr)
 {
 	unsigned long start = (unsigned long)(start_ptr);
-	unsigned long end = (unsigned long)(end_ptr);
+	/* end is inclusive and end_ptr is exclusive */
+	unsigned long end = (unsigned long)(end_ptr) - 1;
 	struct ftrace_page **last_pg = &ftrace_pages_start;
 	struct ftrace_page *tmp_page = NULL;
 	struct ftrace_page *pg;
@@ -7260,6 +7261,9 @@ void ftrace_free_mem(struct module *mod,
 	struct ftrace_init_func *func, *func_next;
 	LIST_HEAD(clear_hash);
 
+	if (start_ptr >= end_ptr)
+		return;
+
 	key.ip = start;
 	key.flags = end;	/* overload flags, as it is unsigned long */
 


