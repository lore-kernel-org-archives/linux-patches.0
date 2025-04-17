Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124DE1A3178;
	Thu, 17 Apr 2025 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915201; cv=none; b=tK/5O7U0ceDIsfCnbqimQkUpm4lbQyQyFc5ZHIPK+grY/a4NHeqTHdiM85wcdCU5JN1pL/Q8MQ5S6jPTZTeUDP8/Q90KKS3Ib0Rq/WLuDU6EOZohfaZn/gehx2DMwZY4KmIvuADeC0nKe9+NzugwNJhZlrEbSh0c7T9y+RUQ4Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915201; c=relaxed/simple;
	bh=08vhaarHIrdSVA9BKg6ePkOfRC/OeMQ83ehj2gnZfss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8aZTjNJRXsKJ6oiwOX6JkEcSb4BLD8zdo/kE+sBP0V/7QctvVGGZKFdv1RWNwvb+tffgXW7DmeNL0lUsTVF0GtIqBqykVXIVvV7xcLOEX6jrllDmljQoUskZynR+SJgtaqMwqSmNbbeYj9rcytO2Ztzmrs5+jBCVtR13Ti5QUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ja/5Iz9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ja/5Iz9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFACC4CEE4;
	Thu, 17 Apr 2025 18:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915200;
	bh=08vhaarHIrdSVA9BKg6ePkOfRC/OeMQ83ehj2gnZfss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ja/5Iz9yqEx3UGCQWoiZg7QIAOD4w4m9er4rD0QK2ss3+RMYIuid7dKGANh1VhkpU
	 7jE9I6Wui3WQOa1EVxolAD/AVuyDGOJUrDnOtjZ7h1povHOhOdmAAIrtO208lC3LNe
	 x+d8shjakmKJewvokHHr+Ifhlb8MIOMD+7k32/vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xin Li (Intel)" <xin@zytor.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/393] x86/ia32: Leave NULL selector values 0~3 unchanged
Date: Thu, 17 Apr 2025 19:47:39 +0200
Message-ID: <20250417175109.601959598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Xin Li (Intel) <xin@zytor.com>

[ Upstream commit ad546940b5991d3e141238cd80a6d1894b767184 ]

The first GDT descriptor is reserved as 'NULL descriptor'.  As bits 0
and 1 of a segment selector, i.e., the RPL bits, are NOT used to index
GDT, selector values 0~3 all point to the NULL descriptor, thus values
0, 1, 2 and 3 are all valid NULL selector values.

When a NULL selector value is to be loaded into a segment register,
reload_segments() sets its RPL bits.  Later IRET zeros ES, FS, GS, and
DS segment registers if any of them is found to have any nonzero NULL
selector value.  The two operations offset each other to actually effect
a nop.

Besides, zeroing of RPL in NULL selector values is an information leak
in pre-FRED systems as userspace can spot any interrupt/exception by
loading a nonzero NULL selector, and waiting for it to become zero.
But there is nothing software can do to prevent it before FRED.

ERETU, the only legit instruction to return to userspace from kernel
under FRED, by design does NOT zero any segment register to avoid this
problem behavior.

As such, leave NULL selector values 0~3 unchanged and close the leak.

Do the same on 32-bit kernel as well.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241126184529.1607334-1-xin@zytor.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/signal_32.c | 62 +++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index ef654530bf5a9..98123ff10506c 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -33,25 +33,55 @@
 #include <asm/smap.h>
 #include <asm/gsseg.h>
 
+/*
+ * The first GDT descriptor is reserved as 'NULL descriptor'.  As bits 0
+ * and 1 of a segment selector, i.e., the RPL bits, are NOT used to index
+ * GDT, selector values 0~3 all point to the NULL descriptor, thus values
+ * 0, 1, 2 and 3 are all valid NULL selector values.
+ *
+ * However IRET zeros ES, FS, GS, and DS segment registers if any of them
+ * is found to have any nonzero NULL selector value, which can be used by
+ * userspace in pre-FRED systems to spot any interrupt/exception by loading
+ * a nonzero NULL selector and waiting for it to become zero.  Before FRED
+ * there was nothing software could do to prevent such an information leak.
+ *
+ * ERETU, the only legit instruction to return to userspace from kernel
+ * under FRED, by design does NOT zero any segment register to avoid this
+ * problem behavior.
+ *
+ * As such, leave NULL selector values 0~3 unchanged.
+ */
+static inline u16 fixup_rpl(u16 sel)
+{
+	return sel <= 3 ? sel : sel | 3;
+}
+
 #ifdef CONFIG_IA32_EMULATION
 #include <asm/unistd_32_ia32.h>
 
 static inline void reload_segments(struct sigcontext_32 *sc)
 {
-	unsigned int cur;
+	u16 cur;
 
+	/*
+	 * Reload fs and gs if they have changed in the signal
+	 * handler.  This does not handle long fs/gs base changes in
+	 * the handler, but does not clobber them at least in the
+	 * normal case.
+	 */
 	savesegment(gs, cur);
-	if ((sc->gs | 0x03) != cur)
-		load_gs_index(sc->gs | 0x03);
+	if (fixup_rpl(sc->gs) != cur)
+		load_gs_index(fixup_rpl(sc->gs));
 	savesegment(fs, cur);
-	if ((sc->fs | 0x03) != cur)
-		loadsegment(fs, sc->fs | 0x03);
+	if (fixup_rpl(sc->fs) != cur)
+		loadsegment(fs, fixup_rpl(sc->fs));
+
 	savesegment(ds, cur);
-	if ((sc->ds | 0x03) != cur)
-		loadsegment(ds, sc->ds | 0x03);
+	if (fixup_rpl(sc->ds) != cur)
+		loadsegment(ds, fixup_rpl(sc->ds));
 	savesegment(es, cur);
-	if ((sc->es | 0x03) != cur)
-		loadsegment(es, sc->es | 0x03);
+	if (fixup_rpl(sc->es) != cur)
+		loadsegment(es, fixup_rpl(sc->es));
 }
 
 #define sigset32_t			compat_sigset_t
@@ -105,18 +135,12 @@ static bool ia32_restore_sigcontext(struct pt_regs *regs,
 	regs->orig_ax = -1;
 
 #ifdef CONFIG_IA32_EMULATION
-	/*
-	 * Reload fs and gs if they have changed in the signal
-	 * handler.  This does not handle long fs/gs base changes in
-	 * the handler, but does not clobber them at least in the
-	 * normal case.
-	 */
 	reload_segments(&sc);
 #else
-	loadsegment(gs, sc.gs);
-	regs->fs = sc.fs;
-	regs->es = sc.es;
-	regs->ds = sc.ds;
+	loadsegment(gs, fixup_rpl(sc.gs));
+	regs->fs = fixup_rpl(sc.fs);
+	regs->es = fixup_rpl(sc.es);
+	regs->ds = fixup_rpl(sc.ds);
 #endif
 
 	return fpu__restore_sig(compat_ptr(sc.fpstate), 1);
-- 
2.39.5



