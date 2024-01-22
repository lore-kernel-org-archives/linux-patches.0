Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC86876908;
	Tue, 23 Jan 2024 02:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975495; cv=none; b=YvblTE5QGFKzEIukF7VcxYCPUsSHA5yKte7BFmU2Vns/gxjsTfFhSWciC8ACg9qwWIutPJ5eR8UYvLflpWlGBUKdHvhoOCa22yIJ8rgX2xQ0480VNhlk26pqs7ZuGIMY5Wqhjkecye1WJZFdeIoFTjC5UNhSbkm+FBdh7VvpmBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975495; c=relaxed/simple;
	bh=wnqYxSa/fd8p3H2fRM3XhwhB52i9X6OG3qEbwoGPQ2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rmmu3fRJVKmkh0rbXyffpWvDd1Abox9x3si982J4ZABaU2vT+QK8tV358siR9NeWCaE2gQAD1/kd1iXGll855JyLYE5+D4B6bDTSkxO4RpSaaMC0FGP6BNFlOc4Vb+rfuRqX2Z76F1iRuqkg1Vk5GxlwOCO5ScTUkSxTsYGaCyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTqi3iML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTqi3iML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B28C433F1;
	Tue, 23 Jan 2024 02:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975495;
	bh=wnqYxSa/fd8p3H2fRM3XhwhB52i9X6OG3qEbwoGPQ2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTqi3iMLZd6u2vUiKP4847veMqph9vMVGHadLfN8C5zTakaZx6lxse42l6yeMAZbt
	 0MLBEF6cc+n8TFRkh15u+YkvN5VAAQvdPzPizIMutf89yOxecdsN3drEHrKqKot8AA
	 1M+8SHkMmNQ0kmZpNkTfjRACUKM9lisGulh1rFds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 450/583] riscv: Fix module_alloc() that did not reset the linear mapping permissions
Date: Mon, 22 Jan 2024 15:58:21 -0800
Message-ID: <20240122235825.744375953@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 7c651d55fcbd..df4f6fec5d17 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -440,7 +440,8 @@ void *module_alloc(unsigned long size)
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



