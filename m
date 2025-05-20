Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DACF2459CD;
	Tue, 20 May 2025 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749156; cv=none; b=UdDtaSfBf5k9QcHGfO5+BGLh7+4SxnoHh0ao/gBCR2srDPk/bcTHHOSlLlQY4h446nZY1XHGdHPD0pbpR1v78Fi7idzekRZqGGtn9Ii5adOsuAo877Irl9WJlFMmf4ZmLn+mm4Cg4a1xlBd45sAoZKyZoqcdT/n3N/Rqd1L+QIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749156; c=relaxed/simple;
	bh=mtu/WJWRmVJIw8POt/2+/7ZdVLH8Q4sAz1CNNJGgTiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkHz6OgBxKZyvYdIf7o6L0YneR9lXb0apgzIkMybWxMm51JM+B6Gju3K4u3PhHDAG3J9Cz6HHvdDMiFG9sv2coPAuuOcUpooQiVxGMsSBGqIPQLetsVepP13rNIzZ1w1cKKsEdwx8nriIcZ8NBt1Dfe4Q8dwHDdq0adpdxaW34c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ts5BF6O3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ts5BF6O3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0CAC4CEE9;
	Tue, 20 May 2025 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749155;
	bh=mtu/WJWRmVJIw8POt/2+/7ZdVLH8Q4sAz1CNNJGgTiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ts5BF6O3wn6Gzjbe1mLkU6D9KYbVEI8M/XSoHifICVBmwQ5V+dl9nm3GRdyRBlmLg
	 mnDT5jeOPZGOXZttUr5uuIIiUp2x5RRvlEDNCLI8QkEZ/q1jmCdNNiJlTS25VuMBEV
	 sIf1HMoEGUgWRMdKG6KJeNNDZdtbrbN5/p+EPDDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 15/59] x86/speculation: Simplify and make CALL_NOSPEC consistent
Date: Tue, 20 May 2025 15:50:06 +0200
Message-ID: <20250520125754.437733640@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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
@@ -285,16 +285,11 @@ extern retpoline_thunk_t __x86_indirect_
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
 


