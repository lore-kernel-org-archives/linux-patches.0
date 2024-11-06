Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3357E7DA7F;
	Wed,  6 Nov 2024 12:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896367; cv=none; b=Hgy50A+xn+AvC2M6/7u5E4dtjUwZI1wIxJ4q+rpNnhmDWbpnm3XI7wpnXFboPOukgBYHoZwapXl4YSRH9yTwPVMqXeTpXlCTnzNsJwCbXomCBYnaupkP3Q+dEuhsw5+fkZUkhNCd45VW8SctThERm+tzFbC6oS/hTGw0aDli9ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896367; c=relaxed/simple;
	bh=bmfkuF8fZQ7rsTlFPJsNICL6ESpjuoxmJeQX77gnuZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkWB7exZY/XI+EcnYfn/s8inU/nP+Cr6zwKyiF84j3IfW8wfnkJTZRzBz4ExJdwU57X9b//MxMa6n/lFLxEN2N6kbbaxIhYnaHJXjpN2mG6MI2MBXaRIQcKzlkHRZw13P8lOp7TnU2rPga8/E08la6Pb37hCMR/8A0P6Lgtn0Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBqkFXVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBqkFXVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB860C4CECD;
	Wed,  6 Nov 2024 12:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896367;
	bh=bmfkuF8fZQ7rsTlFPJsNICL6ESpjuoxmJeQX77gnuZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBqkFXVZSOIqDxpTa3vY9LPiWpC2Yrill5zfNyi5JC7NWSrIHEKsp66eF7cgDORUd
	 92k80vPAqoPTXnak8IPgjaYQJ1+ht8/dGBB4Vpo23xAX0WA7Hrxy1cvVbwTWOBR+x+
	 4OVTXxhhjZ94WgftT4lSl7byecHGTejM1n4n6IME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 178/245] x86/traps: move kmsan check after instrumentation_begin
Date: Wed,  6 Nov 2024 13:03:51 +0100
Message-ID: <20241106120323.617976605@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

[ Upstream commit 1db272864ff250b5e607283eaec819e1186c8e26 ]

During x86_64 kernel build with CONFIG_KMSAN, the objtool warns following:

  AR      built-in.a
  AR      vmlinux.a
  LD      vmlinux.o
vmlinux.o: warning: objtool: handle_bug+0x4: call to
    kmsan_unpoison_entry_regs() leaves .noinstr.text section
  OBJCOPY modules.builtin.modinfo
  GEN     modules.builtin
  MODPOST Module.symvers
  CC      .vmlinux.export.o

Moving kmsan_unpoison_entry_regs() _after_ instrumentation_begin() fixes
the warning.

There is decode_bug(regs->ip, &imm) is left before KMSAN unpoisoining, but
it has the return condition and if we include it after
instrumentation_begin() it results the warning "return with
instrumentation enabled", hence, I'm concerned that regs will not be KMSAN
unpoisoned if `ud_type == BUG_NONE` is true.

Link: https://lkml.kernel.org/r/20241016152407.3149001-1-snovitoll@gmail.com
Fixes: ba54d194f8da ("x86/traps: avoid KMSAN bugs originating from handle_bug()")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/traps.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 415881607c5df..29ec49209ae01 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -261,12 +261,6 @@ static noinstr bool handle_bug(struct pt_regs *regs)
 	int ud_type;
 	u32 imm;
 
-	/*
-	 * Normally @regs are unpoisoned by irqentry_enter(), but handle_bug()
-	 * is a rare case that uses @regs without passing them to
-	 * irqentry_enter().
-	 */
-	kmsan_unpoison_entry_regs(regs);
 	ud_type = decode_bug(regs->ip, &imm);
 	if (ud_type == BUG_NONE)
 		return handled;
@@ -275,6 +269,12 @@ static noinstr bool handle_bug(struct pt_regs *regs)
 	 * All lies, just get the WARN/BUG out.
 	 */
 	instrumentation_begin();
+	/*
+	 * Normally @regs are unpoisoned by irqentry_enter(), but handle_bug()
+	 * is a rare case that uses @regs without passing them to
+	 * irqentry_enter().
+	 */
+	kmsan_unpoison_entry_regs(regs);
 	/*
 	 * Since we're emulating a CALL with exceptions, restore the interrupt
 	 * state to what it was at the exception site.
-- 
2.43.0



