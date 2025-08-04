Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37AB176FB1;
	Mon,  4 Aug 2025 00:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267187; cv=none; b=PVIbwcivX5uygvYsqV+qZsFfJoFcoLkng5R1D0F3cRbomJfmsKv6skq0bYKBXndWSBVb/x/aq2zzfG0VvmkCD/2i1BTZacGyAJnvTeaHGzZbiNMhV4ZcdKA9KWqi7mnKT41pERm60/wqbU47DBZ5bX7/6FjEEVqxouTxrIznbwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267187; c=relaxed/simple;
	bh=VLCWgXSxW1CI0U+xPeGBgFU0kOcoQdb9I963U2yuwgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jIKpf4jXqo6xV15l+EX2fvGRmXZbCa3x9gyrRpmuUGwJISpgRf2Gy1fl/2XFrZyYNAQIeCydCK7iOIRMyDJKAw+yULsuMC2byxAF+5+J5FFtcjqvum+6RAb24wmBAw/7foE3J/ZP0qc54UjBcawh483Voq3nc7AaLFpU28uPsI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lz45tLsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lz45tLsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A632C4CEEB;
	Mon,  4 Aug 2025 00:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267186;
	bh=VLCWgXSxW1CI0U+xPeGBgFU0kOcoQdb9I963U2yuwgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lz45tLsDvilSJtJMkenMN4rRlA3FHSnbO+YCqKhBhEUCu3+l21hb3lJFzeH6JPBtl
	 wr1M2J8FtdGxtslHxRpyRjL4kiArrV+RZhNg/D3UynW/PCppIf5n6FAx3G0WDKfGGe
	 3IQn/b4C/NnWhkfltqmItLszIVmVBDXFH5zQ4sqSQB63DtSvsTuZvKo+3Mr7aA75Va
	 YGzj1GdnCfmgKMtI1nK36WoGaPHv2j2xvp9O58IXRFWLAiKMAO7CcRcEurOuh4bcam
	 C/aad94ztsApkYikG3C9Z3+m5+ZQSkUWNwZs6CY8TvsIZ2+9cAlHPfQgqHn+GSo+RB
	 givqaGvJqhBBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mingo@kernel.org,
	ardb@kernel.org,
	thomas.lendacky@amd.com,
	darwi@linutronix.de
Subject: [PATCH AUTOSEL 6.16 54/85] x86/sev/vc: Fix EFI runtime instruction emulation
Date: Sun,  3 Aug 2025 20:23:03 -0400
Message-Id: <20250804002335.3613254-54-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Gerd Hoffmann <kraxel@redhat.com>

[ Upstream commit 7b22e0432981c2fa230f1b493082b7e67112c4aa ]

In case efi_mm is active go use the userspace instruction decoder which
supports fetching instructions from active_mm.  This is needed to make
instruction emulation work for EFI runtime code, so it can use CPUID and
RDMSR.

EFI runtime code uses the CPUID instruction to gather information about
the environment it is running in, such as SEV being enabled or not, and
choose (if needed) the SEV code path for ioport access.

EFI runtime code uses the RDMSR instruction to get the location of the
CAA page (see SVSM spec, section 4.2 - "Post Boot").

The big picture behind this is that the kernel needs to be able to
properly handle #VC exceptions that come from EFI runtime services.
Since EFI runtime services have a special page table mapping for the EFI
virtual address space, the efi_mm context must be used when decoding
instructions during #VC handling.

  [ bp: Massage. ]

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Link: https://lore.kernel.org/20250626114014.373748-2-kraxel@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit message and code changes, I can
provide my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real bug affecting users**: The commit fixes instruction
   emulation for EFI runtime services in SEV-enabled systems. Without
   this fix, EFI runtime services cannot properly use CPUID and RDMSR
   instructions, which are essential for:
   - Determining if SEV is enabled
   - Getting the location of the CAA page (per SVSM spec)
   - Choosing the correct code path for I/O port access

2. **Small and contained fix**: The change is minimal - it only modifies
   the `vc_decode_insn()` function in arch/x86/coco/sev/vc-handle.c by
   adding a single condition check: `|| mm_is_efi(current->active_mm)`.
   This additional check ensures that when EFI runtime services are
   active (using efi_mm), the userspace instruction decoder is used
   instead of the kernel decoder.

3. **No architectural changes**: The fix doesn't introduce any new
   features or change the architecture. It simply fixes the existing
   instruction decoding logic to handle the special case of EFI runtime
   services.

4. **Critical for SEV functionality**: Systems with AMD SEV (Secure
   Encrypted Virtualization) enabled need proper #VC exception handling
   for EFI runtime services to function correctly. Without this fix,
   these systems may experience failures when EFI runtime services
   attempt to execute CPUID or RDMSR instructions.

5. **Low regression risk**: The change only affects the code path when
   `mm_is_efi()` returns true, which is a very specific scenario (EFI
   runtime services execution). It doesn't modify the existing behavior
   for normal kernel or userspace instruction decoding.

6. **Clear problem and solution**: The commit message clearly explains
   the issue (EFI runtime services use special page table mappings that
   require the userspace decoder) and the solution is straightforward.

The fix is essential for proper operation of SEV-enabled systems that
rely on EFI runtime services, making it a good candidate for stable
backporting according to stable tree rules.

 arch/x86/coco/sev/vc-handle.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index 0989d98da130..faf1fce89ed4 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 #include <linux/psp-sev.h>
+#include <linux/efi.h>
 #include <uapi/linux/sev-guest.h>
 
 #include <asm/init.h>
@@ -178,9 +179,15 @@ static enum es_result __vc_decode_kern_insn(struct es_em_ctxt *ctxt)
 		return ES_OK;
 }
 
+/*
+ * User instruction decoding is also required for the EFI runtime. Even though
+ * the EFI runtime is running in kernel mode, it uses special EFI virtual
+ * address mappings that require the use of efi_mm to properly address and
+ * decode.
+ */
 static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
 {
-	if (user_mode(ctxt->regs))
+	if (user_mode(ctxt->regs) || mm_is_efi(current->active_mm))
 		return __vc_decode_user_insn(ctxt);
 	else
 		return __vc_decode_kern_insn(ctxt);
-- 
2.39.5

