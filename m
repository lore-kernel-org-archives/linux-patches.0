Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370AC26A08C;
	Wed, 23 Apr 2025 15:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420490; cv=none; b=OfrMrrzWwgY0OqpZSTzrDqOCtmKU6Gg3ioOGm6Loc3RRR/rHg8aMQh9camx3D+csAzmaTRqfW9wp1TgVhtCqBUJb1Mbsgdw3891XGKbBhE7xcdf828cfTAKeajrB+p7KRf1y7ewXZdVjvkUrQAMgNiL7tgzEqU6557L53FZvhts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420490; c=relaxed/simple;
	bh=yan6Nd5UOema878LjCMOZw0ZWIySof1vRiylqihXEhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSDnrQYpPyighnIjU5U48ZOEI/2zjki6CtgBEOCt9/nGsf6sdtjVaSTDwZM3DiiG2Kx1U0gbeH0+CQEJVLUNLMtzODi5RlTx04duMLfH2YrAXMPiKAZVMX2AfZ62aiCy26d8bazw/8A22uy/3KmXY8a8hBQEuvcsOwzrHngbQ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKWG6PWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKWG6PWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD25C4CEE2;
	Wed, 23 Apr 2025 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420490;
	bh=yan6Nd5UOema878LjCMOZw0ZWIySof1vRiylqihXEhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKWG6PWJTtDP9EQd6utUM6Zg1ZtVfiCvrZe3DgFkzTqw9lK8vefPIQmI5ytLrzi3I
	 aZgpM8XDBYDUk2gJov8znm21kAl2DUqkAlbGL/YNsPX7Oqhfl5Wko/OkOVSLHaFQhg
	 IXlAGygWYZbehr3uTtKJ+wSK++odJi9lD5lD0QAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>
Subject: [PATCH 6.12 136/223] x86/cpu/amd: Fix workaround for erratum 1054
Date: Wed, 23 Apr 2025 16:43:28 +0200
Message-ID: <20250423142622.629608242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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
@@ -862,6 +862,16 @@ static void init_amd_zen1(struct cpuinfo
 
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
@@ -1045,13 +1055,8 @@ static void init_amd(struct cpuinfo_x86
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


