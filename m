Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4634C431488;
	Thu, 30 Jul 2026 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421455; cv=none; b=d4nBTx0fSx9DaSvwbIN4KiDewIpUgG4pxwdcAQdbmSQokMrF3nioZo8IlfAufkRTrV7HB0AqjtFVTIujv8289yrHeVUpX5YburLNyYBAWIhiNr91Xt1Cp5xlbwmbDkskyWoQUKUjKgiph0x/fvoMdYP0vxFqGgsj2P+ABpvTJD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421455; c=relaxed/simple;
	bh=Rp7veMbtgJu+ik85Nek/mjqhsKQQaFlTOFX1UAabmoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rooD3NkCrIlzf57Lt4DB+pU2vXaTQD0cIMqO4KlPx0b3UDD25ZW8iITVuDMPZsive7YQGbQp+Xlj3FKb57/1QjxBYzzPAXwmzJsqsgdjO9Lipkn3qLQJi+7IFrpwELJ064YHptgns7mpMuafHV/T0/M1kJiSSQqnQ7zztxOodik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RF4QgxGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RF4QgxGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991EF1F00A3A;
	Thu, 30 Jul 2026 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421454;
	bh=wDAPZK4OVWZCLOYvtFGrgZI+BrG+it3zSc4mhp6XXWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RF4QgxGCKQFrJ5bkCC8eOpQzH8T7VIX4L4YBWgvc9PtPgg1crxHZHZBAc2CK5pOG0
	 lOONHAgIhobuT0/pJ0vwloAvpZJWoY4zmBCW16OSKkFKVt+UxE2ek9hn0purs3ENWU
	 PUmQchkrxZaoVtQZv2OfTWCxJWnULdKxQdwl8B04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 108/744] riscv: Gate FUNCTION_ALIGNMENT_4B on DYNAMIC_FTRACE
Date: Thu, 30 Jul 2026 16:06:21 +0200
Message-ID: <20260730141446.572661122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Rui Qi <qirui.001@bytedance.com>

[ Upstream commit 3a2694bf6ac8e47b3814293e80343f58fc72937f ]

The FUNCTION_ALIGNMENT_4B select forces the whole kernel to be built
with -fmin-function-alignment=4. This alignment is only needed so the
patchable-function-entry NOPs, which arch/riscv/Makefile emits under
CONFIG_DYNAMIC_FTRACE, can be patched reliably on RISCV_ISA_C=y builds
where compressed instructions otherwise allow 2-byte function
alignment.

The select is currently gated on HAVE_DYNAMIC_FTRACE, a capability bit
that is selected whenever the toolchain supports dynamic ftrace, rather
than on whether tracing is actually enabled. As a result every
RISCV_ISA_C=y build gets 4-byte function alignment across the entire
kernel even when function tracing is disabled, needlessly growing the
kernel image and wasting instruction cache for a feature that is not
in use.

Gate the select on DYNAMIC_FTRACE instead, matching the condition under
which arch/riscv/Makefile emits -fpatchable-function-entry, so the
alignment is only applied when it is actually needed.

Fixes: c41bf4326c7b ("riscv: ftrace: align patchable functions to 4 Byte boundary")
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Link: https://patch.msgid.link/20260706130415.463682-1-qirui.001@bytedance.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index c5754942cf85a4..e73f556720c1cf 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -155,7 +155,7 @@ config RISCV
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS if MMU
 	select HAVE_DYNAMIC_FTRACE if MMU && (CLANG_SUPPORTS_DYNAMIC_FTRACE || GCC_SUPPORTS_DYNAMIC_FTRACE)
-	select FUNCTION_ALIGNMENT_4B if HAVE_DYNAMIC_FTRACE && RISCV_ISA_C
+	select FUNCTION_ALIGNMENT_4B if DYNAMIC_FTRACE && RISCV_ISA_C
 	select HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS if HAVE_DYNAMIC_FTRACE_WITH_CALL_OPS
 	select HAVE_DYNAMIC_FTRACE_WITH_CALL_OPS if (DYNAMIC_FTRACE_WITH_ARGS && !CFI)
 	select HAVE_DYNAMIC_FTRACE_WITH_ARGS if HAVE_DYNAMIC_FTRACE
-- 
2.53.0



