Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCA9385D67;
	Tue, 21 Jul 2026 19:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660839; cv=none; b=oNXF2o/BkspGpy//1zA2hdrnv/cWtYu8+2xVGKtVjoYKC3huTKBno+SQev/Lfbxc1lKh4TFNexHwhTQxKWRrzk444TJ+C1jjTECnKrkw1bgpjKofMMQzyFMwk037UtGsnnlnjiyQWDm/pI/nChWkALLQGZwkHj5uBlp8jNo1gic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660839; c=relaxed/simple;
	bh=LRl9IaMh2KIp1v5GaY6LTwnzQe+BOfTzNinXBZ4MD5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJw7PjhrtqW4CWpJ1MvNPPu/nifu+g0Em5Hylx8Ms4u2vnSkBhoVXTB95NKaOfZGG3gkgTqrnMXXVbdZ1HvnslbGaXYh7lRdz3RPsdih1vMAy20/YyAF0rfLnzG/YKhTY5GolmlPuQeT5YS9VCpsLAJSOWi7AdN5VModzFfpy7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MD2DplDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MD2DplDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CA41F000E9;
	Tue, 21 Jul 2026 19:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660838;
	bh=ZC1aAkG0fgKOKU99bUQ2lDL/OPTfMJE3UDf/c+9gaSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MD2DplDBtnyV2Us059M34AlH5nYI7eZxZYBrnGqhCvFbO6QEwvFrnG/OI+XSypJW7
	 KcKDFPW6HYrEI9AvbuSSfQeRn17UsggPqzjXdhbvobcxNha6oAkvOzZBkzZXaMzfpH
	 yGAxetNJjGPqQkGytN/PSLp0zyKbphljiHnEf7uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1131/2077] arm64: static_call: include asm/insns.h
Date: Tue, 21 Jul 2026 17:13:24 +0200
Message-ID: <20260721152619.495700021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 998d4d789d2d625e1d8c77c1b6c3951e30e81bb0 ]

I came a cross a missing declaration in a randconfig build:

arch/arm64/kernel/static_call.c:16:5: error: call to undeclared function 'aarch64_insn_adrp_get_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
   16 |                   aarch64_insn_adrp_get_offset(le32_to_cpup(tramp + 4)) +
      |                   ^

Include the header that contains this definition explicitly,
rather than relying on it to come indirectly through another
header.

Fixes: 54ac9ff8f119 ("arm64: Use static call trampolines when kCFI is enabled")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/static_call.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/static_call.c b/arch/arm64/kernel/static_call.c
index 8b3a19e108713e..c126edced022f4 100644
--- a/arch/arm64/kernel/static_call.c
+++ b/arch/arm64/kernel/static_call.c
@@ -2,6 +2,7 @@
 #include <linux/static_call.h>
 #include <linux/memory.h>
 #include <asm/text-patching.h>
+#include <asm/insn.h>
 
 void arch_static_call_transform(void *site, void *tramp, void *func, bool tail)
 {
-- 
2.53.0



