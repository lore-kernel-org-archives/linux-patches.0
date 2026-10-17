Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCBD17BED0;
	Sat, 17 Oct 2026 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253630; cv=none; b=qY2rjKGJ4SKSZLGi0SrIDfhJpWTJhi55azM0vSYfghfwrrvLNDjUVFRD1VPFUN4CLTwb2MQLsYiS06dz02HNoNtecjY7aVnEwHLSTyypsV+esigFWywB9YYJ4uIIvn2A0kPJ6El1Ase6tl7MaDL6lqLmBlGQ5ZuTlLcFGqid/VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253630; c=relaxed/simple;
	bh=otxaZaqXanSYRtrpK183ITaic+tVnUgzcBwz8mCi4Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9/0BbZzjHT8j56qIFNbR3cIx+spTA2Sbku9QPaCNgeKxNNL6UiYiqoS5B/Ug4JLCV9KL5zwF6HWjxLjwVaOLM8OeKjZtcrrTjGKoZ8Pem92B3iJ8z7+Hh4gQF/7ES/dnlyyjaEDPIpy5jivIShQrYwr93HmDjSbjeDAybdF5/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtTsF481; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtTsF481"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2253B1F000C4;
	Sat, 17 Oct 2026 16:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253628;
	bh=BOFj5DQ4y/J0oL96cChoRpxGS6oGNpOzhXUB6v69ns8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtTsF4814LmXsmmuSdlac5kCEh6XVPDFiNV8I2Mlphles2gE5Hnmk60ABjTrQW+YW
	 8tqZrKxm8ATd6G1UBjYHYxQBT252zSNjwVVwZ0V5LnIQ8EyG/pLaN+AnoT6rP3958A
	 uMH8a0Ov3nC1V+q7WL0ph5E4vSiH7j5Ahk6bLHRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/869] riscv: trace: fix snapshot deadlock with sbi ecall
Date: Sat, 17 Oct 2026 17:50:22 +0200
Message-ID: <20261017160041.694557117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0678650817d4f..7328e62a7b8e8 100644
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
 extra-y += vmlinux.lds
 
 obj-y	+= head.o
-- 
2.53.0



