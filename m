Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AAD2EBDC0;
	Tue, 17 Jun 2025 15:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174131; cv=none; b=rppvuqUIhcS/t7jEJierATlLGw6gS2AJRAYW1AJBl/ikK9EQGJu97f9KoWeo/SFkBSo6WJ5sO+MfikOujnR18tFZDcMODHZwYpu52gkjKD4thfuZDfTokVz9VT7UqbOP+Wbkiy0QpLLz2lnX78WOrnEKsBs+tf+3MF8xYY/q+5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174131; c=relaxed/simple;
	bh=5MlBz2d5Vnicy7OYk+mW19LFwgwXYCH9ty69azzWKJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k58P3G1sYzt2w7UkzM9cwbPePtwiWFW4sBzOXrDYM7sOEW0c1XQpQ5klP58vNYg9e5Crdm+7REurZjZ24byNP69bOcqLD7scOLvqFmLl5nKh0u1TnMsKtQaiR/xhL+Tu8Zlkkj6CrdG7M1O1tMf8hJedx3sSqARVRepdcJtUaK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOWGywQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOWGywQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4985FC4CEE3;
	Tue, 17 Jun 2025 15:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174130;
	bh=5MlBz2d5Vnicy7OYk+mW19LFwgwXYCH9ty69azzWKJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOWGywQQS7EK9yu/dr3+Xg8gJHrxxlLJ8FW/rx3+K5caAxNZeIZhCS7b4BPT9PuKH
	 Ji6+mG9qbESE1G2NOxpI4lxWG8MliuFbkm6qeftpPVJgE+OHoXLaKF6ZThhU4sFmHb
	 WfZBSy9+VyYxZCOU7mmJadLV4daDtS9JNYzb/VA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Ingo Molnar <mingo@kernel.org>,
	Dave Hansen <dave.hansen@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 002/780] x86/idle: Remove MFENCEs for X86_BUG_CLFLUSH_MONITOR in mwait_idle_with_hints() and prefer_mwait_c1_over_halt()
Date: Tue, 17 Jun 2025 17:15:10 +0200
Message-ID: <20250617152451.597081798@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Cooper <andrew.cooper3@citrix.com>

[ Upstream commit 1f13c60d84e880df6698441026e64f84c7110c49 ]

The following commit, 12 years ago:

  7e98b7192046 ("x86, idle: Use static_cpu_has() for CLFLUSH workaround, add barriers")

added barriers around the CLFLUSH in mwait_idle_with_hints(), justified with:

  ... and add memory barriers around it since the documentation is explicit
  that CLFLUSH is only ordered with respect to MFENCE.

This also triggered, 11 years ago, the same adjustment in:

  f8e617f45829 ("sched/idle/x86: Optimize unnecessary mwait_idle() resched IPIs")

during development, although it failed to get the static_cpu_has_bug() treatment.

X86_BUG_CLFLUSH_MONITOR (a.k.a the AAI65 errata) is specific to Intel CPUs,
and the SDM currently states:

  Executions of the CLFLUSH instruction are ordered with respect to each
  other and with respect to writes, locked read-modify-write instructions,
  and fence instructions[1].

With footnote 1 reading:

  Earlier versions of this manual specified that executions of the CLFLUSH
  instruction were ordered only by the MFENCE instruction.  All processors
  implementing the CLFLUSH instruction also order it relative to the other
  operations enumerated above.

i.e. The SDM was incorrect at the time, and barriers should not have been
inserted.  Double checking the original AAI65 errata (not available from
intel.com any more) shows no mention of barriers either.

Note: If this were a general codepath, the MFENCEs would be needed, because
      AMD CPUs of the same vintage do sport otherwise-unordered CLFLUSHs.

Remove the unnecessary barriers. Furthermore, use a plain alternative(),
rather than static_cpu_has_bug() and/or no optimisation.  The workaround
is a single instruction.

Use an explicit %rax pointer rather than a general memory operand, because
MONITOR takes the pointer implicitly in the same way.

[ mingo: Cleaned up the commit a bit. ]

Fixes: 7e98b7192046 ("x86, idle: Use static_cpu_has() for CLFLUSH workaround, add barriers")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20250402172458.1378112-1-andrew.cooper3@citrix.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/mwait.h | 9 +++------
 arch/x86/kernel/process.c    | 9 +++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index ce857ef54cf15..54dc313bcdf01 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -116,13 +116,10 @@ static __always_inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 static __always_inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
 {
 	if (static_cpu_has_bug(X86_BUG_MONITOR) || !current_set_polling_and_test()) {
-		if (static_cpu_has_bug(X86_BUG_CLFLUSH_MONITOR)) {
-			mb();
-			clflush((void *)&current_thread_info()->flags);
-			mb();
-		}
+		const void *addr = &current_thread_info()->flags;
 
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		alternative_input("", "clflush (%[addr])", X86_BUG_CLFLUSH_MONITOR, [addr] "a" (addr));
+		__monitor(addr, 0, 0);
 
 		if (!need_resched()) {
 			if (ecx & 1) {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 962c3ce39323e..12948380cdd06 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -907,13 +907,10 @@ static __init bool prefer_mwait_c1_over_halt(void)
 static __cpuidle void mwait_idle(void)
 {
 	if (!current_set_polling_and_test()) {
-		if (this_cpu_has(X86_BUG_CLFLUSH_MONITOR)) {
-			mb(); /* quirk */
-			clflush((void *)&current_thread_info()->flags);
-			mb(); /* quirk */
-		}
+		const void *addr = &current_thread_info()->flags;
 
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		alternative_input("", "clflush (%[addr])", X86_BUG_CLFLUSH_MONITOR, [addr] "a" (addr));
+		__monitor(addr, 0, 0);
 		if (!need_resched()) {
 			__sti_mwait(0, 0);
 			raw_local_irq_disable();
-- 
2.39.5



