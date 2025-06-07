Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1313B15D1;
	Sat,  7 Jun 2025 10:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291053; cv=none; b=BIJNKDMwJHfvgf9BWBThZp8fZbeuoG+DkGGsiXqtx/tT60pjllqL56E0/MttFN8+VwhPPHEYR9MW+o2obBOIWSXtepeZLhDnkgBc3D4+2wp83HRIWS5suiMngX4DLlTWuGs1xsBaVLwn0L+aCXl9f5z4fmf11vKWdOaWRzo3VeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291053; c=relaxed/simple;
	bh=Ci1cUYyk38I4/KfLLR8wbJc6DfrpWi1KZsqLMJmv2AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsUQZXDmJMMJSyunpMF8qR5N17OJfWnCCTL4Z0HITCoxTk5Tpq2QeFfRQwtn+iOV0z8fWrPmr7m5CbJQUC9hdJWdTs6eVE+5zZI6RxEoCSKXZvDMXti9C4qYWLH9jv2NWboJXP2RV7jwnsE4fjMZpdRMcWxp9jPTeRIo3gq5iKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCJtsU2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCJtsU2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EFCC4CEE4;
	Sat,  7 Jun 2025 10:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291052;
	bh=Ci1cUYyk38I4/KfLLR8wbJc6DfrpWi1KZsqLMJmv2AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCJtsU2l9/AOsm/bo0VIDtp64yZGN6GU+pwnr6IL58FTtqBCPlpGgHpSUmjGVjLHb
	 PCvNjudkxN5gNeFOMLFWzCoseRkpUQJU+gJ+qkEbMgIrbpf+zEI5c4xct5gq8ASrzp
	 4Clm9bfb1MOlKRcWnuHa34rFnjRUgrDyh726jPYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Brandt <todd.e.brandt@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.15 02/34] Revert "x86/smp: Eliminate mwait_play_dead_cpuid_hint()"
Date: Sat,  7 Jun 2025 12:07:43 +0200
Message-ID: <20250607100719.810111964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 70523f335734b0b42f97647556d331edf684c7dc upstream.

Revert commit 96040f7273e2 ("x86/smp: Eliminate mwait_play_dead_cpuid_hint()")
because it introduced a significant power regression on systems that
start with "nosmt" in the kernel command line.

Namely, on such systems, SMT siblings permanently go offline early,
when cpuidle has not been initialized yet, so after the above commit,
hlt_play_dead() is called for them.  Later on, when the processor
attempts to enter a deep package C-state, including PC10 which is
requisite for reaching minimum power in suspend-to-idle, it is not
able to do that because of the SMT siblings staying in C1 (which
they have been put into by HLT).

As a result, the idle power (including power in suspend-to-idle)
rises quite dramatically on those systems with all of the possible
consequences, which (needless to say) may not be expected by their
users.

This issue is hard to debug and potentially dangerous, so it needs to
be addressed as soon as possible in a way that will work for 6.15.y,
hence the revert.

Of course, after this revert, the issue that commit 96040f7273e2
attempted to address will be back and it will need to be fixed again
later.

Fixes: 96040f7273e2 ("x86/smp: Eliminate mwait_play_dead_cpuid_hint()")
Reported-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Cc: 6.15+ <stable@vger.kernel.org> # 6.15+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://patch.msgid.link/12674167.O9o76ZdvQC@rjwysocki.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/smpboot.c |   54 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1238,10 +1238,6 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
-/*
- * We need to flush the caches before going to sleep, lest we have
- * dirty data in our caches when we come back up.
- */
 void __noreturn mwait_play_dead(unsigned int eax_hint)
 {
 	struct mwait_cpu_dead *md = this_cpu_ptr(&mwait_cpu_dead);
@@ -1288,6 +1284,50 @@ void __noreturn mwait_play_dead(unsigned
 }
 
 /*
+ * We need to flush the caches before going to sleep, lest we have
+ * dirty data in our caches when we come back up.
+ */
+static inline void mwait_play_dead_cpuid_hint(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	unsigned int highest_cstate = 0;
+	unsigned int highest_subcstate = 0;
+	int i;
+
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+	    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
+		return;
+	if (!this_cpu_has(X86_FEATURE_MWAIT))
+		return;
+	if (!this_cpu_has(X86_FEATURE_CLFLUSH))
+		return;
+
+	eax = CPUID_LEAF_MWAIT;
+	ecx = 0;
+	native_cpuid(&eax, &ebx, &ecx, &edx);
+
+	/*
+	 * eax will be 0 if EDX enumeration is not valid.
+	 * Initialized below to cstate, sub_cstate value when EDX is valid.
+	 */
+	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED)) {
+		eax = 0;
+	} else {
+		edx >>= MWAIT_SUBSTATE_SIZE;
+		for (i = 0; i < 7 && edx; i++, edx >>= MWAIT_SUBSTATE_SIZE) {
+			if (edx & MWAIT_SUBSTATE_MASK) {
+				highest_cstate = i;
+				highest_subcstate = edx & MWAIT_SUBSTATE_MASK;
+			}
+		}
+		eax = (highest_cstate << MWAIT_SUBSTATE_SIZE) |
+			(highest_subcstate - 1);
+	}
+
+	mwait_play_dead(eax);
+}
+
+/*
  * Kick all "offline" CPUs out of mwait on kexec(). See comment in
  * mwait_play_dead().
  */
@@ -1337,9 +1377,9 @@ void native_play_dead(void)
 	play_dead_common();
 	tboot_shutdown(TB_SHUTDOWN_WFS);
 
-	/* Below returns only on error. */
-	cpuidle_play_dead();
-	hlt_play_dead();
+	mwait_play_dead_cpuid_hint();
+	if (cpuidle_play_dead())
+		hlt_play_dead();
 }
 
 #else /* ... !CONFIG_HOTPLUG_CPU */


