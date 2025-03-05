Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0981A3176;
	Wed,  5 Mar 2025 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197871; cv=none; b=l57Dvpul4IqZ0UaOVH0BYgef4J43kDHNUQZqlGnPH+03SSQniYEn4lwNMMXeO0qJDtIcIJ94CxugwKVJSFMK09oTTU6NLTt6DUF/f82BibG4ncqacMc0EagAgqg9q6XGWdMqKtIMn6RFHHtVEU4w0zjn8rwoDzY9gVAjBt53OPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197871; c=relaxed/simple;
	bh=zID9OTOMh+UyNQhUwJ2wEImrCDEeua1qgSCC1gCmbWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5mUc5J1zD0fsG3NdCKxwI+DrYRj0nRg+l113YAnsiJJaVAzyqEhDLbA3JWt4CfkZBT6/GV8+8C5x5L8ria1flTXV37tNKFFnKCq6pfx8xAVkDpSl9FGu6oE8GjKbKJ4Q+zWfT1GSjZ3PbrYtyfDu7xk/bZXKvozuxJA3/g+D20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLy+bu2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLy+bu2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF36C4CED1;
	Wed,  5 Mar 2025 18:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197870;
	bh=zID9OTOMh+UyNQhUwJ2wEImrCDEeua1qgSCC1gCmbWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLy+bu2OifWZBboHyVrSfdRPyC+TKsrIEoB3BJnVqhkmNlONNy1N4/zzKz6uzkBQa
	 XNNxDZHW+I7UpCa3eccGThe0PSKhCAq5T5Uw60OMGZ3bNdlLsxoA8kuz5xq0LzPXxl
	 WVoAg5xb1T7T6PkPZYKgrb1uP7cYKnViwpttk1I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 128/142] x86/microcode: Prepare for minimal revision check
Date: Wed,  5 Mar 2025 18:49:07 +0100
Message-ID: <20250305174505.474593251@linuxfoundation.org>
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

commit 9407bda845dd19756e276d4f3abc15a20777ba45 upstream

Applying microcode late can be fatal for the running kernel when the
update changes functionality which is in use already in a non-compatible
way, e.g. by removing a CPUID bit.

There is no way for admins which do not have access to the vendors deep
technical support to decide whether late loading of such a microcode is
safe or not.

Intel has added a new field to the microcode header which tells the
minimal microcode revision which is required to be active in the CPU in
order to be safe.

Provide infrastructure for handling this in the core code and a command
line switch which allows to enforce it.

If the update is considered safe the kernel is not tainted and the annoying
warning message not emitted. If it's enforced and the currently loaded
microcode revision is not safe for late loading then the load is aborted.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231017211724.079611170@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    5 +++++
 arch/x86/Kconfig                                |   23 ++++++++++++++++++++++-
 arch/x86/kernel/cpu/microcode/amd.c             |    3 +++
 arch/x86/kernel/cpu/microcode/core.c            |   19 ++++++++++++++-----
 arch/x86/kernel/cpu/microcode/intel.c           |    3 +++
 arch/x86/kernel/cpu/microcode/internal.h        |    2 ++
 6 files changed, 49 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3287,6 +3287,11 @@
 
 	mga=		[HW,DRM]
 
+	microcode.force_minrev=	[X86]
+			Format: <bool>
+			Enable or disable the microcode minimal revision
+			enforcement for the runtime microcode loader.
+
 	min_addr=nn[KMG]	[KNL,BOOT,IA-64] All physical memory below this
 			physical address is ignored.
 
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1323,7 +1323,28 @@ config MICROCODE_LATE_LOADING
 	  is a tricky business and should be avoided if possible. Just the sequence
 	  of synchronizing all cores and SMT threads is one fragile dance which does
 	  not guarantee that cores might not softlock after the loading. Therefore,
