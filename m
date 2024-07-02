Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EBA1BD002;
	Tue,  2 Jul 2024 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940164; cv=none; b=coceicMPobYu1luutwAeS1Uvhb8i3bPDFcoL8gSJcFSbquAKfHs5Tzn73n6qqTWr1wvCZHTwvAr8HReXTJgsqiXuweD4gs0OE+s02rJjH6j0vo4eEi0t2jifVsTAYx7kwdwajJR2rcpTM1oJVzKNnWQ7Ds8neCNBCG+8d1t8f58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940164; c=relaxed/simple;
	bh=h8SGg87h/5F7skgFxWGNvSN4LBstXx+PlLnlUk9AyVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2mmFMrue3w9FftX5t26398r9bVaDNDKw625Hj4m/+mowGQW4dT3Q2RUjNDIsco4ioloZ97L5lSXJmnkNwQ/B7RXqP4dT34/eso7byUHVTUWqlnxcPf2PEWxNqkC7ZgKqA6r91yJ+fJJUvbWQ7bAQ+g5CM1t3Dp1+1ANdV4UY/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyEMzzgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyEMzzgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBADC116B1;
	Tue,  2 Jul 2024 17:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940163;
	bh=h8SGg87h/5F7skgFxWGNvSN4LBstXx+PlLnlUk9AyVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyEMzzgLzY7KiRVkR0EyYo5BemHDFwzckdFWP5P7kprZwo9NBn6KbTeqYmyqsKswp
	 lrZMEyYNMZZ2EJECpdFXEsp2X7WlKvDwy9ID29AnkAzWMxoKoXMVS2skAIFGrkSNP3
	 SDZ/vcH637QRJqSUsW0eC453MVf7WXF/vaSB28Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 071/222] x86/fpu: Fix AMD X86_BUG_FXSAVE_LEAK fixup
Date: Tue,  2 Jul 2024 19:01:49 +0200
Message-ID: <20240702170246.694778248@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit 5d31174f3c8c465d9dbe88f6b9d1fe5716f44981 ]

The assembly snippet in restore_fpregs_from_fpstate() that implements
X86_BUG_FXSAVE_LEAK fixup loads the value from a random variable,
preferably the one that is already in the L1 cache.

However, the access to fpinit_state via *fpstate pointer is not
implemented correctly. The "m" asm constraint requires dereferenced
pointer variable, otherwise the compiler just reloads the value
via temporary stack slot. The current asm code reflects this:

     mov    %rdi,(%rsp)
     ...
     fildl  (%rsp)

With dereferenced pointer variable, the code does what the
comment above the asm snippet says:

     fildl  (%rdi)

Also, remove the pointless %P operand modifier. The modifier is
ineffective on non-symbolic references - it was used to prevent
%rip-relative addresses in .altinstr sections, but FILDL in the
.text section can use %rip-relative addresses without problems.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240315081849.5187-1-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 520deb411a702..1209c7aebb211 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -145,8 +145,8 @@ void restore_fpregs_from_fpstate(struct fpstate *fpstate, u64 mask)
 		asm volatile(
 			"fnclex\n\t"
 			"emms\n\t"
-			"fildl %P[addr]"	/* set F?P to defined value */
-			: : [addr] "m" (fpstate));
+			"fildl %[addr]"	/* set F?P to defined value */
+			: : [addr] "m" (*fpstate));
 	}
 
 	if (use_xsave()) {
-- 
2.43.0



