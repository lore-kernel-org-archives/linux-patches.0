Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821C717B505;
	Wed,  5 Mar 2025 18:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197925; cv=none; b=WRKUKaAb3VUMN9/6hjn1dTKPUgaT6Z9rUwizaV7PjCgMHHL7hXs7TMCwkaHxKSg8T/aZC5CGwtgmYvajjo5yb2cgLnSMtodWwcINAeg7DaFvESm24RGcV17+LXVmd2pBLVmE8eIgCMmNYAHT82S73JIRGd+yUyoHb3qbYWJ/Ozs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197925; c=relaxed/simple;
	bh=DNslw0S+cfmswe1IKmvROcuyHkb0jMKkGPcdr22SFTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qb09qrv2Y4FfbJoaxADnxBXJqdJvjF/m3YeZomfkZ7IWoJO5g3j+WFwFWk8xR2f3ooINWyP1rrrMJNT2OcGVtjDieomOldOgFKP4a4Rn6YLjlJ53j8+I8v/HMb7eL09q/fMYdI5PlqKTkPplToZf5AXQpWHm/oshnsiG5HQ+pc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7Tr86xf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7Tr86xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C453C4CED1;
	Wed,  5 Mar 2025 18:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197925;
	bh=DNslw0S+cfmswe1IKmvROcuyHkb0jMKkGPcdr22SFTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7Tr86xfLtCSHwWoCECnRkB058px2p79Qxdlhdc9uIMvi9mVUet+BBCZNL5KAiZT3
	 +cpeXvCun0KjTp4bVhIRASCKxMikhrP/4V0UVspKlHECrS4x8eSNq9lTyEtYqGYFeP
	 SAcDTpx2iketuGuptq7CEZhaZE/QZWQ2bdE3wJ/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 140/142] x86/microcode/AMD: Get rid of the _load_microcode_amd() forward declaration
Date: Wed,  5 Mar 2025 18:49:19 +0100
Message-ID: <20250305174505.961905822@linuxfoundation.org>
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

commit b39c387164879eef71886fc93cee5ca7dd7bf500 upstream

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
@@ -597,34 +597,6 @@ void __init load_ucode_amd_bsp(struct ea
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
@@ -1008,6 +980,32 @@ static enum ucode_state load_microcode_a
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


