Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17321C863D;
	Wed,  5 Mar 2025 18:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197853; cv=none; b=BwPv+MK4lhIfaXB9A9CtTWBkWooVB8tiy4bZk7oUT4RGvhaIiaBB/yC6yOrvJ2KebMrYlcmWYi3PoVWzCiDQsl9r5pscAC/PhSoqO0fxlVBhpB4gNliZCy53IlkjLnPdRu4iZKPD9twgZTD/79Zn38DV0lAvR+BKkjUEyfx83rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197853; c=relaxed/simple;
	bh=zuson8+LaBr0V/5HyPNnRBNFm7ERjv+zt5eSPPPpy1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzujkmTueAlKfy/qhJx7J1GnX1KsHLsOElbqd2Pj1floUchIJ0XVQmNRx5XRqMTKZ2z8m2QPGZXg7S1kwiIEC29u9cM83Y0brcTDIqI1Y7ji+5XrUyBwL69abyncpzZNt/vkn1Hn8a0Hya7IJxhhdElkklZma1eAdeYe2BsMSqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF4h0HW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF4h0HW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ABEC4CED1;
	Wed,  5 Mar 2025 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197853;
	bh=zuson8+LaBr0V/5HyPNnRBNFm7ERjv+zt5eSPPPpy1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SF4h0HW6IeJpB/PCZ8GO8GAIMefOIgXYK6nVmKbhLimyT1NIDWk3SH3svv12abcjI
	 xcBmyf5fzLv1qZpSh3ydCL9C0sri5GoDuBupVsNAGgr3g3lKodX9CF7vwrkcY5F8eQ
	 ZG0FEpTBF25L1YLm6aOO2eq69KLB3EEXzlpUYLjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 105/142] x86/microcode/intel: Unify microcode apply() functions
Date: Wed,  5 Mar 2025 18:48:44 +0100
Message-ID: <20250305174504.548308257@linuxfoundation.org>
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

commit 3973718cff1e3a5d88ea78ec28ecca2afa60b30b upstream

Deduplicate the early and late apply() functions.

  [ bp: Rename the function which does the actual application to
      __apply_microcode() to differentiate it from
      microcode_ops.apply_microcode(). ]

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20231017211722.795508212@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/intel.c |  106 +++++++++++-----------------------
 1 file changed, 37 insertions(+), 69 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -307,12 +307,12 @@ static __init struct microcode_intel *sc
 	return size ? NULL : patch;
 }
 
