Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20203A8F4;
	Tue, 23 Jan 2024 00:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969869; cv=none; b=bOYwOmzYucCjN1QiIHZ9M6ByOAVxrEJf7UF3GUtFwR9lkc7nb52pTblZR6uwu5aeiDf1rJ1y8c72riVPgyB79nBl/ldJQDeuy4T9ka64Nd2temSlIYbm+pmGcGJ0Yn/q2dbk2pDEyQhH/ghbllEVPVJc/st/agjWd4ML0/EFjJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969869; c=relaxed/simple;
	bh=jdUZ+wWHC2t4Hl+JrG1E1tW3pVuc//eIN3p/jlHxFsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nReXXN5JVvIsSQ56TjZW5AIwkaKXfow6OhCS6SRc9Jj1npfrhQgNxPgeMQDDElFYJkulMYV79En9Df6YlxeqgsrQBE4u18C2TZ9OWYj8Fpr3Rgea8PBdJIMdyJub2a9f+Lc5hfKVk9HK+nrDWvV/PABTSQMUWP+3o6SSZvSYVgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkoe0zLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkoe0zLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF67C433F1;
	Tue, 23 Jan 2024 00:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969868;
	bh=jdUZ+wWHC2t4Hl+JrG1E1tW3pVuc//eIN3p/jlHxFsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkoe0zLLpPND692z5ZaFxf5Dy2iegnIuAGyiRFtkCmmCs/5ttEBxdcgSiXfi0Ohxt
	 NfIiqao76STIjBappAOTYKOwGkTqSYpoW8sbSephBuAPdJBsNFLtIaYRvd1/OvTPh6
	 H1P+xUWfRivRi0TJszxkxrCHIdkQsD+0H7jrMs4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 496/641] riscv: Fix module_alloc() that did not reset the linear mapping permissions
Date: Mon, 22 Jan 2024 15:56:40 -0800
Message-ID: <20240122235833.588642626@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index aac019ed63b1..862834bb1d64 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -894,7 +894,8 @@ void *module_alloc(unsigned long size)
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



