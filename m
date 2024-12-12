Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E131216E29;
	Thu, 12 Dec 2024 15:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016104; cv=none; b=ZuX7gQQHZtpX/t8Jq9t0LNngNRdc9n9HLO+5XNWPzjNejJrZeGhWv/yEq/A9tCMJc4+cW5io6U5TVxRD5fBriPDn9xMw2RQQDN5qPO2lQOjiyl8ZzK7esAZfnnL/eHfLeQJsUiUt91oi5urfiiQxWZYjE1r+AUzoNApyDaT0MZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016104; c=relaxed/simple;
	bh=n6PivKZJM8QSqbZPerQO8s9E1k+8H2H9DBgRBhGxzcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBXAG76YQ122ihAuIxANKi3idJRENJ2kzhCuaEPaLIB/lYkCJYWjOAjtYJtGhu7z1XgnRbfmOx4Wwdah4wKXW8IH8HObLLCdusrIDLU28mLHu+lXy2Tpgwqux4uVkVJs0lIi2mFuzQgs0EdURpryq3weyJ2c2p2x6i+Jr9KOisI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jiu3tDLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jiu3tDLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7095C4CECE;
	Thu, 12 Dec 2024 15:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016104;
	bh=n6PivKZJM8QSqbZPerQO8s9E1k+8H2H9DBgRBhGxzcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jiu3tDLx732bhompztP7Nw25SxtqXHVRzrOkMSbCSnFrgyCbgo8dE4DYT9NQZbIuJ
	 7sszA2HGJ4gd7IMmU/c56mrSvLl+HNKtB1Rg2w+FqmBxqdD3Ihb+71agh5pOQ10A/Y
	 9Bl6EUxepe0zkZb/2eX4G5GC3SrTMslrlqk1WmWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yutang Jiang <jiangyutang@os.amperecomputing.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 134/466] arm64: mm: Fix zone_dma_limit calculation
Date: Thu, 12 Dec 2024 15:55:03 +0100
Message-ID: <20241212144312.099490335@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shi <yang@os.amperecomputing.com>

commit 56a708742a8bf127eb66798bfc9c9516c61f9930 upstream.

Commit ba0fb44aed47 ("dma-mapping: replace zone_dma_bits by
zone_dma_limit") and subsequent patches changed how zone_dma_limit is
calculated to allow a reduced ZONE_DMA even when RAM starts above 4GB.
Commit 122c234ef4e1 ("arm64: mm: keep low RAM dma zone") further fixed
this to ensure ZONE_DMA remains below U32_MAX if RAM starts below 4GB,
especially on platforms that do not have IORT or DT description of the
device DMA ranges. While zone boundaries calculation was fixed by the
latter commit, zone_dma_limit, used to determine the GFP_DMA flag in the
core code, was not updated. This results in excessive use of GFP_DMA and
unnecessary ZONE_DMA allocations on some platforms.

Update zone_dma_limit to match the actual upper bound of ZONE_DMA.

Fixes: ba0fb44aed47 ("dma-mapping: replace zone_dma_bits by zone_dma_limit")
Cc: <stable@vger.kernel.org> # 6.12.x
Reported-by: Yutang Jiang <jiangyutang@os.amperecomputing.com>
Tested-by: Yutang Jiang <jiangyutang@os.amperecomputing.com>
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Link: https://lore.kernel.org/r/20241125171650.77424-1-yang@os.amperecomputing.com
[catalin.marinas@arm.com: some tweaking of the commit log]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/init.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -116,15 +116,6 @@ static void __init arch_reserve_crashker
 
 static phys_addr_t __init max_zone_phys(phys_addr_t zone_limit)
 {
-	/**
-	 * Information we get from firmware (e.g. DT dma-ranges) describe DMA
-	 * bus constraints. Devices using DMA might have their own limitations.
-	 * Some of them rely on DMA zone in low 32-bit memory. Keep low RAM
-	 * DMA zone on platforms that have RAM there.
-	 */
-	if (memblock_start_of_DRAM() < U32_MAX)
-		zone_limit = min(zone_limit, U32_MAX);
-
 	return min(zone_limit, memblock_end_of_DRAM() - 1) + 1;
 }
 
@@ -140,6 +131,14 @@ static void __init zone_sizes_init(void)
 	acpi_zone_dma_limit = acpi_iort_dma_get_max_cpu_address();
 	dt_zone_dma_limit = of_dma_get_max_cpu_address(NULL);
 	zone_dma_limit = min(dt_zone_dma_limit, acpi_zone_dma_limit);
+	/*
+	 * Information we get from firmware (e.g. DT dma-ranges) describe DMA
+	 * bus constraints. Devices using DMA might have their own limitations.
+	 * Some of them rely on DMA zone in low 32-bit memory. Keep low RAM
+	 * DMA zone on platforms that have RAM there.
+	 */
+	if (memblock_start_of_DRAM() < U32_MAX)
+		zone_dma_limit = min(zone_dma_limit, U32_MAX);
 	arm64_dma_phys_limit = max_zone_phys(zone_dma_limit);
 	max_zone_pfns[ZONE_DMA] = PFN_DOWN(arm64_dma_phys_limit);
 #endif


