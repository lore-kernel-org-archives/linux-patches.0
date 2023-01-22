Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097442590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DBAC433EF;
	Sun, 22 Jan 2023 15:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400783;
	bh=ursuw5HNI91vXx3Sf8bbedPhGNKrQQ6b0pUTliDmU4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otTquDTN51aNxOBtAJdifOAO3tojbjKnMh54XU85qiVwmdRXdWMQ810r/BnR37nyd
	 z2aCZVAOY2E//XFREC0/ytqVd7rhhCAbEtJF1uBbcRr9K8YtfB5qkIuMJhYCaw47mD
	 OgB44VT85rM36LxIDPZIa2+JlUJ71a3BQRCS4Tpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 108/117] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date: Sun, 22 Jan 2023 16:04:58 +0100
Message-Id: <20230122150237.325995900@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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

commit 4b9880dbf3bdba3a7c56445137c3d0e30aaa0a40 upstream.

The powerpc linker script explicitly includes .exit.text, because
otherwise the link fails due to references from __bug_table and
__ex_table. The code is freed (discarded) at runtime along with
.init.text and data.

That has worked in the past despite powerpc not defining
RUNTIME_DISCARD_EXIT because DISCARDS appears late in the powerpc linker
script (line 410), and the explicit inclusion of .exit.text
earlier (line 280) supersedes the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 136). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier [1], causing
.exit.text to actually be discarded at link time, leading to build
errors:

  '.exit.text' referenced in section '__bug_table' of crypto/algboss.o: defined in
  discarded section '.exit.text' of crypto/algboss.o
  '.exit.text' referenced in section '__ex_table' of drivers/nvdimm/core.o: defined in
  discarded section '.exit.text' of drivers/nvdimm/core.o

Fix it by defining RUNTIME_DISCARD_EXIT, which causes the generic
DISCARDS macro to not include .exit.text at all.

1: https://lore.kernel.org/lkml/87fscp2v7k.fsf@igel.home/

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230105132349.384666-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	0
+#define RUNTIME_DISCARD_EXIT
 
 #define SOFT_MASK_TABLE(align)						\
 	. = ALIGN(align);						\


