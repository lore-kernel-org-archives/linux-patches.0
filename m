Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB6519F485;
	Tue, 27 Aug 2024 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771211; cv=none; b=qr2+DENFN0n+FLgnu3qgwLgH8FZOll6FMnw1HEugL566kwmmBu7We3WMv+y9FANIxHq5iU7kyRZRC9v9y3866vuySR5rfFUp46d0JZl+W+mIKTSe68BJ5J0yNBmSzOwsqtceZ6FL929Uvb1cM4Htbw9o2cJn+bdEig9q0JsrMXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771211; c=relaxed/simple;
	bh=8C+0Oio+Vif94BKmLC1XaOoMLP/ZRv6iLQkoINzK2KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mn831qMaguVA7Zvscp05o/gbn3HYg5lspMvYeW/QW0FPePNukWjVJDFli3Lylq9gnxnb0gl06hjM51EtgMmHLWi2f8IljmrNPnYdgT+IrF5tigFW/Od2Lu1hms276zpYA+2l483kuTkxrqCXkdvv+rZxAwFEAySKpESeGN1z3IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnUwpFWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnUwpFWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7CDC4AF61;
	Tue, 27 Aug 2024 15:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771210;
	bh=8C+0Oio+Vif94BKmLC1XaOoMLP/ZRv6iLQkoINzK2KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnUwpFWPxwjeSwtVTVV8YrTinvp6rIC7pVE+Cz5WlAvCmvShx26AKkDLkCwBpPy0K
	 Mj420Aowvdtqk4xSZ/T0rIe3O8fuU7N7Uxjt48CWPXPz6CVHGvPaTIfALCPT0bpbQ/
	 hprA6O/kt0CdCfC2om7fnZReEUIWj3Zl0qG0+gFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 120/273] kallsyms: Match symbols exactly with CONFIG_LTO_CLANG
Date: Tue, 27 Aug 2024 16:37:24 +0200
Message-ID: <20240827143837.974824748@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit fb6a421fb6153d97cf3058f9bd550b377b76a490 ]

With CONFIG_LTO_CLANG=y, the compiler may add .llvm.<hash> suffix to
function names to avoid duplication. APIs like kallsyms_lookup_name()
and kallsyms_on_each_match_symbol() tries to match these symbol names
without the .llvm.<hash> suffix, e.g., match "c_stop" with symbol
c_stop.llvm.17132674095431275852. This turned out to be problematic
for use cases that require exact match, for example, livepatch.

Fix this by making the APIs to match symbols exactly.

Also cleanup kallsyms_selftests accordingly.

Signed-off-by: Song Liu <song@kernel.org>
Fixes: 8cc32a9bbf29 ("kallsyms: strip LTO-only suffixes from promoted global functions")
Tested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20240807220513.3100483-3-song@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kallsyms.c          | 55 +++++---------------------------------
 kernel/kallsyms_selftest.c | 22 +--------------
 2 files changed, 7 insertions(+), 70 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index fb2c77368d187..a9a0ca605d4a8 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -160,38 +160,6 @@ unsigned long kallsyms_sym_address(int idx)
 	return kallsyms_relative_base - 1 - kallsyms_offsets[idx];
 }
 
