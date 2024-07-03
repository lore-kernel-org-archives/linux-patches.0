Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17703175545;
	Wed,  3 Jul 2024 10:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003644; cv=none; b=YczxJwueqEaPHWge+gwe9q5goGz3GppVQpjRPIiJfIccIrSjLwrNbyqcYtW+Z/McoIM3ywdF2qvw9SyJNMdw/ZgOG21WEye3xAHMcEBdIUtoVBXr6bOgUEBfwtWmvbJjUbwc+jjY6w90TxdozfVbM+K52SSx0V+9d2PSBZcHNi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003644; c=relaxed/simple;
	bh=0aaYNGZGZe3j2pN8mWrWWNaNMqkRh0V3S+JChQgLM24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqNluL8Bs41CgE0ekCHgzUt+3twDmTPxVe3tBIaQAFWkMt0KVRYRuR3hAsddBvh7aDbk0c25AofH3Zwpii4FrryzJjvuRl5xR/aScMQkcILsKx8Qs1EJAKeYZjM8l0CYZRvRw8LYSbM1l+zpg6lk0IKRK3wOrOMMD//5YnMUwbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIpo4F1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIpo4F1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFCFC2BD10;
	Wed,  3 Jul 2024 10:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003643;
	bh=0aaYNGZGZe3j2pN8mWrWWNaNMqkRh0V3S+JChQgLM24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIpo4F1UGoA0//UkVrQoe8FESEdLQQYGCbsM7G+pMQ/BsrDfEfGzX7GC1hswHHir2
	 OR6taGRLMklmPJ+WLxzpYs6QvEmMKW4LJdTAw1jQvOIEvkhGoLu3d2qEA8sRmIYhKL
	 CvXBGTsVouKTKLP8xILV/ofkRKGNu+KNi2nzTDmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/139] x86: stop playing stack games in profile_pc()
Date: Wed,  3 Jul 2024 12:40:13 +0200
Message-ID: <20240703102834.820327776@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 093d9603b60093a9aaae942db56107f6432a5dca ]

The 'profile_pc()' function is used for timer-based profiling, which
isn't really all that relevant any more to begin with, but it also ends
up making assumptions based on the stack layout that aren't necessarily
valid.

Basically, the code tries to account the time spent in spinlocks to the
caller rather than the spinlock, and while I support that as a concept,
it's not worth the code complexity or the KASAN warnings when no serious
profiling is done using timers anyway these days.

And the code really does depend on stack layout that is only true in the
simplest of cases.  We've lost the comment at some point (I think when
the 32-bit and 64-bit code was unified), but it used to say:

	Assume the lock function has either no stack frame or a copy
	of eflags from PUSHF.

which explains why it just blindly loads a word or two straight off the
stack pointer and then takes a minimal look at the values to just check
if they might be eflags or the return pc:

	Eflags always has bits 22 and up cleared unlike kernel addresses

but that basic stack layout assumption assumes that there isn't any lock
debugging etc going on that would complicate the code and cause a stack
frame.

It causes KASAN unhappiness reported for years by syzkaller [1] and
others [2].

With no real practical reason for this any more, just remove the code.

Just for historical interest, here's some background commits relating to
this code from 2006:

  0cb91a229364 ("i386: Account spinlocks to the caller during profiling for !FP kernels")
  31679f38d886 ("Simplify profile_pc on x86-64")

and a code unification from 2009:

  ef4512882dbe ("x86: time_32/64.c unify profile_pc")

but the basics of this thing actually goes back to before the git tree.

Link: https://syzkaller.appspot.com/bug?extid=84fe685c02cd112a2ac3 [1]
Link: https://lore.kernel.org/all/CAK55_s7Xyq=nh97=K=G1sxueOFrJDAvPOJAL4TPTCAYvmxO9_A@mail.gmail.com/ [2]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/time.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 0680a2e9e06bb..b52ba6962325c 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -26,26 +26,7 @@
 
 unsigned long profile_pc(struct pt_regs *regs)
 {
-	unsigned long pc = instruction_pointer(regs);
-
-	if (!user_mode(regs) && in_lock_functions(pc)) {
-#ifdef CONFIG_FRAME_POINTER
-		return *(unsigned long *)(regs->bp + sizeof(long));
-#else
-		unsigned long *sp =
-			(unsigned long *)kernel_stack_pointer(regs);
-		/*
-		 * Return address is either directly at stack pointer
-		 * or above a saved flags. Eflags has bits 22-31 zero,
-		 * kernel addresses don't.
-		 */
-		if (sp[0] >> 22)
-			return sp[0];
-		if (sp[1] >> 22)
-			return sp[1];
-#endif
-	}
-	return pc;
+	return instruction_pointer(regs);
 }
 EXPORT_SYMBOL(profile_pc);
 
-- 
2.43.0



