Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D87519C542;
	Wed,  5 Mar 2025 18:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198369; cv=none; b=DNREebzxpPyAEJeQmuM3Lo9qDSqAcCdJgivKi76N5vqz93EL5lUwFFp07bb4I9OoZEFq1QCWw/4q0ZgqA9FseuTxY7vL9SxQO7x7UUILZIVIIk7k6mkqrFaxV4MNXAIAqOs3PELGhylsGeHXTLQu9dnTepeNWBeoplRfmZcQydc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198369; c=relaxed/simple;
	bh=qR1RhMbO/j8kIpFx5Wkr39tadRfVeWAM2kY4AtEZCec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLlBy6D41sTG6qnAfU0GGKUaD+VHLHKedjMh4n4ygMUIu9WlJgLlxN8wyTsinCliXcUXPKTAGYLNVCG+ghoUr7LG/SxgggsYSq4KZcB5Cyj1ZBbMatHw/oDumHOHAzldW2IK7nyGnnfKps0QtA17RZdHwf2qLmA+vtGJnPnaBFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2K+fP7dN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2K+fP7dN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C83C4CEE0;
	Wed,  5 Mar 2025 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198369;
	bh=qR1RhMbO/j8kIpFx5Wkr39tadRfVeWAM2kY4AtEZCec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2K+fP7dNSz6F3mZACzTnj/XH7zrV67Et8Cca9Xf460PAT8SYbpdmh/gAj6EdRYIY2
	 qK/aPlNwaQhTiyrkDIShOmrGCPDLbc23XeEU1CH0aZu+nlIfDATQ+4QIMWEjOJRU8k
	 maEWTxFMZLyLhHuROdL2r9Zgpxc2rrYJQfFIKRmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 148/150] x86/microcode/AMD: Get rid of the _load_microcode_amd() forward declaration
Date: Wed,  5 Mar 2025 18:49:37 +0100
Message-ID: <20250305174509.762008930@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

commit b39c387164879eef71886fc93cee5ca7dd7bf500 upstream.

Simply move save_microcode_in_initrd() down.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250211163648.30531-5-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   54 +++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -594,34 +594,6 @@ void __init load_ucode_amd_bsp(struct ea
 		native_rdmsr(MSR_AMD64_PATCH_LEVEL, ed->new_rev, dummy);
 }
 
-static enum ucode_state _load_microcode_amd(u8 family, const u8 *data, size_t size);
-
-static int __init save_microcode_in_initrd(void)
-{
-	unsigned int cpuid_1_eax = native_cpuid_eax(1);
-	struct cpuinfo_x86 *c = &boot_cpu_data;
-	struct cont_desc desc = { 0 };
-	enum ucode_state ret;
-	struct cpio_data cp;
-
-	if (dis_ucode_ldr || c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10)
-		return 0;
-
-	if (!find_blobs_in_containers(&cp))
-		return -EINVAL;
-
-	scan_containers(cp.data, cp.size, &desc);
-	if (!desc.mc)
-		return -EINVAL;
-
-	ret = _load_microcode_amd(x86_family(cpuid_1_eax), desc.data, desc.size);
-	if (ret > UCODE_UPDATED)
-		return -EINVAL;
-
-	return 0;
-}
-early_initcall(save_microcode_in_initrd);
-
 static inline bool patch_cpus_equivalent(struct ucode_patch *p,
 					 struct ucode_patch *n,
 					 bool ignore_stepping)
@@ -1005,6 +977,32 @@ static enum ucode_state load_microcode_a
 	return ret;
 }
 
+static int __init save_microcode_in_initrd(void)
+{
+	unsigned int cpuid_1_eax = native_cpuid_eax(1);
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	struct cont_desc desc = { 0 };
+	enum ucode_state ret;
+	struct cpio_data cp;
+
+	if (dis_ucode_ldr || c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10)
+		return 0;
+
+	if (!find_blobs_in_containers(&cp))
+		return -EINVAL;
+
+	scan_containers(cp.data, cp.size, &desc);
+	if (!desc.mc)
+		return -EINVAL;
+
+	ret = _load_microcode_amd(x86_family(cpuid_1_eax), desc.data, desc.size);
+	if (ret > UCODE_UPDATED)
+		return -EINVAL;
+
+	return 0;
+}
+early_initcall(save_microcode_in_initrd);
+
 /*
  * AMD microcode firmware naming convention, up to family 15h they are in
  * the legacy file:


