Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49278355026;
	Tue, 16 Dec 2025 11:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885919; cv=none; b=X46vHELrYhXQ+ftroDG5d2evePq3K9JPexv18xgjDfVMxNg9MacsqKt+CwoK+rc2EeLphQArujLnXw07NfVvdaFCDCADX/WV9S+gasFxTtCWDdW9+dqbdQDYwu/Ybgz8lwKxQH8fEsvjrsGMy3X4avRVqQ+YSeeqrtr433x/v2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885919; c=relaxed/simple;
	bh=OQKHyNf9xNozWObCkpAiVry8Q/ah3e/zKIZagmx0gYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3PV6409w1Pl7tfMszwVdNkrPw/1Lmc3ykbmzGx3/dmWXZ6gbw61w2dUurPbcMzw+Phk6Zbuv5a72ndAUbPKgWMdXhhfjCB+ofU0N3aDIEfx+en3/AE836I7sNOCknhL1lVbs9kEFVpwfp9qtQRrirdqImufE67uX2c6LAxKLLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7YstinG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7YstinG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591CEC4CEF1;
	Tue, 16 Dec 2025 11:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885918;
	bh=OQKHyNf9xNozWObCkpAiVry8Q/ah3e/zKIZagmx0gYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7YstinG0qqoNPNCCdmv0pVyQMi9/qf8xOqC7xeoMJkomDGzaZJR/DBjX6btgtIYM
	 xLnmh88OytEIMYyu/CmJ1hM7InbcXLnEca/t5hX/8y+4u9H7km7f5NbdAhi4JdOG4b
	 71RFGbE8y14EtTyz3t2ingJ4821ceuUmATjHurQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 250/507] mshv: Fix create memory region overlap check
Date: Tue, 16 Dec 2025 12:11:31 +0100
Message-ID: <20251216111354.550948579@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Das Neves <nunodasneves@linux.microsoft.com>

[ Upstream commit ba9eb9b86d232854e983203dc2fb1ba18e316681 ]

The current check is incorrect; it only checks if the beginning or end
of a region is within an existing region. This doesn't account for
userspace specifying a region that begins before and ends after an
existing region.

Change the logic to a range intersection check against gfns and uaddrs
for each region.

Remove mshv_partition_region_by_uaddr() as it is no longer used.

Fixes: 621191d709b1 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Reported-by: Michael Kelley <mhklinux@outlook.com>
Closes: https://lore.kernel.org/linux-hyperv/SN6PR02MB41575BE0406D3AB22E1D7DB5D4C2A@SN6PR02MB4157.namprd02.prod.outlook.com/
Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_root_main.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index 618cac041441a..baa6a24066348 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -1200,21 +1200,6 @@ mshv_partition_region_by_gfn(struct mshv_partition *partition, u64 gfn)
 	return NULL;
 }
 
-static struct mshv_mem_region *
-mshv_partition_region_by_uaddr(struct mshv_partition *partition, u64 uaddr)
-{
-	struct mshv_mem_region *region;
-
-	hlist_for_each_entry(region, &partition->pt_mem_regions, hnode) {
-		if (uaddr >= region->start_uaddr &&
-		    uaddr < region->start_uaddr +
-			    (region->nr_pages << HV_HYP_PAGE_SHIFT))
-			return region;
-	}
-
-	return NULL;
-}
-
 /*
  * NB: caller checks and makes sure mem->size is page aligned
  * Returns: 0 with regionpp updated on success, or -errno
@@ -1224,15 +1209,21 @@ static int mshv_partition_create_region(struct mshv_partition *partition,
 					struct mshv_mem_region **regionpp,
 					bool is_mmio)
 {
-	struct mshv_mem_region *region;
+	struct mshv_mem_region *region, *rg;
 	u64 nr_pages = HVPFN_DOWN(mem->size);
 
 	/* Reject overlapping regions */
-	if (mshv_partition_region_by_gfn(partition, mem->guest_pfn) ||
-	    mshv_partition_region_by_gfn(partition, mem->guest_pfn + nr_pages - 1) ||
-	    mshv_partition_region_by_uaddr(partition, mem->userspace_addr) ||
-	    mshv_partition_region_by_uaddr(partition, mem->userspace_addr + mem->size - 1))
+	hlist_for_each_entry(rg, &partition->pt_mem_regions, hnode) {
+		u64 rg_size = rg->nr_pages << HV_HYP_PAGE_SHIFT;
+
+		if ((mem->guest_pfn + nr_pages <= rg->start_gfn ||
+		     rg->start_gfn + rg->nr_pages <= mem->guest_pfn) &&
+		    (mem->userspace_addr + mem->size <= rg->start_uaddr ||
+		     rg->start_uaddr + rg_size <= mem->userspace_addr))
+			continue;
+
 		return -EEXIST;
+	}
 
 	region = vzalloc(sizeof(*region) + sizeof(struct page *) * nr_pages);
 	if (!region)
-- 
2.51.0



