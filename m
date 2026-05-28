Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7162830E82E;
	Thu, 28 May 2026 20:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998561; cv=none; b=PEQdlqIuncWhAPT+zrfoLjQ63nXLJXh14vlvy6GArsdHI+gb02MGFZpDeMB134lHX92PDBRHsjUJZ/HMLcPuYdXfXWK/NpjgMPjFSjJjcUV8EeH9TuwQySE7rMjwEXvzgTYayCbetuF2EuadCdFOdhZODaX/uQT8uICCstBbfsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998561; c=relaxed/simple;
	bh=BpQyukS7aT9SiAPk1qlOREFiL3rr9+YjQ5M9PURvaiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLd3+G9dpF5//Kjz+6ytuCLDv6CQVxatYl/N2B8lGXJr4ngejkTtfJMYj/xTKL8sG0d+WnXEcmdakfywEanez51cBowaIgR4/xn2MRI/gAske98YQOF7kaOxsqTTP3aTvcz9If8MIwkPn3S46WlXCvlPR+tR/it8734BsSFLifw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aha7MqM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aha7MqM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B901F000E9;
	Thu, 28 May 2026 20:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998560;
	bh=VHlvmQ21P+KU5zQgr46R/Ziff+cjMr3xBLqE4JUJG58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aha7MqM/4j2dooYERPq/xSXyr5lTUsjZf2d1iqh441QhNfG/xovFXpFqKLcW3IoEm
	 +PKXhQlRPVIGbAhFPLMQDjEm341fJxnHbkQLVnFUtX1CGiejXBFFjRLm+0AtqA3vds
	 y/jyYRmCiO1yt4nkHFPfrxBWqJH1XziaZOHQ6Ry0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 217/461] kprobes: skip non-symbol addresses in kprobe_add_ksym_blacklist()
Date: Thu, 28 May 2026 21:45:46 +0200
Message-ID: <20260528194653.409408735@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>

[ Upstream commit 307abfac04a254c09c5705d816b33354acee97a0 ]

When kprobe_add_area_blacklist() iterates through a section like
.kprobes.text, the start address may not correspond to a named symbol.
On ARM64 with CONFIG_DYNAMIC_FTRACE_WITH_CALL_OPS=y (introduced by
commit baaf553d3bc3 ("arm64: Implement
HAVE_DYNAMIC_FTRACE_WITH_CALL_OPS")), the compiler flag
-fpatchable-function-entry=4,2 inserts 2 NOPs before each function entry
point for ftrace call_ops. These pre-function NOPs sit at the section base
address, before the first named function symbol. The compiler emits a $x
mapping symbol at offset 0x00 to mark the start of code, but
find_kallsyms_symbol() ignores mapping symbols.

Without CONFIG_DYNAMIC_FTRACE_WITH_CALL_OPS (e.g. defconfig), no
pre-function NOPs are inserted, the first function starts at offset
0x00, and the bug does not trigger.

This only affects modules that have a .kprobes.text section (i.e. those
using the __kprobes annotation). Modules using NOKPROBE_SYMBOL() instead
(like kretprobe_example.ko) blacklist exact function addresses via the
_kprobe_blacklist section and are not affected.

For kprobe_example.ko on ARM64 with -fpatchable-function-entry=4,2,
the .kprobes.text section layout is:

  offset 0x00: $x + 2 NOPs    (mapping symbol + ftrace preamble)
  offset 0x08: handler_post   (64 bytes)
  offset 0x50: handler_pre    (68 bytes)

kprobe_add_area_blacklist() starts iterating from the section base
address (offset 0x00), which only has the $x mapping symbol.
kprobe_add_ksym_blacklist() then calls kallsyms_lookup_size_offset()
for this address, which goes through:

  kallsyms_lookup_size_offset()
    -> module_address_lookup()
      -> find_kallsyms_symbol()

find_kallsyms_symbol() scans all module symbols to find the closest
preceding symbol.

Since no named text symbol exists at offset 0x00,
find_kallsyms_symbol() picks __UNIQUE_ID_vermagic (a .modinfo symbol
whose address is in the temporary image) as the "best" match. The
computed "size" = next_text_symbol - modinfo_symbol spans across
these two unrelated memory regions, creating a blacklist entry with
a bogus range of tens of terabytes.

Whether this causes a visible failure depends on address randomization,
here is what happens on Raspberry Pi 4/5:

  - On RPi5, the bogus size was ~35 TB. start + size stayed within
    64-bit range, so the blacklist entry covered the entire kernel
    text. register_kprobe() in the module's own init function failed
    with -EINVAL.

  - On RPi4, the bogus size was ~75 TB. start + size overflowed
    64 bits and wrapped to a small address near zero. The range
    check (addr >= start && addr < end) then failed because end
    wrapped around, so the bogus entry was accidentally harmless
    and kprobes worked by luck.

The same bug exists on both machines, but randomization determines whether
the integer overflow masks it or not.

Fix this by adding notrace to the __kprobes macro. Functions in
.kprobes.text are kprobe infrastructure handlers that should never be
traced by ftrace. With notrace, the compiler stops inserting them and the
non-symbol gap at the section start disappears entirely.

Link: https://lore.kernel.org/all/20260506012706.2785785-1-jianpeng.chang.cn@windriver.com/

Fixes: baaf553d3bc3 ("arm64: Implement HAVE_DYNAMIC_FTRACE_WITH_CALL_OPS")
Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/kprobes.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/kprobes.h b/include/asm-generic/kprobes.h
index 060eab094e5a2..5290a2b2e15a0 100644
--- a/include/asm-generic/kprobes.h
+++ b/include/asm-generic/kprobes.h
@@ -14,7 +14,7 @@ static unsigned long __used					\
 	_kbl_addr_##fname = (unsigned long)fname;
 # define NOKPROBE_SYMBOL(fname)	__NOKPROBE_SYMBOL(fname)
 /* Use this to forbid a kprobes attach on very low level functions */
-# define __kprobes	__section(".kprobes.text")
+# define __kprobes	notrace __section(".kprobes.text")
 # define nokprobe_inline	__always_inline
 #else
 # define NOKPROBE_SYMBOL(fname)
-- 
2.53.0



