Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E9019D084;
	Mon, 23 Jun 2025 21:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714834; cv=none; b=ZfwEcfPOfEdpW3Z/JwA4pE+pcacOoa0LBoFmr2uAESt7EtXYco11bl8BGr57LrJLhkf3OIYXcfZplZJzFwTztvAliSMNhrKfTxrlySSdBYjbVvzJ1cs9QoEY1qZ4lk/8m9IzxRWnRoLFgDi4iySJP80NqIrqfPb7ncHgGYClhWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714834; c=relaxed/simple;
	bh=MQcY3de9OhbTzJ/aIhAxEs2ezpaQZEQj9qy6IAIabUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTgdOMD3kFU/HvHaa7Uy3pt0CGrPjHg/CVhr+lO3Rc1lsNwlnYjJyLI4epR8M4y5apzJ0oRjiDtJvUHjQ6dYQ17QExs+axTRreuRr6QTzFhgCj/Z9LlrowFfFvPhliZ+HBH4k4muV/lJp+wcSWjQ+SfXi5ya4YTx3N5PadyUtpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUSRtOWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUSRtOWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D8BC4CEF0;
	Mon, 23 Jun 2025 21:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714833;
	bh=MQcY3de9OhbTzJ/aIhAxEs2ezpaQZEQj9qy6IAIabUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUSRtOWwNMbRYb791kB6wEfX4moiQjZR8STfw2iK3fQ19ecuMqAETqdPYbQ3ZIp+w
	 km6guEbIJNJQ+QLXOwFbBxu3Tym9IE9uWTvh3SQoN7rBGjYOf1m8UQdYr9FT/0kz9t
	 2YdML3TLGgIiB0Up0jd2OHNRqYzPKsTxHtcD9AV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 441/592] powerpc/vdso: Fix build of VDSO32 with pcrel
Date: Mon, 23 Jun 2025 15:06:39 +0200
Message-ID: <20250623130710.922864372@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit b93755f408325170edb2156c6a894ed1cae5f4f6 ]

Building vdso32 on power10 with pcrel leads to following errors:

	  VDSO32A arch/powerpc/kernel/vdso/gettimeofday-32.o
	arch/powerpc/kernel/vdso/gettimeofday.S: Assembler messages:
	arch/powerpc/kernel/vdso/gettimeofday.S:40: Error: syntax error; found `@', expected `,'
	arch/powerpc/kernel/vdso/gettimeofday.S:71:  Info: macro invoked from here
	arch/powerpc/kernel/vdso/gettimeofday.S:40: Error: junk at end of line: `@notoc'
	arch/powerpc/kernel/vdso/gettimeofday.S:71:  Info: macro invoked from here
	 ...
	make[2]: *** [arch/powerpc/kernel/vdso/Makefile:85: arch/powerpc/kernel/vdso/gettimeofday-32.o] Error 1
	make[1]: *** [arch/powerpc/Makefile:388: vdso_prepare] Error 2

Once the above is fixed, the following happens:

	  VDSO32C arch/powerpc/kernel/vdso/vgettimeofday-32.o
	cc1: error: '-mpcrel' requires '-mcmodel=medium'
	make[2]: *** [arch/powerpc/kernel/vdso/Makefile:89: arch/powerpc/kernel/vdso/vgettimeofday-32.o] Error 1
	make[1]: *** [arch/powerpc/Makefile:388: vdso_prepare] Error 2
	make: *** [Makefile:251: __sub-make] Error 2

Make sure pcrel version of CFUNC() macro is used only for powerpc64
builds and remove -mpcrel for powerpc32 builds.

Fixes: 7e3a68be42e1 ("powerpc/64: vmlinux support building with PCREL addresing")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/1fa3453f07d42a50a70114da9905bf7b73304fca.1747073669.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/ppc_asm.h | 2 +-
 arch/powerpc/kernel/vdso/Makefile  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 02897f4b0dbf8..b891910fce8a6 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -183,7 +183,7 @@
 /*
  * Used to name C functions called from asm
  */
-#ifdef CONFIG_PPC_KERNEL_PCREL
+#if defined(__powerpc64__) && defined(CONFIG_PPC_KERNEL_PCREL)
 #define CFUNC(name) name@notoc
 #else
 #define CFUNC(name) name
diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index e8824f9333261..8834dfe9d7279 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -53,7 +53,7 @@ ldflags-$(CONFIG_LD_ORPHAN_WARN) += -Wl,--orphan-handling=$(CONFIG_LD_ORPHAN_WAR
 ldflags-y += $(filter-out $(CC_AUTO_VAR_INIT_ZERO_ENABLER) $(CC_FLAGS_FTRACE) -Wa$(comma)%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 CC32FLAGS := -m32
-CC32FLAGSREMOVE := -mcmodel=medium -mabi=elfv1 -mabi=elfv2 -mcall-aixdesc
+CC32FLAGSREMOVE := -mcmodel=medium -mabi=elfv1 -mabi=elfv2 -mcall-aixdesc -mpcrel
 ifdef CONFIG_CC_IS_CLANG
 # This flag is supported by clang for 64-bit but not 32-bit so it will cause
 # an unused command line flag warning for this file.
-- 
2.39.5



