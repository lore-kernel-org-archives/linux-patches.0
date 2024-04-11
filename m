Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA4613D24D;
	Thu, 11 Apr 2024 10:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831945; cv=none; b=QeEkh94Onry4OwP9Qcpno/I7gH0b9gnNTZWrL8Sf8D8CYNUFkrlE/MA9N7OnW62Ej4YWZIj+NnL3kSMPRdEG1CloDH7j2JFwkbTOwTAkGTkg8AEPIyLeaQzX7xfdxPeVZ0hm8SA/+HJOVsdsJ+kbWczOUAV7L0oZ7TSh6bKt1L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831945; c=relaxed/simple;
	bh=wO4SN25Ohzamm7xRoqvjXhw7XvCTnSMJwX/vFzuWY4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKuKyuhdnIX4wyQYajTPfdpld0FJkfMo37JYVWwK/0yPv9G3MHHDbcjA1WULNYLNNDsTahj2BHSxrSmrxFRdoNwTFKvzDoydzQ0TJR/Pz5I1ARjl5ClGzZxd1D9/qWMkC3q92bMMX5Lfq1Al3hZ1AsgCPaYamCMUOFrDSmPuVzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9Ov7nuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9Ov7nuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35DCC433C7;
	Thu, 11 Apr 2024 10:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831945;
	bh=wO4SN25Ohzamm7xRoqvjXhw7XvCTnSMJwX/vFzuWY4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9Ov7nuGBn9wIxCemevFBBGQT6NzLMdPpYwcfAsjcUH0RWra2NqP7OJ30B0r0FUZ1
	 z88SjfzsNxF4eivABFNwrnkvNfw2Td+ajv7qdaRK6yAV32lq9YPZQby0vvUCUYKFlZ
	 g/iQx3z3rRhTR2g8PopIaWvLujcqiomzA3Zo3r2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kim Phillips <kim.phillips@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 178/294] x86/cpu: Enable STIBP on AMD if Automatic IBRS is enabled
Date: Thu, 11 Apr 2024 11:55:41 +0200
Message-ID: <20240411095440.986131766@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kim Phillips <kim.phillips@amd.com>

commit fd470a8beed88440b160d690344fbae05a0b9b1b upstream.

Unlike Intel's Enhanced IBRS feature, AMD's Automatic IBRS does not
provide protection to processes running at CPL3/user mode, see section
"Extended Feature Enable Register (EFER)" in the APM v2 at
https://bugzilla.kernel.org/attachment.cgi?id=304652

Explicitly enable STIBP to protect against cross-thread CPL3
branch target injections on systems with Automatic IBRS enabled.

Also update the relevant documentation.

Fixes: e7862eda309e ("x86/cpu: Support AMD Automatic IBRS")
Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230720194727.67022-1-kim.phillips@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |   11 +++++++----
 arch/x86/kernel/cpu/bugs.c                    |   15 +++++++++------
 2 files changed, 16 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -484,11 +484,14 @@ Spectre variant 2
 
    Systems which support enhanced IBRS (eIBRS) enable IBRS protection once at
    boot, by setting the IBRS bit, and they're automatically protected against
-   Spectre v2 variant attacks, including cross-thread branch target injections
-   on SMT systems (STIBP). In other words, eIBRS enables STIBP too.
+   Spectre v2 variant attacks.
 
-   Legacy IBRS systems clear the IBRS bit on exit to userspace and
-   therefore explicitly enable STIBP for that
+   On Intel's enhanced IBRS systems, this includes cross-thread branch target
+   injections on SMT systems (STIBP). In other words, Intel eIBRS enables
+   STIBP, too.
+
+   AMD Automatic IBRS does not protect userspace, and Legacy IBRS systems clear
+   the IBRS bit on exit to userspace, therefore both explicitly enable STIBP.
 
    The retpoline mitigation is turned on by default on vulnerable
    CPUs. It can be forced on or off by the administrator
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1317,19 +1317,21 @@ spectre_v2_user_select_mitigation(void)
 	}
 
 	/*
-	 * If no STIBP, enhanced IBRS is enabled, or SMT impossible, STIBP
+	 * If no STIBP, Intel enhanced IBRS is enabled, or SMT impossible, STIBP
 	 * is not required.
 	 *
-	 * Enhanced IBRS also protects against cross-thread branch target
+	 * Intel's Enhanced IBRS also protects against cross-thread branch target
 	 * injection in user-mode as the IBRS bit remains always set which
 	 * implicitly enables cross-thread protections.  However, in legacy IBRS
 	 * mode, the IBRS bit is set only on kernel entry and cleared on return
-	 * to userspace. This disables the implicit cross-thread protection,
-	 * so allow for STIBP to be selected in that case.
+	 * to userspace.  AMD Automatic IBRS also does not protect userspace.
+	 * These modes therefore disable the implicit cross-thread protection,
+	 * so allow for STIBP to be selected in those cases.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	    (spectre_v2_in_eibrs_mode(spectre_v2_enabled) &&
+	     !boot_cpu_has(X86_FEATURE_AUTOIBRS)))
 		return;
 
 	/*
@@ -2596,7 +2598,8 @@ static ssize_t rfds_show_state(char *buf
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled) &&
+	    !boot_cpu_has(X86_FEATURE_AUTOIBRS))
 		return "";
 
 	switch (spectre_v2_user_stibp) {


