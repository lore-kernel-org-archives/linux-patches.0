Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821BF1B3927;
	Mon, 10 Mar 2025 17:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627367; cv=none; b=LVdoUDeQWFqvcZU3SPMYAqHqAgB4o33539BSVgoUdmdyWutZ6SnF+A74dllFYqKGpNEuzfpF/yPwbhPx3TLKqlPXXq/zUz2FB5NJw7x9503ysW70rgKxWdjI/WXc38LXYUodvXW33K9ORo/1eWDUasAhngww4ocdbWsA4AXb8nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627367; c=relaxed/simple;
	bh=gRNpEvdXjkAcf/HeEkFQMmQkcwKSZdEXb8AN50Wsj8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rruNpxvdvfSL8/EvrKPzCv0fo1bdPRvFu2brVrdfXNiYVvxP2jCTzYV6OYPcurQPBk3xbdvke/6jjnrsqFDiQQohQonSCmgC9e+tWRwsQPsaVo5LPexmEv5E6N5W/0HcGhLSwM0fEBlu50HlTBSUWFdaTm3uVBM9T33rE0LQ8EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mabeAsZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mabeAsZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1AEC4CEE5;
	Mon, 10 Mar 2025 17:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627367;
	bh=gRNpEvdXjkAcf/HeEkFQMmQkcwKSZdEXb8AN50Wsj8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mabeAsZ0PMtnSnZswN2iabdX/17xg7xOban67vEAm5SOrEOHsNdLc4hJswBc0uVUn
	 NS699+WhT5oXlGq+cfQzVSHTFS7a2HwlGpMcQMa6pjHw+gDKy1N8whCPOD0Buet4zO
	 Wl9qxtTwzZvDkt7Yavwq+0cH9iU9ZTspG9vbvQqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 105/269] x86/boot: Sanitize boot params before parsing command line
Date: Mon, 10 Mar 2025 18:04:18 +0100
Message-ID: <20250310170501.896831257@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/pgtable_64.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "misc.h"
 #include <asm/bootparam.h>
+#include <asm/bootparam_utils.h>
 #include <asm/e820/types.h>
 #include <asm/processor.h>
 #include "pgtable.h"
@@ -107,6 +108,7 @@ asmlinkage void configure_5level_paging(
 	bool l5_required = false;
 
 	/* Initialize boot_params. Required for cmdline_find_option_bool(). */
+	sanitize_boot_params(bp);
 	boot_params_ptr = bp;
 
 	/*


