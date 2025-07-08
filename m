Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7512E1C74;
	Tue,  8 Jul 2025 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994204; cv=none; b=s8UZ2VOcBxtbZE1wCA6uGqy/ut1OMuL7DC20InDR/8SMAfm8SqoIHfLj/oXrQf/jMw01jclnxg3UD7PtDk4Gc2ZMfpjiRg+ixcUqW/fmd8xQt91Yr7hgBj+I7np5BEKuyXuTM+mt+DwynDh0Yd0Y2gU2Iix7qzhPClGvpnZlD8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994204; c=relaxed/simple;
	bh=YPL6KQcH+qOaCSAbBpy9vqFFBbBg4fYMv5w+FJ65UCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQ4qy/CVaqWuS9z1eXL2o2l63RNpsFq6rYcZs58diYbUvr6DFyM/bght9zXulRFPGI0kK3H9jKNK54SNi3rsU9UOpuziYJIVZ7H3Bggt9aw4jojlX+lE0ZCnjz3Vda96rc7BQ0+ebH1Z4/J6AWkVrRgDufzrNXM4RrKsKkyi5Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLAvOyMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLAvOyMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1AAC4CEED;
	Tue,  8 Jul 2025 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994204;
	bh=YPL6KQcH+qOaCSAbBpy9vqFFBbBg4fYMv5w+FJ65UCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLAvOyMgg/skC3Hwgik4ggOvUhtjIniDr1eE+d+U2s8tOY9yUeELGzRcn/gjh8nw2
	 JwiOSQUID8JHBb6lvYxJzYWNB6HeqSiajylR8GZ1l0tTkyeP2rsuKe1kFpzo/oFAIJ
	 83VqKCGFT3GhNBLC6KuJ4u4yjCpuUhk1r8gXvQ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 160/160] x86/process: Move the buffer clearing before MONITOR
Date: Tue,  8 Jul 2025 18:23:17 +0200
Message-ID: <20250708162235.716750984@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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
@@ -836,6 +836,11 @@ static int prefer_mwait_c1_over_halt(con
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
@@ -844,13 +849,17 @@ static __cpuidle void mwait_idle(void)
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
 


