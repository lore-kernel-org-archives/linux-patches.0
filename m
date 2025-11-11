Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE372DC328;
	Tue, 11 Nov 2025 01:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824678; cv=none; b=LSdmgzzkJSsnE9KWFiLAQSYVNl5CBSfr76eq2QQqT3NIdyVOl6NA4BHO1C6hhz5MucRTcdpZgykBamZR9NNKLoPBbXak/EWHZJbn6cz01jNe1docvE+D++sH4Zslm8H9Nk5ttmtF5M99IropcBPDWft0zgVpKxOct9Lo4huFMfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824678; c=relaxed/simple;
	bh=Fl0X1T9ynt1ZNeyiKqZfqNOjb+rNGdeJrxUC2GbLMLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejrKF/xnxLwRiE+Jf/IGJtPkOJDdCqvGDuf1791PJC9H3x93Z54+ZWUetT5RZgw/6YUWynQds/3Lhfk8r+1AsmsrZVKv13gzs0NdeEFgJDWlLASlEOVy7YdLiclU0/OQonFKcG1qBpckHqjNdWTLEohV3vvLC5q6UTj0gFvzk1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLY3LoTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLY3LoTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C28C4CEFB;
	Tue, 11 Nov 2025 01:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824676;
	bh=Fl0X1T9ynt1ZNeyiKqZfqNOjb+rNGdeJrxUC2GbLMLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLY3LoTd740L8YJlcFmxdpX2h/jfPCUd5XErROUlvTGfSwJOdj1oUcsWnIO9f5jTc
	 iBwMONMztEJsnpyEUUCpT6G0cy9byGVDzBPW1ZImYi4t+Pty9jvC8ryS/nqT5qddnh
	 YfvhvSJHcmPQDuvmJ6KaKATYrKUaRLEYhprhI4Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <David.Laight@aculab.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 496/565] x86: use cmov for user address masking
Date: Tue, 11 Nov 2025 09:45:52 +0900
Message-ID: <20251111004538.094514120@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 91309a70829d94c735c8bb1cc383e78c96127a16 ]

This was a suggestion by David Laight, and while I was slightly worried
that some micro-architecture would predict cmov like a conditional
branch, there is little reason to actually believe any core would be
that broken.

Intel documents that their existing cores treat CMOVcc as a data
dependency that will constrain speculation in their "Speculative
Execution Side Channel Mitigations" whitepaper:

  "Other instructions such as CMOVcc, AND, ADC, SBB and SETcc can also
   be used to prevent bounds check bypass by constraining speculative
   execution on current family 6 processors (Intel® Core™, Intel® Atom™,
   Intel® Xeon® and Intel® Xeon Phi™ processors)"

and while that leaves the future uarch issues open, that's certainly
true of our traditional SBB usage too.

Any core that predicts CMOV will be unusable for various crypto
algorithms that need data-independent timing stability, so let's just
treat CMOV as the safe choice that simplifies the address masking by
avoiding an extra instruction and doesn't need a temporary register.

Suggested-by: David Laight <David.Laight@aculab.com>
Link: https://www.intel.com/content/dam/develop/external/us/en/documents/336996-speculative-execution-side-channel-mitigations.pdf
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 284922f4c563 ("x86: uaccess: don't use runtime-const rewriting in modules")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/uaccess_64.h | 12 ++++++------
 arch/x86/lib/getuser.S            |  5 ++---
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index b0a887209400d..c52f0133425b9 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -63,13 +63,13 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm,
  */
 static inline void __user *mask_user_address(const void __user *ptr)
 {
-	unsigned long mask;
+	void __user *ret;
 	asm("cmp %1,%0\n\t"
-	    "sbb %0,%0"
-		:"=r" (mask)
-		:"r" (ptr),
-		 "0" (runtime_const_ptr(USER_PTR_MAX)));
-	return (__force void __user *)(mask | (__force unsigned long)ptr);
+	    "cmova %1,%0"
+		:"=r" (ret)
+		:"r" (runtime_const_ptr(USER_PTR_MAX)),
+		 "0" (ptr));
+	return ret;
 }
 #define masked_user_access_begin(x) ({				\
 	__auto_type __masked_ptr = (x);				\
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index 4357ec2a0bfc2..89ecd57c9d423 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -44,9 +44,8 @@
   .pushsection runtime_ptr_USER_PTR_MAX,"a"
 	.long 1b - 8 - .
   .popsection
-	cmp %rax, %rdx
-	sbb %rdx, %rdx
-	or %rdx, %rax
+	cmp %rdx, %rax
+	cmova %rdx, %rax
 .else
 	cmp $TASK_SIZE_MAX-\size+1, %eax
 	jae .Lbad_get_user
-- 
2.51.0



