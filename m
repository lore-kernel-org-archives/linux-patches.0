Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F9014389D;
	Tue, 23 Apr 2024 21:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908622; cv=none; b=WIkuCjUGQAgN2pQ5NzPjX39IlYPOBimUt67XPu/jGL1ok/FNBdKOVvx1m5BsLLWQqKswqoQ1hlAPeGIqRICXccM1oKUxWwKyj0yaZHVK+1XOB8ppnoJT+vacS4TCo2qsYaUA6MqqEwwNGf/QsvgG46Y+hzP7Uds+qpHQEEsu6yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908622; c=relaxed/simple;
	bh=SWG0BTvMn9KJmmSBYslhB5gZBu+l94Juq/aYUTxdT6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmcVF0iUE9npgirWd/d7o/45QlazRUmTdguLeAHA4ggzIym/nZmW8CUucLsDxiQbjwXok6Ye3g6ll/oYYAx6B3elLuYxqVp8h3a7qetHtvOVI4DTJSPnG/H3k8vjvtLoQtO7KRSLJ2XI/QJlNaHYU1bdSy+e6SGeIsAQLtjpVbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kx4UPHls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kx4UPHls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A552CC32783;
	Tue, 23 Apr 2024 21:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908622;
	bh=SWG0BTvMn9KJmmSBYslhB5gZBu+l94Juq/aYUTxdT6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kx4UPHlsmy6XzkXKcVxRNeLogWQvvV/35QpGmaCTJkoA0+p/1iyM/B/rq5wmwsBv6
	 KF6mMig1rLbuIffjgBrtt0hO8D70Oz0Z1om+xbUSnwjQ2WMT70SJEh3tzKBVzn2GvV
	 msg7kJNqzrWAC7+TMdsiz2ve5XGZ5DuKksIScHRc=
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
Subject: [PATCH 6.6 097/158] x86/bugs: Fix BHI retpoline check
Date: Tue, 23 Apr 2024 14:38:54 -0700
Message-ID: <20240423213858.899778358@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5ff69b1d39b20..c2dc9b7426acb 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1651,7 +1651,8 @@ static void __init bhi_select_mitigation(void)
 		return;
 
 	/* Retpoline mitigates against BHI unless the CPU has RRSBA behavior */
-	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {
+	if (boot_cpu_has(X86_FEATURE_RETPOLINE) &&
+	    !boot_cpu_has(X86_FEATURE_RETPOLINE_LFENCE)) {
 		spec_ctrl_disable_kernel_rrsba();
 		if (rrsba_disabled)
 			return;
@@ -2803,11 +2804,13 @@ static const char *spectre_bhi_state(void)
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



