Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA6E53365;
	Thu, 12 Dec 2024 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023124; cv=none; b=flc+9uOHF0bMKBRQf2Ize7ad1SgDSi9NoopqQ+cJsEuezPWdnEMN5W1xmJZioey9cAB3lMnbc8RKrMztl/hY6JG4t2ceAszkDEsqlthEg1ttr7d17n6da6SBoC+IsvSxTQTAT47EDBr5GAe5fQSFmTfSPoSt1uSL1ryN/WqwZzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023124; c=relaxed/simple;
	bh=nN6yN+CMxT/rwPXTIOgIHom//7N9A2nEwy43KuxHSz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rNpsoxvTvUrnzcyV0TUf6/SslGZpYoHXgLA0w0PrjKv8pN6PFxG+ea3KwTyJDT7X6t7LBTsnMrVTxvSBzbd5BgnZApi0feh1zZAKuLBWhE+0ZLNS8FhNYg/3w9+3aMLthWAc6EKVXpFlpMaa2nCeaLCp4efIkJqqb5A/+2/1++s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of9onT9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of9onT9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94052C4CECE;
	Thu, 12 Dec 2024 17:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023124;
	bh=nN6yN+CMxT/rwPXTIOgIHom//7N9A2nEwy43KuxHSz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=of9onT9q9/dzredjyUhOrrcs3p0HLM43qq6zSXNSOU5z11u5wiqYR8IO6Cz+VVCz9
	 JbbO9cMXi2NbiWHIJ11uGqHQU9b05pNbMWlmLUJQ3spKe5orhotXnwXYNzE8z5yiTa
	 gcoSBS4ol5PEW9zQ6ZwpEJo+vIO3mbd0mSfPWUSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <quentin@isovalent.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/565] bpftool: Remove asserts from JIT disassembler
Date: Thu, 12 Dec 2024 16:00:27 +0100
Message-ID: <20241212144328.761983849@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit 55b4de58d0e2aca810ed2b198a0173640300acf8 ]

The JIT disassembler in bpftool is the only components (with the JSON
writer) using asserts to check the return values of functions. But it
does not do so in a consistent way, and diasm_print_insn() returns no
value, although sometimes the operation failed.

Remove the asserts, and instead check the return values, print messages
on errors, and propagate the error to the caller from prog.c.

Remove the inclusion of assert.h from jit_disasm.c, and also from map.c
where it is unused.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Tested-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20221025150329.97371-3-quentin@isovalent.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: ef3ba8c258ee ("bpftool: fix potential NULL pointer dereferencing in prog_dump()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/jit_disasm.c | 51 +++++++++++++++++++++++-----------
 tools/bpf/bpftool/main.h       | 25 +++++++++--------
 tools/bpf/bpftool/map.c        |  1 -
 tools/bpf/bpftool/prog.c       | 15 ++++++----
 4 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index aaf99a0168c90..fe23c9669a876 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -16,7 +16,6 @@
 #include <stdarg.h>
 #include <stdint.h>
 #include <stdlib.h>
-#include <assert.h>
 #include <unistd.h>
 #include <string.h>
 #include <bfd.h>
@@ -29,14 +28,18 @@
 #include "json_writer.h"
 #include "main.h"
 
-static void get_exec_path(char *tpath, size_t size)
+static int get_exec_path(char *tpath, size_t size)
 {
 	const char *path = "/proc/self/exe";
 	ssize_t len;
 
 	len = readlink(path, tpath, size - 1);
-	assert(len > 0);
+	if (len <= 0)
+		return -1;
+
 	tpath[len] = 0;
+
+	return 0;
 }
 
 static int oper_count;
@@ -97,30 +100,39 @@ static int fprintf_json_styled(void *out,
 	return r;
 }
 
-void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
-		       const char *arch, const char *disassembler_options,
-		       const struct btf *btf,
-		       const struct bpf_prog_linfo *prog_linfo,
-		       __u64 func_ksym, unsigned int func_idx,
-		       bool linum)
+int disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
+		      const char *arch, const char *disassembler_options,
+		      const struct btf *btf,
+		      const struct bpf_prog_linfo *prog_linfo,
+		      __u64 func_ksym, unsigned int func_idx,
+		      bool linum)
 {
 	const struct bpf_line_info *linfo = NULL;
 	disassembler_ftype disassemble;
+	int count, i, pc = 0, err = -1;
 	struct disassemble_info info;
 	unsigned int nr_skip = 0;
-	int count, i, pc = 0;
 	char tpath[PATH_MAX];
 	bfd *bfdf;
 
 	if (!len)
-		return;
+		return -1;
 
 	memset(tpath, 0, sizeof(tpath));
-	get_exec_path(tpath, sizeof(tpath));
+	if (get_exec_path(tpath, sizeof(tpath))) {
+		p_err("failed to create disasembler (get_exec_path)");
+		return -1;
+	}
 
 	bfdf = bfd_openr(tpath, NULL);
-	assert(bfdf);
-	assert(bfd_check_format(bfdf, bfd_object));
+	if (!bfdf) {
+		p_err("failed to create disassembler (bfd_openr)");
+		return -1;
+	}
+	if (!bfd_check_format(bfdf, bfd_object)) {
+		p_err("failed to create disassembler (bfd_check_format)");
+		goto exit_close;
+	}
 
 	if (json_output)
 		init_disassemble_info_compat(&info, stdout,
@@ -139,7 +151,7 @@ void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
 			bfdf->arch_info = inf;
 		} else {
 			p_err("No libbfd support for %s", arch);
-			return;
+			goto exit_close;
 		}
 	}
 