-static enum ucode_state apply_microcode_early(struct ucode_cpu_info *uci)
+static enum ucode_state __apply_microcode(struct ucode_cpu_info *uci,
+					  struct microcode_intel *mc,
+					  u32 *cur_rev)
 {
-	struct microcode_intel *mc;
-	u32 rev, old_rev, date;
+	u32 rev;
 
-	mc = uci->mc;
 	if (!mc)
 		return UCODE_NFOUND;
 
@@ -321,14 +321,12 @@ static enum ucode_state apply_microcode_
 	 * operation - when the other hyperthread has updated the microcode
 	 * already.
 	 */
-	rev = intel_get_microcode_revision();
-	if (rev >= mc->hdr.rev) {
-		uci->cpu_sig.rev = rev;
+	*cur_rev = intel_get_microcode_revision();
+	if (*cur_rev >= mc->hdr.rev) {
+		uci->cpu_sig.rev = *cur_rev;
 		return UCODE_OK;
 	}
 
-	old_rev = rev;
-
 	/*
 	 * Writeback and invalidate caches before updating microcode to avoid
 	 * internal issues depending on what the microcode is updating.
@@ -343,13 +341,24 @@ static enum ucode_state apply_microcode_
 		return UCODE_ERROR;
 
 	uci->cpu_sig.rev = rev;
-
-	date = mc->hdr.date;
-	pr_info_once("updated early: 0x%x -> 0x%x, date = %04x-%02x-%02x\n",
-		     old_rev, rev, date & 0xffff, date >> 24, (date >> 16) & 0xff);
 	return UCODE_UPDATED;
 }
 
+static enum ucode_state apply_microcode_early(struct ucode_cpu_info *uci)
+{
+	struct microcode_intel *mc = uci->mc;
+	enum ucode_state ret;
+	u32 cur_rev, date;
+
+	ret = __apply_microcode(uci, mc, &cur_rev);
+	if (ret == UCODE_UPDATED) {
+		date = mc->hdr.date;
+		pr_info_once("updated early: 0x%x -> 0x%x, date = %04x-%02x-%02x\n",
+			     cur_rev, mc->hdr.rev, date & 0xffff, date >> 24, (date >> 16) & 0xff);
+	}
+	return ret;
+}
+
 static __init bool load_builtin_intel_microcode(struct cpio_data *cp)
 {
 	unsigned int eax = 1, ebx, ecx = 0, edx;
@@ -459,70 +468,29 @@ static int collect_cpu_info(int cpu_num,
 	return 0;
 }
 
-static enum ucode_state apply_microcode_intel(int cpu)
+static enum ucode_state apply_microcode_late(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	bool bsp = c->cpu_index == boot_cpu_data.cpu_index;
-	struct microcode_intel *mc;
+	struct microcode_intel *mc = ucode_patch_late;
 	enum ucode_state ret;
-	static int prev_rev;
-	u32 rev;
-
-	/* We should bind the task to the CPU */
-	if (WARN_ON(raw_smp_processor_id() != cpu))
-		return UCODE_ERROR;
-
-	mc = ucode_patch_late;
-	if (!mc)
-		return UCODE_NFOUND;
-
-	/*
-	 * Save us the MSR write below - which is a particular expensive
-	 * operation - when the other hyperthread has updated the microcode
-	 * already.
-	 */
-	rev = intel_get_microcode_revision();
-	if (rev >= mc->hdr.rev) {
-		ret = UCODE_OK;
-		goto out;
-	}
+	u32 cur_rev;
 
-	/*
-	 * Writeback and invalidate caches before updating microcode to avoid
-	 * internal issues depending on what the microcode is updating.
-	 */
-	native_wbinvd();
-
-	/* write microcode via MSR 0x79 */
-	wrmsrl(MSR_IA32_UCODE_WRITE, (unsigned long)mc->bits);
-
-	rev = intel_get_microcode_revision();
-
-	if (rev != mc->hdr.rev) {
-		pr_err("CPU%d update to revision 0x%x failed\n",
-		       cpu, mc->hdr.rev);
+	if (WARN_ON_ONCE(smp_processor_id() != cpu))
 		return UCODE_ERROR;
-	}
 
-	if (bsp && rev != prev_rev) {
-		pr_info("updated to revision 0x%x, date = %04x-%02x-%02x\n",
-			rev,
-			mc->hdr.date & 0xffff,
-			mc->hdr.date >> 24,
+	ret = __apply_microcode(uci, mc, &cur_rev);
+	if (ret != UCODE_UPDATED && ret != UCODE_OK)
+		return ret;
+
+	if (!cpu && uci->cpu_sig.rev != cur_rev) {
+		pr_info("Updated to revision 0x%x, date = %04x-%02x-%02x\n",
+			uci->cpu_sig.rev, mc->hdr.date & 0xffff, mc->hdr.date >> 24,
 			(mc->hdr.date >> 16) & 0xff);
-		prev_rev = rev;
 	}
 
-	ret = UCODE_UPDATED;
-
-out:
-	uci->cpu_sig.rev = rev;
-	c->microcode	 = rev;
-
-	/* Update boot_cpu_data's revision too, if we're on the BSP: */
-	if (bsp)
-		boot_cpu_data.microcode = rev;
+	cpu_data(cpu).microcode	 = uci->cpu_sig.rev;
+	if (!cpu)
+		boot_cpu_data.microcode = uci->cpu_sig.rev;
 
 	return ret;
 }
@@ -663,7 +631,7 @@ static void finalize_late_load(int resul
 static struct microcode_ops microcode_intel_ops = {
 	.request_microcode_fw	= request_microcode_fw,
 	.collect_cpu_info	= collect_cpu_info,
-	.apply_microcode	= apply_microcode_intel,
+	.apply_microcode	= apply_microcode_late,
 	.finalize_late_load	= finalize_late_load,
 };
 


