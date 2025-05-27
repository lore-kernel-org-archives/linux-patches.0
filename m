Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE51C276057;
	Tue, 27 May 2025 16:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364741; cv=none; b=Q5ZOIOIp1JNWaA4vahTOW5uTkG36PGtzQZMemaBuXReFOlDSLS5dRISsgwEHgI66xPiBxwL5w7M357p2WIgXB8mt5B/4eJho18JjBHXMVEgj2pExx68YWC2lDo5Eh63ef83ggLdLKRXda1jTt1Gn4U99/wGR+FnKwZv+aPsShO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364741; c=relaxed/simple;
	bh=Xm222L8UyWkhu/MtAKjCiI5cUJRuPLTpU9Tz9tVcgyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLjeRsj6waQIkaVMcZETevm2FRD2mrTd6G0P64gzdu1bgItpgVEIgnNB9hveW3RmZEKc3njfVlqt5ptqwJrD47e+SrXCM5MlhlHYQXz1T3ziwJnMnswrvW5jjQv3truKPqNmFq2XV65tv/TNw+eaSuPjVduv6IrgG5vvZVj+2AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/D6TChr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/D6TChr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1A4C4CEE9;
	Tue, 27 May 2025 16:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364740;
	bh=Xm222L8UyWkhu/MtAKjCiI5cUJRuPLTpU9Tz9tVcgyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/D6TChrZaYlwxaD9YIaGJxC7eYxw2F40P+eeTlQBOng8mJ8udMeCfQsLG7O0Ls7d
	 Z5siJmQpYyp8T4NthpKBEfT4szUBXbEveVrfyOMriWdU0Ib3H3RQ4fnGCHCp8Le6RO
	 qqRKtDjzuWsQPQd1w6wpk1VQatkADVX9eCCNA99k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sohil Mehta <sohil.mehta@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/626] x86/microcode: Update the Intel processor flag scan check
Date: Tue, 27 May 2025 18:20:03 +0200
Message-ID: <20250527162449.509012793@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Sohil Mehta <sohil.mehta@intel.com>

[ Upstream commit 7e6b0a2e4152f4046af95eeb46f8b4f9b2a7398d ]

The Family model check to read the processor flag MSR is misleading and
potentially incorrect. It doesn't consider Family while comparing the
model number. The original check did have a Family number but it got
lost/moved during refactoring.

intel_collect_cpu_info() is called through multiple paths such as early
initialization, CPU hotplug as well as IFS image load. Some of these
flows would be error prone due to the ambiguous check.

Correct the processor flag scan check to use a Family number and update
it to a VFM based one to make it more readable.

Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/r/20250219184133.816753-4-sohil.mehta@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h   | 1 +
 arch/x86/kernel/cpu/microcode/intel.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 62d8b9448dc5c..c6198fbcc1d77 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -46,6 +46,7 @@
 #define INTEL_ANY			IFM(X86_FAMILY_ANY, X86_MODEL_ANY)
 
 #define INTEL_PENTIUM_PRO		IFM(6, 0x01)
+#define INTEL_PENTIUM_III_DESCHUTES	IFM(6, 0x05)
 
 #define INTEL_CORE_YONAH		IFM(6, 0x0E)
 
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index df5650eb3f088..362cc71bbc866 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -74,7 +74,7 @@ void intel_collect_cpu_info(struct cpu_signature *sig)
 	sig->pf = 0;
 	sig->rev = intel_get_microcode_revision();
 
-	if (x86_model(sig->sig) >= 5 || x86_family(sig->sig) > 6) {
+	if (IFM(x86_family(sig->sig), x86_model(sig->sig)) >= INTEL_PENTIUM_III_DESCHUTES) {
 		unsigned int val[2];
 
 		/* get processor flags from MSR 0x17 */
-- 
2.39.5



