Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7822E22EA07;
	Thu, 12 Dec 2024 16:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020991; cv=none; b=bE5+KRFGiW3Gs5YGs9oh18OEWN+mHYkvfCfXxRob/fwu8+s4aYP6Hs5R4+ma7SjjOtBAI9KS5Qt214wm8RN1XhmGXl3fB5/WuxkeYdos3DBVADoYfGOEE2wM9A8IzbZa8d8mRtNT0O13NIwU2aZ6E1hSKhXOm206aGnblVtpE0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020991; c=relaxed/simple;
	bh=m4VYCHE42hblRj88jmfHjpNv84gBpke4Nf7Z9cZnsos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JLi2xYTmVy+TmXc+QGYxhMQ2Klc9PBZJQ8kwRJjadKlp4Tnj/+nZGhEg1S4kvH6sE2+cstWajpS07ry09CGQNY2GNQQXul/qIS2xweBc4hBTQ6UdsobvR1OHvTdXxVJdWnVe2SzPTT4FMRiKc6vB2QKSsKbxqn0x4Wh808o/L9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsw+P13S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsw+P13S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F15C4CED0;
	Thu, 12 Dec 2024 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020991;
	bh=m4VYCHE42hblRj88jmfHjpNv84gBpke4Nf7Z9cZnsos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsw+P13Sscn7/t4AVX70LwQNwMNBCPneK4CGrnTBxTbSCjZKHO23VdkH6eqOciVmZ
	 siT5LvkGmv1anBDJvEQdMXpINMkF7np8d/l1FrmThKLJjYHm7cIU0F/qV7zpcLhO+W
	 Rl78MCnOldjMjUmHURYutnq9RjlCPbWel7n0B/Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <quentin@isovalent.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 586/772] bpftool: Remove asserts from JIT disassembler
Date: Thu, 12 Dec 2024 15:58:51 +0100
Message-ID: <20241212144414.151674315@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5e5060c2ac047..c9e171082cf61 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -173,22 +173,23 @@ int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len);
 
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
index 9a6ca9f311338..3087ced658adc 100644
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
index 7e0b846e17eef..801e564b055a0 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -820,10 +820,11 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
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
 
@@ -836,8 +837,10 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
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



