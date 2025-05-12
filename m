Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168FC297A61;
	Mon, 12 May 2025 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073152; cv=none; b=rMBh1HAMZKYqzgrNJzDFQNjcN6Nyyst0GIGNcTeEYPIb43W2+DMcyS3liERhaORzMP+SrzrCaDSwBTaT8shXg7WiiqmhfkUuoDSSNCCroaksf8zNY+Ev6WHMAsPfEFxAjLO6pIh9mIvPdAWdx0X//pOT5A9LixRzlluOtL5tOas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073152; c=relaxed/simple;
	bh=4Jl0zTcoFUOWKCBhvX63iAtzvCO7splLVClGZy+9wc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdm000QnGTxzqvgmPMPlK1xY0mFnr2/1JcPLgp/0LaLmEgDvsMeF4faWkMPzQtQUjWySR+FJ93WYObBFYw9KCIjUPeTmDzKRLc/lo9Gli3WxI24UXuDb08NyC5BPwAKwgObpAU7Aa28d17ZFplFxiP89+IBirp4NznvDThbr6nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5dE6fn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5dE6fn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C299C4CEE9;
	Mon, 12 May 2025 18:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073151;
	bh=4Jl0zTcoFUOWKCBhvX63iAtzvCO7splLVClGZy+9wc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5dE6fn0lWxDcfzhyT/gAdTql4B6C8PNRXCvSeZXHG8o2F6Cb3HOrzubkbsi39pBA
	 f+G4ML98Td0DRiVXWs89I3uQkcO9PMUlRS1fsD5H9wlSjGqrmkB7STwPSm/ruAWxEL
	 dxesWsfU4MOBFHUvHFO/oe6IEmSVmYXJDpdd30g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.12 171/184] x86/speculation: Simplify and make CALL_NOSPEC consistent
Date: Mon, 12 May 2025 19:46:12 +0200
Message-ID: <20250512172048.770948100@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
retpoline thunk at compile time when CONFIG_MITIGATION_RETPOLINE is
enabled.

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
@@ -442,16 +442,11 @@ static inline void call_depth_return_thu
  * Inline asm uses the %V modifier which is only in newer GCC
  * which is ensured when CONFIG_MITIGATION_RETPOLINE is defined.
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
+#ifdef CONFIG_MITIGATION_RETPOLINE
+#define CALL_NOSPEC	"call __x86_indirect_thunk_%V[thunk_target]\n"
+#else
+#define CALL_NOSPEC	"call *%[thunk_target]\n"
+#endif
 
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 


