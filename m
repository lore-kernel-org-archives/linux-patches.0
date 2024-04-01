Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0EC1E86C;
	Mon,  1 Apr 2024 16:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990717; cv=none; b=X1KEENf8AIIKzvriMu+f33yv0Av7Ot+RAtOyK12aBKdlj20/26h35+xX+ZrtDGQF7HTxICGOX/hCDt3W9lqaW+8bAIWVwRcNQRfTwtjjbLfhubCpVztNMFIHxG2VO52ErnoO4BCafwQ17oGcnPFLBRBkLGc+Qlgs9f5fXJdfAIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990717; c=relaxed/simple;
	bh=LLxOVD+Iko8MczvrXpEZoK6g2DT51793yKXgBj6Q9Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJVBZXzWrZhI3zqW5i8agdxcMr+nZweIv5YFM7AG4HsEtuYPzjwi33BuWO+tJImkV3eZhVJUshdYRlgTBm89EdBM2ze3eHLgfa/FlSIKlwAGVR8Drja8mn+Ky0EQtYNnCkgwpqlcvQJ2g6bL0QJOfrpxoa6Du05oVvHdRwPMTco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdowHDXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdowHDXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6E0C433F1;
	Mon,  1 Apr 2024 16:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990717;
	bh=LLxOVD+Iko8MczvrXpEZoK6g2DT51793yKXgBj6Q9Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdowHDXBkaEmfWF7s8wdEm8CKWEoxK/hhsNcwIk8FUQnrpv947q1IOJpDZ/w3mPl0
	 E6eoHbleJpzVzcksf++3zi54a0ruLoPRYull1KfA5bpzcsN8nW6cxO6iNYdqQGEEIP
	 QgqfUSYOQ4bGMMTnbRyKuvc6Abz1b44bwjyaW73M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/272] parisc/unaligned: Rewrite 64-bit inline assembly of emulate_ldd()
Date: Mon,  1 Apr 2024 17:43:54 +0200
Message-ID: <20240401152531.776546462@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a8e7d7224a26..782ee05e20889 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -167,6 +167,7 @@ static int emulate_ldw(struct pt_regs *regs, int toreg, int flop)
 static int emulate_ldd(struct pt_regs *regs, int toreg, int flop)
 {
 	unsigned long saddr = regs->ior;
+	unsigned long shift, temp1;
 	__u64 val = 0;
 	ASM_EXCEPTIONTABLE_VAR(ret);
 
@@ -178,25 +179,22 @@ static int emulate_ldd(struct pt_regs *regs, int toreg, int flop)
 
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
@@ -212,7 +210,6 @@ static int emulate_ldd(struct pt_regs *regs, int toreg, int flop)
 	ASM_EXCEPTIONTABLE_ENTRY_EFAULT(3b, 4b, "%1")
 	: "+r" (val), "+r" (ret), "+r" (saddr), "=&r" (shift), "=&r" (temp1)
 	: "r" (regs->isr) );
-    }
 #endif
 
 	DPRINTF("val = 0x%llx\n", val);
-- 
2.43.0



