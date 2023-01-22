Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63862590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A229C433EF;
	Sun, 22 Jan 2023 15:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401277;
	bh=2awkV/Mup82aTVUp+wDSA8RjQGb/SKRWMP/nnLhK6bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHV2gpYzx1hwj5zpOCX5oRn9xeNFc8LiozFZDKJ3jfE1QfksO1t9UnLEHNwwC/s4z
	 Izz2hWunoccD/oKMkyS0ZLCkEYbKihfcC+2rwa/36FpbwqA3LoKlUlE1Xz5Cg+muBS
	 zaL01ZuvjhbERgDXSNSWG9de/axyQ9vWgv4eF+MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Gilmore <dennis@ausil.us>,
	Ard Biesheuvel <ardb@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 160/193] arch: fix broken BuildID for arm64 and riscv
Date: Sun, 22 Jan 2023 16:04:49 +0100
Message-Id: <20230122150253.715751257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -929,7 +929,12 @@
 #define PRINTK_INDEX
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\


