Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B257117B505;
	Wed,  5 Mar 2025 18:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197893; cv=none; b=uHjhrSBUFZ1bHdhGeTIzBALpZSyHnxjSmzYyoC5rfQmJMnts6TbF6AYuRikpuGiRdZVjM02k6V4sayWkk7jHxzk7iXEUQ408MLt2PifTkGcVaFNV+h7zjl37cyG0pJcDNeIO+RGtiEyuZC+lJR9DFxrUvXhN8soiRTC6/l/PLMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197893; c=relaxed/simple;
	bh=P9nXMTa4L2VuMt7thI6HjYnaS60kh9PNx7BKMj2ITmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8jB6O3v5Ezvco105bsBzoKyjGoPL38hXrm0g8n7ZVwE146uown8Jas48wTO0YDG7p1QcinAwtop9EPKFAyxu4Aby5Ar23iCS/EV8eaUB+0y6U6/RYrmoxo7YXM2ex7dWOVFI+p61tCd5VW/8lYdKzyr4E/F/G2FhqmphA05WB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maxlGyb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maxlGyb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A43C4CED1;
	Wed,  5 Mar 2025 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197893;
	bh=P9nXMTa4L2VuMt7thI6HjYnaS60kh9PNx7BKMj2ITmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maxlGyb+4bgS18xazRr2U1FVlBg0injnjjd2EJGkgEU5Jg8tKWSwM5gLOqCxihEjy
	 LakO+/2PAl8nWUAQMJJOhKUaa37S0oYK/uJ9anrQjy1VmY6HYxxyYvlvPkEYOWNlVu
	 6llZuYhitWO9nEhgGcIjL3pr3uLXOLs6iHHQNM1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.6 135/142] x86/microcode/AMD: Flush patch buffer mapping after application
Date: Wed,  5 Mar 2025 18:49:14 +0100
Message-ID: <20250305174505.756974651@linuxfoundation.org>
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

commit c809b0d0e52d01c30066367b2952c4c4186b1047 upstream

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
 
@@ -485,11 +486,25 @@ static void scan_containers(u8 *ucode, s
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
@@ -531,7 +546,7 @@ static bool early_apply_microcode(u32 ol
 	if (old_rev > mc->hdr.patch_id)
 		return ret;
 
-	return !__apply_microcode_amd(mc);
+	return !__apply_microcode_amd(mc, desc.psize);
 }
 
 static bool get_builtin_microcode(struct cpio_data *cp)
@@ -747,7 +762,7 @@ void reload_ucode_amd(unsigned int cpu)
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
 	if (rev < mc->hdr.patch_id) {
-		if (!__apply_microcode_amd(mc))
+		if (!__apply_microcode_amd(mc, p->size))
 			pr_info_once("reload revision: 0x%08x\n", mc->hdr.patch_id);
 	}
 }
@@ -800,7 +815,7 @@ static enum ucode_state apply_microcode_
 		goto out;
 	}
 
-	if (__apply_microcode_amd(mc_amd)) {
+	if (__apply_microcode_amd(mc_amd, p->size)) {
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 			cpu, mc_amd->hdr.patch_id);
 		return UCODE_ERROR;


