Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2F7FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD08C433D2;
	Mon, 15 May 2023 16:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169193;
	bh=4zIpdbbR4MfzIjZvHW7a1FTFF5jI7bmPAeYOIqvkwEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsjcpikHBT3Ufrmx9jzL7fvrWYxPS8vqvcKv+yTkVDUMgT7bwt/Yx6fzkpsIYv7cB
	 S8QFqHeTVDy0HsDd8d6nWF7LaMIE4e0PaYk8x8bXH/D5484FZcKk9hUTNur2X+MjVX
	 PGwiIKw0nH3H3wvieKpvQIJBCjHhcBj6EsfEN4ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	devicetree@vger.kernel.org,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-sh@vger.kernel.org
Subject: [PATCH 4.19 172/191] sh: init: use OF_EARLY_FLATTREE for early init
Date: Mon, 15 May 2023 18:26:49 +0200
Message-Id: <20230515161713.674951042@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

commit 6cba655543c7959f8a6d2979b9d40a6a66b7ed4f upstream.

When CONFIG_OF_EARLY_FLATTREE and CONFIG_SH_DEVICE_TREE are not set,
SH3 build fails with a call to early_init_dt_scan(), so in
arch/sh/kernel/setup.c and arch/sh/kernel/head_32.S, use
CONFIG_OF_EARLY_FLATTREE instead of CONFIG_OF_FLATTREE.

Fixes this build error:
../arch/sh/kernel/setup.c: In function 'sh_fdt_init':
../arch/sh/kernel/setup.c:262:26: error: implicit declaration of function 'early_init_dt_scan' [-Werror=implicit-function-declaration]
  262 |         if (!dt_virt || !early_init_dt_scan(dt_virt)) {

Fixes: 03767daa1387 ("sh: fix build regression with CONFIG_OF && !CONFIG_OF_FLATTREE")
Fixes: eb6b6930a70f ("sh: fix memory corruption of unflattened device tree")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org
Cc: stable@vger.kernel.org
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/20230306040037.20350-4-rdunlap@infradead.org
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sh/kernel/head_32.S |    6 +++---
 arch/sh/kernel/setup.c   |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/sh/kernel/head_32.S
+++ b/arch/sh/kernel/head_32.S
@@ -67,7 +67,7 @@ ENTRY(_stext)
 	ldc	r0, r6_bank
 #endif
 
-#ifdef CONFIG_OF_FLATTREE
+#ifdef CONFIG_OF_EARLY_FLATTREE
 	mov	r4, r12		! Store device tree blob pointer in r12
 #endif
 	
@@ -318,7 +318,7 @@ ENTRY(_stext)
 10:		
 #endif
 
-#ifdef CONFIG_OF_FLATTREE
+#ifdef CONFIG_OF_EARLY_FLATTREE
 	mov.l	8f, r0		! Make flat device tree available early.
 	jsr	@r0
 	 mov	r12, r4
@@ -349,7 +349,7 @@ ENTRY(stack_start)
 5:	.long	start_kernel
 6:	.long	cpu_init
 7:	.long	init_thread_union
-#if defined(CONFIG_OF_FLATTREE)
+#if defined(CONFIG_OF_EARLY_FLATTREE)
 8:	.long	sh_fdt_init
 #endif
 
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -242,7 +242,7 @@ void __init __weak plat_early_device_set
 {
 }
 
-#ifdef CONFIG_OF_FLATTREE
+#ifdef CONFIG_OF_EARLY_FLATTREE
 void __ref sh_fdt_init(phys_addr_t dt_phys)
 {
 	static int done = 0;
@@ -329,7 +329,7 @@ void __init setup_arch(char **cmdline_p)
 	/* Let earlyprintk output early console messages */
 	early_platform_driver_probe("earlyprintk", 1, 1);
 
-#ifdef CONFIG_OF_FLATTREE
+#ifdef CONFIG_OF_EARLY_FLATTREE
 #ifdef CONFIG_USE_BUILTIN_DTB
 	unflatten_and_copy_device_tree();
 #else


