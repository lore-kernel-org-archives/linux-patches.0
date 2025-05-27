Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E08F1EA91;
	Tue, 27 May 2025 17:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365359; cv=none; b=RLiHhboEj6kzMTqcbg3dc6vl0JhL0FOCY5KxQW+XekKwaGQDuwCw+mJrvOBSqojPcW5BakxrJQSiGy/TdGo5itfjhETg47cWb/tP57dfP+/P7uEgZHDzSn2BcScInybue5tfOMm0HhJggo1fjCoC4jtJ1WuZxHD+mEAvastFHFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365359; c=relaxed/simple;
	bh=tNeAmQ2qUV+9reGGfNdYHcbgpezdp22J+FhdSU1V5OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMooGomQ2exyn0AxvMDgSpl8s1Nz9+6pXVCSbbN3Jgo703iQIMYC+SWCBjalmfO8aSMO4VKyCsNccpuuW+FPgntXv7iC4FLOC0SKHJ9oW0fQJvejI5KQUh/tWn5jx2YguosceXnMbsZFTIgbYk8sndM2rvKZEjS0CNFJgMslySI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmal4uFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmal4uFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41ACBC4CEE9;
	Tue, 27 May 2025 17:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365358;
	bh=tNeAmQ2qUV+9reGGfNdYHcbgpezdp22J+FhdSU1V5OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmal4uFE597W6X92Pmi/xe/ex0N73u7URpd/rWhMIbfop1Ko6ENfel1E5l7ukD9S3
	 il/HFuMd9MzSU4WME53rUYpx8KQY7eKNywqczMXOJeyUQscgvFzO6FeLAZnAPKR9wR
	 +v/qGyhSAjJtg4e6+NtQz0+/lXUMTaHRfqtXsTls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/626] MIPS: Use arch specific syscall name match function
Date: Tue, 27 May 2025 18:23:23 +0200
Message-ID: <20250527162457.632877254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



