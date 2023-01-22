Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59222590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD9BC433D2;
	Sun, 22 Jan 2023 15:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400471;
	bh=0eFq7L/GFuBtGA45HBKH6qcHYpB33yd/Nr7RSTqGHFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSf9Rc9Rhl8PDKPMcu7zMdpt1wpt3xOn5qxi42PbWRamGVOccRSOzJIK7XLg/WvPy
	 1JZ4J9Ce+y8yUPZ95LlrRSYUw+usNYSQ4jSv/6M43ZiUq7PrupYBHaKYmxN87SqHNQ
	 oPSaxPkrJGtC+yvfd4IiQmmSnlrPT9qBXeSCpGDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 88/98] powerpc/vmlinux.lds: Dont discard .rela* for relocatable builds
Date: Sun, 22 Jan 2023 16:04:44 +0100
Message-Id: <20230122150233.142695275@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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

commit 07b050f9290ee012a407a0f64151db902a1520f5 upstream.

Relocatable kernels must not discard relocations, they need to be
processed at runtime. As such they are included for CONFIG_RELOCATABLE
builds in the powerpc linker script (line 340).

However they are also unconditionally discarded later in the
script (line 414). Previously that worked because the earlier inclusion
superseded the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 137). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier, causing .rela* to
actually be discarded at link time, leading to build warnings and a
kernel that doesn't boot:

  ld: warning: discarding dynamic section .rela.init.rodata

Fix it by conditionally discarding .rela* only when CONFIG_RELOCATABLE
is disabled.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230105132349.384666-2-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/vmlinux.lds.S |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -379,9 +379,12 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .rela* .comment)
+		*(.glink .iplt .plt .comment)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)
+#ifndef CONFIG_RELOCATABLE
+		*(.rela*)
+#endif
 	}
 }


