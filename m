Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D22D18EAB;
	Tue,  8 Jul 2025 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993250; cv=none; b=rXwRNFXBRug9ro91DcKLFD22lg78lrjcach0/rpeeEnqRzMnC8F1R1phjYGSSEAMlVbbGywS9kIgw06eQJu6XGTyvM6Tgd4phe9QsjfI6TOoIYlIiGo+HKMSnGnHsOHLoVK/gzhNwYtXvJB5BAcrCCf9TGhQM+q9JGjkhFmRHJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993250; c=relaxed/simple;
	bh=9Ls2KIdE7Lvz/0tYls1BfjJjWnQcFz013ISUjlNpzMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/0fOam0JRt6p0PLfvXwuQaUL2DwalKVpCDvbKLqbtJfZTeFzCyMZGh9fVg+3HQLb7TV0q4h8nxWUoQCRkAA1f/9q9GnbHeMtmY1WI0gjf+vnopJnvR8y4f7+lsXFh87qkH5y6z9XjNs1kV0FfuVnih0A3gQDAQorjHfd9kI04Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkcbmeLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkcbmeLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9281C4CEED;
	Tue,  8 Jul 2025 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993250;
	bh=9Ls2KIdE7Lvz/0tYls1BfjJjWnQcFz013ISUjlNpzMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkcbmeLa24Z61sZrFe2lA7hKteM51nYi+0yLTLZftUm6mYyMHyxGKdM3bQBkpZxjC
	 3kdZUfL4S7alAqgAe+fY4ln6l6//MnD/B64st+/Qi0NWBoc+hJEFAJFBP+cR9zjDrV
	 +IzzH8c/pYfHSmOaWRw3NV+3nr982d+0M5BJF+68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 232/232] x86/process: Move the buffer clearing before MONITOR
Date: Tue,  8 Jul 2025 18:23:48 +0200
Message-ID: <20250708162247.496360571@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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
@@ -44,8 +44,6 @@ static __always_inline void __monitorx(c
 
 static __always_inline void __mwait(unsigned long eax, unsigned long ecx)
 {
-	x86_idle_clear_cpu_buffers();
-
 	/* "mwait %eax, %ecx;" */
 	asm volatile(".byte 0x0f, 0x01, 0xc9;"
 		     :: "a" (eax), "c" (ecx));
@@ -98,7 +96,6 @@ static __always_inline void __mwaitx(uns
  */
 static __always_inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
-	x86_idle_clear_cpu_buffers();
 
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
@@ -117,21 +114,29 @@ static __always_inline void __sti_mwait(
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
@@ -911,16 +911,24 @@ static __init bool prefer_mwait_c1_over_
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
 


