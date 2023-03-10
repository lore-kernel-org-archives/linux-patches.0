Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B88848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BC8C433D2;
	Fri, 10 Mar 2023 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458099;
	bh=InHjlbWT79bv4wu0NpzWY9+/c2CQwkORqRuHqCxPxzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLsQKzUzFGcUhAMyEAhIfiXonDa+JYygaSbezXLplGkJJZj9LhPfESDVHDZsvMA3W
	 javQuuSVo1Mq7Vwleh9gwwm2F8pLWy1iO3NOpESH/83VbjQYfq5DpS0o2jdGaCG8Tn
	 Z41RgPHljvaBRbkVP8yZMMeJWQhIUof9JHzCm9xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Oliveira?= <joseloliveira11@gmail.com>,
	Rodrigo Branco <rodrigo@kernelhacking.com>,
	KP Singh <kpsingh@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 4.19 164/252] x86/speculation: Allow enabling STIBP with legacy IBRS
Date: Fri, 10 Mar 2023 14:38:54 +0100
Message-Id: <20230310133723.821913781@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: KP Singh <kpsingh@kernel.org>

commit 6921ed9049bc7457f66c1596c5b78aec0dae4a9d upstream.

When plain IBRS is enabled (not enhanced IBRS), the logic in
spectre_v2_user_select_mitigation() determines that STIBP is not needed.

The IBRS bit implicitly protects against cross-thread branch target
injection. However, with legacy IBRS, the IBRS bit is cleared on
returning to userspace for performance reasons which leaves userspace
threads vulnerable to cross-thread branch target injection against which
STIBP protects.

Exclude IBRS from the spectre_v2_in_ibrs_mode() check to allow for
enabling STIBP (through seccomp/prctl() by default or always-on, if
selected by spectre_v2_user kernel cmdline parameter).

  [ bp: Massage. ]

Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
Reported-by: José Oliveira <joseloliveira11@gmail.com>
Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
Signed-off-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230220120127.1975241-1-kpsingh@kernel.org
Link: https://lore.kernel.org/r/20230221184908.2349578-1-kpsingh@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -983,14 +983,18 @@ spectre_v2_parse_user_cmdline(void)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
-static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
+static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
 {
-	return mode == SPECTRE_V2_IBRS ||
-	       mode == SPECTRE_V2_EIBRS ||
+	return mode == SPECTRE_V2_EIBRS ||
 	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
 	       mode == SPECTRE_V2_EIBRS_LFENCE;
 }
 
+static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
+{
+	return spectre_v2_in_eibrs_mode(mode) || mode == SPECTRE_V2_IBRS;
+}
+
 static void __init
 spectre_v2_user_select_mitigation(void)
 {
@@ -1053,12 +1057,19 @@ spectre_v2_user_select_mitigation(void)
 	}
 
 	/*
-	 * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible,
-	 * STIBP is not required.
+	 * If no STIBP, enhanced IBRS is enabled, or SMT impossible, STIBP
+	 * is not required.
+	 *
+	 * Enhanced IBRS also protects against cross-thread branch target
+	 * injection in user-mode as the IBRS bit remains always set which
+	 * implicitly enables cross-thread protections.  However, in legacy IBRS
+	 * mode, the IBRS bit is set only on kernel entry and cleared on return
+	 * to userspace. This disables the implicit cross-thread protection,
+	 * so allow for STIBP to be selected in that case.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return;
 
 	/*
@@ -2110,7 +2121,7 @@ static ssize_t mmio_stale_data_show_stat
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {


