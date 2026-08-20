Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BC7468C17;
	Thu, 20 Aug 2026 17:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247530; cv=none; b=U6gsPdQCqcXmvYxhEKKm2un6xYlLz41FmVpunOw4TL68150Qz8HuFot5HnSLMZJlHIQMJnDiSSVbAJ6+CpFFVUGu7ZmKb40J5/ZMnVbhzQvG8iB6gZ6+m21Dpy+owASA370YyBQ4K8krdwSteSpHYsf8vCnRXtWoNFqkSYVhp94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247530; c=relaxed/simple;
	bh=NX0ScRnzo/jU3muiomu/aGh/quDigkEcYqHmx40w1XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2FyEokn7MvCnjdhgaHLtEuJE6cfAcHOWYR8l6EPoa9+z0aqrw+ieA08gN5wg5f9TxzvFrQHJFstZJ1R3+kk/REktKwr3u2D4Izx25U+n8BICJCjKLFGCaJ/6Bh26eU/F/VwA+7l/RhQvGqtqFQ71UZrWzEVjTAWBfMVzeQIZyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phPF27jY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phPF27jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F7C1F000E9;
	Thu, 20 Aug 2026 17:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247527;
	bh=CvrC6Tsl1LZlbGe2NZ1MxJ7hndjrS+0BP+Ow0cv+qS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phPF27jYXn+i4Ro1ffueNV0oR/Jg4R4R/v2L3I8bO/wXaYNGaLsykKgT4xdIG0Bsw
	 KZ8tPdIzxOUM+63otS7D1SL3iuOLKVkes0Yihorr5n08fCVbl3F0FTIYFIzWFFBVit
	 CHfsqkjqsEicMQMnV7b6S/A6Eyj/RrAG//UXnzjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH 6.6 038/166] openrisc: signal: do not restore privileged SR bits on sigreturn
Date: Thu, 20 Aug 2026 16:54:57 +0200
Message-ID: <20260820145212.320708623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit 32ef1b30ad736519f7a207bcc2986f3d4129d972 upstream.

restore_sigcontext() copies the whole supervision register (SR) from the
signal frame and only clears SPR_SR_SM before the value is reloaded into
the hardware SR (through ESR and l.rfe) on the return to user space.  All
other SR bits are left under user control.

An unprivileged task can thus return from a signal handler through a
crafted sigframe that clears SPR_SR_DME.  With the data MMU disabled the
CPU performs no translation or protection on data accesses, so the task
gains read and write access to arbitrary physical memory, a local
privilege escalation.  SPR_SR_IME, SPR_SR_SUMRA, SPR_SR_LEE, SPR_SR_EPH
and the cache-enable bits are exposed the same way.  The ptrace GPR regset
already refuses any change to SR for exactly this reason.

Restore only the arithmetic flag bits (F, CY, OV) from the signal frame
and take every privileged control bit from the SR the kernel saved on
signal entry.

Verified with qemu-system-or1k -M or1k-sim: before this change an
unprivileged PoC clears SPR_SR_DME in rt_sigreturn and writes a marker to
physical address 0x03000000 (beyond the kernel's mem=32M); afterwards the
same PoC receives SIGSEGV and physical memory is unchanged.

Fixes: ac689eb7f9d4 ("OpenRISC: Signal handling")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/openrisc/include/asm/processor.h |    2 ++
 arch/openrisc/kernel/signal.c         |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/openrisc/include/asm/processor.h
+++ b/arch/openrisc/include/asm/processor.h
@@ -26,6 +26,8 @@
 		   | SPR_SR_DCE | SPR_SR_SM)
 #define USER_SR   (SPR_SR_DME | SPR_SR_IME | SPR_SR_ICE \
 		   | SPR_SR_DCE | SPR_SR_IEE | SPR_SR_TEE)
+/* SR bits user space may change via sigreturn, the rest stay kernel owned */
+#define SPR_SR_USER_MASK  (SPR_SR_F | SPR_SR_CY | SPR_SR_OV)
 
 /*
  * User space process size. This is hardcoded into a few places,
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -42,6 +42,7 @@ asmlinkage int do_work_pending(struct pt
 static int restore_sigcontext(struct pt_regs *regs,
 			      struct sigcontext __user *sc)
 {
+	unsigned long old_sr = regs->sr;
 	int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
@@ -57,8 +58,8 @@ static int restore_sigcontext(struct pt_
 	err |= __copy_from_user(&regs->sr, &sc->regs.sr, sizeof(unsigned long));
 	err |= __copy_from_user(&regs->fpcsr, &sc->fpcsr, sizeof(unsigned long));
 
-	/* make sure the SM-bit is cleared so user-mode cannot fool us */
-	regs->sr &= ~SPR_SR_SM;
+	/* keep the privileged SR bits kernel owned, restore only user flags */
+	regs->sr = (old_sr & ~SPR_SR_USER_MASK) | (regs->sr & SPR_SR_USER_MASK);
 
 	regs->orig_gpr11 = -1;	/* Avoid syscall restart checks */
 


