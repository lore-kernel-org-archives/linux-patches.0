Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06651A3174;
	Wed,  5 Mar 2025 18:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197890; cv=none; b=P+e3eSzgGY4TWuwccRwDPRQTSEYJIoVe2bbJNNTo69p9HekOH07M8QjfAfbNc0GMu9SGidpF7ixGxCyb6kqhTWPPkdJ89iFjPnSjq8Uc20CpIa0WlYE7Mu74PurgMVJ9k9KALtw63ga0CSE2mnpZo28+yGjriJyXdbM1/08ADiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197890; c=relaxed/simple;
	bh=dA/i9TWil9kfAL0dE0S4kNr4KNm+nKydOEp1w7Byhx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/KnRq51R4Ql9yItsYB+wKWvA3ByFZOSzHSf3bksgxJaRTwsMG5xIm9ow+FvrtOjSOTAsnEh2n6mEIP0DUsY/7E7ueVWeC1SMcmX8NFPsGeWdtKFMWlCsyC8AV8XT3zqz84tLbcVMJ8QTQVm8Cx1D0KqrIUxavhGnIr4QcfDBx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRPOAJs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRPOAJs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59468C4CED1;
	Wed,  5 Mar 2025 18:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197890;
	bh=dA/i9TWil9kfAL0dE0S4kNr4KNm+nKydOEp1w7Byhx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRPOAJs1Ob+S3UTuOHOeKUYN0leLzgwptIckQqsYG0D968Np3pL+Wo7NgV31ZKKyc
	 KdEi/XyaQVCc/nLqIFcfc5b505vyfhYWnf8kng1bLabhMpF13Emjr3VSlAkNY4WRcw
	 UZV5ApMgjNQb4ThsikpJ/ygftJXFX1YfLZuq0NYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Hua Wu <yanhua1.wu@intel.com>,
	William Xie <william.xie@intel.com>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ashok Raj <ashok.raj@intel.com>
Subject: [PATCH 6.6 134/142] x86/microcode/intel: Remove unnecessary cache writeback and invalidation
Date: Wed,  5 Mar 2025 18:49:13 +0100
Message-ID: <20250305174505.717620782@linuxfoundation.org>
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

From: "Chang S. Bae" <chang.seok.bae@intel.com>

commit 9a819753b0209c6edebdea447a1aa53e8c697653 upstream

Currently, an unconditional cache flush is performed during every
microcode update. Although the original changelog did not mention
a specific erratum, this measure was primarily intended to address
a specific microcode bug, the load of which has already been blocked by
is_blacklisted(). Therefore, this cache flush is no longer necessary.

Additionally, the side effects of doing this have been overlooked. It
increases CPU rendezvous time during late loading, where the cache flush
takes between 1x to 3.5x longer than the actual microcode update.

Remove native_wbinvd() and update the erratum name to align with the
latest errata documentation, document ID 334163 Version 022US.

  [ bp: Zap the flaky documentation URL. ]

Fixes: 91df9fdf5149 ("x86/microcode/intel: Writeback and invalidate caches before updating microcode")
Reported-by: Yan Hua Wu <yanhua1.wu@intel.com>
Reported-by: William Xie <william.xie@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Ashok Raj <ashok.raj@intel.com>
Tested-by: Yan Hua Wu <yanhua1.wu@intel.com>
Link: https://lore.kernel.org/r/20241001161042.465584-2-chang.seok.bae@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/intel.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -319,12 +319,6 @@ static enum ucode_state __apply_microcod
 		return UCODE_OK;
 	}
 
-	/*
-	 * Writeback and invalidate caches before updating microcode to avoid
-	 * internal issues depending on what the microcode is updating.
-	 */
-	native_wbinvd();
-
 	/* write microcode via MSR 0x79 */
 	native_wrmsrl(MSR_IA32_UCODE_WRITE, (unsigned long)mc->bits);
 
@@ -551,7 +545,7 @@ static bool is_blacklisted(unsigned int
 	/*
 	 * Late loading on model 79 with microcode revision less than 0x0b000021
 	 * and LLC size per core bigger than 2.5MB may result in a system hang.
-	 * This behavior is documented in item BDF90, #334165 (Intel Xeon
+	 * This behavior is documented in item BDX90, #334165 (Intel Xeon
 	 * Processor E7-8800/4800 v4 Product Family).
 	 */
 	if (c->x86 == 6 &&
@@ -559,7 +553,7 @@ static bool is_blacklisted(unsigned int
 	    c->x86_stepping == 0x01 &&
 	    llc_size_per_core > 2621440 &&
 	    c->microcode < 0x0b000021) {
-		pr_err_once("Erratum BDF90: late loading with revision < 0x0b000021 (0x%x) disabled.\n", c->microcode);
+		pr_err_once("Erratum BDX90: late loading with revision < 0x0b000021 (0x%x) disabled.\n", c->microcode);
 		pr_err_once("Please consider either early loading through initrd/built-in or a potential BIOS update.\n");
 		return true;
 	}


