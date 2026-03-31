Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B3C2D1F40;
	Tue, 31 Mar 2026 16:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975577; cv=none; b=biQyISRX0tzQGUbu6Z5fxynMOUWXUIu8CsioWgr0eJaufBhexYKVQghbIHm7HWoF2jejFj35OHw04v72C4Vz8wb9OymffCS5XfTEk1NjmuhQGwO1i27VTcXno1egn3JRr/vAj059VjKwRjpf75zrEhglJbGCOmfFdsMmaRecU04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975577; c=relaxed/simple;
	bh=pDjR1aJRmafKtvnRFsHQK+ttWskj3yF8RBoNku+SIkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IprC8NKNCzIAhyGcYh4h7DybbYQZBYHUvowyODXKko0ORbkOCZKu0WuhZbZ3revUqTc4cKgau0fOKBacSP03BV4vaSnxRUQ8J6zntBmP254XOyA+RDl2VOX/dZeEHXBT0mWxMniv779VfQMEz8nBKMxm/K4Azk9gf+HICejPezA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDI9ru93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDI9ru93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D653C19423;
	Tue, 31 Mar 2026 16:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975577;
	bh=pDjR1aJRmafKtvnRFsHQK+ttWskj3yF8RBoNku+SIkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDI9ru93sX0ww1+EHNi5LFE/OYBYSvHYSpMGRWA8kble2XJMZFo7kac1GmlJoX5su
	 La5aqqWQjnTSlyzbLPqhBIAH7FmML6NqIiIicVXMqlOgxdVg6q54Q8dZQydQhXfx4h
	 21Y4g4pUt+/Px9kaYy2eziTfrQCtNZM13HiA5JF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Bill Wendling <morbo@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Justin Stitt <justinstitt@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 341/342] bug: avoid format attribute warning for clang as well
Date: Tue, 31 Mar 2026 18:22:54 +0200
Message-ID: <20260331161811.446506300@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2598ab9d63f41160c7081998857fef409182933d ]

Like gcc, clang-22 now also warns about a function that it incorrectly
identifies as a printf-style format:

lib/bug.c:190:22: error: diagnostic behavior may be improved by adding the 'format(printf, 1, 0)' attribute to the declaration of '__warn_printf' [-Werror,-Wmissing-format-attribute]
  179 | static void __warn_printf(const char *fmt, struct pt_regs *regs)
      | __attribute__((format(printf, 1, 0)))
  180 | {
  181 |         if (!fmt)
  182 |                 return;
  183 |
  184 | #ifdef HAVE_ARCH_BUG_FORMAT_ARGS
  185 |         if (regs) {
  186 |                 struct arch_va_list _args;
  187 |                 va_list *args = __warn_args(&_args, regs);
  188 |
  189 |                 if (args) {
  190 |                         vprintk(fmt, *args);
      |                                           ^

Revert the change that added a gcc-specific workaround, and instead add
the generic annotation that avoid the warning.

Link: https://lkml.kernel.org/r/20260323205534.1284284-1-arnd@kernel.org
Fixes: d36067d6ea00 ("bug: Hush suggest-attribute=format for __warn_printf()")
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Brendan Jackman <jackmanb@google.com>
Link: https://lore.kernel.org/all/20251208141618.2805983-1-andriy.shevchenko@linux.intel.com/T/#u
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/bug.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/bug.c b/lib/bug.c
index 623c467a8b76c..aab9e6a40c5f9 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -173,10 +173,8 @@ struct bug_entry *find_bug(unsigned long bugaddr)
 	return module_find_bug(bugaddr);
 }
 
-__diag_push();
-__diag_ignore(GCC, all, "-Wsuggest-attribute=format",
-	      "Not a valid __printf() conversion candidate.");
-static void __warn_printf(const char *fmt, struct pt_regs *regs)
+static __printf(1, 0)
+void __warn_printf(const char *fmt, struct pt_regs *regs)
 {
 	if (!fmt)
 		return;
@@ -195,7 +193,6 @@ static void __warn_printf(const char *fmt, struct pt_regs *regs)
 
 	printk("%s", fmt);
 }
-__diag_pop();
 
 static enum bug_trap_type __report_bug(struct bug_entry *bug, unsigned long bugaddr, struct pt_regs *regs)
 {
-- 
2.53.0



