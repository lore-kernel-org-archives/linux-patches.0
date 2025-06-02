Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF8E223DEC;
	Mon,  2 Jun 2025 14:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873620; cv=none; b=VzxdXkRFxB9GPuJt+P+fnccQakhlfRUqtotVR4TFXfwdm+hqvuPGNZKlJu8i9SGDB6Pylza78mY0bChXzJwZDn5fc7Wk7XYuL07JU8V4JVd66TPCyEM1i92MrYl6KtFOfflcQ0SPIZvC0fdsT7pPvgI5WQrOpxpvjmD8dzrg5v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873620; c=relaxed/simple;
	bh=j7JeK/+yXfPPQZeQJloFwWZete4IbV8512kTiB8n9nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBWJMaJInvcTefxEv15UBFfnFj8EI4QTgj57FzyOUPaHvK8kTTF8Vdt4fBG7wie8gIrUWRBxxtJ+8VFbYCYRy1CPDZ573NOyKMKCWj9lwG4l1hVkbOTQCT4dssYV2PcNy6Cfm0S7q0PSOqPWnLSgTBik5H1XFfb9RYsaR1Gaf7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/HNDlQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/HNDlQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFBBC4CEEE;
	Mon,  2 Jun 2025 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873620;
	bh=j7JeK/+yXfPPQZeQJloFwWZete4IbV8512kTiB8n9nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/HNDlQPM5VYxT4M3Yd7I9xd0bJOuJ02R+s88ZBTYruifUagyj0Hqa+Lr6Xszy18/
	 yBAphKvGM68Oo5LnR572BMKKlUZbsRvqnWj9aTqwpO0NtSM44pzDASI+FDlI3MXirL
	 Rm1P4m0nhZ9KnVoJ99nB77CEqI6svIlBZ55a3sI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/444] MIPS: Use arch specific syscall name match function
Date: Mon,  2 Jun 2025 15:44:22 +0200
Message-ID: <20250602134348.943259615@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index db497a8167da2..e3212f44446fa 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -87,4 +87,20 @@ struct dyn_arch_ftrace {
 #endif /*  CONFIG_DYNAMIC_FTRACE */
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



