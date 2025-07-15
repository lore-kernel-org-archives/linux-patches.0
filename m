Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C262EA172;
	Tue, 15 Jul 2025 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587960; cv=none; b=I1OKiQEloe9HC5miOKzXuLMsDZ6DJtLFNQnVVk6towYA0q2bZo87z6Jd4SUgI2fwPYTlGZiZJCDPqYVvRmHBLxv8hibkU3QROQV8n9f6M+lEPK+IHUuOKmqzxCruu6DsACM2QvoS7MRjJcSDeRJYjrPHsGo2o92sFU2souzYUQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587960; c=relaxed/simple;
	bh=oRpf/+g/F55Ien1WT3xf1Gizecj2q17f7Poeq4UZ9fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKWYeJqflAYY52vxsgkOM6iydR71uaEjsRB+qOdKHDuqMU9sRJK9ilXbp6NtmTOOZLy+r1BLyLxqBzQVkGlJNkpj6XD9jbXsgjzZkQ6mlFMp9uiPBX9NvXRvd/ACMAwFDE3bmmaXJafXbfQ59BIWlU095ujDbnH9WCKfyX/6xyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHtGqwLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHtGqwLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2975DC4CEE3;
	Tue, 15 Jul 2025 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587960;
	bh=oRpf/+g/F55Ien1WT3xf1Gizecj2q17f7Poeq4UZ9fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHtGqwLs+syrHqz4VreV756UGcRBTp9v9K0vlLXGF3IbJBWUeIH2Eq1AJmDu9hqOu
	 sE7uMEcYqrVuGQnCuVq9Tj/xko7HPsRHOdB1QtbEwinVhco+YYttYfBNKMwXkjrHV6
	 QNfPmAKOyTshQCXv2a/GKLGmh3D6TRakTMRS6Pzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 208/208] x86/process: Move the buffer clearing before MONITOR
Date: Tue, 15 Jul 2025 15:15:17 +0200
Message-ID: <20250715130819.258231993@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@kernel.org>

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit 8e786a85c0a3c0fffae6244733fb576eeabd9dec upstream.

Move the VERW clearing before the MONITOR so that VERW doesn't disarm it
and the machine never enters C1.

Original idea by Kim Phillips <kim.phillips@amd.com>.

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/mwait.h |   16 +++++++++++-----
 arch/x86/kernel/process.c    |   15 ++++++++++++---
 2 files changed, 23 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -43,8 +43,6 @@ static inline void __monitorx(const void
 
 static inline void __mwait(unsigned long eax, unsigned long ecx)
 {
-	x86_idle_clear_cpu_buffers();
-
 	/* "mwait %eax, %ecx;" */
 	asm volatile(".byte 0x0f, 0x01, 0xc9;"
 		     :: "a" (eax), "c" (ecx));
@@ -88,7 +86,6 @@ static inline void __mwaitx(unsigned lon
 
 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
-	x86_idle_clear_cpu_buffers();
 
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
@@ -107,6 +104,11 @@ static inline void __sti_mwait(unsigned
  */
 static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
 {
+	if (need_resched())
+		return;
+
+	x86_idle_clear_cpu_buffers();
+
 	if (static_cpu_has_bug(X86_BUG_MONITOR) || !current_set_polling_and_test()) {
 		if (static_cpu_has_bug(X86_BUG_CLFLUSH_MONITOR)) {
 			mb();
@@ -115,9 +117,13 @@ static inline void mwait_idle_with_hints
 		}
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		if (!need_resched())
-			__mwait(eax, ecx);
+		if (need_resched())
+			goto out;
+
+		__mwait(eax, ecx);
 	}
+
+out:
 	current_clr_polling();
 }
 
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -825,6 +825,11 @@ static int prefer_mwait_c1_over_halt(con
  */
 static __cpuidle void mwait_idle(void)
 {
+	if (need_resched())
+		return;
+
+	x86_idle_clear_cpu_buffers();
+
 	if (!current_set_polling_and_test()) {
 		if (this_cpu_has(X86_BUG_CLFLUSH_MONITOR)) {
 			mb(); /* quirk */
@@ -833,13 +838,17 @@ static __cpuidle void mwait_idle(void)
 		}
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		if (!need_resched())
-			__sti_mwait(0, 0);
-		else
+		if (need_resched()) {
 			raw_local_irq_enable();
+			goto out;
+		}
+
+		__sti_mwait(0, 0);
 	} else {
 		raw_local_irq_enable();
 	}
+
+out:
 	__current_clr_polling();
 }
 


