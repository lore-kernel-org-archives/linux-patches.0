Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709DA1ABEA1;
	Mon, 14 Oct 2024 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916943; cv=none; b=HX9TDHIKa6VG54uvXnGKqi3I3H0EJTH41oMqwMm5bqvTUsnMr8mAIB7hxIcbfYpeI46e2E1PfApGRCAB1eWZ4cOmSQ6D3IGLhs5H1V+1ny97ZU3sPNqeQxBd7NJPOnXJcif4DO2A1YFFRdiOf1/DiGraMazbCo6Cks5Rn2FIaUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916943; c=relaxed/simple;
	bh=xhFa7tzUfCGjnJeDbl75IRvZqvnv6mEjSy0d/hipSvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GE6xIj5pPcUAh8d7oeK6dncAD3ms2hvQCB/uwGMSw43aZMaPPFA4lSRcWDlynzF8Wp6DVaf/quIhjM52f6lEDU7Z7Osxq9qukQnjtbbbyw5k5op7sXJAXj8UdVYKChoxl/sLq+qrlFs72eR+evFmnEbcg/MuhRVAIv46U1xOGRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1UyjRfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1UyjRfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82503C4CEC3;
	Mon, 14 Oct 2024 14:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916943;
	bh=xhFa7tzUfCGjnJeDbl75IRvZqvnv6mEjSy0d/hipSvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1UyjRfz1kfL6nG9g6BNiEYXgUjGgNhJJuQYl0MJ5R1VBYtyqKaQCpH0Lcs74w0jO
	 hfuux7XmfV+bLb/5+YQS1dJ1RN/i6sAq6wtZeBClcWnxCHI5hwRBY23hwhuuVD9sA4
	 BdmLDIa4btE9MtoUmFtnel53kZPdKZ5oR+K9g7Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/213] RISC-V: Dont have MAX_PHYSMEM_BITS exceed phys_addr_t
Date: Mon, 14 Oct 2024 16:19:43 +0200
Message-ID: <20241014141045.986791150@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit ad380f6a0a5e82e794b45bb2eaec24ed51a56846 ]

I recently ended up with a warning on some compilers along the lines of

      CC      kernel/resource.o
    In file included from include/linux/ioport.h:16,
                     from kernel/resource.c:15:
    kernel/resource.c: In function 'gfr_start':
    include/linux/minmax.h:49:37: error: conversion from 'long long unsigned int' to 'resource_size_t' {aka 'unsigned int'} changes value from '17179869183' to '4294967295' [-Werror=overflow]
       49 |         ({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
          |                                     ^
    include/linux/minmax.h:52:9: note: in expansion of macro '__cmp_once_unique'
       52 |         __cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
          |         ^~~~~~~~~~~~~~~~~
    include/linux/minmax.h:161:27: note: in expansion of macro '__cmp_once'
      161 | #define min_t(type, x, y) __cmp_once(min, type, x, y)
          |                           ^~~~~~~~~~
    kernel/resource.c:1829:23: note: in expansion of macro 'min_t'
     1829 |                 end = min_t(resource_size_t, base->end,
          |                       ^~~~~
    kernel/resource.c: In function 'gfr_continue':
    include/linux/minmax.h:49:37: error: conversion from 'long long unsigned int' to 'resource_size_t' {aka 'unsigned int'} changes value from '17179869183' to '4294967295' [-Werror=overflow]
       49 |         ({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
          |                                     ^
    include/linux/minmax.h:52:9: note: in expansion of macro '__cmp_once_unique'
       52 |         __cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
          |         ^~~~~~~~~~~~~~~~~
    include/linux/minmax.h:161:27: note: in expansion of macro '__cmp_once'
      161 | #define min_t(type, x, y) __cmp_once(min, type, x, y)
          |                           ^~~~~~~~~~
    kernel/resource.c:1847:24: note: in expansion of macro 'min_t'
     1847 |                addr <= min_t(resource_size_t, base->end,
          |                        ^~~~~
    cc1: all warnings being treated as errors

which looks like a real problem: our phys_addr_t is only 32 bits now, so
having 34-bit masks is just going to result in overflows.

Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240731162159.9235-2-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/sparsemem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/sparsemem.h b/arch/riscv/include/asm/sparsemem.h
index 63acaecc33747..2f901a410586d 100644
--- a/arch/riscv/include/asm/sparsemem.h
+++ b/arch/riscv/include/asm/sparsemem.h
@@ -7,7 +7,7 @@
 #ifdef CONFIG_64BIT
 #define MAX_PHYSMEM_BITS	56
 #else
-#define MAX_PHYSMEM_BITS	34
+#define MAX_PHYSMEM_BITS	32
 #endif /* CONFIG_64BIT */
 #define SECTION_SIZE_BITS	27
 #endif /* CONFIG_SPARSEMEM */
-- 
2.43.0



