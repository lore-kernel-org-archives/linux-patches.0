Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4A93C276E;
	Tue, 21 Jul 2026 17:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655239; cv=none; b=b5pVkc2SbQPAqTVxT1HXjE8ybGcUDvw/ZLKVmmJ5ETrQoGcJJh4KuN6nBSJxQEmclT+atONOGnQdl6iJ369kgt9R3GleV584IFAW5HS9fkNMsZxO3vuNNDT9DCDLFhLkNRaXuwEj9wz7w7bC88y8kXXmfXSq8dHa2FXJgNYYw3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655239; c=relaxed/simple;
	bh=O27a1zgMNw7rNiKNpcOWNqEkoa/JjtTGlb7pHx+XxqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ev5R0lQBrbyafL8ccV4XbEBcoeffJy1qupR+u9iMN4SLLyfQBkM18MxxYvI+ukkehwggQo8CwJ61Z9JvJ8J5BJTNsdcXDvp3EgH99yuNezHV5A3tU2qGLNJb+S0ycJK7WQkPs/WtJY7Onwc7sP5nmMZ/rFQ9suloKQM4FjoZ/88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmOCZhJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmOCZhJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847F81F000E9;
	Tue, 21 Jul 2026 17:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655238;
	bh=VnVihxfAymbRAyViGMqEPzsbpFc4D+7ZD6Cx6SFpFzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NmOCZhJJioyQ4a9P7+d5z558niWSDPWlQIvOgC9sVxHK7WWbxif/ChZx+wEfXdI5p
	 Xv/WP9PsoqIQcXF89PEr4h+06tKC2a0ARrv5Onyc5G+zWPud66nItHrovsErkyxMZo
	 zzIMGzN6UvatHxWjFbdXsS927CaEIa/tVIOrLikY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Joel Stanley <joel@jms.id.au>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.1 2008/2077] arch/riscv: vdso: remove CFI landing pad from rt_sigreturn
Date: Tue, 21 Jul 2026 17:28:01 +0200
Message-ID: <20260721152640.071317151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

commit e4bf6eb4c7b61db1cf24487e14e6ae8755e61e3d upstream.

When CONFIG_RISCV_USER_CFI is enabled, the CFI version of the vDSO, has
a CFI landing pad instruction at the start of __vdso_rt_sigreturn. This
breaks libgcc's unwinding code which matches on the first two
instructions. Other unwinders that rely on similar instruction matching
may also be affected.

Since __vdso_rt_sigreturn is reached as part of signal-return handling
rather than via an indirect call/jump from userspace, it does not need a
CFI landing pad. Remove it and restore the instruction sequence expected
by existing unwinding code.

This matches what was done on arm64 in commit 9a964285572b ("arm64:
vdso: Don't prefix sigreturn trampoline with a BTI C instruction") for a
similar issue.

Cc: stable@vger.kernel.org
Fixes: 37f57bd3faea ("arch/riscv: compile vdso with landing pad and shadow stack note")
Co-authored-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://patch.msgid.link/20260623204058.498120-1-aurelien@aurel32.net
[pjw@kernel.org: fixed comment style]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/vdso/rt_sigreturn.S | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vdso/rt_sigreturn.S b/arch/riscv/kernel/vdso/rt_sigreturn.S
index e82987dc3739..d6f96b1abe40 100644
--- a/arch/riscv/kernel/vdso/rt_sigreturn.S
+++ b/arch/riscv/kernel/vdso/rt_sigreturn.S
@@ -7,11 +7,19 @@
 #include <asm/unistd.h>
 #include <asm/assembler.h>
 
+/*
+ * WARNING: Do NOT add a CFI landing pad at the start of this function.
+ * Unwinders such as libgcc identify the sigreturn trampoline by matching the
+ * instruction sequence. Adding a landing pad here would break unwinding from
+ * signal handlers.
+ *
+ * This trampoline is used only for signal return and not via an indirect
+ * call/jump from userspace, so adding CFI landing pad is unnecessary.
+ */
 	.text
 SYM_FUNC_START(__vdso_rt_sigreturn)
 	.cfi_startproc
 	.cfi_signal_frame
-	vdso_lpad
 	li a7, __NR_rt_sigreturn
 	ecall
 	.cfi_endproc
-- 
2.55.0



