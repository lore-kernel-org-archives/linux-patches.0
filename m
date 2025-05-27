Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6422827CCF0;
	Tue, 27 May 2025 17:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367514; cv=none; b=PGs7boTLWvqOrPpi+2Cfa/6X1bYY0cpxMv93s+lKo6m960h/GeJehzW+ntFUYwr2kSITxOSFaLfDZS24BfzSGJHW7Uyeqcv4SkF26gvHdutxe9wylG410FZP12P2hGJ0w5OrysT3kiwkgOV/Co+GVGO4KPQmhPkWsTbcemo3lSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367514; c=relaxed/simple;
	bh=HNNyMe2oTO/quMmGgdvtlfejLuloyJLetDSH45jDIao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4QSJre6EKW1I7RfP5aOIsoA6AVS5G8vsLMtBD0Yem4Y2anxRKScvQ8McFHIHwPZ5/SUnT0IrjuxkeTPnZ0Ro3lrw31yFJwmOHmBdTHF7Pc+HWoRVobDatbLDD09HSMRhQyoOZMEl/kUlMI09CaSZ3eERjyE2jUFoFDBK6t3cYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmFThx4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmFThx4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77A8C4CEE9;
	Tue, 27 May 2025 17:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367514;
	bh=HNNyMe2oTO/quMmGgdvtlfejLuloyJLetDSH45jDIao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmFThx4jFZKmDzUJ5buFbRBUiE9VI1i+j7Mgia6tExVj8ZWsmo8P2CohjyDDHSzSb
	 +Brd4KXrKIhW2GHyUReS/RK6Si2XT2Z6CUD7xIDxc7xKX1yJODVMAA7Pk9jtv5NfLg
	 mfGRKgb2ikzy9DJGxZXPeuOZLorxVpzO5yOotVKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 382/783] MIPS: Use arch specific syscall name match function
Date: Tue, 27 May 2025 18:22:59 +0200
Message-ID: <20250527162528.648759805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 756276ce78d5624dc814f9d99f7d16c8fd51076e ]

On MIPS system, most of the syscall function name begin with prefix
sys_. Some syscalls are special such as clone/fork, function name of
these begin with __sys_. Since scratch registers need be saved in
stack when these system calls happens.

With ftrace system call method, system call functions are declared with
SYSCALL_DEFINEx, metadata of the system call symbol name begins with
sys_. Here mips specific function arch_syscall_match_sym_name is used to
compare function name between sys_call_table[] and metadata of syscall
symbol.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/ftrace.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
index dc025888f6d28..b41fc10446688 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -91,4 +91,20 @@ void prepare_ftrace_return(unsigned long *parent_ra_addr, unsigned long self_ra,
 
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+#ifndef __ASSEMBLY__
+/*
+ * Some syscall entry functions on mips start with "__sys_" (fork and clone,
+ * for instance). We should also match the sys_ variant with those.
+ */
+#define ARCH_HAS_SYSCALL_MATCH_SYM_NAME
+static inline bool arch_syscall_match_sym_name(const char *sym,
+					       const char *name)
+{
+	return !strcmp(sym, name) ||
+		(!strncmp(sym, "__sys_", 6) && !strcmp(sym + 6, name + 4));
+}
+#endif /* __ASSEMBLY__ */
+#endif /* CONFIG_FTRACE_SYSCALLS */
 #endif /* _ASM_MIPS_FTRACE_H */
-- 
2.39.5



