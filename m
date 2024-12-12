Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510CF2210FB;
	Thu, 12 Dec 2024 15:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018591; cv=none; b=f1DzwoH7AcHRSbulfQ2HxouILEK+PmcDKlsDpSl3dvCk9fwGqUOKHWgn8Kk8f/Xr3mlcVqepKA2sTouy2eBsEASmM1a0VYeXGUYKXcmChz0QcVpfvogcqIbxnxo6rb+cCCjCadCIDqC2Va75y21f2hp32sdhbTycbcpPtx7j060=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018591; c=relaxed/simple;
	bh=cO18gw1aq1zbiSuySH1B2pnx1dnyLnNrPHkrveZjgpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwfZy3TEaJfH5R3d4XR8ytNL6TwjnS2bl6fnAKBqdkSJ7CNGzJqKWatD+6/q4p2h/q2FmmmotwRz58a9BS+olWpD6RMWiT1vsddhk8G9FnfamTAfsHOgoq3AV8TYCFllQ+RLyYA2Vn45o7VIEeHju0rewLG/9xAIeW4dQFkTF14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2TiJPFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2TiJPFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9693DC4AF09;
	Thu, 12 Dec 2024 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018591;
	bh=cO18gw1aq1zbiSuySH1B2pnx1dnyLnNrPHkrveZjgpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2TiJPFuOCUd5YGpjUA/+G3fzDKgxzUa4n/7cYkveDu0CPzf0YplBosA8iseO+8fE
	 DBp/i7K0QV0xzyFSOd2RQJxHuLhb+s13wOlbYlViRg88uDGxbl2mHi3mzisW5tMUSu
	 rgaH9d/Mp5nH5ARwpenbDkr2uP4/A7Uspsrl3fr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 335/356] x86: Fix build regression with CONFIG_KEXEC_JUMP enabled
Date: Thu, 12 Dec 2024 16:00:54 +0100
Message-ID: <20241212144257.793458259@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit aeb68937614f4aeceaaa762bd7f0212ce842b797 ]

Build 6.13-rc12 for x86_64 with gcc 14.2.1 fails with the error:

  ld: vmlinux.o: in function `virtual_mapped':
  linux/arch/x86/kernel/relocate_kernel_64.S:249:(.text+0x5915b): undefined reference to `saved_context_gdt_desc'

when CONFIG_KEXEC_JUMP is enabled.

This was introduced by commit 07fa619f2a40 ("x86/kexec: Restore GDT on
return from ::preserve_context kexec") which introduced a use of
saved_context_gdt_desc without a declaration for it.

Fix that by including asm/asm-offsets.h where saved_context_gdt_desc
is defined (indirectly in include/generated/asm-offsets.h which
asm/asm-offsets.h includes).

Fixes: 07fa619f2a40 ("x86/kexec: Restore GDT on return from ::preserve_context kexec")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: David Woodhouse <dwmw@amazon.co.uk>
Closes: https://lore.kernel.org/oe-kbuild-all/202411270006.ZyyzpYf8-lkp@intel.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/relocate_kernel_64.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 569d5577059db..fb00a9e8b0879 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -11,6 +11,7 @@
 #include <asm/pgtable_types.h>
 #include <asm/nospec-branch.h>
 #include <asm/unwind_hints.h>
+#include <asm/asm-offsets.h>
 
 /*
  * Must be relocatable PIC code callable as a C function, in particular
-- 
2.43.0