-static void cleanup_symbol_name(char *s)
-{
-	char *res;
-
-	if (!IS_ENABLED(CONFIG_LTO_CLANG))
-		return;
-
-	/*
-	 * LLVM appends various suffixes for local functions and variables that
-	 * must be promoted to global scope as part of LTO.  This can break
-	 * hooking of static functions with kprobes. '.' is not a valid
-	 * character in an identifier in C. Suffixes only in LLVM LTO observed:
-	 * - foo.llvm.[0-9a-f]+
-	 */
-	res = strstr(s, ".llvm.");
-	if (res)
-		*res = '\0';
-
-	return;
-}
-
-static int compare_symbol_name(const char *name, char *namebuf)
-{
-	/* The kallsyms_seqs_of_names is sorted based on names after
-	 * cleanup_symbol_name() (see scripts/kallsyms.c) if clang lto is enabled.
-	 * To ensure correct bisection in kallsyms_lookup_names(), do
-	 * cleanup_symbol_name(namebuf) before comparing name and namebuf.
-	 */
-	cleanup_symbol_name(namebuf);
-	return strcmp(name, namebuf);
-}
-
 static unsigned int get_symbol_seq(int index)
 {
 	unsigned int i, seq = 0;
@@ -219,7 +187,7 @@ static int kallsyms_lookup_names(const char *name,
 		seq = get_symbol_seq(mid);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		ret = compare_symbol_name(name, namebuf);
+		ret = strcmp(name, namebuf);
 		if (ret > 0)
 			low = mid + 1;
 		else if (ret < 0)
@@ -236,7 +204,7 @@ static int kallsyms_lookup_names(const char *name,
 		seq = get_symbol_seq(low - 1);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		if (compare_symbol_name(name, namebuf))
+		if (strcmp(name, namebuf))
 			break;
 		low--;
 	}
@@ -248,7 +216,7 @@ static int kallsyms_lookup_names(const char *name,
 			seq = get_symbol_seq(high + 1);
 			off = get_symbol_offset(seq);
 			kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-			if (compare_symbol_name(name, namebuf))
+			if (strcmp(name, namebuf))
 				break;
 			high++;
 		}
@@ -407,8 +375,7 @@ static int kallsyms_lookup_buildid(unsigned long addr,
 		if (modbuildid)
 			*modbuildid = NULL;
 
-		ret = strlen(namebuf);
-		goto found;
+		return strlen(namebuf);
 	}
 
 	/* See if it's in a module or a BPF JITed image. */
@@ -422,8 +389,6 @@ static int kallsyms_lookup_buildid(unsigned long addr,
 		ret = ftrace_mod_address_lookup(addr, symbolsize,
 						offset, modname, namebuf);
 
-found:
-	cleanup_symbol_name(namebuf);
 	return ret;
 }
 
@@ -450,8 +415,6 @@ const char *kallsyms_lookup(unsigned long addr,
 
 int lookup_symbol_name(unsigned long addr, char *symname)
 {
-	int res;
-
 	symname[0] = '\0';
 	symname[KSYM_NAME_LEN - 1] = '\0';
 
@@ -462,16 +425,10 @@ int lookup_symbol_name(unsigned long addr, char *symname)
 		/* Grab name */
 		kallsyms_expand_symbol(get_symbol_offset(pos),
 				       symname, KSYM_NAME_LEN);
-		goto found;
+		return 0;
 	}
 	/* See if it's in a module. */
-	res = lookup_module_symbol_name(addr, symname);
-	if (res)
-		return res;
-
-found:
-	cleanup_symbol_name(symname);
-	return 0;
+	return lookup_module_symbol_name(addr, symname);
 }
 
 /* Look up a kernel symbol and return it in a text buffer. */
diff --git a/kernel/kallsyms_selftest.c b/kernel/kallsyms_selftest.c
index 2f84896a7bcbd..873f7c445488c 100644
--- a/kernel/kallsyms_selftest.c
+++ b/kernel/kallsyms_selftest.c
@@ -187,31 +187,11 @@ static void test_perf_kallsyms_lookup_name(void)
 		stat.min, stat.max, div_u64(stat.sum, stat.real_cnt));
 }
 
-static bool match_cleanup_name(const char *s, const char *name)
-{
-	char *p;
-	int len;
-
-	if (!IS_ENABLED(CONFIG_LTO_CLANG))
-		return false;
-
-	p = strstr(s, ".llvm.");
-	if (!p)
-		return false;
-
-	len = strlen(name);
-	if (p - s != len)
-		return false;
-
-	return !strncmp(s, name, len);
-}
-
 static int find_symbol(void *data, const char *name, unsigned long addr)
 {
 	struct test_stat *stat = (struct test_stat *)data;
 
-	if (strcmp(name, stat->name) == 0 ||
-	    (!stat->perf && match_cleanup_name(name, stat->name))) {
+	if (!strcmp(name, stat->name)) {
 		stat->real_cnt++;
 		stat->addr = addr;
 
-- 
2.43.0



