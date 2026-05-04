Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B37D3DDDD7;
	Mon,  4 May 2026 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903131; cv=none; b=GRmv8jCc2+LbKqqzj1CDmRs3l8Ktu7hAKNmlQGpUoef1AXCX7TT+5ojcBs6eEKZE0UGsj+JdPkBjKserbGz3uD2/lD117GBIxS3i3YnkH7UM4kbPus0lHV/8PJyxM+lK087cKAwhPTcHZqPmUFjVhcPd5aVpmfPyMizfJTLWSlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903131; c=relaxed/simple;
	bh=1jraNgiHsMlH5L0ot1p3sQgwVJnC4GoEgnKdMcLE06M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duJUCCs2z0EvqtZy+QmYnrC6NJG7sIbcTE0MpRPGFp1vTad+GQT6xPP5ZC6OJeL81fe0qgJJOBbpRi1VWnFnnN037hU6z/Z1ziB41vAIbE70qEDHa8jiJPjPyGZyBes/MnHM0X3eMj3BYu7930L60/kn7yyfkXW/8/cTXrmbwYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMYhZTr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMYhZTr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B6BC2BCB8;
	Mon,  4 May 2026 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903130;
	bh=1jraNgiHsMlH5L0ot1p3sQgwVJnC4GoEgnKdMcLE06M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMYhZTr/FRCUUHwq/SiShukdM+CdW33nIUxS1vTa8B4OiGzLIWFiXwhpBpFlVo1U0
	 +7dXQT2GeOAgcKsu29tC862D2hg4vmu2jY8fWuEA58bjeVGt4sYfZVPmC4n8PG6pwi
	 kZDr387vzYjCQgYGnzslTe5dzJ3aKX7l1WFF7rzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.0 116/307] module.lds.S: Fix modules on 32-bit parisc architecture
Date: Mon,  4 May 2026 15:50:01 +0200
Message-ID: <20260504135147.169772424@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 1221365f55281349da4f4ba41c05b57cd15f5c28 upstream.

On the 32-bit parisc architecture, we always used the
-ffunction-sections compiler option to tell the compiler to put the
functions into seperate text sections. This is necessary, otherwise
"big" kernel modules like ext4 or ipv6 fail to load because some
branches won't be able to reach their stubs.

Commit 1ba9f8979426 ("vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and related
macros") broke this for parisc because all text sections will get
unconditionally merged now.

Introduce the ARCH_WANTS_MODULES_TEXT_SECTIONS config option which
avoids the text section merge for modules, and fix this issue by
enabling this option by default for 32-bit parisc.

Fixes: 1ba9f8979426 ("vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and related macros")
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: stable@vger.kernel.org # v6.19+
Suggested-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/Kconfig         |    7 +++++++
 arch/parisc/Kconfig  |    1 +
 scripts/module.lds.S |    2 ++
 3 files changed, 10 insertions(+)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1128,6 +1128,13 @@ config ARCH_WANTS_MODULES_DATA_IN_VMALLO
 	  For architectures like powerpc/32 which have constraints on module
 	  allocation and need to allocate module data outside of module area.
 
+config ARCH_WANTS_MODULES_TEXT_SECTIONS
+	bool
+	help
+	  For architectures like 32-bit parisc which require that functions in
+	  modules have to keep code in own text sections (-ffunction-sections)
+	  and to avoid merging all text into one big text section,
+
 config ARCH_WANTS_EXECMEM_LATE
 	bool
 	help
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -8,6 +8,7 @@ config PARISC
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_SYSCALL_TRACEPOINTS
 	select ARCH_WANT_FRAME_POINTERS
+	select ARCH_WANTS_MODULES_TEXT_SECTIONS if !64BIT
 	select ARCH_HAS_CPU_CACHE_ALIASING
 	select ARCH_HAS_DMA_ALLOC if PA11
 	select ARCH_HAS_DMA_OPS
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -41,9 +41,11 @@ SECTIONS {
 	__kcfi_traps		0 : { KEEP(*(.kcfi_traps)) }
 #endif
 
+#ifndef CONFIG_ARCH_WANTS_MODULES_TEXT_SECTIONS
 	.text			0 : {
 		*(.text .text.[0-9a-zA-Z_]*)
 	}
+#endif
 
 	.bss			0 : {
 		*(.bss .bss.[0-9a-zA-Z_]*)


