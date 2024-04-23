Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7985D143882;
	Tue, 23 Apr 2024 21:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908731; cv=none; b=RsmuL8YWFVy88uxtyYZ0XgWSWTY9mmpC2d2IJwPE3dKl9sWV5pfCfY8HhZWM8NGOuoHvuOoj8zyKJlzpXV8PPjnlihnqMABbwk4GkK3o0l07hc5hVa+5hxNx+PEt0zGBFL7/f5KcFNyF85K459xUHhTMC2XhuC5LR31mskPaqGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908731; c=relaxed/simple;
	bh=Q2j2BRDL1F+dUYkNzS5URkHFpyLo9iiaW6t7bjnu0Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHvvA7F0t6PQDtz228tydgwTskw87+uvcREUQu7xxUquqzBPgHz0RTBXdRnMmQo5LGYz07EhDYk/B1Wi6p9XQB7W0RbsYXZVLBQ1Cymo3kJROdkWwh9UIlSTCB2hMwkWzyULtRdmzKfNSGYVKSdqxEU1oFd/TsiX1xBEHHF75Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3QLsfF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3QLsfF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CD8C32783;
	Tue, 23 Apr 2024 21:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908731;
	bh=Q2j2BRDL1F+dUYkNzS5URkHFpyLo9iiaW6t7bjnu0Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3QLsfF0YImJf0f1/mix9Bm8QsQKBV2Iv+OL3c8ElrWXyM9SzkKANoum3puvMX2wZ
	 LOT6XTCLBPR2Nne4Pwri/hfDxW8uuhbEE+/fGrhRhmvowx+lTicjZfzhHOZrmsHhyJ
	 /N/2qnnvQvaAXNjhMlQR0UC/rNua+RJ/nF8Pb7SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/141] x86/bugs: Fix BHI retpoline check
Date: Tue, 23 Apr 2024 14:39:25 -0700
Message-ID: <20240423213856.321383804@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 69129794d94c544810e68b2b4eaa7e44063f9bf2 ]

Confusingly, X86_FEATURE_RETPOLINE doesn't mean retpolines are enabled,
as it also includes the original "AMD retpoline" which isn't a retpoline
at all.

Also replace cpu_feature_enabled() with boot_cpu_has() because this is
before alternatives are patched and cpu_feature_enabled()'s fallback
path is slower than plain old boot_cpu_has().

Fixes: ec9404e40e8f ("x86/bhi: Add BHI mitigation knob")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/ad3807424a3953f0323c011a643405619f2a4927.1712944776.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6d69123de3660..3f38592ec7713 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1629,7 +1629,8 @@ static void __init bhi_select_mitigation(void)
 		return;
 
 	/* Retpoline mitigates against BHI unless the CPU has RRSBA behavior */
-	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {
+	if (boot_cpu_has(X86_FEATURE_RETPOLINE) &&
+	    !boot_cpu_has(X86_FEATURE_RETPOLINE_LFENCE)) {
 		spec_ctrl_disable_kernel_rrsba();
 		if (rrsba_disabled)
 			return;
@@ -2783,11 +2784,13 @@ static const char *spectre_bhi_state(void)
 {
 	if (!boot_cpu_has_bug(X86_BUG_BHI))
 		return "; BHI: Not affected";
-	else if  (boot_cpu_has(X86_FEATURE_CLEAR_BHB_HW))
+	else if (boot_cpu_has(X86_FEATURE_CLEAR_BHB_HW))
 		return "; BHI: BHI_DIS_S";
-	else if  (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP))
+	else if (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP))
 		return "; BHI: SW loop, KVM: SW loop";
-	else if (boot_cpu_has(X86_FEATURE_RETPOLINE) && rrsba_disabled)
+	else if (boot_cpu_has(X86_FEATURE_RETPOLINE) &&
+		 !boot_cpu_has(X86_FEATURE_RETPOLINE_LFENCE) &&
+		 rrsba_disabled)
 		return "; BHI: Retpoline";
 	else if (boot_cpu_has(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT))
 		return "; BHI: Vulnerable, KVM: SW loop";
-- 
2.43.0



