Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB05C2123E0;
	Tue, 12 Nov 2024 10:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407461; cv=none; b=nQwI0mxj8v1akl5ztknaWAnrVREQqki8aYCVhcQZwu6esOLLwh/6s9Shz6ynjPS0zdEy/tNUpADHzdZXUBV40pakyyRPQTaU0nrABpHi/YsLO9Y0NGMVhM8IMPrfLsSmChTksvSXiMmAsQKjlXEcdUhipla7EU5RTiXvK8nWegY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407461; c=relaxed/simple;
	bh=ybDFQOZHHGoI4VfvBBd9XKfPMQ3B2IM9NQA4wZHtfY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIZrLeP6clI5IaeOfmLUUtwMvoRXoMFigQccaNhuw9tn9OGAcVxhOK16YgFFkEO6AmLOoq4KsuKquupBmvY16k3Wongm8M6rBqcbNoLvPQwx3DsVb51tNJqjXYNcSfde1OPg9yPpC4d6XBW+pxVCSUjDcpZeI2XPlRfczafDr4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqkxoLBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqkxoLBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017F1C4CECD;
	Tue, 12 Nov 2024 10:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407461;
	bh=ybDFQOZHHGoI4VfvBBd9XKfPMQ3B2IM9NQA4wZHtfY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqkxoLBmIh1pwN/crRsLg7rjv/oxfUZq0D4LwKMV/q9Y8Drr0qs+Ztxf1MZt5OW4V
	 zXyCSA5zz4reNzpAmozDDaQ+wJofGK8Q/WcnuZPnK7H9ig6WWHqoXDkfZYHnMH+dO9
	 LR7sEXozSqM5ih3jP1Am69EUmn7o8glvFjy9sTGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Maslowski <cyrevolt@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 75/98] riscv/purgatory: align riscv_kernel_entry
Date: Tue, 12 Nov 2024 11:21:30 +0100
Message-ID: <20241112101847.113633674@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Maslowski <cyrevolt@googlemail.com>

commit fb197c5d2fd24b9af3d4697d0cf778645846d6d5 upstream.

When alignment handling is delegated to the kernel, everything must be
word-aligned in purgatory, since the trap handler is then set to the
kexec one. Without the alignment, hitting the exception would
ultimately crash. On other occasions, the kernel's handler would take
care of exceptions.
This has been tested on a JH7110 SoC with oreboot and its SBI delegating
unaligned access exceptions and the kernel configured to handle them.

Fixes: 736e30af583fb ("RISC-V: Add purgatory")
Signed-off-by: Daniel Maslowski <cyrevolt@gmail.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240719170437.247457-1-cyrevolt@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/purgatory/entry.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/riscv/purgatory/entry.S
+++ b/arch/riscv/purgatory/entry.S
@@ -11,6 +11,8 @@
 .macro	size, sym:req
 	.size \sym, . - \sym
 .endm
+#include <asm/asm.h>
+#include <linux/linkage.h>
 
 .text
 
@@ -39,6 +41,7 @@ size purgatory_start
 
 .data
 
+.align LGREG
 .globl riscv_kernel_entry
 riscv_kernel_entry:
 	.quad	0


