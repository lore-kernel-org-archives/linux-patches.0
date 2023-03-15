Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11CD4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6E5C433EF;
	Wed, 15 Mar 2023 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883418;
	bh=+effdjfC/iKhxl10KEpAkVUiTRlr463FYn8RFiE1CPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S23Xfel9JNVijBsRa/blR1eXDS4Pkv0MUQ9k5O+8tbdIqOI2medDnN98ernHI5rpZ
	 KadMGDk2LrGDd4mCp2hmTAqz793eUw2d7wNxFDawXrSG6Sp4v+fQz88qJfj67yPSLs
	 jeg4jUZE8hd7ddF+RUbnPoQtg7IB+PBKrmOLG9ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andres Freund <andres@anarazel.de>,
	Ben Hutchings <benh@debian.org>,
	Quentin Monnet <quentin@isovalent.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	bpf@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5.15 135/145] tools include: add dis-asm-compat.h to handle version differences
Date: Wed, 15 Mar 2023 13:13:21 +0100
Message-Id: <20230315115743.381654201@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andres Freund <andres@anarazel.de>

commit a45b3d6926231c3d024ea0de4f7bd967f83709ee upstream.

binutils changed the signature of init_disassemble_info(), which now causes
compilation failures for tools/{perf,bpf}, e.g. on debian unstable.

Relevant binutils commit:

  https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=60a3da00bd5407f07

This commit introduces a wrapper for init_disassemble_info(), to avoid
spreading #ifdef DISASM_INIT_STYLED to a bunch of places. Subsequent
commits will use it to fix the build failures.

It likely is worth adding a wrapper for disassember(), to avoid the already
existing DISASM_FOUR_ARGS_SIGNATURE ifdefery.

Signed-off-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Ben Hutchings <benh@debian.org>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Ben Hutchings <benh@debian.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: bpf@vger.kernel.org
Link: http://lore.kernel.org/lkml/20220622181918.ykrs5rsnmx3og4sv@alap3.anarazel.de
Link: https://lore.kernel.org/r/20220801013834.156015-4-andres@anarazel.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/tools/dis-asm-compat.h |   55 +++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 tools/include/tools/dis-asm-compat.h

--- /dev/null
+++ b/tools/include/tools/dis-asm-compat.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
+#ifndef _TOOLS_DIS_ASM_COMPAT_H
+#define _TOOLS_DIS_ASM_COMPAT_H
+
+#include <stdio.h>
+#include <dis-asm.h>
+
+/* define types for older binutils version, to centralize ifdef'ery a bit */
+#ifndef DISASM_INIT_STYLED
+enum disassembler_style {DISASSEMBLER_STYLE_NOT_EMPTY};
+typedef int (*fprintf_styled_ftype) (void *, enum disassembler_style, const char*, ...);
+#endif
+
+/*
+ * Trivial fprintf wrapper to be used as the fprintf_styled_func argument to
+ * init_disassemble_info_compat() when normal fprintf suffices.
+ */
+static inline int fprintf_styled(void *out,
+				 enum disassembler_style style,
+				 const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	(void)style;
+
+	va_start(args, fmt);
+	r = vfprintf(out, fmt, args);
+	va_end(args);
+
+	return r;
+}
+
+/*
+ * Wrapper for init_disassemble_info() that hides version
+ * differences. Depending on binutils version and architecture either
+ * fprintf_func or fprintf_styled_func will be called.
+ */
+static inline void init_disassemble_info_compat(struct disassemble_info *info,
+						void *stream,
+						fprintf_ftype unstyled_func,
+						fprintf_styled_ftype styled_func)
+{
+#ifdef DISASM_INIT_STYLED
+	init_disassemble_info(info, stream,
+			      unstyled_func,
+			      styled_func);
+#else
+	(void)styled_func;
+	init_disassemble_info(info, stream,
+			      unstyled_func);
+#endif
+}
+
+#endif /* _TOOLS_DIS_ASM_COMPAT_H */


