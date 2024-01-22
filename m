Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFD574E23;
	Tue, 23 Jan 2024 02:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975493; cv=none; b=KEEgpMJGBF/x4Ll/Neld/oDNGGrfksgwseM0lz2awNf3yzCOtvjWIdfGzoCByfOW1vP4rUE5JndZCuXTJyeJFzCu7R27nn17RBNTQi8eYSeiCfF9/lXysEBi7uCiL2mIPv7vyqfNa+YWs9fD6/s3M33bz21mPqhrcnW7iDPiEzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975493; c=relaxed/simple;
	bh=YBecJcT5+QZAhMxJsXVkv4Exvc1uBwTRmgc2dNoLLDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOxBLdNunpuBRhV0Q/JPk0vVCuCjWVbauqaHeegtl5bw663xxzWlo0xh5k7zi0o+HS6nn6AEmzY7BAmpYC4NzTT1SdZUvrkDDHYNCDvcp+UBYgubH7GuqKpuXOw/UzCpGZ0U8DfyM1Jk3I6mPmxfC99Fp4mseq0610Gr2a6pySY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2k3cnbXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2k3cnbXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0401C433F1;
	Tue, 23 Jan 2024 02:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975493;
	bh=YBecJcT5+QZAhMxJsXVkv4Exvc1uBwTRmgc2dNoLLDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2k3cnbXBetx4CciXZY7p3HZEJGJXHpLmnb2OxZFvCGXSEt+g1Rta7M8d35qeA3OhU
	 qbGVr4J6kojr/8Bj67XCSV/k8KzKDvHDqgafN/R4vREWVW1N2LdFk31TiZd1bQ3+V5
	 wdCeRl3mohynN0Sfr2XtO01bKhURQEx1F7Edbvtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 447/583] mips: Fix incorrect max_low_pfn adjustment
Date: Mon, 22 Jan 2024 15:58:18 -0800
Message-ID: <20240122235825.657109406@linuxfoundation.org>
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

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit 0f5cc249ff73552d3bd864e62f85841dafaa107d ]

max_low_pfn variable is incorrectly adjusted if the kernel is built with
high memory support and the later is detected in a running system, so the
memory which actually can be directly mapped is getting into the highmem
zone. See the ZONE_NORMAL range on my MIPS32r5 system:

> Zone ranges:
>   DMA      [mem 0x0000000000000000-0x0000000000ffffff]
>   Normal   [mem 0x0000000001000000-0x0000000007ffffff]
>   HighMem  [mem 0x0000000008000000-0x000000020fffffff]

while the zones are supposed to look as follows:

> Zone ranges:
>   DMA      [mem 0x0000000000000000-0x0000000000ffffff]
>   Normal   [mem 0x0000000001000000-0x000000001fffffff]
>   HighMem  [mem 0x0000000020000000-0x000000020fffffff]

Even though the physical memory within the range [0x08000000;0x20000000]
belongs to MMIO on our system, we don't really want it to be considered as
high memory since on MIPS32 that range still can be directly mapped.

Note there might be other problems caused by the max_low_pfn variable
misconfiguration. For instance high_memory variable is initialize with
virtual address corresponding to the max_low_pfn PFN, and by design it
must define the upper bound on direct map memory, then end of the normal
zone. That in its turn potentially may cause problems in accessing the
memory by means of the /dev/mem and /dev/kmem devices.

Let's fix the discovered misconfiguration then. It turns out the commit
a94e4f24ec83 ("MIPS: init: Drop boot_mem_map") didn't introduce the
max_low_pfn adjustment quite correct. If the kernel is built with high
memory support and the system is equipped with high memory, the
max_low_pfn variable will need to be initialized with PFN of the most
upper directly reachable memory address so the zone normal would be
correctly setup. On MIPS that PFN corresponds to PFN_DOWN(HIGHMEM_START).
If the system is built with no high memory support and one is detected in
the running system, we'll just need to adjust the max_pfn variable to
discard the found high memory from the system and leave the max_low_pfn as
is, since the later will be less than PFN_DOWN(HIGHMEM_START) anyway by
design of the for_each_memblock() loop performed a bit early in the
bootmem_init() method.

Fixes: a94e4f24ec83 ("MIPS: init: Drop boot_mem_map")
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index cb871eb784a7..f88a2f83c5ea 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -326,11 +326,11 @@ static void __init bootmem_init(void)
 		panic("Incorrect memory mapping !!!");
 
 	if (max_pfn > PFN_DOWN(HIGHMEM_START)) {
+		max_low_pfn = PFN_DOWN(HIGHMEM_START);
 #ifdef CONFIG_HIGHMEM
-		highstart_pfn = PFN_DOWN(HIGHMEM_START);
+		highstart_pfn = max_low_pfn;
 		highend_pfn = max_pfn;
 #else
-		max_low_pfn = PFN_DOWN(HIGHMEM_START);
 		max_pfn = max_low_pfn;
 #endif
 	}
-- 
2.43.0



