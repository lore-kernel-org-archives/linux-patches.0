Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D715B3659ED;
	Tue, 16 Dec 2025 12:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887053; cv=none; b=cl96ryudFlgfPSmoRXYzZbeflcwU3Wr9AIgI9EH5LP/mWewDqL5VsjlEbuh9JWGBJBX7ufB7vGvwwEHAxZ+OrPuQ5tzJGaLKHg+t7RxVHTCG/SY2/TtWNST5KSadQxZCjOofKRU1QiFjJPe6YNc1H1XeUWJ9u0QfTEkyefgmJTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887053; c=relaxed/simple;
	bh=VNmuyuKlUF3ANPhwGy/IuxgcYglYFbqxyN8xBrekwXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VH4Xy9vDbnECCsCWFQRwYtK+SZc06fwrXipuRMD1CEom95kSp9KWusy903UK8VJBwCkfVDZ6cfm6RRrinS5Arv7J9AK2zLieZtMGxuZYrv0Ot9ki7jbvcTp061U/ZKIjNJxs2W7V5PxTjyQnkak1X7czbqDeo07vElHgQwlQDys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMZSiyei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMZSiyei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40222C4CEF1;
	Tue, 16 Dec 2025 12:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887052;
	bh=VNmuyuKlUF3ANPhwGy/IuxgcYglYFbqxyN8xBrekwXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMZSiyeitWLNQW8btT0zxJoLzj1fsOmsSnHZxg4PzXA68n3lpYgXP9wnhY0DjuEq3
	 NXHEODAbWmBw28kGWasfrCTNDB0GK3yy2kUDytqHPw7sfrPRZh7KTE7Ama3258JdiO
	 BFe22Q7lZS0jgJ0A/2BKhQryn290JaPvDIk4ZUkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/614] tools/nolibc: x86: fix section mismatch caused by asm "mem*" functions
Date: Tue, 16 Dec 2025 12:08:00 +0100
Message-ID: <20251216111405.430638736@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 2602949b22330f1275138e2b5aea5d49126b9757 ]

I recently got occasional build failures at -Os or -Oz that would always
involve waitpid(), where the assembler would complain about this:

   init.s: Error: .size expression for waitpid.constprop.0 does not evaluate to a constant

And without -fno-asynchronous-unwind-tables it could also spit such
errors:

  init.s:836: Error: CFI instruction used without previous .cfi_startproc
  init.s:838: Error: .cfi_endproc without corresponding .cfi_startproc
  init.s: Error: open CFI at the end of file; missing .cfi_endproc directive

A trimmed down reproducer is as simple as this:

  int main(int argc, char **argv)
  {
        int ret, status;

        if (argc == 0)
                ret = waitpid(-1, &status, 0);
        else
                ret = waitpid(-1, &status, 0);

        return status;
  }

It produces the following asm code on x86_64:

        .text
  .section .text.nolibc_memmove_memcpy
  .weak memmove
  .weak memcpy
  memmove:
  memcpy:
        movq %rdx, %rcx
	(...)
        retq
  .section .text.nolibc_memset
  .weak memset
  memset:
        xchgl %eax, %esi
        movq  %rdx, %rcx
        pushq %rdi
        rep stosb
        popq  %rax
        retq

        .type	waitpid.constprop.0.isra.0, @function
  waitpid.constprop.0.isra.0:
        subq	$8, %rsp
        (...)
        jmp	*.L5(,%rax,8)
        .section	.rodata
        .align 8
        .align 4
  .L5:
        .quad	.L10
        (...)
        .quad	.L4
        .text
  .L10:
        (...)
        .cfi_def_cfa_offset 8
        ret
        .cfi_endproc
  .LFE273:
        .size	waitpid.constprop.0.isra.0, .-waitpid.constprop.0.isra.0

It's a bit dense, but here's the explanation: the compiler has emitted a
".text" statement because it knows it's working in the .text section.

Then, our hand-written asm code for the mem* functions forced the section
to .text.something without the compiler knowing about it, so it thinks
the code is still being emitted for .text. As such, without any .section
statement, the waitpid.constprop.0.isra.0 label is in fact placed in the
previously created section, here .text.nolibc_memset.

The waitpid() function involves a switch/case statement that can be
turned to a jump table, which is what the compiler does with the .rodata
section, and after that it restores .text, which is no longer the
previous .text.nolibc_memset section. Then the CFI statements cross a
section, so does the .size calculation, which explains the error.

While a first approach consisting in placing an explicit ".text" at the
end of these functions was verified to work, it's still unreliable as
it depends on what the compiler remembers having emitted previously. A
better approach is to replace the ".section" with ".pushsection", and
place a ".popsection" at the end, so that these code blocks are agnostic
to where they're placed relative to other blocks.

Fixes: 553845eebd60 ("tools/nolibc: x86-64: Use `rep movsb` for `memcpy()` and `memmove()`")
Fixes: 12108aa8c1a1 ("tools/nolibc: x86-64: Use `rep stosb` for `memset()`")
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-x86.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/include/nolibc/arch-x86.h b/tools/include/nolibc/arch-x86.h
index d3efc0c3b8adc..c8b0c3e624a51 100644
--- a/tools/include/nolibc/arch-x86.h
+++ b/tools/include/nolibc/arch-x86.h
@@ -351,7 +351,7 @@ void *memcpy(void *dst, const void *src, size_t len);
 void *memset(void *dst, int c, size_t len);
 
 __asm__ (
-".section .text.nolibc_memmove_memcpy\n"
+".pushsection .text.nolibc_memmove_memcpy\n"
 ".weak memmove\n"
 ".weak memcpy\n"
 "memmove:\n"
@@ -371,8 +371,9 @@ __asm__ (
 	"rep movsb\n\t"
 	"cld\n\t"
 	"retq\n"
+".popsection\n"
 
-".section .text.nolibc_memset\n"
+".pushsection .text.nolibc_memset\n"
 ".weak memset\n"
 "memset:\n"
 	"xchgl %eax, %esi\n\t"
@@ -381,6 +382,7 @@ __asm__ (
 	"rep stosb\n\t"
 	"popq  %rax\n\t"
 	"retq\n"
+".popsection\n"
 );
 
 #endif /* !defined(__x86_64__) */
-- 
2.51.0



