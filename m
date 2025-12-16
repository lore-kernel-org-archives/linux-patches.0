Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2843845A0;
	Tue, 16 Dec 2025 12:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888607; cv=none; b=suduhBJ/Y8wASrIIgc+bK1lflwFTQUV5HRvdOtVJhhuq+1siQpuMld4/7jFmFci+uEb+ClS+zltSaNlIls/ax+9OQFk9IPy5x+n9LiO0L3pOijrhv/5tlWIrEULW6SwlTN1XalRCmu8pysynN/F+BDck1mdxngE0ImhPAj+v20E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888607; c=relaxed/simple;
	bh=yQ5zfYtOKHbW2jIEOR5Q+wBe2GSEdBHoosEjbt+iVaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJz18VWYKbmEPgiPPoQcq2sL/8pQtc0hX519+/lWCS3uwZJyqyCaq3KM69IGcBv2od2Wtyt6+eyVEe3mtY5IlXnqqRz/svjpcWGuqGA7gu0E5z9VehEBHWC1GrKnzU9+Mdh4moSUCFVysOMxYFpRUsUhgxiO/KSz9em+RMfsAKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGHowH/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGHowH/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6E6C19422;
	Tue, 16 Dec 2025 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888607;
	bh=yQ5zfYtOKHbW2jIEOR5Q+wBe2GSEdBHoosEjbt+iVaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGHowH/+6cRdfEl3O/b8JmzQh6HX4bzPKuN0MFdxvudBNuk7iT0oY+61drcfI6PYw
	 Z6bkXZiD165C5oBsowV1f9X4gUnnakqejyWu/VVXr22RJt+6+erGw+fom97zN2TTam
	 gAbIRrLKjQ5DDST2LXbK7IpGCpXi7iWTkRSq1s40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Liyuan Pang <pangliyuan1@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 584/614] ARM: 9464/1: fix input-only operand modification in load_unaligned_zeropad()
Date: Tue, 16 Dec 2025 12:15:51 +0100
Message-ID: <20251216111422.549149058@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f9a3897b06e7f..5023f98d8293d 100644
--- a/arch/arm/include/asm/word-at-a-time.h
+++ b/arch/arm/include/asm/word-at-a-time.h
@@ -67,7 +67,7 @@ static inline unsigned long find_zero(unsigned long mask)
  */
 static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
-	unsigned long ret, offset;
+	unsigned long ret, tmp;
 
 	/* Load word from unaligned pointer addr */
 	asm(
@@ -75,9 +75,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
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
@@ -90,7 +90,7 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 	"	.align	3\n"
 	"	.long	1b, 3b\n"
 	"	.popsection"
-	: "=&r" (ret), "=&r" (offset)
+	: "=&r" (ret), "=&r" (tmp)
 	: "r" (addr), "Qo" (*(unsigned long *)addr));
 
 	return ret;
-- 
2.51.0



