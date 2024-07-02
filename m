Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3CF1BE22B;
	Tue,  2 Jul 2024 17:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941356; cv=none; b=J6jdio5w+hji0z9Zqscabw7uKAMR5/eeahG0Z1owfTTLLUq0md+GMQhN/eJqMt4TiHQrB8da1NkURK2rx4h9Ys6OIJlv8W7XmiS4Iqvq62RRcwZ+Iymsrn22WzGX9IkxQJOliAfHKixGKOnmSyK3WmMoAyqBqiUB6MPaDz1McaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941356; c=relaxed/simple;
	bh=64zkpMYtgzeZMTduHgPJpBf6YvLaGylHb4msWL4CqfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzfZBLc+QsXwToLm6MKEPVyoSSSDDTXljPElBa56Y7nk32NZR2t9NLl8gfe05bezE0GIUsiwhyOsWhcOrJ58oeaKXKNkaNQpF7aNwlLMmEcwT4bVCnQ/i94jwM3nVr1HzT5GJFFLTytn1zHauoHwgG0dECfnvgbWfr01J5vaPFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxFsPzF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxFsPzF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7F8C116B1;
	Tue,  2 Jul 2024 17:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941356;
	bh=64zkpMYtgzeZMTduHgPJpBf6YvLaGylHb4msWL4CqfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxFsPzF5fbrPUddURLVY3zQbJzStTLdOqOgyNE92eyXwx2kAS+ieJ3fEILH1pexHv
	 KPjYurfghiRwUDceq6ORVcux6xZUkRSRMFHP4TT8dTNhgg2uFcCpvAtcmKQhMKIURJ
	 0UD15Uaefsbpu96hGZGiIK+fkhS+0eHky/zj3gm0=
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
Subject: [PATCH 6.1 040/128] x86/fpu: Fix AMD X86_BUG_FXSAVE_LEAK fixup
Date: Tue,  2 Jul 2024 19:04:01 +0200
Message-ID: <20240702170227.752131524@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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
index 1d190761d00fd..f1446f532b17b 100644
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



