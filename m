Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5132C8C8;
	Mon, 11 Dec 2023 18:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVbXO+B+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68307C433C7;
	Mon, 11 Dec 2023 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320414;
	bh=S4bcVzmGpTEN/Io8H/Vif07bjr3hZM5oe6fczCssxMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVbXO+B+QRSnJ8JykILqlEHa1t6g9ypQrTz8UFqCbL+HZlOYI5T/mCn8DmuhiFD8p
	 RJVMkvA+Mczf17Y44+7/tuDuKUMqBQ9XB7/VZBHKLOOCrFNpYYn0sT/0M5efSVxWwq
	 JOh0sSdSJGUgTMw0zp4957J5oTaaCQL4hE/wCOFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 014/194] x86/tdx: Allow 32-bit emulation by default
Date: Mon, 11 Dec 2023 19:20:04 +0100
Message-ID: <20231211182037.246622303@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

[ upstream commit f4116bfc44621882556bbf70f5284fbf429a5cf6 ]

32-bit emulation was disabled on TDX to prevent a possible attack by
a VMM injecting an interrupt on vector 0x80.

Now that int80_emulation() has a check for external interrupts the
limitation can be lifted.

To distinguish software interrupts from external ones, int80_emulation()
checks the APIC ISR bit relevant to the 0x80 vector. For
software interrupts, this bit will be 0.

On TDX, the VAPIC state (including ISR) is protected and cannot be
manipulated by the VMM. The ISR bit is set by the microcode flow during
the handling of posted interrupts.

[ dhansen: more changelog tweaks ]

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/tdx/tdx.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -830,14 +830,5 @@ void __init tdx_early_init(void)
 	x86_platform.guest.enc_cache_flush_required  = tdx_cache_flush_required;
 	x86_platform.guest.enc_tlb_flush_required    = tdx_tlb_flush_required;
 
-	/*
-	 * The VMM is capable of injecting interrupt 0x80 and triggering the
-	 * compatibility syscall path.
-	 *
-	 * By default, the 32-bit emulation is disabled in order to ensure
-	 * the safety of the VM.
-	 */
-	ia32_disable();
-
 	pr_info("Guest detected\n");
 }


