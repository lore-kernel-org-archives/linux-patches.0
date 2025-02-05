Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC77B15FA7B;
	Wed,  5 Feb 2025 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768335; cv=none; b=Qpaf8RAjz60HIUdycOb3iVvR7O1tSuK/MVeM8pK1t4YcW9sbsnXiXM99zl4iz8NW/MVigf3GVTOMBSz9M2dqb0DVGrH6yZFzp/X5KNNn53iBxKtQKX5TGVq0x0ZraogrtLbecg1u20FvNEACSP4l+B1RX0/2nJexiTX+9+m3kqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768335; c=relaxed/simple;
	bh=+0kuvSu5/I+OpoIZvnRJfQ/EaZanX5xSaOljwUWPV28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m56nbGwPaba8fZ+W9fSfnSE//DpYNzJQgCJQ0+X9bIihoggn3LTlvO5HLTDx+o6iObLI1KbFh0s4HGKIvDn6T/Rh5wBnVGOPNHgRnODqIq3EQBURs73yxz1wSrKfqP71MtIt0zWM8qfONM2TuCKF7xjkRFYHPm6a++o6JU07GAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvTppcW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvTppcW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BABC4CED1;
	Wed,  5 Feb 2025 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768335;
	bh=+0kuvSu5/I+OpoIZvnRJfQ/EaZanX5xSaOljwUWPV28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvTppcW1Znt+6yr+kS/gu2YU9Q6HELBeGDfHsGgMuce/lEGfgfP5FnB30Pp5kR0rp
	 Hovm9vMYmsqnefR+Q2vGKW/HwIfCxjseLId6wIedX+ijvl/kOYqIqQ8K8LJUEM7MDV
	 WjvjeilgYq6xA2NPOBqkJy7rRtao3mj9y/P1RcPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 532/623] perf annotate: Use an array for the disassembler preference
Date: Wed,  5 Feb 2025 14:44:34 +0100
Message-ID: <20250205134516.579939232@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit bde4ccfd5ab5361490514fc4af7497989cfbee17 ]

Prior to this change a string was used which could cause issues with
an unrecognized disassembler in symbol__disassembler. Change to
initializing an array of perf_disassembler enum values. If a value
already exists then adding it a second time is ignored to avoid array
out of bounds problems present in the previous code, it also allows a
statically sized array and removes memory allocation needs. Errors in
the disassembler string are reported when the config is parsed during
perf annotate or perf top start up. If the array is uninitialized
after processing the config file the default llvm, capstone then
objdump values are added but without a need to parse a string.

Fixes: a6e8a58de629 ("perf disasm: Allow configuring what disassemblers to use")
Closes: https://lore.kernel.org/lkml/CAP-5=fUdfCyxmEiTpzS2uumUp3-SyQOseX2xZo81-dQtWXj6vA@mail.gmail.com/
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20250124043856.1177264-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 76 +++++++++++++++++++++++++++++++---
 tools/perf/util/annotate.h | 15 ++++---
 tools/perf/util/disasm.c   | 83 +++++++-------------------------------
 3 files changed, 96 insertions(+), 78 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 32e15c9f53f3c..31dce9b87bffd 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -2102,6 +2102,57 @@ int symbol__annotate2(struct map_symbol *ms, struct evsel *evsel,
 	return 0;
 }
 
