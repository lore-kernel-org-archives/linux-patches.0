Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A1B21882B;
	Mon,  2 Jun 2025 14:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874786; cv=none; b=Q3jsInj86rCy7xSBicDqHtJxXi9/KIOHEW24EoQtdbVCBu/kTvtXufcAOwS3yEWMCSgEe4Wz6GIQDtC0SdflzZQFixwcUeokJ7PvqR/ecmdLYdprt+zHD0cMPDjY81hdihe4+vwCM9nrt6J7ckTZoRfxmGvrsFOASadyZTVTYhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874786; c=relaxed/simple;
	bh=X3DpabZUBYCDUTKpb+EqQqu4PLQBDMnG1aPfAEsdhMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbuWYm4esN6YPX0qOysZIHuSSIYVX6BIDC7yJy4wY8B1Erbi9hF79IL9O+l4lRcLaJ80SQOLIndI6K7UI5lAbg3ALied1IO4Fyj1hUjtIJUVQ59pws1c3nIoYfvOyFdF4YK4gsZ79/wy0i79SLX8XcFMciTC66OCY60FNOLX5CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6XXGaJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6XXGaJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AABC4CEEB;
	Mon,  2 Jun 2025 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874786;
	bh=X3DpabZUBYCDUTKpb+EqQqu4PLQBDMnG1aPfAEsdhMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6XXGaJyYiACzdK/TqHUneyNvsZXJ/raF/sLyhhm5d4nOWsaZaEhL3AKYZ51IJpB/
	 DBB/A1wDcWNxojK2cLJu9BG3Q8eZnKBy2i7WuUEq+V1ut/o/OUOdAHboPDYb3bKB31
	 /WV63jysP1puehx6yc0egU/6bx6Fh4aCTf12xJWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/204] MIPS: Use arch specific syscall name match function
Date: Mon,  2 Jun 2025 15:47:47 +0200
Message-ID: <20250602134300.919378994@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b463f2aa5a613..7acbe701afd69 100644
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



