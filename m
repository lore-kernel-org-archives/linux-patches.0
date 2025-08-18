Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933A1335BA3;
	Mon, 18 Aug 2025 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525151; cv=none; b=a2QNsXT6h6oyvSJiKj+6BclFb1egJQw9B+hULhR5To0SX3FSBV1iXWzOw15+6zCgxpmZWCotkdq+YvjUMhSER+CuHz81kWPLuGiQ1QrGToOt1v1oOD9O3598RLuZAJKfb3lJCtQGnozUgaTduvCQKGIqEKtmVTBryLPlNF5OXtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525151; c=relaxed/simple;
	bh=uKM9rMpQF1IMvPoAI4ergeVP002HV/qVfTHle9UsHno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSl0fASBtD/iGaV33azKeNtlBC+mlFdB4ViRZ4LXZd3zcwaCSCsWryCoGRL5eI5H2Ml3i6y9Mk21k0h3AePm3X2Qyx66f+yXyk2BopkCGBMcNElF2dNJtacLEBTDTqtlcbSgF+hiCKSZ8UbZWaE/g+s5EzGHX8CjmO4hHiPOQMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjxooPO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjxooPO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174F6C4CEEB;
	Mon, 18 Aug 2025 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525151;
	bh=uKM9rMpQF1IMvPoAI4ergeVP002HV/qVfTHle9UsHno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjxooPO1g2g9NhiuJc1mlrZiA9GtsE7REfGm2MuxDUCb8ZEyWPiSXJnMdrVRw4PmT
	 Au/n/b7p2ArvJcZ2d+nF/9GyIwQlShUUF49twBLJ7Z/xS/4r6Y3ivucudbFTCwEar1
	 M3Yv57fovMSLyno5xB66Pl+bNuPLtYKe43nF0elw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 175/570] x86/sev/vc: Fix EFI runtime instruction emulation
Date: Mon, 18 Aug 2025 14:42:42 +0200
Message-ID: <20250818124512.540115635@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

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



