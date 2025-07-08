Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B224C1FC0F3;
	Tue,  8 Jul 2025 16:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993762; cv=none; b=EgjxE7Q4rOeqyzGzfPsg5jUrW46jHDMewHDSzgs1wI5fXXL3O/g8nTHYJF5jtgZMiV+Y5GboRWHdN5alBkwtiIgXkYBWPZCrexInbkOG4NRv2igTR0/6Y0PcX3F8Gx3yRD8be8Od86QbDme90O53dFnPo7wPt0Adeq21wHL1UTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993762; c=relaxed/simple;
	bh=TvWBu8vaUquX8Buz7zPBwg3zQpOPjoMY23VxIlDNfOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBItg9Lgx9Gqq45YyVYNRzifWfvZGoUgICdc09B2qmdLd6SttMcCFva8xXrIIR77NdxG7BxWyciGDqJyVrShJT+huDmvWhc3XZfAr4/84T8RNPa01UkFQ9iqHxgt6XPM0BG0xUQZm+hVN4iVef2O3gV1HEWIGpYOMchR0lXisPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giEgf1gF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giEgf1gF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F2BC4CEF0;
	Tue,  8 Jul 2025 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993762;
	bh=TvWBu8vaUquX8Buz7zPBwg3zQpOPjoMY23VxIlDNfOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giEgf1gFWXpjcdsyaecWIDFXDVqIC2aQoOKtPBoOchrTRhKmFHZYKSlAMRulWEmYa
	 8RERb1P5XSYOFbo3Zu3UiEOZsVEkOmxaB1hpfZgaUyIGJeNu35kRhx5vpLtNqGVbhy
	 7LmA1W0phpp+dnJagE46W+oLzkZrxeOWHkYtFTF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.15 178/178] x86/process: Move the buffer clearing before MONITOR
Date: Tue,  8 Jul 2025 18:23:35 +0200
Message-ID: <20250708162241.086263737@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit 8e786a85c0a3c0fffae6244733fb576eeabd9dec upstream.

Move the VERW clearing before the MONITOR so that VERW doesn't disarm it
and the machine never enters C1.

Original idea by Kim Phillips <kim.phillips@amd.com>.

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/mwait.h |   25 +++++++++++++++----------
 arch/x86/kernel/process.c    |   16 ++++++++++++----
 2 files changed, 27 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -43,8 +43,6 @@ static __always_inline void __monitorx(c
 
 static __always_inline void __mwait(unsigned long eax, unsigned long ecx)
 {
-	x86_idle_clear_cpu_buffers();
-
 	/* "mwait %eax, %ecx;" */
 	asm volatile(".byte 0x0f, 0x01, 0xc9;"
 		     :: "a" (eax), "c" (ecx));
@@ -97,7 +95,6 @@ static __always_inline void __mwaitx(uns
  */
 static __always_inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
-	x86_idle_clear_cpu_buffers();
 
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
@@ -116,21 +113,29 @@ static __always_inline void __sti_mwait(
  */
 static __always_inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
 {
+	if (need_resched())
+		return;
+
+	x86_idle_clear_cpu_buffers();
+
 	if (static_cpu_has_bug(X86_BUG_MONITOR) || !current_set_polling_and_test()) {
 		const void *addr = &current_thread_info()->flags;
 
 		alternative_input("", "clflush (%[addr])", X86_BUG_CLFLUSH_MONITOR, [addr] "a" (addr));
 		__monitor(addr, 0, 0);
 
-		if (!need_resched()) {
-			if (ecx & 1) {
-				__mwait(eax, ecx);
-			} else {
-				__sti_mwait(eax, ecx);
-				raw_local_irq_disable();
-			}
+		if (need_resched())
+			goto out;
+
+		if (ecx & 1) {
+			__mwait(eax, ecx);
+		} else {
+			__sti_mwait(eax, ecx);
+			raw_local_irq_disable();
 		}
 	}
+
+out:
 	current_clr_polling();
 }
 
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -912,16 +912,24 @@ static __init bool prefer_mwait_c1_over_
  */
 static __cpuidle void mwait_idle(void)
 {
+	if (need_resched())
+		return;
+
+	x86_idle_clear_cpu_buffers();
+
 	if (!current_set_polling_and_test()) {
 		const void *addr = &current_thread_info()->flags;
 
 		alternative_input("", "clflush (%[addr])", X86_BUG_CLFLUSH_MONITOR, [addr] "a" (addr));
 		__monitor(addr, 0, 0);
-		if (!need_resched()) {
-			__sti_mwait(0, 0);
-			raw_local_irq_disable();
-		}
+		if (need_resched())
+			goto out;
+
+		__sti_mwait(0, 0);
+		raw_local_irq_disable();
 	}
+
+out:
 	__current_clr_polling();
 }
 