@@ -160,7 +172,10 @@ void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
 #else
 	disassemble = disassembler(bfdf);
 #endif
-	assert(disassemble);
+	if (!disassemble) {
+		p_err("failed to create disassembler");
+		goto exit_close;
+	}
 
 	if (json_output)
 		jsonw_start_array(json_wtr);
@@ -224,7 +239,11 @@ void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
+	err = 0;
+
+exit_close:
 	bfd_close(bfdf);
+	return err;
 }
 
 int disasm_init(void)
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 90caa42aac4cf..834f8317b855f 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -193,22 +193,23 @@ int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len);
 
 struct bpf_prog_linfo;
 #ifdef HAVE_LIBBFD_SUPPORT
-void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
-		       const char *arch, const char *disassembler_options,
-		       const struct btf *btf,
-		       const struct bpf_prog_linfo *prog_linfo,
-		       __u64 func_ksym, unsigned int func_idx,
-		       bool linum);
+int disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
+		      const char *arch, const char *disassembler_options,
+		      const struct btf *btf,
+		      const struct bpf_prog_linfo *prog_linfo,
+		      __u64 func_ksym, unsigned int func_idx,
+		      bool linum);
 int disasm_init(void);
 #else
 static inline
-void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
-		       const char *arch, const char *disassembler_options,
-		       const struct btf *btf,
-		       const struct bpf_prog_linfo *prog_linfo,
-		       __u64 func_ksym, unsigned int func_idx,
-		       bool linum)
+int disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
+		      const char *arch, const char *disassembler_options,
+		      const struct btf *btf,
+		      const struct bpf_prog_linfo *prog_linfo,
+		      __u64 func_ksym, unsigned int func_idx,
+		      bool linum)
 {
+	return 0;
 }
 static inline int disasm_init(void)
 {
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 72ef9ddae2609..c775a677688ae 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2017-2018 Netronome Systems, Inc. */
 
-#include <assert.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <linux/err.h>
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index afb28fcc66786..75f71c3ad4f62 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -744,10 +744,11 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 					printf("%s:\n", sym_name);
 				}
 
-				disasm_print_insn(img, lens[i], opcodes,
-						  name, disasm_opt, btf,
-						  prog_linfo, ksyms[i], i,
-						  linum);
+				if (disasm_print_insn(img, lens[i], opcodes,
+						      name, disasm_opt, btf,
+						      prog_linfo, ksyms[i], i,
+						      linum))
+					goto exit_free;
 
 				img += lens[i];
 
@@ -760,8 +761,10 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 			if (json_output)
 				jsonw_end_array(json_wtr);
 		} else {
-			disasm_print_insn(buf, member_len, opcodes, name,
-					  disasm_opt, btf, NULL, 0, 0, false);
+			if (disasm_print_insn(buf, member_len, opcodes, name,
+					      disasm_opt, btf, NULL, 0, 0,
+					      false))
+				goto exit_free;
 		}
 	} else if (visual) {
 		if (json_output)
-- 
2.43.0



