Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297D51EE00B;
	Tue,  3 Dec 2024 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242556; cv=none; b=XHr4hmef9rZvpoYSujd5vhHelL0wcQrnVqWn2kmBm7OR4gjSJeOul0xRmkHwMOOcTfRJqu61316tEmHHdLNT0F2FioUmsQHmiDsBbCArJgE/rf2yK0kaLXzlyqSdW9W3n7Vmhi0h+fZrQx1iL0vBJ+2yvQpqXZE/t1ADXIax26w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242556; c=relaxed/simple;
	bh=wFUhsiSwNm9b4pa8AmtWTX9Savs6mfrF3Lz58qIpdVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRpsg9ZRYhVRAWIYVzNEMtV7C3PFyEAw60zDvDXakm6rgkrxyDHKoCB+iJQAV1f5nQ96qQj0nF6owJklC97yLeDJybTXa2/fCAPRP4o+3/lg+Gk7zP/GXenC0porccq5mCaaqYYE5rRG3iF0XHbrHKl0VCxPUL8PMs8A6u+3Ziw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjMueejL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjMueejL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D07BC4CECF;
	Tue,  3 Dec 2024 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242556;
	bh=wFUhsiSwNm9b4pa8AmtWTX9Savs6mfrF3Lz58qIpdVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjMueejLT8V8Q+qREGu8yGEERN174bvkpJN1+5lPALsoo4HyoFGurexssUasrDjcI
	 diYkqao0QVFQmy4s3N2z7l6OmMt1gL3bL/PTGRnZ6Wggcp4CHkdJJ1DbnfeqXQ5zrY
	 t5JIeCS7vNal9sfiO1P6zovFwx9fWZJWAJHng+HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.12 739/826] x86/microcode/AMD: Flush patch buffer mapping after application
Date: Tue,  3 Dec 2024 15:47:46 +0100
Message-ID: <20241203144812.591153227@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit c809b0d0e52d01c30066367b2952c4c4186b1047 upstream.

Due to specific requirements while applying microcode patches on Zen1
and 2, the patch buffer mapping needs to be flushed from the TLB after
application. Do so.

If not, unnecessary and unnatural delays happen in the boot process.

Reported-by: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
Cc: <stable@kernel.org> # f1d84b59cbb9 ("x86/mm: Carve out INVLPG inline asm for use by others")
Link: https://lore.kernel.org/r/ZyulbYuvrkshfsd2@antipodes
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -34,6 +34,7 @@
 #include <asm/setup.h>
 #include <asm/cpu.h>
 #include <asm/msr.h>
+#include <asm/tlb.h>
 
 #include "internal.h"
 
@@ -483,11 +484,25 @@ static void scan_containers(u8 *ucode, s
 	}
 }
 
-static int __apply_microcode_amd(struct microcode_amd *mc)
+static int __apply_microcode_amd(struct microcode_amd *mc, unsigned int psize)
 {
+	unsigned long p_addr = (unsigned long)&mc->hdr.data_code;
 	u32 rev, dummy;
 
-	native_wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc->hdr.data_code);
+	native_wrmsrl(MSR_AMD64_PATCH_LOADER, p_addr);
+
+	if (x86_family(bsp_cpuid_1_eax) == 0x17) {
+		unsigned long p_addr_end = p_addr + psize - 1;
+
+		invlpg(p_addr);
+
+		/*
+		 * Flush next page too if patch image is crossing a page
+		 * boundary.
+		 */
+		if (p_addr >> PAGE_SHIFT != p_addr_end >> PAGE_SHIFT)
+			invlpg(p_addr_end);
+	}
 
 	/* verify patch application was successful */
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
@@ -529,7 +544,7 @@ static bool early_apply_microcode(u32 ol
 	if (old_rev > mc->hdr.patch_id)
 		return ret;
 
-	return !__apply_microcode_amd(mc);
+	return !__apply_microcode_amd(mc, desc.psize);
 }
 
 static bool get_builtin_microcode(struct cpio_data *cp)
@@ -745,7 +760,7 @@ void reload_ucode_amd(unsigned int cpu)
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
 	if (rev < mc->hdr.patch_id) {
-		if (!__apply_microcode_amd(mc))
+		if (!__apply_microcode_amd(mc, p->size))
 			pr_info_once("reload revision: 0x%08x\n", mc->hdr.patch_id);
 	}
 }
@@ -798,7 +813,7 @@ static enum ucode_state apply_microcode_
 		goto out;
 	}
 
-	if (__apply_microcode_amd(mc_amd)) {
+	if (__apply_microcode_amd(mc_amd, p->size)) {
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 			cpu, mc_amd->hdr.patch_id);
 		return UCODE_ERROR;


