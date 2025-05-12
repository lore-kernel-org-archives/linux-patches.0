Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E22296FA7;
	Mon, 12 May 2025 17:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072570; cv=none; b=BNu5MtgsQy9kfCFbMvHfzi3v2oj0aOJknKZuE/wWWVro7+f0ZqQ6BhiBw9oFbwqiqkYEHdf+91sjwe8Ky9QuVrZyMlsIOaUL5nox+4ns8mbgRXP+MfXMhbu6CakLaehOk4CX4M6tN0zPMSABEN2DSPQl+IGDvz9YY7+6zqjpTQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072570; c=relaxed/simple;
	bh=/zsbAa8oIgKmIFPYRWKclbNLfPnjQybECQI6q3KTnF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggEP9+3tXmXCY1CGrhMX3TcrSfupx2cEqdiJWmmbBOVyXRufvFwhjYIgj4RF1PAr8z6gw1cjcUlBdT9KJEhPDDsVtVeg3+Uwtr6flWQiS87UmiTCWI36f/CiPNp7wga5pIffIDYK2TZlMwl3ktXmAyAMzCpyJfkCwfcQl478XIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUvXcvde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUvXcvde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D907C4CEE9;
	Mon, 12 May 2025 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072569;
	bh=/zsbAa8oIgKmIFPYRWKclbNLfPnjQybECQI6q3KTnF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUvXcvdesKMPY4pNVBm1bTsmCNc/68br1Xc6ulVDfmCdN8YbtfqEN3+Dpm0kGWJPs
	 NXyJcfPxgwqn8wEV9yRKLXlz8XqOT2HxPe3GzwDlY0Ga2kx+KFTiUdSWiIYH6VcYMy
	 XrOo5ttLaetN8VPzTg+xjgvOVqomSoQugSMDrISQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.1 81/92] x86/speculation: Simplify and make CALL_NOSPEC consistent
Date: Mon, 12 May 2025 19:45:56 +0200
Message-ID: <20250512172026.424293949@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit cfceff8526a426948b53445c02bcb98453c7330d upstream.

CALL_NOSPEC macro is used to generate Spectre-v2 mitigation friendly
indirect branches. At compile time the macro defaults to indirect branch,
and at runtime those can be patched to thunk based mitigations.

This approach is opposite of what is done for the rest of the kernel, where
the compile time default is to replace indirect calls with retpoline thunk
calls.

Make CALL_NOSPEC consistent with the rest of the kernel, default to
retpoline thunk at compile time when CONFIG_RETPOLINE is
enabled.

  [ pawan: s/CONFIG_MITIGATION_RETPOLINE/CONFIG_RETPOLINE/ ]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250228-call-nospec-v3-1-96599fed0f33@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -284,16 +284,11 @@ extern void (*x86_return_thunk)(void);
  * Inline asm uses the %V modifier which is only in newer GCC
  * which is ensured when CONFIG_RETPOLINE is defined.
  */
-# define CALL_NOSPEC						\
-	ALTERNATIVE_2(						\
-	ANNOTATE_RETPOLINE_SAFE					\
-	"call *%[thunk_target]\n",				\
-	"call __x86_indirect_thunk_%V[thunk_target]\n",		\
-	X86_FEATURE_RETPOLINE,					\
-	"lfence;\n"						\
-	ANNOTATE_RETPOLINE_SAFE					\
-	"call *%[thunk_target]\n",				\
-	X86_FEATURE_RETPOLINE_LFENCE)
+#ifdef CONFIG_RETPOLINE
+#define CALL_NOSPEC	"call __x86_indirect_thunk_%V[thunk_target]\n"
+#else
+#define CALL_NOSPEC	"call *%[thunk_target]\n"
+#endif
 
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 


