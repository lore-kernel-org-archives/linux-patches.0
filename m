Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD33922060;
	Tue, 23 Jan 2024 01:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974963; cv=none; b=sDNni3qoAsKyGyJpI3zlAqD+QTICSG37TZo0WB0W+53AuQtaMQfwpd/iVdF6TwJKzJpDTNxiaMJzwaFTGGXM/FbYbH/UYP3BqrzL+MHAgutwfuF097ECPfj94w3wYmWPuShkWn9gNmGGSj5MHgbe6j5rVKhaD3xdx2KW1E1o/2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974963; c=relaxed/simple;
	bh=kLB7FB1XPXgI9LuUwLGVHicJ1iTbR5aMotFWOiY0US8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKbJPiggZnWOP9OC9p83f7T49WbLVuXbpEOtGZn0WryCsdkXGlHsrw27fvIolLZ5GLdms4sOrICNYF6YYCvnKYiIO+v/A0ixW6TnQdQwBGSrvfehQabDP8zkWRT0Qx4WDCfJyjcC94kgzSZsMlh6Mlnurx2uo20GTklee3jzG6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBPXq0sT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBPXq0sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73655C433F1;
	Tue, 23 Jan 2024 01:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974963;
	bh=kLB7FB1XPXgI9LuUwLGVHicJ1iTbR5aMotFWOiY0US8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBPXq0sTFvm/mqKmjvxxfFjkfNaVrhPk35c1S9SVy0WwLieAyfp1LrOhu/eeiulLC
	 FerIMaKGl/ntWHLsI1Ndp1fRsqnfIVRAHZXDaad0QGmsco+7CxDQ1Y/JnfY9a9M9XR
	 kL/5jRGi9Jg9zpr5CezX1HYgnPkw2f3a59skyuao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/374] riscv: Fix module_alloc() that did not reset the linear mapping permissions
Date: Mon, 22 Jan 2024 15:59:14 -0800
Message-ID: <20240122235755.152313531@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 749b94b08005929bbc636df21a23322733166e35 ]

After unloading a module, we must reset the linear mapping permissions,
see the example below:

Before unloading a module:

0xffffaf809d65d000-0xffffaf809d6dc000    0x000000011d65d000       508K PTE .   ..     ..   D A G . . W R V
0xffffaf809d6dc000-0xffffaf809d6dd000    0x000000011d6dc000         4K PTE .   ..     ..   D A G . . . R V
0xffffaf809d6dd000-0xffffaf809d6e1000    0x000000011d6dd000        16K PTE .   ..     ..   D A G . . W R V
0xffffaf809d6e1000-0xffffaf809d6e7000    0x000000011d6e1000        24K PTE .   ..     ..   D A G . X . R V

After unloading a module:

0xffffaf809d65d000-0xffffaf809d6e1000    0x000000011d65d000       528K PTE .   ..     ..   D A G . . W R V
0xffffaf809d6e1000-0xffffaf809d6e7000    0x000000011d6e1000        24K PTE .   ..     ..   D A G . X W R V

The last mapping is not reset and we end up with WX mappings in the linear
mapping.

So add VM_FLUSH_RESET_PERMS to our module_alloc() definition.

Fixes: 0cff8bff7af8 ("riscv: avoid the PIC offset of static percpu data in module beyond 2G limits")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20231213134027.155327-2-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/module.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 4a48287513c3..24c3883c80d0 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -423,7 +423,8 @@ void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR,
 				    MODULES_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
+				    PAGE_KERNEL, VM_FLUSH_RESET_PERMS,
+				    NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 #endif
-- 
2.43.0



