Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC59528F93A;
	Wed, 23 Apr 2025 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422405; cv=none; b=uZWzwbYceaBoKVuthzgtRlhyCRcoVhbWKasPDs02C59/4qZF6PiRWZYZphSSli0ftBey10Q+Jb7TefAmx4osNRdZP5T5RGKWkKGApGR4vwWc0OOrSgOLyhYgNjniaRalCQl/Fl3hNQl4Y39AunKY77mlTMjT0nXMfTSMDcK/8AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422405; c=relaxed/simple;
	bh=qmeKZahCrPljg7f/SOREpLNjKiwmKhYxkYXmHNt/NIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6XjV0nPwNs2imV8InEkn8l0GxWYaaykCgFv0PIkyWvRnHgJvFWuB0QuHJ4wfpfbvjzJk3veFbu2yT1Igye/lMhAwpcSTdcF4S4xEq2xBu5cJesWbQejOY5TPwEv4qjBBGE1Z6sl46xF6OzMMCI/V5Cos8wwggr8in03OK8/qkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RucD9n99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RucD9n99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF61C4CEE2;
	Wed, 23 Apr 2025 15:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422404;
	bh=qmeKZahCrPljg7f/SOREpLNjKiwmKhYxkYXmHNt/NIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RucD9n99fdRldvIxxXtj079p9ghPONoQSDTywRHEm7lhWWIjnBto0lZu/4/3b7Ea5
	 5bYU68x7aOlAOcRLdGmt3iXo+AXSWoFOvteC2yOfWbPkdFrz3dYi/QFFFDg+t+M+9V
	 3G786bYmukodtY7x4tsBxRKTAL4jeOsHKE9CCI8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>
Subject: [PATCH 6.6 337/393] x86/cpu/amd: Fix workaround for erratum 1054
Date: Wed, 23 Apr 2025 16:43:53 +0200
Message-ID: <20250423142657.254453551@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Sandipan Das <sandipan.das@amd.com>

commit 263e55949d8902a6a09bdb92a1ab6a3f67231abe upstream.

Erratum 1054 affects AMD Zen processors that are a part of Family 17h
Models 00-2Fh and the workaround is to not set HWCR[IRPerfEn]. However,
when X86_FEATURE_ZEN1 was introduced, the condition to detect unaffected
processors was incorrectly changed in a way that the IRPerfEn bit gets
set only for unaffected Zen 1 processors.

Ensure that HWCR[IRPerfEn] is set for all unaffected processors. This
includes a subset of Zen 1 (Family 17h Models 30h and above) and all
later processors. Also clear X86_FEATURE_IRPERF on affected processors
so that the IRPerfCount register is not used by other entities like the
MSR PMU driver.

Fixes: 232afb557835 ("x86/CPU/AMD: Add X86_FEATURE_ZEN1")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/caa057a9d6f8ad579e2f1abaa71efbd5bd4eaf6d.1744956467.git.sandipan.das@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1039,6 +1039,16 @@ static void init_amd_zen1(struct cpuinfo
 
 	pr_notice_once("AMD Zen1 DIV0 bug detected. Disable SMT for full protection.\n");
 	setup_force_cpu_bug(X86_BUG_DIV0);
+
+	/*
+	 * Turn off the Instructions Retired free counter on machines that are
+	 * susceptible to erratum #1054 "Instructions Retired Performance
+	 * Counter May Be Inaccurate".
+	 */
+	if (c->x86_model < 0x30) {
+		msr_clear_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
+		clear_cpu_cap(c, X86_FEATURE_IRPERF);
+	}
 }
 
 static bool cpu_has_zenbleed_microcode(void)
@@ -1185,13 +1195,8 @@ static void init_amd(struct cpuinfo_x86
 	if (!cpu_feature_enabled(X86_FEATURE_XENPV))
 		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
 
-	/*
-	 * Turn on the Instructions Retired free counter on machines not
-	 * susceptible to erratum #1054 "Instructions Retired Performance
-	 * Counter May Be Inaccurate".
-	 */
-	if (cpu_has(c, X86_FEATURE_IRPERF) &&
-	    (boot_cpu_has(X86_FEATURE_ZEN1) && c->x86_model > 0x2f))
+	/* Enable the Instructions Retired free counter */
+	if (cpu_has(c, X86_FEATURE_IRPERF))
 		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
 
 	check_null_seg_clears_base(c);


