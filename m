Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4BE20C004;
	Wed,  5 Mar 2025 18:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197919; cv=none; b=sDIH/2Sbppls8A0j7kjM0LKOiA17y6paZM21F5GXs6TIV2MLjMTlSUBgwrkjO4VrNfMzOOB/0FMB5iVXEKNEYOx6JaSJ4Ucbgjs4ccl8Gk6L/RwvJjBusHL4SGDtSNmm0Ro/EN1jbJcLZ9qdj+urKMMYwrySSO+lcspL4YkjC1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197919; c=relaxed/simple;
	bh=pOCk9WfbEz7OLnFs2P8iF5iiCz9e6BejIA5dr81EZ14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYy+0MK5sM0AG1x14WxKcOceuzMR8aU1wmj+0/Al0w8H8ZQt/fxKh2mCTwCKqhEZP6bnNeUya18uilZQ0K//WsmJMGN6fKkQau23r5FzM+6fQQkPqE7kdSXg3mFQQC2QR/THi2zGfkzor6PUXebt4EzFF57MeqUPzHPRZBzrwDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkuKQ2u+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkuKQ2u+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42186C4CED1;
	Wed,  5 Mar 2025 18:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197919;
	bh=pOCk9WfbEz7OLnFs2P8iF5iiCz9e6BejIA5dr81EZ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkuKQ2u+v39cTT17vHzLOrBgtnG073XOIDDk5ZDYLoT/boDQ+sI4QL6Pz082NWIH9
	 8BGG1KC6oY7nqPdQAZoE3+PSKZILFurgLsfZP31Lnrd0kIi1GrmYWLWlmJZVmZeB4F
	 vdEpOBuwUluDbbOxBGwcqCs3YHZQcp4q82Y4bX/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 103/142] x86/microcode/intel: Save the microcode only after a successful late-load
Date: Wed,  5 Mar 2025 18:48:42 +0100
Message-ID: <20250305174504.469123010@linuxfoundation.org>
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

commit 2a1dada3d1cf8f80a27663653a371d99dbf5d540 upstream

There are situations where the late microcode is loaded into memory but
is not applied:

  1) The rendezvous fails
  2) The microcode is rejected by the CPUs

If any of this happens then the pointer which was updated at firmware
load time is stale and subsequent CPU hotplug operations either fail to
update or create inconsistent microcode state.

Save the loaded microcode in a separate pointer before the late load is
attempted and when successful, update the hotplug pointer accordingly
via a new microcode_ops callback.

Remove the pointless fallback in the loader to a microcode pointer which
is never populated.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231002115902.505491309@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/core.c     |    4 ++++
 arch/x86/kernel/cpu/microcode/intel.c    |   30 +++++++++++++++---------------
 arch/x86/kernel/cpu/microcode/internal.h |    1 +
 3 files changed, 20 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -403,6 +403,10 @@ static int microcode_reload_late(void)
 	store_cpu_caps(&prev_info);
 
 	ret = stop_machine_cpuslocked(__reload_late, NULL, cpu_online_mask);
+
+	if (microcode_ops->finalize_late_load)
+		microcode_ops->finalize_late_load(ret);
+
 	if (!ret) {
 		pr_info("Reload succeeded, microcode revision: 0x%x -> 0x%x\n",
 			old, boot_cpu_data.microcode);
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -36,6 +36,7 @@ static const char ucode_path[] = "kernel
 
 /* Current microcode patch used in early patching on the APs. */
 static struct microcode_intel *ucode_patch_va __read_mostly;
+static struct microcode_intel *ucode_patch_late __read_mostly;
 
 /* last level cache size per core */
 static unsigned int llc_size_per_core __ro_after_init;
@@ -470,12 +471,9 @@ static enum ucode_state apply_microcode_
 	if (WARN_ON(raw_smp_processor_id() != cpu))
 		return UCODE_ERROR;
 
-	mc = ucode_patch_va;
-	if (!mc) {
-		mc = uci->mc;
-		if (!mc)
-			return UCODE_NFOUND;
-	}
+	mc = ucode_patch_late;
+	if (!mc)
+		return UCODE_NFOUND;
 
 	/*
 	 * Save us the MSR write below - which is a particular expensive
@@ -594,15 +592,7 @@ static enum ucode_state parse_microcode_
 	if (!new_mc)
 		return UCODE_NFOUND;
 
-	/* Save for CPU hotplug */
-	save_microcode_patch((struct microcode_intel *)new_mc);
-	uci->mc = ucode_patch_va;
-
-	vfree(new_mc);
-
-	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
-		 cpu, cur_rev, uci->cpu_sig.rev);
-
+	ucode_patch_late = (struct microcode_intel *)new_mc;
 	return UCODE_NEW;
 }
 
@@ -659,10 +649,20 @@ static enum ucode_state request_microcod
 	return ret;
 }
 
+static void finalize_late_load(int result)
+{
+	if (!result)
+		save_microcode_patch(ucode_patch_late);
+
+	vfree(ucode_patch_late);
+	ucode_patch_late = NULL;
+}
+
 static struct microcode_ops microcode_intel_ops = {
 	.request_microcode_fw	= request_microcode_fw,
 	.collect_cpu_info	= collect_cpu_info,
 	.apply_microcode	= apply_microcode_intel,
+	.finalize_late_load	= finalize_late_load,
 };
 
 static __init void calc_llc_size_per_core(struct cpuinfo_x86 *c)
--- a/arch/x86/kernel/cpu/microcode/internal.h
+++ b/arch/x86/kernel/cpu/microcode/internal.h
@@ -31,6 +31,7 @@ struct microcode_ops {
 	 */
 	enum ucode_state (*apply_microcode)(int cpu);
 	int (*collect_cpu_info)(int cpu, struct cpu_signature *csig);
+	void (*finalize_late_load)(int result);
 };
 
 extern struct ucode_cpu_info ucode_cpu_info[];


