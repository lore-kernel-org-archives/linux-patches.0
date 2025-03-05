Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C71323027C;
	Wed,  5 Mar 2025 18:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198813; cv=none; b=WexGO2qorg0cd7d0/jrHC6mA6kP5i/xYn47i3IM7fythIHARPWgukr1upKCAZwM2YxJ0hVHdMC3Sh7Sb2nU8T0EZ+L1m1suM+wC1Iph2rMlD3lsEF4lzZL/96oMlD4Uplyem6OI5EwwYbQVt3X9XF0L8OT0XCQb5xcT5usW6zGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198813; c=relaxed/simple;
	bh=SXsZNx359UT6t8yXLT7bJ/+piRXpB+Bj0QXFf4q16H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guwOZeBK2fdgyWe8sEG6TfYr6FmXeGCGgSH6sf80CRNZtTB0M8kP0hEG/lO+2swVdoIaCIS7H4L7NaEOXDvmymjFada+vBwS3YFmIppJhNkIfTEeSte2f/uNvZe3bsC1kGf4tHJEBLOQXa8AL2erZHnlc5hXRjY4DmZPYGqX4Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiTbtKm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiTbtKm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F488C4CED1;
	Wed,  5 Mar 2025 18:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198813;
	bh=SXsZNx359UT6t8yXLT7bJ/+piRXpB+Bj0QXFf4q16H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiTbtKm2x5x7p3hHaHm/9yOcfSHGG7Mv2zeKmxgP7nihWd1/odfeHKQ9EgSmTgs00
	 z0d+a2o2u0V7pxhC4nbCTM8eKOYqSbYFJRsO2rFIWfSj6uq5nIorHFXhDjMCe7AyL0
	 qT4tslsUpXb92xhYLSJ/SBNSnYUoVpeSUwlxoBSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.13 155/157] x86/microcode/AMD: Get rid of the _load_microcode_amd() forward declaration
Date: Wed,  5 Mar 2025 18:49:51 +0100
Message-ID: <20250305174511.519930980@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


