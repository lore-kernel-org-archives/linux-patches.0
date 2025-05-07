Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508F214A4C7;
	Wed,  7 May 2025 18:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643500; cv=none; b=pfnPeD0I9SRVxAfTAb6SPFlzMQ0cFaT8yyBMiIvMS0M3Inpoy/yiZtxJszY2mXo4MuTHv9On2wto0wOu0+B+1imD+JuxW8YLWMNec1s+I5e6DQ+f0iWQYv9u3S0mybW5kEwZ3oNNDfqq1y/JpqYZALAV/VLQb5LvnTtzxSViRtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643500; c=relaxed/simple;
	bh=BZlVa/rQk0l+DNLbMhZXDQoFHH9bT7/zq6v2vqwrXZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJ4Xz4boLecObn8LUMNBqMXOmdnQ3cb4GhRNLAIrBsrG++yNxIT5/JQ7d2ymPTW+8PPAA+t71Fn1RjIQ7mvriz5HLysQaE2XHgPxsNZfPUlS9OSZqvBrMhKJwr1hbTqKFCZ5fOus6HrInVGt+5GZhqavvxFbHkLeQhANDWx16kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypAp3k/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypAp3k/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C333DC4CEE2;
	Wed,  7 May 2025 18:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643500;
	bh=BZlVa/rQk0l+DNLbMhZXDQoFHH9bT7/zq6v2vqwrXZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypAp3k/1iHnpNQwEK+TK30sTUXC6Q0SUhAAQi66oxrPGQu/ykKlx/CnPS+HgtQQly
	 9kLcvrlGilkpnuyUeTIIhFy/x2s4FknBWX292NjUGoIGGvhGjrs+jOwF6VxMEXX24Y
	 DbHB3SOZiqHGuCh54pA9zk4ErDn5Hg7eU/5petq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John David Anglin <dave.anglin@bell.net>,
	Camm Maguire <camm@maguirefamily.org>
Subject: [PATCH 6.1 08/97] parisc: Fix double SIGFPE crash
Date: Wed,  7 May 2025 20:38:43 +0200
Message-ID: <20250507183807.330196030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


