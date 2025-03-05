Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D1B1A3174;
	Wed,  5 Mar 2025 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197885; cv=none; b=UvHr4Fm+myMdp/yFJW8vf9DoYzbU8oEQz67lsfJLMlUgZNEF8Z2sMdoCR+FJqaZiAFOnLgF/ZnD5JpK/a9DVmQr+Sg9o1AB78fL5nVNLvV43iUk5yO+YPxYHr5CFFedL2t3sHdfwJ9YY0S8QXfDITcY25tw7MyYuU0i6WkZOp7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197885; c=relaxed/simple;
	bh=Tb0RlUr7XEb9qqbOtWilhsV18lHIxlreVM53IDTvok8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nz3Ty9ZKnSS+QmNjyjq8wSABEwCj8uTkaUQiv4A9g/LWwPlW0oYRqxobXr3rW0JA34fMTcQMe6UiSEyP4U1GhROzUup1gwscVl4AGl9Y2cgomWGqk2ReRCdMNPpKVqVULjMOkf/TbBzYMRFuoe5jIj8r9CdBO8XjsEZI6QZRxSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tv5R22U7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tv5R22U7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56C7C4CEE0;
	Wed,  5 Mar 2025 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197885;
	bh=Tb0RlUr7XEb9qqbOtWilhsV18lHIxlreVM53IDTvok8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tv5R22U7j28QHL95l3RV9EHtBMGzHtVvQ7pBj1FRd38WmtwtEJ9Wz33MQlM/yxHky
	 hw0bq2idsGUdjky1oi/NwJSJYatqMUnRj/X2ELlE3RpjHtjjHtDuzV1V4LfGRuI25Q
	 hZZ72lmSiImppiG+iSCo/LliIbT6OmYOjLkzWIuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 106/142] x86/microcode/intel: Rework intel_cpu_collect_info()
Date: Wed,  5 Mar 2025 18:48:45 +0100
Message-ID: <20250305174504.589559993@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 164aa1ca537238c46923ccacd8995b4265aee47b upstream

Nothing needs struct ucode_cpu_info. Make it take struct cpu_signature,
let it return a boolean and simplify the implementation. Rename it now
that the silly name clash with collect_cpu_info() is gone.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231017211722.851573238@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpu.h            |    4 ++--
 arch/x86/kernel/cpu/microcode/intel.c |   33 +++++++++------------------------
 drivers/platform/x86/intel/ifs/load.c |    8 +++-----
 3 files changed, 14 insertions(+), 31 deletions(-)

--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -71,9 +71,9 @@ static inline void init_ia32_feat_ctl(st
 
 extern __noendbr void cet_disable(void);
 
-struct ucode_cpu_info;
+struct cpu_signature;
 
-int intel_cpu_collect_info(struct ucode_cpu_info *uci);
+void intel_collect_cpu_info(struct cpu_signature *sig);
 
 static inline bool intel_cpu_signatures_match(unsigned int s1, unsigned int p1,
 					      unsigned int s2, unsigned int p2)
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -68,36 +68,21 @@ static inline unsigned int exttable_size
 	return et->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE;
 }
 
-int intel_cpu_collect_info(struct ucode_cpu_info *uci)
+void intel_collect_cpu_info(struct cpu_signature *sig)
 {
-	unsigned int val[2];
-	unsigned int family, model;
-	struct cpu_signature csig = { 0 };
-	unsigned int eax, ebx, ecx, edx;
+	sig->sig = cpuid_eax(1);
+	sig->pf = 0;
+	sig->rev = intel_get_microcode_revision();
 
-	memset(uci, 0, sizeof(*uci));
+	if (x86_model(sig->sig) >= 5 || x86_family(sig->sig) > 6) {
+		unsigned int val[2];
 
-	eax = 0x00000001;
-	ecx = 0;
-	native_cpuid(&eax, &ebx, &ecx, &edx);
-	csig.sig = eax;
-
-	family = x86_family(eax);
-	model  = x86_model(eax);
-
-	if (model >= 5 || family > 6) {
 		/* get processor flags from MSR 0x17 */
 		native_rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
-		csig.pf = 1 << ((val[1] >> 18) & 7);
+		sig->pf = 1 << ((val[1] >> 18) & 7);
 	}
-
-	csig.rev = intel_get_microcode_revision();
-
-	uci->cpu_sig = csig;
-
-	return 0;
 }
-EXPORT_SYMBOL_GPL(intel_cpu_collect_info);
+EXPORT_SYMBOL_GPL(intel_collect_cpu_info);
 
 /*
  * Returns 1 if update has been found, 0 otherwise.
@@ -391,7 +376,7 @@ static __init struct microcode_intel *ge
 	if (!(cp.data && cp.size))
 		return NULL;
 
-	intel_cpu_collect_info(uci);
+	intel_collect_cpu_info(&uci->cpu_sig);
 
 	return scan_microcode(cp.data, cp.size, uci, save);
 }
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -227,7 +227,7 @@ out:
 
 static int image_sanity_check(struct device *dev, const struct microcode_header_intel *data)
 {
-	struct ucode_cpu_info uci;
+	struct cpu_signature sig;
 
 	/* Provide a specific error message when loading an older/unsupported image */
 	if (data->hdrver != MC_HEADER_TYPE_IFS) {
@@ -240,11 +240,9 @@ static int image_sanity_check(struct dev
 		return -EINVAL;
 	}
 
-	intel_cpu_collect_info(&uci);
+	intel_collect_cpu_info(&sig);
 
-	if (!intel_find_matching_signature((void *)data,
-					   uci.cpu_sig.sig,
-					   uci.cpu_sig.pf)) {
+	if (!intel_find_matching_signature((void *)data, sig.sig, sig.pf)) {
 		dev_err(dev, "cpu signature, processor flags not matching\n");
 		return -EINVAL;
 	}


