Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994C2155A4E;
	Tue, 29 Apr 2025 18:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950584; cv=none; b=peD2vV66fvGZZqz4RJwzO4hL2VABPwopecJzSw0x1s+MWgwgWENyN2wObfgIr6KdBMnYZYS/8QzdyZ3vVswa0CJfBO6OWNgQMZXsYpleZnx7BKrNMbhthq2dnmNCzYqKhDtFifEOH7SlyvP53pv8q0IODh1La8faKX9m0ZBkebY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950584; c=relaxed/simple;
	bh=ZQhUasssEDVT3HRrLAfHLJ3eBGfIDJJnjmC1O9XAdN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiyG9J41giNdR3BNeL8ovnD5z0PY7dxQh+3LZjHntOIJjBb5DgJ8WfO5icPtBrJ5aC5eS0/V9MUz2lCw9LqEvabD8Wkvq0oWTzRlEulDiT+cIBAeYAPlWEXcTnwvHXAO054dvRgFGtQptjz4gL1Ibw91ctfNRTEDxyb+bZ7ShA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jt0JqE5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jt0JqE5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2118CC4CEE3;
	Tue, 29 Apr 2025 18:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950584;
	bh=ZQhUasssEDVT3HRrLAfHLJ3eBGfIDJJnjmC1O9XAdN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jt0JqE5/FjaZzDiFslJOAqftMOJJ+EiCkMZsL/aOEe6xwFA9eTS7ls8ioKZn9/My8
	 qdM9LzUftj6noIcIUdKN3uQBRDC1Uyo6Ka/MjdTEz9piUKg86hvRkJTIFO7Sb34lF7
	 axO/uz3fHX13XyD+XLkIyIxxO6CMXYiaP3GWiAg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/204] objtool, panic: Disable SMAP in __stack_chk_fail()
Date: Tue, 29 Apr 2025 18:43:50 +0200
Message-ID: <20250429161105.236421416@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 72c774aa9d1e16bfd247096935e7dae194d84929 ]

__stack_chk_fail() can be called from uaccess-enabled code.  Make sure
uaccess gets disabled before calling panic().

Fixes the following warning:

  kernel/trace/trace_branch.o: error: objtool: ftrace_likely_update+0x1ea: call to __stack_chk_fail() with UACCESS enabled

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/a3e97e0119e1b04c725a8aa05f7bc83d98e657eb.1742852847.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c        | 6 ++++++
 tools/objtool/check.c | 5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index ef9f9a4e928de..d7973e9754748 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -763,9 +763,15 @@ device_initcall(register_warn_debugfs);
  */
 __visible noinstr void __stack_chk_fail(void)
 {
+	unsigned long flags;
+
 	instrumentation_begin();
+	flags = user_access_save();
+
 	panic("stack-protector: Kernel stack is corrupted in: %pB",
 		__builtin_return_address(0));
+
+	user_access_restore(flags);
 	instrumentation_end();
 }
 EXPORT_SYMBOL(__stack_chk_fail);
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index ddf3da6eccd0d..eb6d7025ee49c 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1225,12 +1225,15 @@ static const char *uaccess_safe_builtin[] = {
 	"__ubsan_handle_load_invalid_value",
 	/* STACKLEAK */
 	"stackleak_track_stack",
+	/* TRACE_BRANCH_PROFILING */
+	"ftrace_likely_update",
+	/* STACKPROTECTOR */
+	"__stack_chk_fail",
 	/* misc */
 	"csum_partial_copy_generic",
 	"copy_mc_fragile",
 	"copy_mc_fragile_handle_tail",
 	"copy_mc_enhanced_fast_string",
-	"ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */
 	"rep_stos_alternative",
 	"rep_movs_alternative",
 	"__copy_user_nocache",
-- 
2.39.5



