Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442ED78F32;
	Tue, 27 May 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365295; cv=none; b=l+1a2kUCi1m3pheT9hcP9CV7S1dG75Oj9Ss3uktdzrf2Eu1M5Z6gIesKo1pO7VqNjldfwg6Jja+t5oHzv3dWU8V18Gx+Evs0eEp6vqBLlc1IOGqFn++XI3OlR3+vsWaC7tRi1zOZXheH8D0LCCtaKOEwxrOrMy5CPjSWrv08hyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365295; c=relaxed/simple;
	bh=QjR7j7SimQF0QaA8rz6+3Ca7YalVjUQIOlhdvyX78xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ldsw8YnyB/vRCBbYsSpAWNID8idoquO25YpoY/WsbQpTVxsFlztNQCPVwBDSGiKe4AYh6dCQ0yLJjtMS0TLR4p+oCefUJ62y8yaTGF1kUgNhP7/TQPg8tOrApzRlKrhYTME3ua1RFrIGWzcdAeXkhwASEs7IiVbEaHxRXEBHoy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqjY1651; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqjY1651"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C87C4CEE9;
	Tue, 27 May 2025 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365295;
	bh=QjR7j7SimQF0QaA8rz6+3Ca7YalVjUQIOlhdvyX78xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqjY1651xmwEvox3oITORtNq9cKS0qCBv0gkO9Qovbuy60JEQfEdTz10wHitS7v0L
	 Ox7kNjyIkfsW2Kx1YlABN1RSIJiRcBHbC5JsgvKgAVSzJgGdrQscfZVBPP+ZiLfDhH
	 WHLNI/ACw/BWmr7Ncb8GVjWNtld58/t56JdZjJXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/626] x86/locking: Use ALT_OUTPUT_SP() for percpu_{,try_}cmpxchg{64,128}_op()
Date: Tue, 27 May 2025 18:23:25 +0200
Message-ID: <20250527162457.710462987@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit 4087e16b033140cf2ce509ec23503bddec818a16 ]

percpu_{,try_}cmpxchg{64,128}() macros use CALL instruction inside
asm statement in one of their alternatives. Use ALT_OUTPUT_SP()
macro to add required dependence on %esp register.

ALT_OUTPUT_SP() implements the above dependence by adding
ASM_CALL_CONSTRAINT to its arguments. This constraint should be used
for any inline asm which has a CALL instruction, otherwise the
compiler may schedule the asm before the frame pointer gets set up
by the containing function, causing objtool to print a "call without
frame pointer save/setup" warning.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250214150929.5780-1-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/percpu.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index c55a79d5feaeb..2d9c250b3c8d8 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -349,9 +349,9 @@ do {									\
 									\
 	asm qual (ALTERNATIVE("call this_cpu_cmpxchg8b_emu",		\
 			      "cmpxchg8b " __percpu_arg([var]), X86_FEATURE_CX8) \
-		  : [var] "+m" (__my_cpu_var(_var)),			\
-		    "+a" (old__.low),					\
-		    "+d" (old__.high)					\
+		  : ALT_OUTPUT_SP([var] "+m" (__my_cpu_var(_var)),	\
+				  "+a" (old__.low),			\
+				  "+d" (old__.high))			\
 		  : "b" (new__.low),					\
 		    "c" (new__.high),					\
 		    "S" (&(_var))					\
@@ -380,10 +380,10 @@ do {									\
 	asm qual (ALTERNATIVE("call this_cpu_cmpxchg8b_emu",		\
 			      "cmpxchg8b " __percpu_arg([var]), X86_FEATURE_CX8) \
 		  CC_SET(z)						\
-		  : CC_OUT(z) (success),				\
-		    [var] "+m" (__my_cpu_var(_var)),			\
-		    "+a" (old__.low),					\
-		    "+d" (old__.high)					\
+		  : ALT_OUTPUT_SP(CC_OUT(z) (success),			\
+				  [var] "+m" (__my_cpu_var(_var)),	\
+				  "+a" (old__.low),			\
+				  "+d" (old__.high))			\
 		  : "b" (new__.low),					\
 		    "c" (new__.high),					\
 		    "S" (&(_var))					\
@@ -420,9 +420,9 @@ do {									\
 									\
 	asm qual (ALTERNATIVE("call this_cpu_cmpxchg16b_emu",		\
 			      "cmpxchg16b " __percpu_arg([var]), X86_FEATURE_CX16) \
-		  : [var] "+m" (__my_cpu_var(_var)),			\
-		    "+a" (old__.low),					\
-		    "+d" (old__.high)					\
+		  : ALT_OUTPUT_SP([var] "+m" (__my_cpu_var(_var)),	\
+				  "+a" (old__.low),			\
+				  "+d" (old__.high))			\
 		  : "b" (new__.low),					\
 		    "c" (new__.high),					\
 		    "S" (&(_var))					\
@@ -451,10 +451,10 @@ do {									\
 	asm qual (ALTERNATIVE("call this_cpu_cmpxchg16b_emu",		\
 			      "cmpxchg16b " __percpu_arg([var]), X86_FEATURE_CX16) \
 		  CC_SET(z)						\
-		  : CC_OUT(z) (success),				\
-		    [var] "+m" (__my_cpu_var(_var)),			\
-		    "+a" (old__.low),					\
-		    "+d" (old__.high)					\
+		  : ALT_OUTPUT_SP(CC_OUT(z) (success),			\
+				  [var] "+m" (__my_cpu_var(_var)),	\
+				  "+a" (old__.low),			\
+				  "+d" (old__.high))			\
 		  : "b" (new__.low),					\
 		    "c" (new__.high),					\
 		    "S" (&(_var))					\
-- 
2.39.5



