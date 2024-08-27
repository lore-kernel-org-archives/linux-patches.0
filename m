Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E32019F485;
	Tue, 27 Aug 2024 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771207; cv=none; b=DKSiR7jT8KnZHfbzo1cfdGklo7jGN+/2F8oEPmxQzZu2N3eX/GW2k1DnBMY3IlKd0tegu6i+5tFDQNErm6JPoVsPuzKIWJAXuHHHGBYERI2ABadavq8rWHcm3rLe7i7qpeZomJvo+gD5sIUdDgP2wD0HUIQAXOcQPF8uA7+CiOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771207; c=relaxed/simple;
	bh=Nc3r4DHEW/kKqjB8ZuDHQonvumZC7iOBHJOCBtAGuFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3rA9eIVwMViiK3IsRkjaSt0uHIB/pyBgxsIpjcs6j99osDou0bHihL7Ih7OHHIEhUcPPJQnBkaPVfE2Uvzx6xw9FN0YvGszmPfwU8x9ZoqKaFaS2Yw3PEMi08qpTZldj0ECkF+T1jg2s8rMGLKnctSGEoqau+bRkRCto5Mwh0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyH58mUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyH58mUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF298C4AF55;
	Tue, 27 Aug 2024 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771207;
	bh=Nc3r4DHEW/kKqjB8ZuDHQonvumZC7iOBHJOCBtAGuFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyH58mUV2hGzOlILWXkPFuKThIJS9YIhzSe/xEh7S9CtVWOCSd5ij6Z80fiA9Xd3/
	 o4qMauAZGMKx3UmlSkp/nUiqXJ1zKsoWxq5HzRCGx1T06en7+ilC8t5wGLQQznQLPA
	 b2StwqlL5uFWKoLNLQHi1N4FtlXa8xW66EgnP4kg=
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
Subject: [PATCH 6.10 119/273] kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols
Date: Tue, 27 Aug 2024 16:37:23 +0200
Message-ID: <20240827143837.936401223@linuxfoundation.org>
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

[ Upstream commit 020925ce92990c3bf59ab2cde386ac6d9ec734ff ]

Cleaning up the symbols causes various issues afterwards. Let's sort
the list based on original name.

Signed-off-by: Song Liu <song@kernel.org>
Fixes: 8cc32a9bbf29 ("kallsyms: strip LTO-only suffixes from promoted global functions")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Tested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20240807220513.3100483-2-song@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kallsyms.c      | 31 ++-----------------------------
 scripts/link-vmlinux.sh |  4 ----
 2 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 55a423519f2e5..839d9c49f28ce 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -5,8 +5,7 @@
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
  *
- * Usage: kallsyms [--all-symbols] [--absolute-percpu]
- *                         [--lto-clang] in.map > out.S
+ * Usage: kallsyms [--all-symbols] [--absolute-percpu]  in.map > out.S
  *
  *      Table compression uses all the unused char codes on the symbols and
  *  maps these to the most used substrings (tokens). For instance, it might
@@ -63,7 +62,6 @@ static struct sym_entry **table;
 static unsigned int table_size, table_cnt;
 static int all_symbols;
 static int absolute_percpu;
-static int lto_clang;
 
 static int token_profit[0x10000];
 
@@ -74,8 +72,7 @@ static unsigned char best_table_len[256];
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--absolute-percpu] "
-			"[--lto-clang] in.map > out.S\n");
+	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--absolute-percpu] in.map > out.S\n");
 	exit(1);
 }
 
@@ -345,25 +342,6 @@ static int symbol_absolute(const struct sym_entry *s)
 	return s->percpu_absolute;
 }
 
-static void cleanup_symbol_name(char *s)
-{
-	char *p;
-
-	/*
-	 * ASCII[.]   = 2e
-	 * ASCII[0-9] = 30,39
-	 * ASCII[A-Z] = 41,5a
-	 * ASCII[_]   = 5f
-	 * ASCII[a-z] = 61,7a
-	 *
-	 * As above, replacing the first '.' in ".llvm." with '\0' does not
-	 * affect the main sorting, but it helps us with subsorting.
-	 */
-	p = strstr(s, ".llvm.");
-	if (p)
-		*p = '\0';
-}
-
 static int compare_names(const void *a, const void *b)
 {
 	int ret;
@@ -528,10 +506,6 @@ static void write_src(void)
 	output_address(relative_base);
 	printf("\n");
 
-	if (lto_clang)
-		for (i = 0; i < table_cnt; i++)
-			cleanup_symbol_name((char *)table[i]->sym);
-
 	sort_symbols_by_name();
 	output_label("kallsyms_seqs_of_names");
 	for (i = 0; i < table_cnt; i++)
@@ -808,7 +782,6 @@ int main(int argc, char **argv)
 		static const struct option long_options[] = {
 			{"all-symbols",     no_argument, &all_symbols,     1},
 			{"absolute-percpu", no_argument, &absolute_percpu, 1},
-			{"lto-clang",       no_argument, &lto_clang,       1},
 			{},
 		};
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 31581504489ef..1e41b330550e6 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -159,10 +159,6 @@ kallsyms()
 		kallsymopt="${kallsymopt} --absolute-percpu"
 	fi
 
-	if is_enabled CONFIG_LTO_CLANG; then
-		kallsymopt="${kallsymopt} --lto-clang"
-	fi
-
 	info KSYMS "${2}.S"
 	scripts/kallsyms ${kallsymopt} "${1}" > "${2}.S"
 
-- 
2.43.0



