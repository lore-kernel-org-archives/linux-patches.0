Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663D3538F
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB0BC433C9;
	Mon, 19 Jun 2023 10:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171376;
	bh=X77fEewRRbsc242A1IvEOhtkWHLN2cEUzLtxn19E3S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkhQv2ivVZbz9nmknTviHUrTAjPfLFQUHUgrPIzqfyTJMLC4LHnMCsCM50l9Yl1Wf
	 WpckGwPpcr03ACwqkST+uDCVZfseJvMageDmFv2DGzFc+RAIhtqfBK1HSdBbfL3vw2
	 FV7ZHJjnk+0e4wKwFDy51H3rfuFv3dZ+KpAggujE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/166] x86/head/64: Switch to KERNEL_CS as soon as new GDT is installed
Date: Mon, 19 Jun 2023 12:27:58 +0200
Message-ID: <20230619102154.662888016@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit a37f2699c36a7f6606ba3300f243227856c5ad6b ]

The call to startup_64_setup_env() will install a new GDT but does not
actually switch to using the KERNEL_CS entry until returning from the
function call.

Commit bcce82908333 ("x86/sev: Detect/setup SEV/SME features earlier in
boot") moved the call to sme_enable() earlier in the boot process and in
between the call to startup_64_setup_env() and the switch to KERNEL_CS.
An SEV-ES or an SEV-SNP guest will trigger #VC exceptions during the call
to sme_enable() and if the CS pushed on the stack as part of the exception
and used by IRETQ is not mapped by the new GDT, then problems occur.
Today, the current CS when entering startup_64 is the kernel CS value
because it was set up by the decompressor code, so no issue is seen.

However, a recent patchset that looked to avoid using the legacy
decompressor during an EFI boot exposed this bug. At entry to startup_64,
the CS value is that of EFI and is not mapped in the new kernel GDT. So
when a #VC exception occurs, the CS value used by IRETQ is not valid and
the guest boot crashes.

Fix this issue by moving the block that switches to the KERNEL_CS value to
be done immediately after returning from startup_64_setup_env().

Fixes: bcce82908333 ("x86/sev: Detect/setup SEV/SME features earlier in boot")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/all/6ff1f28af2829cc9aea357ebee285825f90a431f.1684340801.git.thomas.lendacky%40amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/head_64.S | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index d860d437631b6..998cdb112b725 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -85,6 +85,15 @@ SYM_CODE_START_NOALIGN(startup_64)
 	call	startup_64_setup_env
 	popq	%rsi
 
+	/* Now switch to __KERNEL_CS so IRET works reliably */
+	pushq	$__KERNEL_CS
+	leaq	.Lon_kernel_cs(%rip), %rax
+	pushq	%rax
+	lretq
+
+.Lon_kernel_cs:
+	UNWIND_HINT_EMPTY
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	/*
 	 * Activate SEV/SME memory encryption if supported/enabled. This needs to
@@ -98,15 +107,6 @@ SYM_CODE_START_NOALIGN(startup_64)
 	popq	%rsi
 #endif
 
-	/* Now switch to __KERNEL_CS so IRET works reliably */
-	pushq	$__KERNEL_CS
-	leaq	.Lon_kernel_cs(%rip), %rax
-	pushq	%rax
-	lretq
-
-.Lon_kernel_cs:
-	UNWIND_HINT_EMPTY
-
 	/* Sanitize CPU configuration */
 	call verify_cpu
 
-- 
2.39.2



