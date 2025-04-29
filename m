Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B250882C60;
	Tue, 29 Apr 2025 17:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948092; cv=none; b=olUZI3gtXH4DtMe2ExHX+hAdXQuKFN5txCimgeiTkq+7QBWSnhQ2E7RIcahAtqY1jTr0UinSAaSLc8ne8F/CGn7NebfgXuqqNKlTkIYTsV9aJT+nXi1x0PcrimFn5SKasbqvtHIhmrPtXVAn6r8Zxk73xWqPq37z/viGybXuGvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948092; c=relaxed/simple;
	bh=pc9F19iUViM/wezIz5++odJHdTQNHHyYhm06YNlR63E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAU7sTRKdJ+nJeONdVpfscP3nfQeZKAayhQXjtsnTGdZrX+GlzPocTuebIZ9Ux+oWYB1pTH29m+nDRYQmWhG1fI+/UsLP+w/QDpDNi9tW14W6ctAKLZ6fSD8y0k1uez5TSSMzUXkHTIKkQtZLWKTGpVlc7Bdk43jNjQjvq91cpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JywRYaWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JywRYaWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D89BC4CEE3;
	Tue, 29 Apr 2025 17:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948092;
	bh=pc9F19iUViM/wezIz5++odJHdTQNHHyYhm06YNlR63E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JywRYaWvviy6gnxjeCAvzgyGW1bNoQaYtLqwWN9EK+hW+D4d73ne8xCef1Xhx5fcW
	 BmI9gbf0avFkhkZOrXQjvjTsg5X6tYugXBopfZoEMrLOEcendHTO/Cywji1ead2cL6
	 S0JZoKG0fy8lXtw7mtPyFyDeK6BPK5gJG/fofNBo=
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
Subject: [PATCH 6.12 188/280] objtool, panic: Disable SMAP in __stack_chk_fail()
Date: Tue, 29 Apr 2025 18:42:09 +0200
Message-ID: <20250429161122.797641383@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fbc59b3b64d0b..ddad0578355bb 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -832,9 +832,15 @@ device_initcall(register_warn_debugfs);
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
index ff7e0622e9112..bab1f22fd50a1 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1243,12 +1243,15 @@ static const char *uaccess_safe_builtin[] = {
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



