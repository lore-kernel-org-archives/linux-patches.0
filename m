Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F263C1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77352C433C8;
	Tue, 25 Jul 2023 11:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282996;
	bh=kXxw1DAJtq0QErLe+OIvVSnDPdsqzKuJbrqyl7OqZ7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJtfpyYIM79mA3Wb5v6SOeU3Qj70nulDorh9DS/o6kntvxiANPDcUlUQMVKhe2Res
	 Pv7pe8TM7H8kuLMvJz4KTSMdhHYBeVs4P5yvDcCQ9hUwNEc4b6iNJcsaK+KDvXNopZ
	 WNMJnf0UmBdED3C2TCspw/sADja93/mc+kfld+Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/183] kallsyms: Correctly sequence symbols when CONFIG_LTO_CLANG=y
Date: Tue, 25 Jul 2023 12:45:30 +0200
Message-ID: <20230725104511.616653083@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 010a0aad39fccceba4a07d30d163158a39c704f3 ]

LLVM appends various suffixes for local functions and variables, suffixes
observed:
 - foo.llvm.[0-9a-f]+
 - foo.[0-9a-f]+

Therefore, when CONFIG_LTO_CLANG=y, kallsyms_lookup_name() needs to
truncate the suffix of the symbol name before comparing the local function
or variable name.

Old implementation code:
-	if (strcmp(namebuf, name) == 0)
-		return kallsyms_sym_address(i);
-	if (cleanup_symbol_name(namebuf) && strcmp(namebuf, name) == 0)
-		return kallsyms_sym_address(i);

The preceding process is traversed by address from low to high. That is,
for those with the same name after the suffix is removed, the one with
the smallest address is returned first. Therefore, when sorting in the
tool, if the raw names are the same, they should be sorted by address in
ascending order.

ASCII[.]   = 2e
ASCII[0-9] = 30,39
ASCII[A-Z] = 41,5a
ASCII[_]   = 5f
ASCII[a-z] = 61,7a

According to the preceding ASCII code values, the following sorting result
is strictly followed.
 ---------------------------------
|    main-key     |    sub-key    |
|---------------------------------|
|                 |  addr_lowest  |
| <name>          |      ...      |
| <name>.<suffix> |      ...      |
|                 |  addr_highest |
|---------------------------------|
| <name>?<others> |               |   //? is [_A-Za-z0-9]
 ---------------------------------

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: 8cc32a9bbf29 ("kallsyms: strip LTO-only suffixes from promoted global functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kallsyms.c      | 36 ++++++++++++++++++++++++++++++++++--
 scripts/link-vmlinux.sh |  4 ++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index dcb744a067e5e..67ef9aa14a770 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -78,6 +78,7 @@ static unsigned int table_size, table_cnt;
 static int all_symbols;
 static int absolute_percpu;
 static int base_relative;
+static int lto_clang;
 
 static int token_profit[0x10000];
 
@@ -89,7 +90,7 @@ static unsigned char best_table_len[256];
 static void usage(void)
 {
 	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--absolute-percpu] "
-			"[--base-relative] in.map > out.S\n");
+			"[--base-relative] [--lto-clang] in.map > out.S\n");
 	exit(1);
 }
 
@@ -411,6 +412,34 @@ static int symbol_absolute(const struct sym_entry *s)
 	return s->percpu_absolute;
 }
 
+static char * s_name(char *buf)
+{
+	/* Skip the symbol type */
+	return buf + 1;
+}
+
+static void cleanup_symbol_name(char *s)
+{
+	char *p;
+
+	if (!lto_clang)
+		return;
+
+	/*
+	 * ASCII[.]   = 2e
+	 * ASCII[0-9] = 30,39
+	 * ASCII[A-Z] = 41,5a
+	 * ASCII[_]   = 5f
+	 * ASCII[a-z] = 61,7a
+	 *
+	 * As above, replacing '.' with '\0' does not affect the main sorting,
+	 * but it helps us with subsorting.
+	 */
+	p = strchr(s, '.');
+	if (p)
+		*p = '\0';
+}
+
 static int compare_names(const void *a, const void *b)
 {
 	int ret;
@@ -421,7 +450,9 @@ static int compare_names(const void *a, const void *b)
 
 	expand_symbol(sa->sym, sa->len, sa_namebuf);
 	expand_symbol(sb->sym, sb->len, sb_namebuf);
-	ret = strcmp(&sa_namebuf[1], &sb_namebuf[1]);
+	cleanup_symbol_name(s_name(sa_namebuf));
+	cleanup_symbol_name(s_name(sb_namebuf));
+	ret = strcmp(s_name(sa_namebuf), s_name(sb_namebuf));
 	if (!ret) {
 		if (sa->addr > sb->addr)
 			return 1;
@@ -855,6 +886,7 @@ int main(int argc, char **argv)
 			{"all-symbols",     no_argument, &all_symbols,     1},
 			{"absolute-percpu", no_argument, &absolute_percpu, 1},
 			{"base-relative",   no_argument, &base_relative,   1},
+			{"lto-clang",       no_argument, &lto_clang,       1},
 			{},
 		};
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 918470d768e9c..32e573943cf03 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -156,6 +156,10 @@ kallsyms()
 		kallsymopt="${kallsymopt} --base-relative"
 	fi
 
+	if is_enabled CONFIG_LTO_CLANG; then
+		kallsymopt="${kallsymopt} --lto-clang"
+	fi
+
 	info KSYMS ${2}
 	scripts/kallsyms ${kallsymopt} ${1} > ${2}
 }
-- 
2.39.2



