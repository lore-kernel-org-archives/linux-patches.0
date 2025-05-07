Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A14C14A4C7;
	Wed,  7 May 2025 18:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643345; cv=none; b=K96LEIbin7kWhtE20Z7Juz2IwiaKfLg9oyVsrzFrwAxs8/n+nDrWNEbsz8OtIqsjDX/jqc6nyI9Sui+QrBQ/jH90MIy2FDc24r0IKhd3zFcjU+RNsrMwRVLLr7GsjjrLCSR6pK/qh1URE4y8e4tkWC3VR7gYctqM62nAxlbxF7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643345; c=relaxed/simple;
	bh=3L0J5hoQ6a3UXagCYRxa5SKudUUbJ0EGO+bHc5tVmJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFtbOcTMcTDWPGTEE7taWDQhdT7Cl7UygulgIp7NdHfHeFnJuc2XYJ3clv1atQkkIwTCz7612PfaSqm/GarMCmuFPILwYnPz+rpNTiCKY9/+y7SOXOrXMq8RBSJgPxSMC55r6kFaxrtJkcqubeP/og8pkPVc87sN1UDSljT4Ymg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kmev6v2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kmev6v2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DF5C4CEE2;
	Wed,  7 May 2025 18:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643344;
	bh=3L0J5hoQ6a3UXagCYRxa5SKudUUbJ0EGO+bHc5tVmJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kmev6v2ELmQsH8sD7LwUXky/Tji7ud018SUoVf0nYROP/G1hKj6osXXTwg21QWYxI
	 LtBwYpUm8Nbw3cAfSTLE+iV/vscpJQW2eTwPc0kDQOcUn33N6hwb2C1dEx5OblyIwq
	 /90L+iwrN0srhtrTFSpMeuwibjy5l1Va+bUTH5Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John David Anglin <dave.anglin@bell.net>,
	Camm Maguire <camm@maguirefamily.org>
Subject: [PATCH 5.15 07/55] parisc: Fix double SIGFPE crash
Date: Wed,  7 May 2025 20:39:08 +0200
Message-ID: <20250507183759.350095950@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit de3629baf5a33af1919dec7136d643b0662e85ef upstream.

Camm noticed that on parisc a SIGFPE exception will crash an application with
a second SIGFPE in the signal handler.  Dave analyzed it, and it happens
because glibc uses a double-word floating-point store to atomically update
function descriptors. As a result of lazy binding, we hit a floating-point
store in fpe_func almost immediately.

When the T bit is set, an assist exception trap occurs when when the
co-processor encounters *any* floating-point instruction except for a double
store of register %fr0.  The latter cancels all pending traps.  Let's fix this
by clearing the Trap (T) bit in the FP status register before returning to the
signal handler in userspace.

The issue can be reproduced with this test program:

root@parisc:~# cat fpe.c

static void fpe_func(int sig, siginfo_t *i, void *v) {
        sigset_t set;
        sigemptyset(&set);
        sigaddset(&set, SIGFPE);
        sigprocmask(SIG_UNBLOCK, &set, NULL);
        printf("GOT signal %d with si_code %ld\n", sig, i->si_code);
}

int main() {
        struct sigaction action = {
                .sa_sigaction = fpe_func,
                .sa_flags = SA_RESTART|SA_SIGINFO };
        sigaction(SIGFPE, &action, 0);
        feenableexcept(FE_OVERFLOW);
        return printf("%lf\n",1.7976931348623158E308*1.7976931348623158E308);
}

root@parisc:~# gcc fpe.c -lm
root@parisc:~# ./a.out
 Floating point exception

root@parisc:~# strace -f ./a.out
 execve("./a.out", ["./a.out"], 0xf9ac7034 /* 20 vars */) = 0
 getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
 ...
 rt_sigaction(SIGFPE, {sa_handler=0x1110a, sa_mask=[], sa_flags=SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
 --- SIGFPE {si_signo=SIGFPE, si_code=FPE_FLTOVF, si_addr=0x1078f} ---
 --- SIGFPE {si_signo=SIGFPE, si_code=FPE_FLTOVF, si_addr=0xf8f21237} ---
 +++ killed by SIGFPE +++
 Floating point exception

Signed-off-by: Helge Deller <deller@gmx.de>
Suggested-by: John David Anglin <dave.anglin@bell.net>
Reported-by: Camm Maguire <camm@maguirefamily.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/math-emu/driver.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/arch/parisc/math-emu/driver.c
+++ b/arch/parisc/math-emu/driver.c
@@ -103,9 +103,19 @@ handle_fpe(struct pt_regs *regs)
 
 	memcpy(regs->fr, frcopy, sizeof regs->fr);
 	if (signalcode != 0) {
-	    force_sig_fault(signalcode >> 24, signalcode & 0xffffff,
-			    (void __user *) regs->iaoq[0]);
-	    return -1;
+		int sig = signalcode >> 24;
+
+		if (sig == SIGFPE) {
+			/*
+			 * Clear floating point trap bit to avoid trapping
+			 * again on the first floating-point instruction in
+			 * the userspace signal handler.
+			 */
+			regs->fr[0] &= ~(1ULL << 38);
+		}
+		force_sig_fault(sig, signalcode & 0xffffff,
+				(void __user *) regs->iaoq[0]);
+		return -1;
 	}
 
 	return signalcode ? -1 : 0;


