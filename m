Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E318937312B;
	Sat, 28 Feb 2026 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301504; cv=none; b=E/l5EZMiobX2SymUYumUObSry6BTd7T43UQPHUM2Zg+z4sTh0k18sY+4MtrBWI/bW7FK31QqcDIq0fUye2Pg8Ztv+r9J+BhC1nL6AhZ7H0JOFoFV+M/md2vjNnddwtSHJ03VqGbuBuMoQiaNw0gIxY72SlO0lmIjvyGU8sRBnXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301504; c=relaxed/simple;
	bh=+QmB+On8mef2rFA1QxU+2uPtpps85pIbmRUMtawkgk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBr/G7vOIjp9zd4yriPAoCx/t5vFZDM0F02ZLUkOIuzA8ohAUC6V9xJ3mqEd71uA+Txq8G1Vlu65mG7D4IP+hOLKxAUPyITIZ1Pr9mjGa/6pl/UirKFQZuWOaI8Ogt2qP11UJ0jCDd+8WMi+EVHr8GViXttH2O8kVBmnMz9rv9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTi4GZmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTi4GZmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5346BC19424;
	Sat, 28 Feb 2026 17:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301503;
	bh=+QmB+On8mef2rFA1QxU+2uPtpps85pIbmRUMtawkgk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTi4GZmZgC2udkTIYAkZpVgD6Z1sb2OgaQmir1uKhviKfgZj9W90l0YEFVJtDp4pT
	 qBSGlEQaAMzdJ5iNd4aF6tY1bNA26HDsrlY0GAqv4LjRvXqi1mXrmcI4ZTk2t8BLSH
	 wxy+mXPj2/WNzVPb9RR8KWLYpvy9YVZPa79YCJaXf3iyKn0sa1+LP0+htoFRcWRjX1
	 K7z91NIOo0ZxCSmxmEku+LurCsOQkx7AyufKHSCg5mwcXpMUPcYPJTVhMKemfCF+RW
	 AM3+gZZaG7TVzGj2zefxkSUDKzyfU3UelBauokgHjb629t3e1i+auMqb/PoYqWHylL
	 C606ZJMy6HDyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Huacai Chen <chenhuacai@loongson.cn>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 688/752] LoongArch: Prefer top-down allocation after arch_mem_init()
Date: Sat, 28 Feb 2026 12:46:39 -0500
Message-ID: <20260228174750.1542406-688-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 2172d6ebac9372eb01fe4505a53e18cb061e103b ]

Currently we use bottom-up allocation after sparse_init(), the reason is
sparse_init() need a lot of memory, and bottom-up allocation may exhaust
precious low memory (below 4GB). On the other hand, SWIOTLB and CMA need
low memories for DMA32, so swiotlb_init() and dma_contiguous_reserve()
need bottom-up allocation.

Since swiotlb_init() and dma_contiguous_reserve() are both called in
arch_mem_init(), we no longer need bottom-up allocation after that. So
we set the allocation policy to top-down at the end of arch_mem_init(),
in order to avoid later memory allocations (such as KASAN) exhaust low
memory.

This solve at least two problems:
1. Some buggy BIOSes use 0xfd000000~0xfe000000 for secondary CPUs, but
   didn't reserve this range, which causes smpboot failures.
2. Some DMA32 devices, such as Loongson-DRM and OHCI, cannot work with
   KASAN enabled.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 20cb6f3064568..2b260d15b2e25 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -421,6 +421,7 @@ static void __init arch_mem_init(char **cmdline_p)
 				   PFN_UP(__pa_symbol(&__nosave_end)));
 
 	memblock_dump_all();
+	memblock_set_bottom_up(false);
 
 	early_memtest(PFN_PHYS(ARCH_PFN_OFFSET), PFN_PHYS(max_low_pfn));
 }
-- 
2.51.0

