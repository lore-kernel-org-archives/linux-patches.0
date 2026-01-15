Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573732D6E72;
	Thu, 15 Jan 2026 17:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497753; cv=none; b=f6y32b6nsb4+ICeFUytNtnhLW49UkOOJY+11UJvKhQSYWXXa7d43yWf4CyUU5w32+Nlc2bcQJs+OeUS9N8eDDNtSVyQKG4FtJ1kc6CUgaaFwlXWq0AMvxZKxWJL9GVaLrHhQC18M7bpavJpl+hbm7Im4uZx5L4Dm/b9bTYS0H4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497753; c=relaxed/simple;
	bh=98CVSM4ItNvCDY8ocAuPPYj/iUoSFJkP6g6cG738FJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDGz+wxtFWhV5AWhmBnI4OxeU2XpirSr64XUB6G3yQXI6Kqvco2kieNlbtJaqC/sLmb6viIlFH2rj9ota2UmzT09ipPHwvj7Me5CkMBrA6jf7315qM344zq8QefqEOviTURGeE7aKxMt2obNYLrogDI4nSyDF4v3W/2THMkgvq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKuL9tNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKuL9tNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D8BC116D0;
	Thu, 15 Jan 2026 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497753;
	bh=98CVSM4ItNvCDY8ocAuPPYj/iUoSFJkP6g6cG738FJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKuL9tNtgp+dnZjzGFC98uoaKfDGhVlWBOndRgaXDQGnSSbEtAczyWE4UlH2cflVu
	 kseKRuJS0zFVHF5ZEfkpELD/qou10bRTSlrxTg7PPjg4hqNODKPvd9Mw08hPuo9EeU
	 bwZQyVWQDJtlmgzNMNuFilcY0wn/GwMKL1i0x+rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Liyuan Pang <pangliyuan1@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/554] ARM: 9464/1: fix input-only operand modification in load_unaligned_zeropad()
Date: Thu, 15 Jan 2026 17:44:17 +0100
Message-ID: <20260115164253.172895652@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liyuan Pang <pangliyuan1@huawei.com>

[ Upstream commit edb924a7211c9aa7a4a415e03caee4d875e46b8e ]

In the inline assembly inside load_unaligned_zeropad(), the "addr" is
constrained as input-only operand. The compiler assumes that on exit
from the asm statement these operands contain the same values as they
had before executing the statement, but when kernel page fault happened, the assembly fixup code "bic %2 %2, #0x3" modify the value of "addr", which may lead to an unexpected behavior.

Use a temporary variable "tmp" to handle it, instead of modifying the
input-only operand, just like what arm64's load_unaligned_zeropad()
does.

Fixes: b9a50f74905a ("ARM: 7450/1: dcache: select DCACHE_WORD_ACCESS for little-endian ARMv6+ CPUs")
Co-developed-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Liyuan Pang <pangliyuan1@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/word-at-a-time.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/word-at-a-time.h b/arch/arm/include/asm/word-at-a-time.h
index 352ab213520d2..2e6d0b4349f47 100644
--- a/arch/arm/include/asm/word-at-a-time.h
+++ b/arch/arm/include/asm/word-at-a-time.h
@@ -66,7 +66,7 @@ static inline unsigned long find_zero(unsigned long mask)
  */
 static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
-	unsigned long ret, offset;
+	unsigned long ret, tmp;
 
 	/* Load word from unaligned pointer addr */
 	asm(
@@ -74,9 +74,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 	"2:\n"
 	"	.pushsection .text.fixup,\"ax\"\n"
 	"	.align 2\n"
-	"3:	and	%1, %2, #0x3\n"
-	"	bic	%2, %2, #0x3\n"
-	"	ldr	%0, [%2]\n"
+	"3:	bic	%1, %2, #0x3\n"
+	"	ldr	%0, [%1]\n"
+	"	and	%1, %2, #0x3\n"
 	"	lsl	%1, %1, #0x3\n"
 #ifndef __ARMEB__
 	"	lsr	%0, %0, %1\n"
@@ -89,7 +89,7 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 	"	.align	3\n"
 	"	.long	1b, 3b\n"
 	"	.popsection"
-	: "=&r" (ret), "=&r" (offset)
+	: "=&r" (ret), "=&r" (tmp)
 	: "r" (addr), "Qo" (*(unsigned long *)addr));
 
 	return ret;
-- 
2.51.0



