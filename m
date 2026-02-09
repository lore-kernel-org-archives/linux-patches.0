Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CA837AA91;
	Mon,  9 Feb 2026 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647378; cv=none; b=Q00ySMDBoOsPjBJ/WTOcgCz/7zwHWkzfChuHKEkXaFSNxPDxEfzjqYXqJdqrxJIruBUhnl3O6eEyt7kYTIqO28M69gGgYJrEUxwk9kFY2ugdc6Q1L5gGvqEzr3/7ijfaCqYA96ZDzIfJeAYtmIxGTt/a7mSgFz4R7+XcEB+eTsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647378; c=relaxed/simple;
	bh=TWz1oOi5JpbK5gewlQcWnyf+aQTNFq+dwXjR+4wQdNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfMMxIl0MBGS6CjZdsEqEgSKG1RS/JkYN5eiaqHWpurHueEJRH0We7c1IdzMjZMIlIhVxJRG3KGngf8M6AL5cbIEl7kwO8/hHY2pakiCjfIt9Q4235N+LQUMmv0er1y0HGEU6cE3wHtfEt4Jjp9sF2brWugZxEk3PXwGYCvHQyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1NJQNu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1NJQNu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BB1C116C6;
	Mon,  9 Feb 2026 14:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647378;
	bh=TWz1oOi5JpbK5gewlQcWnyf+aQTNFq+dwXjR+4wQdNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1NJQNu0x18BK/y4Izp6kp3uOUcY8ZXe4Uz6RHPPi+QbItU561elgd6xvSUVB+cYI
	 KEXIXZyzhhjAki9oAx246g5kP1Na7OvOfWAb+ZMbtcpY70fox+L7iicwAjFuQuk3Vt
	 +GdXYIWAahZtrCVtgt/LqlOaJDEKcC+fyqaluT+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/175] riscv: trace: fix snapshot deadlock with sbi ecall
Date: Mon,  9 Feb 2026 15:22:34 +0100
Message-ID: <20260209142323.355502602@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit b0d7f5f0c9f05f1b6d4ee7110f15bef9c11f9df0 ]

If sbi_ecall.c's functions are traceable,

echo "__sbi_ecall:snapshot" > /sys/kernel/tracing/set_ftrace_filter

may get the kernel into a deadlock.

(Functions in sbi_ecall.c are excluded from tracing if
CONFIG_RISCV_ALTERNATIVE_EARLY is set.)

__sbi_ecall triggers a snapshot of the ringbuffer. The snapshot code
raises an IPI interrupt, which results in another call to __sbi_ecall
and another snapshot...

All it takes to get into this endless loop is one initial __sbi_ecall.
On RISC-V systems without SSTC extension, the clock events in
timer-riscv.c issue periodic sbi ecalls, making the problem easy to
trigger.

Always exclude the sbi_ecall.c functions from tracing to fix the
potential deadlock.

sbi ecalls can easiliy be logged via trace events, excluding ecall
functions from function tracing is not a big limitation.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Link: https://patch.msgid.link/20251223135043.1336524-1-martin@kaiser.cx
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/Makefile | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index f60fce69b7259..a01f6439d62b1 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -3,12 +3,6 @@
 # Makefile for the RISC-V Linux kernel
 #
 
-ifdef CONFIG_FTRACE
-CFLAGS_REMOVE_ftrace.o	= $(CC_FLAGS_FTRACE)
-CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
-CFLAGS_REMOVE_sbi.o	= $(CC_FLAGS_FTRACE)
-CFLAGS_REMOVE_return_address.o	= $(CC_FLAGS_FTRACE)
-endif
 CFLAGS_syscall_table.o	+= $(call cc-disable-warning, override-init)
 CFLAGS_compat_syscall_table.o += $(call cc-disable-warning, override-init)
 
@@ -24,7 +18,6 @@ CFLAGS_sbi_ecall.o := -mcmodel=medany
 ifdef CONFIG_FTRACE
 CFLAGS_REMOVE_alternative.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_cpufeature.o = $(CC_FLAGS_FTRACE)
-CFLAGS_REMOVE_sbi_ecall.o = $(CC_FLAGS_FTRACE)
 endif
 ifdef CONFIG_RELOCATABLE
 CFLAGS_alternative.o += -fno-pie
@@ -43,6 +36,14 @@ CFLAGS_sbi_ecall.o += -D__NO_FORTIFY
 endif
 endif
 
+ifdef CONFIG_FTRACE
+CFLAGS_REMOVE_ftrace.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_sbi.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_return_address.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_sbi_ecall.o = $(CC_FLAGS_FTRACE)
+endif
+
 always-$(KBUILD_BUILTIN) += vmlinux.lds
 
 obj-y	+= head.o
-- 
2.51.0



