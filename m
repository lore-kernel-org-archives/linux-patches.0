Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB9719067C;
	Wed,  5 Mar 2025 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197917; cv=none; b=mWx3voNa6qvIKTd6QtcY28ynh/kMiXFojGkToFQGzbdYFW9WqVf012CDRxDzKzCwQzvNebs5FBcBLhHkQlslt+ZpDRnpF2tdEfMXI88XVn//kCGU7wEGmzdFmITXJlW+pRckRvW8/nbNIY9iQ5LCI98hJ8298pwzKlzrcUZpcL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197917; c=relaxed/simple;
	bh=jgIPvkJvYYJnl/gWtHV+tSQbd18qpQ0uCgN6jbPkFv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPM0P0n5mveMxpmhVjqyAL/txiAJfx6mZOQYWA57zUUz3GK8ZL9HE0xItCDrG7Uw1NEhtuaTkUunp6gp6vPStg2IcU06RpIuhRWMlmtKmwXxlw6VrN+thAbuOlnF1kVFLnws4rxDvklCHcmwv4z0wLk846fQ/8kmG9umaVjX3/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8f1Kdbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8f1Kdbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4D2C4CED1;
	Wed,  5 Mar 2025 18:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197916;
	bh=jgIPvkJvYYJnl/gWtHV+tSQbd18qpQ0uCgN6jbPkFv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8f1KdbeEh/Cu/rt9OiotkJ71EGew9AEj38ROje3WiPPn+ZiQbawZpZ5lv0ZNbK9t
	 L37GF8H2xYxEqVeBa5CQbfHBtjN55wGE57BRrmXOcwrEGKHb0GIh0Fx3SOrsM/dt+p
	 6QR3/dxpAkvmVp6w0oJdDR6dBeXuJkAm0ehim9u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 112/142] x86/microcode/amd: Cache builtin/initrd microcode early
Date: Wed,  5 Mar 2025 18:48:51 +0100
Message-ID: <20250305174504.827948136@linuxfoundation.org>
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

commit a7939f01672034a58ad3fdbce69bb6c665ce0024 upstream

There is no reason to scan builtin/initrd microcode on each AP.

Cache the builtin/initrd microcode in an early initcall so that the
early AP loader can utilize the cache.

The existing fs initcall which invoked save_microcode_in_initrd_amd() is
still required to maintain the initrd_gone flag. Rename it accordingly.
This will be removed once the AP loader code is converted to use the
cache.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231017211723.187566507@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c  |    8 +++++++-
 arch/x86/kernel/cpu/microcode/core.c |   26 ++++----------------------
 2 files changed, 11 insertions(+), 23 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -527,12 +527,17 @@ void load_ucode_amd_early(unsigned int c
 
 static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
 
-int __init save_microcode_in_initrd_amd(unsigned int cpuid_1_eax)
+static int __init save_microcode_in_initrd(void)
 {
+	unsigned int cpuid_1_eax = native_cpuid_eax(1);
+	struct cpuinfo_x86 *c = &boot_cpu_data;
 	struct cont_desc desc = { 0 };
 	enum ucode_state ret;
 	struct cpio_data cp;
 
+	if (dis_ucode_ldr || c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10)
+		return 0;
+
 	find_blobs_in_containers(cpuid_1_eax, &cp);
 	if (!(cp.data && cp.size))
 		return -EINVAL;
@@ -549,6 +554,7 @@ int __init save_microcode_in_initrd_amd(
 
 	return 0;
 }
+early_initcall(save_microcode_in_initrd);
 
 /*
  * a small, trivial cache of per-family ucode patches
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -180,30 +180,13 @@ void load_ucode_ap(void)
 	}
 }
 
-static int __init save_microcode_in_initrd(void)
+/* Temporary workaround until find_microcode_in_initrd() is __init */
+static int __init mark_initrd_gone(void)
 {
-	struct cpuinfo_x86 *c = &boot_cpu_data;
-	int ret = -EINVAL;
-
-	if (dis_ucode_ldr) {
-		ret = 0;
-		goto out;
-	}
-
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		if (c->x86 >= 0x10)
-			ret = save_microcode_in_initrd_amd(cpuid_eax(1));
-		break;
-	default:
-		break;
-	}
-
-out:
 	initrd_gone = true;
-
-	return ret;
+	return 0;
 }
+fs_initcall(mark_initrd_gone);
 
 struct cpio_data find_microcode_in_initrd(const char *path)
 {
@@ -621,5 +604,4 @@ static int __init microcode_init(void)
 	return error;
 
 }
-fs_initcall(save_microcode_in_initrd);
 late_initcall(microcode_init);