+const char * const perf_disassembler__strs[] = {
+	[PERF_DISASM_UNKNOWN]  = "unknown",
+	[PERF_DISASM_LLVM]     = "llvm",
+	[PERF_DISASM_CAPSTONE] = "capstone",
+	[PERF_DISASM_OBJDUMP]  = "objdump",
+};
+
+
+static void annotation_options__add_disassembler(struct annotation_options *options,
+						 enum perf_disassembler dis)
+{
+	for (u8 i = 0; i < ARRAY_SIZE(options->disassemblers); i++) {
+		if (options->disassemblers[i] == dis) {
+			/* Disassembler is already present then don't add again. */
+			return;
+		}
+		if (options->disassemblers[i] == PERF_DISASM_UNKNOWN) {
+			/* Found a free slot. */
+			options->disassemblers[i] = dis;
+			return;
+		}
+	}
+	pr_err("Failed to add disassembler %d\n", dis);
+}
+
+static int annotation_options__add_disassemblers_str(struct annotation_options *options,
+						const char *str)
+{
+	while (str && *str != '\0') {
+		const char *comma = strchr(str, ',');
+		int len = comma ? comma - str : (int)strlen(str);
+		bool match = false;
+
+		for (u8 i = 0; i < ARRAY_SIZE(perf_disassembler__strs); i++) {
+			const char *dis_str = perf_disassembler__strs[i];
+
+			if (len == (int)strlen(dis_str) && !strncmp(str, dis_str, len)) {
+				annotation_options__add_disassembler(options, i);
+				match = true;
+				break;
+			}
+		}
+		if (!match) {
+			pr_err("Invalid disassembler '%.*s'\n", len, str);
+			return -1;
+		}
+		str = comma ? comma + 1 : NULL;
+	}
+	return 0;
+}
+
 static int annotation__config(const char *var, const char *value, void *data)
 {
 	struct annotation_options *opt = data;
@@ -2117,11 +2168,10 @@ static int annotation__config(const char *var, const char *value, void *data)
 		else if (opt->offset_level < ANNOTATION__MIN_OFFSET_LEVEL)
 			opt->offset_level = ANNOTATION__MIN_OFFSET_LEVEL;
 	} else if (!strcmp(var, "annotate.disassemblers")) {
-		opt->disassemblers_str = strdup(value);
-		if (!opt->disassemblers_str) {
-			pr_err("Not enough memory for annotate.disassemblers\n");
-			return -1;
-		}
+		int err = annotation_options__add_disassemblers_str(opt, value);
+
+		if (err)
+			return err;
 	} else if (!strcmp(var, "annotate.hide_src_code")) {
 		opt->hide_src_code = perf_config_bool("hide_src_code", value);
 	} else if (!strcmp(var, "annotate.jump_arrows")) {
@@ -2187,9 +2237,25 @@ void annotation_options__exit(void)
 	zfree(&annotate_opts.objdump_path);
 }
 
+static void annotation_options__default_init_disassemblers(struct annotation_options *options)
+{
+	if (options->disassemblers[0] != PERF_DISASM_UNKNOWN) {
+		/* Already initialized. */
+		return;
+	}
+#ifdef HAVE_LIBLLVM_SUPPORT
+	annotation_options__add_disassembler(options, PERF_DISASM_LLVM);
+#endif
+#ifdef HAVE_LIBCAPSTONE_SUPPORT
+	annotation_options__add_disassembler(options, PERF_DISASM_CAPSTONE);
+#endif
+	annotation_options__add_disassembler(options, PERF_DISASM_OBJDUMP);
+}
+
 void annotation_config__init(void)
 {
 	perf_config(annotation__config, &annotate_opts);
+	annotation_options__default_init_disassemblers(&annotate_opts);
 }
 
 static unsigned int parse_percent_type(char *str1, char *str2)
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 194a05cbc506e..858912157e019 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -34,8 +34,13 @@ struct annotated_data_type;
 #define ANNOTATION__BR_CNTR_WIDTH 30
 #define ANNOTATION_DUMMY_LEN	256
 
