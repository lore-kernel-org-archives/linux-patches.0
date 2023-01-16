Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F3246B5;
	Mon, 16 Jan 2023 16:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDB3C433D2;
	Mon, 16 Jan 2023 16:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885136;
	bh=CSrRJ986c/JIm2YrOkIYvHtg6w8N8JFB+1PNV4e3WI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5CwCPtSMMWOAAO0nb90IReqvzU66ULDp2HFjqlZwqS8Sm+NqdSJRsChjazyGl4Vo
	 oOyQDUX9fE8P9Y2uW7moidI3Rrx8r0u4h6OasWMgvaTdICeOTq/uWydeRe0RtM56wt
	 KS1WEomp7E+aD+N+GCjExOViKE3an/hgLNKJFNvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	llvm@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Willy Tarreau <w@1wt.eu>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 64/86] tools/nolibc: Remove .global _start from the entry point code
Date: Mon, 16 Jan 2023 16:51:38 +0100
Message-Id: <20230116154749.706768804@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

[ Upstream commit 1590c59836dace3a20945bad049fe8802c4e6f3f ]

Building with clang yields the following error:
```
  <inline asm>:3:1: error: _start changed binding to STB_GLOBAL
  .global _start
  ^
  1 error generated.
```
Make sure only specify one between `.global _start` and `.weak _start`.
Remove `.global _start`.

Cc: llvm@lists.linux.dev
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 184177c3d6e0 ("tools/nolibc: restore mips branch ordering in the _start block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-aarch64.h | 1 -
 tools/include/nolibc/arch-arm.h     | 1 -
 tools/include/nolibc/arch-i386.h    | 1 -
 tools/include/nolibc/arch-mips.h    | 1 -
 tools/include/nolibc/arch-riscv.h   | 1 -
 tools/include/nolibc/arch-x86_64.h  | 1 -
 6 files changed, 6 deletions(-)

diff --git a/tools/include/nolibc/arch-aarch64.h b/tools/include/nolibc/arch-aarch64.h
index 87d9e434820c..2dbd80d633cb 100644
--- a/tools/include/nolibc/arch-aarch64.h
+++ b/tools/include/nolibc/arch-aarch64.h
@@ -184,7 +184,6 @@ struct sys_stat_struct {
 /* startup code */
 asm(".section .text\n"
     ".weak _start\n"
-    ".global _start\n"
     "_start:\n"
     "ldr x0, [sp]\n"              // argc (x0) was in the stack
     "add x1, sp, 8\n"             // argv (x1) = sp
diff --git a/tools/include/nolibc/arch-arm.h b/tools/include/nolibc/arch-arm.h
index 001a3c8c9ad5..1191395b5acd 100644
--- a/tools/include/nolibc/arch-arm.h
+++ b/tools/include/nolibc/arch-arm.h
@@ -177,7 +177,6 @@ struct sys_stat_struct {
 /* startup code */
 asm(".section .text\n"
     ".weak _start\n"
-    ".global _start\n"
     "_start:\n"
 #if defined(__THUMBEB__) || defined(__THUMBEL__)
     /* We enter here in 32-bit mode but if some previous functions were in
diff --git a/tools/include/nolibc/arch-i386.h b/tools/include/nolibc/arch-i386.h
index d7e4d53325a3..125a691fc631 100644
--- a/tools/include/nolibc/arch-i386.h
+++ b/tools/include/nolibc/arch-i386.h
@@ -176,7 +176,6 @@ struct sys_stat_struct {
  */
 asm(".section .text\n"
     ".weak _start\n"
-    ".global _start\n"
     "_start:\n"
     "pop %eax\n"                // argc   (first arg, %eax)
     "mov %esp, %ebx\n"          // argv[] (second arg, %ebx)
diff --git a/tools/include/nolibc/arch-mips.h b/tools/include/nolibc/arch-mips.h
index c9a6aac87c6d..1a124790c99f 100644
--- a/tools/include/nolibc/arch-mips.h
+++ b/tools/include/nolibc/arch-mips.h
@@ -192,7 +192,6 @@ struct sys_stat_struct {
 asm(".section .text\n"
     ".weak __start\n"
     ".set nomips16\n"
-    ".global __start\n"
     ".set    noreorder\n"
     ".option pic0\n"
     ".ent __start\n"
diff --git a/tools/include/nolibc/arch-riscv.h b/tools/include/nolibc/arch-riscv.h
index bc10b7b5706d..511d67fc534e 100644
--- a/tools/include/nolibc/arch-riscv.h
+++ b/tools/include/nolibc/arch-riscv.h
@@ -185,7 +185,6 @@ struct sys_stat_struct {
 /* startup code */
 asm(".section .text\n"
     ".weak _start\n"
-    ".global _start\n"
     "_start:\n"
     ".option push\n"
     ".option norelax\n"
diff --git a/tools/include/nolibc/arch-x86_64.h b/tools/include/nolibc/arch-x86_64.h
index fe517c16cd4d..b1af63ce1cb0 100644
--- a/tools/include/nolibc/arch-x86_64.h
+++ b/tools/include/nolibc/arch-x86_64.h
@@ -199,7 +199,6 @@ struct sys_stat_struct {
  */
 asm(".section .text\n"
     ".weak _start\n"
-    ".global _start\n"
     "_start:\n"
     "pop %rdi\n"                // argc   (first arg, %rdi)
     "mov %rsp, %rsi\n"          // argv[] (second arg, %rsi)
-- 
2.35.1



