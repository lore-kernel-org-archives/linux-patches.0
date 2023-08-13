Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CACE9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FB1C433C7;
	Sun, 13 Aug 2023 21:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962912;
	bh=7wmk6CBTwoxm8VNWI5yv0q2aS3WASm/f6uAQjYN81QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=138qskRZmxKNZNYjLr/TTr4zMSNaBqN9KQSQNZ4HF15+WdnbMlt3KNxRGB7uo4YZb
	 lJ+q5sOp70NCEXbIADFdkJOLzz1njOPYMY16BZ+C7U+oI3fLabq1VxcbkBj3klZZp9
	 HP/DenZz8IgY2QnDjwqEZ926e/mT+zpyhDm19APc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Daniel Kolesa <daniel@octaforge.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Sven Volkinsfeld <thyrc@gmx.net>,
	Nick Desaulniers <ndesaulniers@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 25/68] x86/srso: Fix build breakage with the LLVM linker
Date: Sun, 13 Aug 2023 23:19:26 +0200
Message-ID: <20230813211708.922155269@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nick Desaulniers <ndesaulniers@google.com>

commit cbe8ded48b939b9d55d2c5589ab56caa7b530709 upstream.

The assertion added to verify the difference in bits set of the
addresses of srso_untrain_ret_alias() and srso_safe_ret_alias() would fail
to link in LLVM's ld.lld linker with the following error:

  ld.lld: error: ./arch/x86/kernel/vmlinux.lds:210: at least one side of
  the expression must be absolute
  ld.lld: error: ./arch/x86/kernel/vmlinux.lds:211: at least one side of
  the expression must be absolute

Use ABSOLUTE to evaluate the expression referring to at least one of the
symbols so that LLD can evaluate the linker script.

Also, add linker version info to the comment about XOR being unsupported
in either ld.bfd or ld.lld until somewhat recently.

Fixes: fb3bd914b3ec ("x86/srso: Add a Speculative RAS Overflow mitigation")
Closes: https://lore.kernel.org/llvm/CA+G9fYsdUeNu-gwbs0+T6XHi4hYYk=Y9725-wFhZ7gJMspLDRA@mail.gmail.com/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Daniel Kolesa <daniel@octaforge.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Suggested-by: Sven Volkinsfeld <thyrc@gmx.net>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://github.com/ClangBuiltLinux/linux/issues/1907
Link: https://lore.kernel.org/r/20230809-gds-v1-1-eaac90b0cbcc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/vmlinux.lds.S |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -524,11 +524,17 @@ INIT_PER_CPU(irq_stack_backing_store);
 
 #ifdef CONFIG_CPU_SRSO
 /*
- * GNU ld cannot do XOR so do: (A | B) - (A & B) in order to compute the XOR
+ * GNU ld cannot do XOR until 2.41.
+ * https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=f6f78318fca803c4907fb8d7f6ded8295f1947b1
+ *
+ * LLVM lld cannot do XOR until lld-17.
+ * https://github.com/llvm/llvm-project/commit/fae96104d4378166cbe5c875ef8ed808a356f3fb
+ *
+ * Instead do: (A | B) - (A & B) in order to compute the XOR
  * of the two function addresses:
  */
-. = ASSERT(((srso_untrain_ret_alias | srso_safe_ret_alias) -
-		(srso_untrain_ret_alias & srso_safe_ret_alias)) == ((1 << 2) | (1 << 8) | (1 << 14) | (1 << 20)),
+. = ASSERT(((ABSOLUTE(srso_untrain_ret_alias) | srso_safe_ret_alias) -
+		(ABSOLUTE(srso_untrain_ret_alias) & srso_safe_ret_alias)) == ((1 << 2) | (1 << 8) | (1 << 14) | (1 << 20)),
 		"SRSO function pair won't alias");
 #endif
 