-// llvm, capstone, objdump
-#define MAX_DISASSEMBLERS 3
+enum perf_disassembler {
+	PERF_DISASM_UNKNOWN = 0,
+	PERF_DISASM_LLVM,
+	PERF_DISASM_CAPSTONE,
+	PERF_DISASM_OBJDUMP,
+};
+#define MAX_DISASSEMBLERS (PERF_DISASM_OBJDUMP + 1)
 
 struct annotation_options {
 	bool hide_src_code,
@@ -52,14 +57,12 @@ struct annotation_options {
 	     annotate_src,
 	     full_addr;
 	u8   offset_level;
-	u8   nr_disassemblers;
+	u8   disassemblers[MAX_DISASSEMBLERS];
 	int  min_pcnt;
 	int  max_lines;
 	int  context;
 	char *objdump_path;
 	char *disassembler_style;
-	const char *disassemblers_str;
-	const char *disassemblers[MAX_DISASSEMBLERS];
 	const char *prefix;
 	const char *prefix_strip;
 	unsigned int percent_type;
@@ -134,6 +137,8 @@ struct disasm_line {
 	struct annotation_line	 al;
 };
 
+extern const char * const perf_disassembler__strs[];
+
 void annotation_line__add(struct annotation_line *al, struct list_head *head);
 
 static inline double annotation_data__percent(struct annotation_data *data,
diff --git a/tools/perf/util/disasm.c b/tools/perf/util/disasm.c
index 41a2b08670dc5..28ceb76e465ba 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -2213,56 +2213,6 @@ static int symbol__disassemble_objdump(const char *filename, struct symbol *sym,
 	return err;
 }
 
-static int annotation_options__init_disassemblers(struct annotation_options *options)
-{
-	char *disassembler;
-
-	if (options->disassemblers_str == NULL) {
-		const char *default_disassemblers_str =
-#ifdef HAVE_LIBLLVM_SUPPORT
-				"llvm,"
-#endif
-#ifdef HAVE_LIBCAPSTONE_SUPPORT
-				"capstone,"
-#endif
-				"objdump";
-
-		options->disassemblers_str = strdup(default_disassemblers_str);
-		if (!options->disassemblers_str)
-			goto out_enomem;
-	}
-
-	disassembler = strdup(options->disassemblers_str);
-	if (disassembler == NULL)
-		goto out_enomem;
-
-	while (1) {
-		char *comma = strchr(disassembler, ',');
-
-		if (comma != NULL)
-			*comma = '\0';
-
-		options->disassemblers[options->nr_disassemblers++] = strim(disassembler);
-
-		if (comma == NULL)
-			break;
-
-		disassembler = comma + 1;
-
-		if (options->nr_disassemblers >= MAX_DISASSEMBLERS) {
-			pr_debug("annotate.disassemblers can have at most %d entries, ignoring \"%s\"\n",
-				 MAX_DISASSEMBLERS, disassembler);
-			break;
-		}
-	}
-
-	return 0;
-
-out_enomem:
-	pr_err("Not enough memory for annotate.disassemblers\n");
-	return -1;
-}
-
 int symbol__disassemble(struct symbol *sym, struct annotate_args *args)
 {
 	struct annotation_options *options = args->options;
@@ -2271,7 +2221,6 @@ int symbol__disassemble(struct symbol *sym, struct annotate_args *args)
 	char symfs_filename[PATH_MAX];
 	bool delete_extract = false;
 	struct kcore_extract kce;
-	const char *disassembler;
 	bool decomp = false;
 	int err = dso__disassemble_filename(dso, symfs_filename, sizeof(symfs_filename));
 
@@ -2331,28 +2280,26 @@ int symbol__disassemble(struct symbol *sym, struct annotate_args *args)
 		}
 	}
 
-	err = annotation_options__init_disassemblers(options);
-	if (err)
-		goto out_remove_tmp;
-
 	err = -1;
+	for (u8 i = 0; i < ARRAY_SIZE(options->disassemblers) && err != 0; i++) {
+		enum perf_disassembler dis = options->disassemblers[i];
 
-	for (int i = 0; i < options->nr_disassemblers && err != 0; ++i) {
-		disassembler = options->disassemblers[i];
-
-		if (!strcmp(disassembler, "llvm"))
+		switch (dis) {
+		case PERF_DISASM_LLVM:
 			err = symbol__disassemble_llvm(symfs_filename, sym, args);
-		else if (!strcmp(disassembler, "capstone"))
+			break;
+		case PERF_DISASM_CAPSTONE:
 			err = symbol__disassemble_capstone(symfs_filename, sym, args);
-		else if (!strcmp(disassembler, "objdump"))
+			break;
+		case PERF_DISASM_OBJDUMP:
 			err = symbol__disassemble_objdump(symfs_filename, sym, args);
-		else
-			pr_debug("Unknown disassembler %s, skipping...\n", disassembler);
-	}
-
-	if (err == 0) {
-		pr_debug("Disassembled with %s\nannotate.disassemblers=%s\n",
-			 disassembler, options->disassemblers_str);
+			break;
+		case PERF_DISASM_UNKNOWN: /* End of disassemblers. */
+		default:
+			goto out_remove_tmp;
+		}
+		if (err == 0)
+			pr_debug("Disassembled with %s\n", perf_disassembler__strs[dis]);
 	}
 out_remove_tmp:
 	if (decomp)
-- 
2.39.5



