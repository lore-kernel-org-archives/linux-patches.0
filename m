Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9FF21621F;
	Tue, 12 Nov 2024 10:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407918; cv=none; b=ZmwXCf75O7yNojYr/iXZa518rPPjul97Rs9HqmMbxHad3AU/+1ajK8aiPa+8vZBrkSUKqCjLHdabblsWAiTqC2PR/sVN071OtqJX2Yiut4PsGvpBpa3PY/kHRbh2Puq4yp7C+8LUySkSyxWgsQtl3a//ArvGjGILwRjOtIN48DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407918; c=relaxed/simple;
	bh=HS8fCo+XtpHR7UdpyVjpG5lVFv/IMjauvLAZQaIBpJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3KaBh9p1Yuh4AnaZeoUOhMie6kgOsMFuU9eCSqhRkqGH3vKdHbsuGr8Xbpqm2jYy060OOTd+u9rotX/UKtXaHrNn/uKzXH9P1aTilDwya2Dnx2kiotDyrw/A3f8hF3RN0htWlJB7Q0bC+j3MTiBNZuUXWHHQUwy9mu/QIyei6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTpl+IXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTpl+IXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F20C4CECD;
	Tue, 12 Nov 2024 10:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407918;
	bh=HS8fCo+XtpHR7UdpyVjpG5lVFv/IMjauvLAZQaIBpJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTpl+IXewhWJXACuxAbfr1+c5xzSMGg7TlkSjyo7ldzaya58LO6YRZG4M6J0JJ3Hq
	 XMAd0lUZyfnBLk2Ff+zY8UUcBF3EqpnURY2/5ygkV+PAkJKEuyK+dfgTAQlw9jgpOp
	 ocVLk8TEEzU7bQtxLCdCiEOMYfNYUpl0zCfkWzrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Maslowski <cyrevolt@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.6 098/119] riscv/purgatory: align riscv_kernel_entry
Date: Tue, 12 Nov 2024 11:21:46 +0100
Message-ID: <20241112101852.466536624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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


