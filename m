Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672AD29CE7;
	Wed,  2 Oct 2024 13:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877133; cv=none; b=n8ATckmnglofiQRcOV/1+0CculqnVVZZ/t8QlqsIkuMyeaC7Bk2gz057ylfhMt60THkUSGWcx6gl7BKsHJozI0zJViuGWVXU0L3x0b97lvDo+iviv69+rvFnm+pqb6u3sUyv1fcPi8fnCrzX3R8vdAShFPril8IRIGhJ3ri7Ln4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877133; c=relaxed/simple;
	bh=qVzjrPUl0XfRCzhhdNEozQ28WSr93p0+g60hKGz84I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxjtL58ZbUFtBzcgvXy0HbLFVMYzJp/p7g8dgo90aXisXrGszBjVvMvLQW6lpl/wZCq2VbWvsDpgusi8beW4k5ra5/u7Fn8njLNy/37AG1dIy6DYhORy0WrnU+KUrS+EtsAWRLm5MopE19GOsmluTiB1ldO1eD3y1AWrXyoF7MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXkKc0ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXkKc0ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F18C4CEC2;
	Wed,  2 Oct 2024 13:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877133;
	bh=qVzjrPUl0XfRCzhhdNEozQ28WSr93p0+g60hKGz84I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXkKc0ht7tQqJH8o1yZj4w9FSmf/5wmB44LEiX7WmE73tsBoQDFx6XvXPGJIfJ8T3
	 BNt265dyOnCU9IbRH581EEuexVZmopBAjVMIy+igMMlnLyFNCSYI6IeA6waZUEKwT8
	 ZlogF0E8tsnwjqFwazZJJbsBKgzhgMmSDFC2SRoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 676/695] compiler.h: specify correct attribute for .rodata..c_jump_table
Date: Wed,  2 Oct 2024 15:01:14 +0200
Message-ID: <20241002125849.498311528@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit c5b1184decc819756ae549ba54c63b6790c4ddfd upstream.

Currently, there is an assembler message when generating kernel/bpf/core.o
under CONFIG_OBJTOOL with LoongArch compiler toolchain:

  Warning: setting incorrect section attributes for .rodata..c_jump_table

This is because the section ".rodata..c_jump_table" should be readonly,
but there is a "W" (writable) part of the flags:

  $ readelf -S kernel/bpf/core.o | grep -A 1 "rodata..c"
  [34] .rodata..c_j[...] PROGBITS         0000000000000000  0000d2e0
       0000000000000800  0000000000000000  WA       0     0     8

There is no above issue on x86 due to the generated section flag is only
"A" (allocatable). In order to silence the warning on LoongArch, specify
the attribute like ".rodata..c_jump_table,\"a\",@progbits #" explicitly,
then the section attribute of ".rodata..c_jump_table" must be readonly
in the kernel/bpf/core.o file.

Before:

  $ objdump -h kernel/bpf/core.o | grep -A 1 "rodata..c"
   21 .rodata..c_jump_table 00000800  0000000000000000  0000000000000000  0000d2e0  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, DATA

After:

  $ objdump -h kernel/bpf/core.o | grep -A 1 "rodata..c"
   21 .rodata..c_jump_table 00000800  0000000000000000  0000000000000000  0000d2e0  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA

By the way, AFAICT, maybe the root cause is related with the different
compiler behavior of various archs, so to some extent this change is a
workaround for LoongArch, and also there is no effect for x86 which is the
only port supported by objtool before LoongArch with this patch.

Link: https://lkml.kernel.org/r/20240924062710.1243-1-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>	[6.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -133,7 +133,7 @@ void ftrace_likely_update(struct ftrace_
 #define annotate_unreachable() __annotate_unreachable(__COUNTER__)
 
 /* Annotate a C jump table to allow objtool to follow the code flow */
-#define __annotate_jump_table __section(".rodata..c_jump_table")
+#define __annotate_jump_table __section(".rodata..c_jump_table,\"a\",@progbits #")
 
 #else /* !CONFIG_OBJTOOL */
 #define annotate_reachable()


