Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A155218DB24;
	Mon, 10 Mar 2025 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628256; cv=none; b=otpyURuQFGsIgnJEFlaJE3In4YoenDlPx03CnuOH0CQtTCZEEF50ecknJY1ZBSYkUNDKaUKyLbY3qVkHuSgOaUyuK79suNq7jPQCz9qO0ZtnlxpiV1RiBtfH4aP8Jz7QDVbL/SpSGj5u51MLV3Tb8qMr3xF3XYMpKX2kl4PIMJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628256; c=relaxed/simple;
	bh=uWZPosHr+nN+nkhrubCA0fAyRyg5E5KIupXUdORVhyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvIrNA9h8Cw7g8nhmLV0dFvuHrDKlDs/dZu2le1dthTpZZe0eaacB+hUIwPfi4DIeiPFkvYfdOwKEaZMU8/fjGlW5jEKkVY6WFM/fATpf9hxFjrVyCDR6E1KyV+Zkj/Ypt7H9qbxsR7j1Phonua/kzEWwnf2J/+W/r/cRyLYlsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKAwTxZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKAwTxZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28685C4CEE5;
	Mon, 10 Mar 2025 17:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628256;
	bh=uWZPosHr+nN+nkhrubCA0fAyRyg5E5KIupXUdORVhyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKAwTxZht6+ySY5zX7hf9F4fUcfn3f0xDdpvl47mO0fFPwt/DJzI3TKpQaTkah47f
	 WnQfsL0wrc6bnTt9GX4D9vF9LAjyJK8S9/YNOZuF1KGND8flaCp7Yjoi7DB4eMEEKY
	 8Y7Vr6sFbbfJB49iHDfbdN/x34KVcFLsVRvBFv20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 142/145] x86/boot: Sanitize boot params before parsing command line
Date: Mon, 10 Mar 2025 18:07:16 +0100
Message-ID: <20250310170440.488777898@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit c00b413a96261faef4ce22329153c6abd4acef25 upstream.

The 5-level paging code parses the command line to look for the 'no5lvl'
string, and does so very early, before sanitize_boot_params() has been
called and has been given the opportunity to wipe bogus data from the
fields in boot_params that are not covered by struct setup_header, and
are therefore supposed to be initialized to zero by the bootloader.

This triggers an early boot crash when using syslinux-efi to boot a
recent kernel built with CONFIG_X86_5LEVEL=y and CONFIG_EFI_STUB=n, as
the 0xff padding that now fills the unused PE/COFF header is copied into
boot_params by the bootloader, and interpreted as the top half of the
command line pointer.

Fix this by sanitizing the boot_params before use. Note that there is no
harm in calling this more than once; subsequent invocations are able to
spot that the boot_params have already been cleaned up.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org> # v6.1+
Link: https://lore.kernel.org/r/20250306155915.342465-2-ardb+git@google.com
Closes: https://lore.kernel.org/all/202503041549.35913.ulrich.gemkow@ikr.uni-stuttgart.de
[ardb: resolve conflict]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/pgtable_64.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "misc.h"
+#include <asm/bootparam_utils.h>
 #include <asm/e820/types.h>
 #include <asm/processor.h>
 #include "pgtable.h"
@@ -106,6 +107,7 @@ asmlinkage void configure_5level_paging(
 	bool l5_required = false;
 
 	/* Initialize boot_params. Required for cmdline_find_option_bool(). */
+	sanitize_boot_params(bp);
 	boot_params_ptr = bp;
 
 	/*


