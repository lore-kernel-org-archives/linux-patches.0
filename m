Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B63442B2E;
	Thu, 20 Aug 2026 16:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243241; cv=none; b=So+Qc3eazHpFb/x7N6jzCBfz4nbbIsEvDuMQU+9AzUcT3hQTNy1o/e2pNtBaSL803dyxVU0fPycvRJX6XfgUPF4g+wkhTn4hGR4yoV9j18Gr6turzkbj82lG+VTQjyf8rmu6tRSBGYRovsGquFITBG13Xv0lZtb9qC3Nc9JumeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243241; c=relaxed/simple;
	bh=bvUeXOEObRGAgSwpFTpmpg01uz0AthxjQz5/CNllKRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8AGC39MpQshHrQjLKJBL4mXleufpjJ6hNzRZt+EIYrYFnFSYzIfOYN75p2dJBrqqxCbwHng11IP9r9uweMpZy68pWegt16vep2aZ7euCvQGZuy27VcFCi+f7ffAF+PyqUciULP1J5JjL5s42ZmGMwo27NBA0EVD0R2WSPmSXwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlhK3gSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlhK3gSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE651F000E9;
	Thu, 20 Aug 2026 16:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243240;
	bh=EhxXnwJ1cflvQuws62RzlFWGgI/ZdaoOgcCOn8zrjic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlhK3gSjL69j/v3BgFL3RDVCtUrLkQCoya3rLgZ0yWaY06mVpXK295vrQuno8G+SS
	 dM+45ZeGBI8waaEWJVDCRa4h01tXpI68XPc0iizIg9Zdk65cqLE8kYQPCxiL7vYi40
	 /Q07FXlBKNvrCADynhmgaceY9RdvsIkIPaHZu6R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 026/272] ftrace: Fix off-by-one fentry site disable in ftrace_free_mem()
Date: Thu, 20 Aug 2026 16:53:30 +0200
Message-ID: <20260820145232.016240648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6838,7 +6838,8 @@ static void add_to_clear_hash_list(struc
 void ftrace_free_mem(struct module *mod, void *start_ptr, void *end_ptr)
 {
 	unsigned long start = (unsigned long)(start_ptr);
-	unsigned long end = (unsigned long)(end_ptr);
+	/* end is inclusive and end_ptr is exclusive */
+	unsigned long end = (unsigned long)(end_ptr) - 1;
 	struct ftrace_page **last_pg = &ftrace_pages_start;
 	struct ftrace_page *tmp_page = NULL;
 	struct ftrace_page *pg;
@@ -6850,6 +6851,9 @@ void ftrace_free_mem(struct module *mod,
 
 	INIT_LIST_HEAD(&clear_hash);
 
+	if (start_ptr >= end_ptr)
+		return;
+
 	key.ip = start;
 	key.flags = end;	/* overload flags, as it is unsigned long */
 


