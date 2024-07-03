Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AD2180A8A;
	Wed,  3 Jul 2024 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006155; cv=none; b=PhtbuwI3k8WIhaOwGeUKHPUvWECqLs1eNmiVRCvo0MMBVipKsidN+yJfxczJHGskomv0zMlf8B6bus+wmEiVvWXq3POaDeBLiIWUMjHCV9djmO881ENV1vwgR/gXdkZNGlca9C4KlJEmNq7TbA+hP8r/XqFPp9jpFMa3vRVbURQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006155; c=relaxed/simple;
	bh=1QEllGUOPFOJW4wTj6bwMrCSmNmPdqDtnmo26wPx+Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+76H5krzHa9EFfE70DLHf6vWShrYZMsddEpAjhorLxiC10/YeUIbJDC28js2r1demR4F/8NBwPeNrFY30MIj3sroTOSYg9OWB9rB8aPT5nVtWhfGVaKA2XuRJhb65iRdTN4JVrVsxNr3uWbribMk90J638eKxDusccBYpI2OQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rna0awa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rna0awa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B108EC2BD10;
	Wed,  3 Jul 2024 11:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006155;
	bh=1QEllGUOPFOJW4wTj6bwMrCSmNmPdqDtnmo26wPx+Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rna0awaKPWUZ7MR7vEOjCX1NNbqh9R4r9DouD+wO6SWe056oQ0nUzV2JdQDzSbl4
	 zeWxLjLrdPDXwN0/k98j3BIA81GVK2AF3vacJ+dwAL29dyHj0hkXCPqAJOn8qfZ1Gr
	 pcWCK8/eOYAPM/aUteyZ4vHGgzSSW14M6MDnS5Fc=
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
Subject: [PATCH 5.15 287/356] x86/fpu: Fix AMD X86_BUG_FXSAVE_LEAK fixup
Date: Wed,  3 Jul 2024 12:40:23 +0200
Message-ID: <20240703102923.973239167@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3ad1bf5de7373..157008d99f951 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -121,8 +121,8 @@ void __restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask)
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



