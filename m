Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00017E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC8CC433D2;
	Sun, 22 Jan 2023 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400237;
	bh=e+PF06QJcCVyj3agoAqZJPaMGeB6uAZNsZaJAzSP1DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMMQaQbYvfzua2WcyJ6PZgUfMqDHGFShCvGI8A6jH/ck588YkCWB1Mi73KkLGPmtK
	 h1ddkTTlFuWrA1JGHwiQZCCzN4ZzMheAp5jhRGTt43E0QOZdfN4xq5hIY21ayYWuUZ
	 ng68jjL1DHbRusEGKriSoRdXU8kLOP0WqpOHq48A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 55/55] powerpc/vmlinux.lds: Dont discard .comment
Date: Sun, 22 Jan 2023 16:04:42 +0100
Message-Id: <20230122150224.468613914@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Ellerman <mpe@ellerman.id.au>

commit be5f95c8779e19779dd81927c8574fec5aaba36c upstream.

Although the powerpc linker script mentions .comment in the DISCARD
section, that has never actually caused it to be discarded, because the
earlier ELF_DETAILS macro (previously STABS_DEBUG) explicitly includes
.comment.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro. With binutils < 2.36 that causes the DISCARD directives later in
the script to be applied earlier, causing .comment to actually be
discarded.

It's confusing to explicitly include and discard .comment, and even more
so if the behaviour depends on the toolchain version. So don't discard
.comment in order to maintain the existing behaviour in all cases.

Fixes: 83a092cf95f2 ("powerpc: Link warning for orphan sections")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230105132349.384666-3-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/vmlinux.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -395,7 +395,7 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .comment)
+		*(.glink .iplt .plt)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)


