Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B4D1487CD;
	Thu, 12 Dec 2024 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017335; cv=none; b=n+NNKzgEQyygz3l4+8FEO+5pvj0sFbsaB+yvZ8amqfguW8RwLMv7WXxtVr2MftHrAF4sQVp/Daw1hJQNiuk74i6E17o51WHzn2Pw7jca7yeVGoxD0fuebbJXA4Nx6Tr2IgeYWTFew5PoMscGTwHEC63DR8+K2DgZKG1JJqLdqpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017335; c=relaxed/simple;
	bh=4ONwU1gbgJHH7imbzsUboVMqnlXUo1HWDA6ns5NM2ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=am5+18QhvciI/9BzSlAX0xXJ5OJHsWMnEMrmaS/3IJDpDHAjhPV4+/9dUwYgLiuy01wcBgJgO6ZhW3stNQp3ZBL+x8wMYiIOsv8g6Lsd1UQMplAcVgFLR2KVNOflcGXkTeDcoGplyqk9/AZSJz90/aQ8rCoYQ+OSqbJnioQcdGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXhmFd05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXhmFd05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7129EC4CECE;
	Thu, 12 Dec 2024 15:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017334;
	bh=4ONwU1gbgJHH7imbzsUboVMqnlXUo1HWDA6ns5NM2ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXhmFd05SWkmWpBs5Eoog3MhmL3JM7jLWFps2Ikc9u8HFXoo5GBBa4NfYp3O04JyW
	 L+BjBbmJexixB3Ud/BiO4OWApXlvOCR6JDQnZ5NqzdhVlHAf2PhE/BnEPMlOnJ0j9Y
	 G3yxEwHOXsP4fMJZtYL9NKcoteHNwWKvBP1udXfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 450/466] x86: Fix build regression with CONFIG_KEXEC_JUMP enabled
Date: Thu, 12 Dec 2024 16:00:19 +0100
Message-ID: <20241212144324.640446550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1236f25fc8d12..540443d699e3c 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -13,6 +13,7 @@
 #include <asm/pgtable_types.h>
 #include <asm/nospec-branch.h>
 #include <asm/unwind_hints.h>
+#include <asm/asm-offsets.h>
 
 /*
  * Must be relocatable PIC code callable as a C function, in particular
-- 
2.43.0



