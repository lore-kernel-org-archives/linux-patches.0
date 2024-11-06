Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628CE1F80C3;
	Wed,  6 Nov 2024 12:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897658; cv=none; b=V5GBJulBi81r2P26l3mBp+0GLhZFImwqdcL2poipLdh+DMjdNmrirjweEzvw1o9iXPkITHyEXw5LbIiiTAk7rBEFado0eJ28AANU00ErKOEHcpwv7lJ1EX765PrlwrLa2A3+J8HGgMbyHov8DILsegCG0J23TLAiz83d5IP8Ckw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897658; c=relaxed/simple;
	bh=8MwTmbHVkMhuTRCylbVq6mq+h6gjl06FaY7MFnND3PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0px6satyAyPHi74psSZEs3m5ePQ+Q2tfVxVAfkaagRqiLAEGbV9Rk9T7Y6RYU9vRBV8Umhz73g/90qqrot2tU7TMSTTrwV8IA6RYnzWLiNq9HzUoiv3VJG08/iwwGO1j9urbWEM/MtZbtZiQdeOsyQ1SphmhvbmV1t30aFK6is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ja/QFDLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ja/QFDLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0AAC4CECD;
	Wed,  6 Nov 2024 12:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897658;
	bh=8MwTmbHVkMhuTRCylbVq6mq+h6gjl06FaY7MFnND3PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ja/QFDLMklXaMb/2Dnlk7vNYA/THsOZ/PE+rMmIHATFtXA5FXRmOLIRoa0gZWWX/g
	 Ct5bd1Grd7M/NpdSU5xAcoU9IHvT1b0/cpQAiv8utafZi6fySI1u1WVeG0Ppv6YlD3
	 Tfxd8LcIrYCr/OGnS2Cpi1bNrfipWJqRgMhGJn28=
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
Subject: [PATCH 6.6 128/151] x86/traps: move kmsan check after instrumentation_begin
Date: Wed,  6 Nov 2024 13:05:16 +0100
Message-ID: <20241106120312.385474145@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 840a3b2d24779..37b8e20c03a9f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -259,12 +259,6 @@ static noinstr bool handle_bug(struct pt_regs *regs)
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
@@ -273,6 +267,12 @@ static noinstr bool handle_bug(struct pt_regs *regs)
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



