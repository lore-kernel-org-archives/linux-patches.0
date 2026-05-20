Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885AA359A6F;
	Wed, 20 May 2026 17:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298542; cv=none; b=d0ITK8age6gZA568D7qO2FvquXwCr2k8fI/KydSBI3kmtqPJTWoJE1/gpbIPN3AqO4QZ8vcVkrL97XcAFGdxzzRsC8ePsyWsn7uweXIn8U6nRI/pxdwxrtzGZK8+4R/LNrLA0NCKJK0soH3Yun94ZvFHsIbwWIUPleJCIi6+ONw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298542; c=relaxed/simple;
	bh=HeQtQNqsF7ZDZ4v2aQfscP85JsvaB0lhIn5uXDuiQLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQ5dKTSJ23fWyBasf+q3HaFRJr41bVny0O8El0mC+lBejlV26CZRjX+8PvDGf0nkUfeZSPVIZmpVjxobIP1vr3+5fxq5V8/QW60Q1C8Ei4OALDhspZl0LvGqQ80vJwxAzsxAc2nmMZtkDn5V7/hUF1rSAxEQ1fQCGlPiRUHCyQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaJ8LF9T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaJ8LF9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F325F1F000E9;
	Wed, 20 May 2026 17:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298541;
	bh=T7pWOzC3o63n5KOgCp+7sYvCl2HBrw+ix5aBjhf6Ml4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaJ8LF9TdaaFp72hepN4xW9zn/tfqy004EdDk6dairswwkXrMs+tcVLFejPNVqGBT
	 cQtasC9WmOaULYfQyl2ufQweJq585VpeqS2/L5HRrktSvEdhq2AM8jEW7Oj6XJ7oek
	 hoLcY+qTXHH316ypEDgSi/Ttha2Z3qYL7NEp9hLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Yury Norov <ynorov@nvidia.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 451/957] tracing: remove size parameter in __trace_puts()
Date: Wed, 20 May 2026 18:15:34 +0200
Message-ID: <20260520162144.300945677@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 86e685ff364394b477cd1c476029480a2a1960c5 ]

The __trace_puts() function takes a string pointer and the size of the
string itself.  All users currently simply pass in the strlen() of the
string it is also passing in.  There's no reason to pass in the size.
Instead have the __trace_puts() function do the strlen() within the
function itself.

This fixes a header recursion issue where using strlen() in the macro
calling __trace_puts() requires adding #include <linux/string.h> in order
to use strlen().  Removing the use of strlen() from the header fixes the
recursion issue.

Link: https://lore.kernel.org/all/aUN8Hm377C5A0ILX@yury/
Link: https://lkml.kernel.org/r/20260116042510.241009-6-ynorov@nvidia.com
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 473e470f16f9 ("tracing: move __printf() attribute on __ftrace_vbprintk()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kernel.h | 4 ++--
 kernel/trace/trace.c   | 7 +++----
 kernel/trace/trace.h   | 2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5b46924fdff52..d5a939b8c3911 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -331,10 +331,10 @@ int __trace_printk(unsigned long ip, const char *fmt, ...);
 	if (__builtin_constant_p(str))					\
 		__trace_bputs(_THIS_IP_, trace_printk_fmt);		\
 	else								\
-		__trace_puts(_THIS_IP_, str, strlen(str));		\
+		__trace_puts(_THIS_IP_, str);				\
 })
 extern int __trace_bputs(unsigned long ip, const char *str);
-extern int __trace_puts(unsigned long ip, const char *str, int size);
+extern int __trace_puts(unsigned long ip, const char *str);
 
 extern void trace_dump_stack(int skip);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2be9e47d64b08..55c9f51a2fda0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1180,11 +1180,10 @@ EXPORT_SYMBOL_GPL(__trace_array_puts);
  * __trace_puts - write a constant string into the trace buffer.
  * @ip:	   The address of the caller
  * @str:   The constant string to write
- * @size:  The size of the string.
  */
-int __trace_puts(unsigned long ip, const char *str, int size)
+int __trace_puts(unsigned long ip, const char *str)
 {
-	return __trace_array_puts(printk_trace, ip, str, size);
+	return __trace_array_puts(printk_trace, ip, str, strlen(str));
 }
 EXPORT_SYMBOL_GPL(__trace_puts);
 
@@ -1203,7 +1202,7 @@ int __trace_bputs(unsigned long ip, const char *str)
 	int size = sizeof(struct bputs_entry);
 
 	if (!printk_binsafe(tr))
-		return __trace_puts(ip, str, strlen(str));
+		return __trace_puts(ip, str);
 
 	if (!(tr->trace_flags & TRACE_ITER_PRINTK))
 		return 0;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ec372e0f2e716..62d5a5f224c4a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -2099,7 +2099,7 @@ extern void tracing_log_err(struct trace_array *tr,
  * about performance). The internal_trace_puts() is for such
  * a purpose.
  */
-#define internal_trace_puts(str) __trace_puts(_THIS_IP_, str, strlen(str))
+#define internal_trace_puts(str) __trace_puts(_THIS_IP_, str)
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)	\
-- 
2.53.0



