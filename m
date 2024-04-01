Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9394943AD6;
	Mon,  1 Apr 2024 16:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989458; cv=none; b=tCZHZVVf5/7PlIDkIaFi/j9SuK4T36rv8DDPe1szSvVGxE/KLj/CJLf0HOwDTGJ4iwGWSRNjrICvoxgZgmYy/cjJyPkiXkk5TsjoCbO8AiOkQCf/ngBZq3mQWWuMTB2zKonTfIKKvF72jHCFRJbpxQ+wgEIqqtV3E9DDxW7SEUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989458; c=relaxed/simple;
	bh=Kh29KrHML0LdQUP8lNfKfFxo+fH9BWh38JWujvvKLzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJC3bpXfJaZjRDQB3SEFHZM9zurbiKUXtdaSv7BR2Y0Pq4nHiMOukr+XQLYfIAq3N2hrgFt99fPYjyP3JkOuT62AFPoBJXZLFYdjI7/XSAwF+kbTUOBVF9e2KkcookJegvWJp2aKltMK7/AojU2SMv4UMU+cuZVQgJujcbMEU7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzeUMzoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzeUMzoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03463C433C7;
	Mon,  1 Apr 2024 16:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989458;
	bh=Kh29KrHML0LdQUP8lNfKfFxo+fH9BWh38JWujvvKLzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzeUMzoFRwqfDkyLxISp8yYKPq4D39p6sH8irQfOGs33CQJmTqnpKkZmTQ3GlAf+Q
	 1Tlyx0V8QATNEAAPd3NMl9QxmwfmPXG+COrx3blN2q/ITgP2kFJtxODaNVzoCMMLw1
	 Y2yNtH9fQfNtvkwlNDF0ot+XxV/OWYMWF6dza2Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/396] parisc/unaligned: Rewrite 64-bit inline assembly of emulate_ldd()
Date: Mon,  1 Apr 2024 17:41:42 +0200
Message-ID: <20240401152549.506316039@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit e5db6a74571a8baf87a116ea39aab946283362ff ]

Convert to use real temp variables instead of clobbering processor
registers. This aligns the 64-bit inline assembly code with the 32-bit
assembly code which was rewritten with commit 427c1073a2a1
("parisc/unaligned: Rewrite 32-bit inline assembly of emulate_ldd()").

While at it, fix comment in 32-bit rewrite code. Temporary variables are
now used for both 32-bit and 64-bit code, so move their declarations
to the function header.

No functional change intended.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/unaligned.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
index c520e551a1652..a8e75e5b884a7 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -169,6 +169,7 @@ static int emulate_ldw(struct pt_regs *regs, int toreg, int flop)
 static int emulate_ldd(struct pt_regs *regs, int toreg, int flop)
 {
 	unsigned long saddr = regs->ior;
+	unsigned long shift, temp1;
 	__u64 val = 0;
 	ASM_EXCEPTIONTABLE_VAR(ret);
 
@@ -180,25 +181,22 @@ static int emulate_ldd(struct pt_regs *regs, int toreg, int flop)
 
 #ifdef CONFIG_64BIT
 	__asm__ __volatile__  (
-"	depd,z	%3,60,3,%%r19\n"		/* r19=(ofs&7)*8 */
-"	mtsp	%4, %%sr1\n"
-"	depd	%%r0,63,3,%3\n"
-"1:	ldd	0(%%sr1,%3),%0\n"
-"2:	ldd	8(%%sr1,%3),%%r20\n"
-"	subi	64,%%r19,%%r19\n"
-"	mtsar	%%r19\n"
-"	shrpd	%0,%%r20,%%sar,%0\n"
+"	depd,z	%2,60,3,%3\n"		/* shift=(ofs&7)*8 */
+"	mtsp	%5, %%sr1\n"
+"	depd	%%r0,63,3,%2\n"
+"1:	ldd	0(%%sr1,%2),%0\n"
+"2:	ldd	8(%%sr1,%2),%4\n"
+"	subi	64,%3,%3\n"
+"	mtsar	%3\n"
+"	shrpd	%0,%4,%%sar,%0\n"
 "3:	\n"
 	ASM_EXCEPTIONTABLE_ENTRY_EFAULT(1b, 3b, "%1")
 	ASM_EXCEPTIONTABLE_ENTRY_EFAULT(2b, 3b, "%1")
-	: "=r" (val), "+r" (ret)
-	: "0" (val), "r" (saddr), "r" (regs->isr)
-	: "r19", "r20" );
+	: "+r" (val), "+r" (ret), "+r" (saddr), "=&r" (shift), "=&r" (temp1)
+	: "r" (regs->isr) );
 #else
-    {
-	unsigned long shift, temp1;
 	__asm__ __volatile__  (
-"	zdep	%2,29,2,%3\n"		/* r19=(ofs&3)*8 */
+"	zdep	%2,29,2,%3\n"		/* shift=(ofs&3)*8 */
 "	mtsp	%5, %%sr1\n"
 "	dep	%%r0,31,2,%2\n"
 "1:	ldw	0(%%sr1,%2),%0\n"
@@ -214,7 +212,6 @@ static int emulate_ldd(struct pt_regs *regs, int toreg, int flop)
 	ASM_EXCEPTIONTABLE_ENTRY_EFAULT(3b, 4b, "%1")
 	: "+r" (val), "+r" (ret), "+r" (saddr), "=&r" (shift), "=&r" (temp1)
 	: "r" (regs->isr) );
-    }
 #endif
 
 	DPRINTF("val = 0x%llx\n", val);
-- 
2.43.0



