Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEDF6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1367AC433EF;
	Mon, 16 Jan 2023 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673889242;
	bh=kCnWFqIJsJsLVNUsATSvvvUu5AIaJy/0EUf4PgVt0UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQOzz3pGoVEGzhvvToxiG0qZNtlDngZyItoYhrtcy+HQLg1iKIjxGlYEbj+xLdMjd
	 KVMbfhAkTLRQsUwGtHofslCA2XXJr9GL6dxm6ZfKaahSK8+k0cz0jTZrKFsGqyueKI
	 sp4GlTOtzdALERL3XqbeJ7hdtwgJ2O8P9xCPRJAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashok Raj <ashok.raj@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 282/338] x86/microcode/intel: Do not retry microcode reloading on the APs
Date: Mon, 16 Jan 2023 16:52:35 +0100
Message-Id: <20230116154833.379983219@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ashok Raj <ashok.raj@intel.com>

commit be1b670f61443aa5d0d01782e9b8ea0ee825d018 upstream.

The retries in load_ucode_intel_ap() were in place to support systems
with mixed steppings. Mixed steppings are no longer supported and there is
only one microcode image at a time. Any retries will simply reattempt to
apply the same image over and over without making progress.

  [ bp: Zap the circumstantial reasoning from the commit message. ]

Fixes: 06b8534cb728 ("x86/microcode: Rework microcode loading")
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221129210832.107850-3-ashok.raj@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/intel.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -662,7 +662,6 @@ void load_ucode_intel_ap(void)
 	else
 		iup = &intel_ucode_patch;
 
-reget:
 	if (!*iup) {
 		patch = __load_ucode_intel(&uci);
 		if (!patch)
@@ -673,12 +672,7 @@ reget:
 
 	uci.mc = *iup;
 
-	if (apply_microcode_early(&uci, true)) {
-		/* Mixed-silicon system? Try to refetch the proper patch: */
-		*iup = NULL;
-
-		goto reget;
-	}
+	apply_microcode_early(&uci, true);
 }
 
 static struct microcode_intel *find_patch(struct ucode_cpu_info *uci)


