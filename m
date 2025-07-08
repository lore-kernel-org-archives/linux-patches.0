Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222C821773D;
	Tue,  8 Jul 2025 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992560; cv=none; b=HYsdSjgInVimLqYasYzoA//9bmjuqzGlIk1kwskOmU+j+VXRSlKZb0ajPxWg9TwfTtiBSbyrJmjP+fFGqjPcZHk0p5q7Mc/EykRucNYBjnlKPMtHkKkXu5yr1ZU9FUExmpDfXsBopwFn/OaeiE4UqWbVSibRs09CcUQKABE5hHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992560; c=relaxed/simple;
	bh=Cfu6EtFoisGCyy9vgG7oUHKclIoDqKamfDlX3JjQ3ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaOWIQreQsllOmd7emYZmcHYBykbA3V3T7OJB6nsW3VhXzCELANz5RBTR0s0xxYOv5VKKqw9KiyogjqGOxbLMTZVhJUcTFslFbAEC+chGAWZoXgWgBi9j4NEpsFsrw9Y3AFpokkgppAZgYsOZgik9KXyXcTjCdBa8RKnhtcskz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wCirT1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wCirT1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D372C4CEED;
	Tue,  8 Jul 2025 16:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992560;
	bh=Cfu6EtFoisGCyy9vgG7oUHKclIoDqKamfDlX3JjQ3ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wCirT1c09leidOOJwhHDLGP6sw2DCgm/DHiGW9w1/FMKSO/t5O/Z3X6aezAt8Mvu
	 OMARczCQRzf9HkmehaAAX6q60c5svt4DOg2jmTLvV+asKZJgz797VTfv6//ySc7WNq
	 zvH5/CWbKWY1uxG1PGrM9AglSRmaV3q++MX81NUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 132/132] x86/process: Move the buffer clearing before MONITOR
Date: Tue,  8 Jul 2025 18:24:03 +0200
Message-ID: <20250708162234.366467385@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -89,7 +87,6 @@ static __always_inline void __mwaitx(uns
 
 static __always_inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
-	x86_idle_clear_cpu_buffers();
 
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
@@ -108,21 +105,29 @@ static __always_inline void __sti_mwait(
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
@@ -928,16 +928,24 @@ static int prefer_mwait_c1_over_halt(con
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
 