-	  use this at your own risk. Late loading taints the kernel too.
+	  use this at your own risk. Late loading taints the kernel unless the
+	  microcode header indicates that it is safe for late loading via the
+	  minimal revision check. This minimal revision check can be enforced on
+	  the kernel command line with "microcode.minrev=Y".
+
+config MICROCODE_LATE_FORCE_MINREV
+	bool "Enforce late microcode loading minimal revision check"
+	default n
+	depends on MICROCODE_LATE_LOADING
+	help
+	  To prevent that users load microcode late which modifies already
+	  in use features, newer microcode patches have a minimum revision field
+	  in the microcode header, which tells the kernel which minimum
+	  revision must be active in the CPU to safely load that new microcode
+	  late into the running system. If disabled the check will not
+	  be enforced but the kernel will be tainted when the minimal
+	  revision check fails.
+
+	  This minimal revision check can also be controlled via the
+	  "microcode.minrev" parameter on the kernel command line.
+
+	  If unsure say Y.
 
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -888,6 +888,9 @@ static enum ucode_state request_microcod
 	enum ucode_state ret = UCODE_NFOUND;
 	const struct firmware *fw;
 
+	if (force_minrev)
+		return UCODE_NFOUND;
+
 	if (c->x86 >= 0x15)
 		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -46,6 +46,9 @@
 static struct microcode_ops	*microcode_ops;
 bool dis_ucode_ldr = true;
 
+bool force_minrev = IS_ENABLED(CONFIG_MICROCODE_LATE_FORCE_MINREV);
+module_param(force_minrev, bool, S_IRUSR | S_IWUSR);
+
 /*
  * Synchronization.
  *
@@ -531,15 +534,17 @@ static int load_cpus_stopped(void *unuse
 	return 0;
 }
 
-static int load_late_stop_cpus(void)
+static int load_late_stop_cpus(bool is_safe)
 {
 	unsigned int cpu, updated = 0, failed = 0, timedout = 0, siblings = 0;
 	unsigned int nr_offl, offline = 0;
 	int old_rev = boot_cpu_data.microcode;
 	struct cpuinfo_x86 prev_info;
 
-	pr_err("Attempting late microcode loading - it is dangerous and taints the kernel.\n");
-	pr_err("You should switch to early loading, if possible.\n");
+	if (!is_safe) {
+		pr_err("Late microcode loading without minimal revision check.\n");
+		pr_err("You should switch to early loading, if possible.\n");
+	}
 
 	atomic_set(&late_cpus_in, num_online_cpus());
 	atomic_set(&offline_in_nmi, 0);
@@ -589,7 +594,9 @@ static int load_late_stop_cpus(void)
 		return -EIO;
 	}
 
-	add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
+	if (!is_safe || failed || timedout)
+		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
+
 	pr_info("load: updated on %u primary CPUs with %u siblings\n", updated, siblings);
 	if (failed || timedout) {
 		pr_err("load incomplete. %u CPUs timed out or failed\n",
@@ -679,7 +686,9 @@ static int load_late_locked(void)
 
 	switch (microcode_ops->request_microcode_fw(0, &microcode_pdev->dev)) {
 	case UCODE_NEW:
-		return load_late_stop_cpus();
+		return load_late_stop_cpus(false);
+	case UCODE_NEW_SAFE:
+		return load_late_stop_cpus(true);
 	case UCODE_NFOUND:
 		return -ENOENT;
 	default:
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -480,6 +480,9 @@ static enum ucode_state parse_microcode_
 	unsigned int curr_mc_size = 0;
 	u8 *new_mc = NULL, *mc = NULL;
 
+	if (force_minrev)
+		return UCODE_NFOUND;
+
 	while (iov_iter_count(iter)) {
 		struct microcode_header_intel mc_header;
 		unsigned int mc_size, data_size;
--- a/arch/x86/kernel/cpu/microcode/internal.h
+++ b/arch/x86/kernel/cpu/microcode/internal.h
@@ -13,6 +13,7 @@ struct device;
 enum ucode_state {
 	UCODE_OK	= 0,
 	UCODE_NEW,
+	UCODE_NEW_SAFE,
 	UCODE_UPDATED,
 	UCODE_NFOUND,
 	UCODE_ERROR,
@@ -88,6 +89,7 @@ static inline unsigned int x86_cpuid_fam
 }
 
 extern bool dis_ucode_ldr;
+extern bool force_minrev;
 
 #ifdef CONFIG_CPU_SUP_AMD
 void load_ucode_amd_bsp(unsigned int family);


