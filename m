Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB64518654
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30562C433C8;
	Wed, 20 Sep 2023 11:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210488;
	bh=5gV9nfRFxasFUOgF4YRwWRuyU9ymGHp2alYhcDnerAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkMmgCWyC0mu1D6mJedT3CkwTnCvaexvf0gB5ODid/YvSUL942s4h0Ovi91EcutXO
	 08QNWXwTBB3B2MJoxzVlmKGd5x4jxgKSjJYK8HejFrSo+ZPOZ2dX1/A8eBJqXnNsrD
	 HxvTVEhH+GOsdExb2kCCfeykh8lCMDLo5151UdNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 094/211] x86: bring back rep movsq for user access on CPUs without ERMS
Date: Wed, 20 Sep 2023 13:28:58 +0200
Message-ID: <20230920112848.726459338@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit ca96b162bfd21a5d55e3cd6099e4ee357a0eeb68 ]

Intel CPUs ship with ERMS for over a decade, but this is not true for
AMD.  In particular one reasonably recent uarch (EPYC 7R13) does not
have it (or at least the bit is inactive when running on the Amazon EC2
cloud -- I found rather conflicting information about AMD CPUs vs the
extension).

Hand-rolled mov loops executing in this case are quite pessimal compared
to rep movsq for bigger sizes.  While the upper limit depends on uarch,
everyone is well south of 1KB AFAICS and sizes bigger than that are
common.

While technically ancient CPUs may be suffering from rep usage, gcc has
been emitting it for years all over kernel code, so I don't think this
is a legitimate concern.

Sample result from read1_processes from will-it-scale (4KB reads/s):

  before:   1507021
  after:    1721828 (+14%)

Note that the cutoff point for rep usage is set to 64 bytes, which is
way too conservative but I'm sticking to what was done in 47ee3f1dd93b
("x86: re-introduce support for ERMS copies for user space accesses").
That is to say *some* copies will now go slower, which is fixable but
beyond the scope of this patch.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/uaccess_64.h |  2 +-
 arch/x86/lib/copy_user_64.S       | 57 +++++++------------------------
 2 files changed, 14 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 81b826d3b7530..f2c02e4469ccc 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -116,7 +116,7 @@ copy_user_generic(void *to, const void *from, unsigned long len)
 		"2:\n"
 		_ASM_EXTABLE_UA(1b, 2b)
 		:"+c" (len), "+D" (to), "+S" (from), ASM_CALL_CONSTRAINT
-		: : "memory", "rax", "r8", "r9", "r10", "r11");
+		: : "memory", "rax");
 	clac();
 	return len;
 }
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 01c5de4c279b8..0a81aafed7f88 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -27,7 +27,7 @@
  * NOTE! The calling convention is very intentionally the same as
  * for 'rep movs', so that we can rewrite the function call with
  * just a plain 'rep movs' on machines that have FSRM.  But to make
- * it simpler for us, we can clobber rsi/rdi and rax/r8-r11 freely.
+ * it simpler for us, we can clobber rsi/rdi and rax freely.
  */
 SYM_FUNC_START(rep_movs_alternative)
 	cmpq $64,%rcx
@@ -68,55 +68,24 @@ SYM_FUNC_START(rep_movs_alternative)
 	_ASM_EXTABLE_UA( 3b, .Lcopy_user_tail)
 
 .Llarge:
-0:	ALTERNATIVE "jmp .Lunrolled", "rep movsb", X86_FEATURE_ERMS
+0:	ALTERNATIVE "jmp .Llarge_movsq", "rep movsb", X86_FEATURE_ERMS
 1:	RET
 
-        _ASM_EXTABLE_UA( 0b, 1b)
+	_ASM_EXTABLE_UA( 0b, 1b)
 
-	.p2align 4
-.Lunrolled:
-10:	movq (%rsi),%r8
-11:	movq 8(%rsi),%r9
-12:	movq 16(%rsi),%r10
-13:	movq 24(%rsi),%r11
-14:	movq %r8,(%rdi)
-15:	movq %r9,8(%rdi)
-16:	movq %r10,16(%rdi)
-17:	movq %r11,24(%rdi)
-20:	movq 32(%rsi),%r8
-21:	movq 40(%rsi),%r9
-22:	movq 48(%rsi),%r10
-23:	movq 56(%rsi),%r11
-24:	movq %r8,32(%rdi)
-25:	movq %r9,40(%rdi)
-26:	movq %r10,48(%rdi)
-27:	movq %r11,56(%rdi)
-	addq $64,%rsi
-	addq $64,%rdi
-	subq $64,%rcx
-	cmpq $64,%rcx
-	jae .Lunrolled
-	cmpl $8,%ecx
-	jae .Lword
+.Llarge_movsq:
+	movq %rcx,%rax
+	shrq $3,%rcx
+	andl $7,%eax
+0:	rep movsq
+	movl %eax,%ecx
 	testl %ecx,%ecx
 	jne .Lcopy_user_tail
 	RET
 
-	_ASM_EXTABLE_UA(10b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(11b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(12b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(13b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(14b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(15b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(16b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(17b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(20b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(21b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(22b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(23b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(24b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(25b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(26b, .Lcopy_user_tail)
-	_ASM_EXTABLE_UA(27b, .Lcopy_user_tail)
+1:	leaq (%rax,%rcx,8),%rcx
+	jmp .Lcopy_user_tail
+
+	_ASM_EXTABLE_UA( 0b, 1b)
 SYM_FUNC_END(rep_movs_alternative)
 EXPORT_SYMBOL(rep_movs_alternative)
-- 
2.40.1



