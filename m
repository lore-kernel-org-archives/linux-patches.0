Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585735;
	b=QbXH2in+5qYDqkXElts64vcPMxjBSIrAyoi8H70bOPQWZg1rzqVjbhsMGd5XKHGOZ4lA
	 ABD9+Jl+z+qryT+FKgARdR9pV20eY6DTVE/dLwHz11VbbnGaJCnE/PDOE5JQD9ugDZ9Hn
	 1E1ANTJ5CJD4sCPyrqkQms3r4mJoTl2Jx4P4K6S6naQZNWUlkR8DVS54q4gUqmv2GhTK0
	 OyZoUM//x55gEKEEssxmbycsTYH3ttc5JkVuSUJpxFloAVWAqOAGJ9ceXFcRKWUtx3Rln
	 f2SkLGuzTpsscxOwsAjPyqlpcPgiyMfr3Dj+wgJpJXWlACOxaceROLjyRH1t8RSFWng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D7k8J1AqLoY4OYyfMhdMZ4HiV2S1XRLdKTNyGBggGMs=;
	b=GbrFnxRyLE04q/Sc9WFaRFBo7d974AqP1LJ0PTDrEQVgvyU2SDy16Cblqj24xfzyhu7G
	 WPrwZrcYpFO4j6JALjO/+yMbwpt/DexBBE229NFz+XZHMe6JYC5w8I4CxiUg3aJMUzqT1
	 /NgPl7JqT18z3wNZ1kmny0vBqvxosCOOVkt9VSDNPilGnt/Xe7SDvETqlx5RF+2rRa1IP
	 IyXllMZkUNHJsSchF/1CdRq/OYe75Md3hKCm+vz+AynxJ0AQM5XE0wyz6S3tsGP6Swc0U
	 WmxTRvSciJ23NZ9wuqF4dJAPtx0DalVyvtkAB1NEqGcoTXnf3gRL6uB33Ww+n3cZIKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dj+3joac;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF2E606A338;
	Fri, 13 Nov 2026 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dj+3joac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02351F000C4;
	Fri, 13 Nov 2026 16:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585735;
	bh=D7k8J1AqLoY4OYyfMhdMZ4HiV2S1XRLdKTNyGBggGMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dj+3joacX6oZIwAF/6dfWeVZR70wYtSTu51JWNGxs7y+prh/3Ywy3Rm3Av4f0rYAb
	 keDe6vQ6iw4w6EIOi2diGs3C1En8zOjV7/eKa5Oierpr7iEj0nnotLkX77jEgPxYwU
	 vwDTfjaLuscPvRs8NIGlx5L7UzUDDE3LLpqK41mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 335/507] x86/entry: Fix ptrace regression
Date: Fri, 13 Nov 2026 10:50:39 -0500
Message-ID: <20261113153806.776943160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit b697faab2c92653ee13bd950c8de13551a78971d ]

The recent rework of the syscall entry code missed the historical detail of
the abuse of syscall number -1L to abort a syscall and keep modifications
by tracers to the return value, while a rewrite of the syscall number to an
invalid value undoes eventual tracer modification to the return value and
overwrite it with -ENOSYS.

Restore the original behaviour.

Fixes: 1b1f3b3e1b39 ("x86/entry: Get rid of the sys_ni_syscall() indirection")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/87ecd4xwlr.ffs@fw13
Closes: https://lore.kernel.org/all/20261022142425.3Wx-RrU5@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/syscall_32.c |  4 ++++
 arch/x86/entry/syscall_64.c | 26 ++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/syscall_32.c b/arch/x86/entry/syscall_32.c
index 91123a90710c4..4c36e8db0e341 100644
--- a/arch/x86/entry/syscall_32.c
+++ b/arch/x86/entry/syscall_32.c
@@ -77,6 +77,10 @@ static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs, unsigned
 	if (likely(nr < IA32_NR_syscalls)) {
 		nr = array_index_nospec(nr, IA32_NR_syscalls);
 		regs->ax = ia32_sys_call(regs, (unsigned int)nr);
+	} else {
+		/* See comment in do_syscall_64() */
+		if (nr != -1UL)
+			regs->ax = -ENOSYS;
 	}
 }
 
diff --git a/arch/x86/entry/syscall_64.c b/arch/x86/entry/syscall_64.c
index 966d3d1b75868..bb95ad0ab7862 100644
--- a/arch/x86/entry/syscall_64.c
+++ b/arch/x86/entry/syscall_64.c
@@ -64,15 +64,20 @@ static __always_inline bool do_syscall_x64(struct pt_regs *regs, unsigned long n
 	return false;
 }
 
-static __always_inline void do_syscall_x32(struct pt_regs *regs, unsigned long nr)
+static __always_inline bool do_syscall_x32(struct pt_regs *regs, unsigned long nr)
 {
+	if (!IS_ENABLED(CONFIG_X86_X32_ABI))
+		return false;
+
 	/* Adjust the starting offset of the table */
 	nr -= __X32_SYSCALL_BIT;
 
-	if (IS_ENABLED(CONFIG_X86_X32_ABI) && likely(nr < X32_NR_syscalls)) {
+	if (likely(nr < X32_NR_syscalls)) {
 		nr = array_index_nospec(nr, X32_NR_syscalls);
 		regs->ax = x32_sys_call(regs, (unsigned int)nr);
+		return true;
 	}
+	return false;
 }
 
 /* Returns true to return using SYSRET, or false to use IRET */
@@ -81,8 +86,21 @@ __visible noinstr bool do_syscall_64(struct pt_regs *regs, long nr)
 	if (likely(syscall_enter_from_user_mode_randomize_stack(regs, &nr))) {
 		instrumentation_begin();
 
-		if (!do_syscall_x64(regs, nr))
-			do_syscall_x32(regs, nr);
+		if (unlikely(!do_syscall_x64(regs, nr))) {
+			/*
+			 * The special treatment of syscall number -1 is a
+			 * historical bogosity as the original code used -1 to
+			 * indicate syscall abort, which is not distinguishable
+			 * from a syscall which is invoked with syscall number
+			 * -1. The historic behavior is to keep the return value
+			 * in regs->ax unmodified in that case, which means it's
+			 * either the preset value -ENOSYS or a value which was
+			 * written by a tracer. If the syscall number is invalid
+			 * but not -1 then overwrite any tracer modification.
+			 */
+			if (!do_syscall_x32(regs, nr) && nr != -1L)
+				regs->ax = -ENOSYS;
+		}
 
 		instrumentation_end();
 	}
-- 
2.53.0



