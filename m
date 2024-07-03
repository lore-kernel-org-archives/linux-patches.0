Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D06194C73;
	Wed,  3 Jul 2024 11:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005896; cv=none; b=mlJyO/8rB8hIZ6qvCeop8/PztNgR45CoBzVYLNLwE5owVNGlT1llbANavfz/EokQvgGfAkMO1t4C/idRQMpfSwXC1pfia10Sx/fWPgAXoCgNiuVNvrM8h9+hD4g8RAcymZDJgN/ZCwutvitGv8lh9YO6XAuX3K5iiLIsyRXddD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005896; c=relaxed/simple;
	bh=XTgbpdBPNZ81Qgs1gzO3inOPwnWaTpvJlfJluBaYDFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grd9DMVvxZgzShIW2OqwjBMd15/2O4IArumPn3qVzkpq0MudG1Mu7vZ4qzdJBLJ2qRnmoT72HIeQ9F3gNXEmtgN7DoAMMX3MzT5qI7JHcUeb2PmEhNMgAbdsbskh7RwUjVqr4QT4GNQuh6yZc0nbb9rpXqk0LMtR8cnvfVjOqBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYbKTa3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYbKTa3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F34AC4AF0C;
	Wed,  3 Jul 2024 11:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005895;
	bh=XTgbpdBPNZ81Qgs1gzO3inOPwnWaTpvJlfJluBaYDFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYbKTa3XxeKLxck47bArXhvtXUOZVnW/dQevJxdOZWP0+kFqQXhlLMnNngdYCFhlL
	 yBsh1ceeNU7jfbPO+dDyn4Xo0UM3qk1tZyryGWTzA8S1xNaML5Ro0KTJR0guZnOuAE
	 zj7/53dVlADXv6wYHox4zAlf2sOIyKJcrDcB77GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changbin Du <changbin.du@huawei.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	changbin.du@gmail.com,
	Thomas Richter <tmricht@linux.ibm.com>,
	Andi Kleen <ak@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/356] perf: script: add raw|disasm arguments to --insn-trace option
Date: Wed,  3 Jul 2024 12:39:28 +0200
Message-ID: <20240703102921.892397290@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changbin Du <changbin.du@huawei.com>

[ Upstream commit 6750ba4b6442fa5ea4bf5c0e4b4ff8b0249ef71d ]

Now '--insn-trace' accept a argument to specify the output format:
  - raw: display raw instructions.
  - disasm: display mnemonic instructions (if capstone is installed).

$ sudo perf script --insn-trace=raw
              ls 1443864 [006] 2275506.209908875:      7f216b426100 _start+0x0 (/usr/lib/x86_64-linux-gnu/ld-2.31.so) insn: 48 89 e7
              ls 1443864 [006] 2275506.209908875:      7f216b426103 _start+0x3 (/usr/lib/x86_64-linux-gnu/ld-2.31.so) insn: e8 e8 0c 00 00
              ls 1443864 [006] 2275506.209908875:      7f216b426df0 _dl_start+0x0 (/usr/lib/x86_64-linux-gnu/ld-2.31.so) insn: f3 0f 1e fa

$ sudo perf script --insn-trace=disasm
              ls 1443864 [006] 2275506.209908875:      7f216b426100 _start+0x0 (/usr/lib/x86_64-linux-gnu/ld-2.31.so)		movq %rsp, %rdi
              ls 1443864 [006] 2275506.209908875:      7f216b426103 _start+0x3 (/usr/lib/x86_64-linux-gnu/ld-2.31.so)		callq _dl_start+0x0
              ls 1443864 [006] 2275506.209908875:      7f216b426df0 _dl_start+0x0 (/usr/lib/x86_64-linux-gnu/ld-2.31.so)	illegal instruction
              ls 1443864 [006] 2275506.209908875:      7f216b426df4 _dl_start+0x4 (/usr/lib/x86_64-linux-gnu/ld-2.31.so)	pushq %rbp
              ls 1443864 [006] 2275506.209908875:      7f216b426df5 _dl_start+0x5 (/usr/lib/x86_64-linux-gnu/ld-2.31.so)	movq %rsp, %rbp
              ls 1443864 [006] 2275506.209908875:      7f216b426df8 _dl_start+0x8 (/usr/lib/x86_64-linux-gnu/ld-2.31.so)	pushq %r15

Signed-off-by: Changbin Du <changbin.du@huawei.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: changbin.du@gmail.com
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240217074046.4100789-5-changbin.du@huawei.com
Stable-dep-of: d4a98b45fbe6 ("perf script: Show also errors for --insn-trace option")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-script.txt |  7 ++++---
 tools/perf/builtin-script.c              | 22 ++++++++++++++++++----
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index c80515243560c..fa6a78c472bc1 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -423,9 +423,10 @@ include::itrace.txt[]
 	will be printed. Each entry has function name and file/line. Enabled by
 	default, disable with --no-inline.
 
---insn-trace::
-	Show instruction stream for intel_pt traces. Combine with --xed to
-	show disassembly.
+--insn-trace[=<raw|disasm>]::
+	Show instruction stream in bytes (raw) or disassembled (disasm)
+	for intel_pt traces. The default is 'raw'. To use xed, combine
+	'raw' with --xed to show disassembly done by xed.
 
 --xed::
 	Run xed disassembler on output. Requires installing the xed disassembler.
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 34e809c934d72..45ccce87d1223 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3585,10 +3585,24 @@ static int perf_script__process_auxtrace_info(struct perf_session *session,
 #endif
 
 static int parse_insn_trace(const struct option *opt __maybe_unused,
-			    const char *str __maybe_unused,
-			    int unset __maybe_unused)
+			    const char *str, int unset __maybe_unused)
 {
-	parse_output_fields(NULL, "+insn,-event,-period", 0);
+	const char *fields = "+insn,-event,-period";
+	int ret;
+
+	if (str) {
+		if (strcmp(str, "disasm") == 0)
+			fields = "+disasm,-event,-period";
+		else if (strlen(str) != 0 && strcmp(str, "raw") != 0) {
+			fprintf(stderr, "Only accept raw|disasm\n");
+			return -EINVAL;
+		}
+	}
+
+	ret = parse_output_fields(NULL, fields, 0);
+	if (ret < 0)
+		return ret;
+
 	itrace_parse_synth_opts(opt, "i0ns", 0);
 	symbol_conf.nanosecs = true;
 	return 0;
@@ -3728,7 +3742,7 @@ int cmd_script(int argc, const char **argv)
 		   "only consider these symbols"),
 	OPT_INTEGER(0, "addr-range", &symbol_conf.addr_range,
 		    "Use with -S to list traced records within address range"),
-	OPT_CALLBACK_OPTARG(0, "insn-trace", &itrace_synth_opts, NULL, NULL,
+	OPT_CALLBACK_OPTARG(0, "insn-trace", &itrace_synth_opts, NULL, "raw|disasm",
 			"Decode instructions from itrace", parse_insn_trace),
 	OPT_CALLBACK_OPTARG(0, "xed", NULL, NULL, NULL,
 			"Run xed disassembler on output", parse_xed),
-- 
2.43.0



