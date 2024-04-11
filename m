Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283A1140E3D;
	Thu, 11 Apr 2024 10:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830812; cv=none; b=cPAQTaGPSTmvHDmRWl9/8NJqFBN9dEhMMcd8x6wJlm79xw/Nd04PYuVvKyotILZR4/8dz01idMjU148J+jT/xMziY5I9xhjwLWfwXs3ShZD6Afv1oD8z060oxhUicsve4GovYUU+qOm9EZUAdb5T5syhk1mZBQYTV9PbX/A5D7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830812; c=relaxed/simple;
	bh=Uvycb5R6QGJmzcUjF+PiOzYvlNEAgeY3mkQn42UUUXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyyNvO29cVbccq+F1xbMqUwoT+zm0dtAZbkIN0FqqcdAXtWqNo4ZV8Q63A9u9hLrHBho+uprhximgQMUsxJ5JlhsgNJjetv1hsru4hVGreqVwzz8+NoNv/MCHkOTFQnst/Ec42mhtW6+6NstM8z0W2h38z8q4UqsSBsuOG2m32g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3cOA86u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3cOA86u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1938C433C7;
	Thu, 11 Apr 2024 10:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830812;
	bh=Uvycb5R6QGJmzcUjF+PiOzYvlNEAgeY3mkQn42UUUXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3cOA86uhqirEWWbigTulZY3CVMJa72M+S1CypEqUNAOfj+kq2n69VhdKzs4qFcUO
	 7P70o7Jqzk5seXiPJ45k6WxcDPp0Z5L5qWMG2vTHppfz1X/zYxBbZIVqsi8fWeAFpS
	 6W1kSIlmRxglW0jlLhXYOdmPjcIVJEH3RaH20zGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kim Phillips <kim.phillips@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.4 126/215] x86/cpu: Enable STIBP on AMD if Automatic IBRS is enabled
Date: Thu, 11 Apr 2024 11:55:35 +0200
Message-ID: <20240411095428.684561950@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1153,19 +1153,21 @@ spectre_v2_user_select_mitigation(void)
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
@@ -2232,7 +2234,8 @@ static ssize_t mmio_stale_data_show_stat
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled) &&
+	    !boot_cpu_has(X86_FEATURE_AUTOIBRS))
 		return "";
 
 	switch (spectre_v2_user_stibp) {


