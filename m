Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E33B12C805;
	Tue, 30 Apr 2024 11:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476573; cv=none; b=rU2hRqyzw/MTwQyerRZiTfv8rP1jTfAs3Z6BjFfawJVSRug2dWH6ThXEokEPbMpl4xDn0+a16luf0miFAcq93mNiH6FQ1uX/LB5wpNqedYL+vIbtfLMVBB9p20HSFVH7lG4TuaU9uJYW5rUEXkK9aM2QkTkU56UIUObzReIJ5fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476573; c=relaxed/simple;
	bh=XdhTJ1sRmoQ4i2IfOGIjQmoXVM/draYtZf+PVhy7T6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX614wK2rSexpUY2WUUP4hDTaX2ruORJERqgUaFp9UvdG1oZhJx5+PzchuIplqsOqgQ91Vb19NtKafYkXoTfT3tQ2dTF/ascOvSLnJbAjYRw2eur7stFz0h24J1r9yZLh176fQ1+DDcKf01lSF8tdExxIqmqWZyCLEfJUnmjiWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1lc3vyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1lc3vyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D9CC2BBFC;
	Tue, 30 Apr 2024 11:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476573;
	bh=XdhTJ1sRmoQ4i2IfOGIjQmoXVM/draYtZf+PVhy7T6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1lc3vyKEFQWSOOFgKhuLEE90rUI1FrCNsXiPeQMUGTkvsHYpxoGwk4X7nOMK4W5Y
	 r+IfSsvbS9IhnEhNiGCDIK3f37xahbTUo75vrXcbUJHSg1dGvmbXmGJ9uCwrXRPEt6
	 b4IvuGDD2NaR+/F+qhU9ufV/wwWKcaQpEf1AxtVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 6.1 074/110] cpu: Re-enable CPU mitigations by default for !X86 architectures
Date: Tue, 30 Apr 2024 12:40:43 +0200
Message-ID: <20240430103049.751443523@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit fe42754b94a42d08cf9501790afc25c4f6a5f631 upstream.

Rename x86's to CPU_MITIGATIONS, define it in generic code, and force it
on for all architectures exception x86.  A recent commit to turn
mitigations off by default if SPECULATION_MITIGATIONS=n kinda sorta
missed that "cpu_mitigations" is completely generic, whereas
SPECULATION_MITIGATIONS is x86-specific.

Rename x86's SPECULATIVE_MITIGATIONS instead of keeping both and have it
select CPU_MITIGATIONS, as having two configs for the same thing is
unnecessary and confusing.  This will also allow x86 to use the knob to
manage mitigations that aren't strictly related to speculative
execution.

Use another Kconfig to communicate to common code that CPU_MITIGATIONS
is already defined instead of having x86's menu depend on the common
CPU_MITIGATIONS.  This allows keeping a single point of contact for all
of x86's mitigations, and it's not clear that other architectures *want*
to allow disabling mitigations at compile-time.

Fixes: f337a6a21e2f ("x86/cpu: Actually turn off mitigations by default for SPECULATION_MITIGATIONS=n")
Closes: https://lkml.kernel.org/r/20240413115324.53303a68%40canb.auug.org.au
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240420000556.2645001-2-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/Kconfig     |    8 ++++++++
 arch/x86/Kconfig |   11 ++++++-----
 kernel/cpu.c     |    4 ++--
 3 files changed, 16 insertions(+), 7 deletions(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -9,6 +9,14 @@
 #
 source "arch/$(SRCARCH)/Kconfig"
 
+config ARCH_CONFIGURES_CPU_MITIGATIONS
+	bool
+
+if !ARCH_CONFIGURES_CPU_MITIGATIONS
+config CPU_MITIGATIONS
+	def_bool y
+endif
+
 menu "General architecture-dependent options"
 
 config CRASH_CORE
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -61,6 +61,7 @@ config X86
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
 	select ARCH_32BIT_OFF_T			if X86_32
 	select ARCH_CLOCKSOURCE_INIT
+	select ARCH_CONFIGURES_CPU_MITIGATIONS
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
@@ -2449,17 +2450,17 @@ config CC_HAS_SLS
 config CC_HAS_RETURN_THUNK
 	def_bool $(cc-option,-mfunction-return=thunk-extern)
 
-menuconfig SPECULATION_MITIGATIONS
-	bool "Mitigations for speculative execution vulnerabilities"
+menuconfig CPU_MITIGATIONS
+	bool "Mitigations for CPU vulnerabilities"
 	default y
 	help
-	  Say Y here to enable options which enable mitigations for
-	  speculative execution hardware vulnerabilities.
+	  Say Y here to enable options which enable mitigations for hardware
+	  vulnerabilities (usually related to speculative execution).
 
 	  If you say N, all mitigations will be disabled. You really
 	  should know what you are doing to say so.
 
-if SPECULATION_MITIGATIONS
+if CPU_MITIGATIONS
 
 config PAGE_TABLE_ISOLATION
 	bool "Remove the kernel mapping in user mode"
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2788,8 +2788,8 @@ enum cpu_mitigations {
 };
 
 static enum cpu_mitigations cpu_mitigations __ro_after_init =
-	IS_ENABLED(CONFIG_SPECULATION_MITIGATIONS) ? CPU_MITIGATIONS_AUTO :
-						     CPU_MITIGATIONS_OFF;
+	IS_ENABLED(CONFIG_CPU_MITIGATIONS) ? CPU_MITIGATIONS_AUTO :
+					     CPU_MITIGATIONS_OFF;
 
 static int __init mitigations_parse_cmdline(char *arg)
 {


