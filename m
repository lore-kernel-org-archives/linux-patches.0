Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C3415B0FE;
	Tue,  2 Jul 2024 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940275; cv=none; b=oFa+Q03nlvu7y6HL2ZwowCva9UotAZXcyShbwzyCA3zeR3j51wx8DWSuFSsih2O5FK+P5vGo1jSCqibpcwE5BucQazZuof0eeC6bcr8c9MStK1vBgIUU/ZZtrFensV+cfqUHaAtMIlNcXmJSb0mX6MHglWjWxrPtLGOXF9du3ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940275; c=relaxed/simple;
	bh=itq0g4U1hWBp73gY0yYyk4b6J9k74R2jXiC+I6dGz7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4mSuzhIrJKPUCAzoGAUsuOykwMDaPw0jIK/6A2sbByNK+g1lbUx2fa9nqsB4tdBkoPXdxJ12s7pk6d/YF+IgfFFGtO8vKanbdFm44Q3KhM471EdeGn3LegeoASnensOcgWf8cluUcTNQKc03HUBTDbw7gCCBrw1JzJfYIO/ZdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Guv3Om2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Guv3Om2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41425C116B1;
	Tue,  2 Jul 2024 17:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940275;
	bh=itq0g4U1hWBp73gY0yYyk4b6J9k74R2jXiC+I6dGz7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Guv3Om2g6M1mcnEzGdMX4TSbkY1PlnSzl8PsnDWMZmRiI+YNhMNCHr32VeyZqHvTN
	 +yQbClG0rp8XA9s+VvdFWhR4CtVivk6JMTmQhhZim8qxV6/H3JEBnoPJ3RcMF3kPpe
	 IrJQIJF+sP3GW8r9zYu46QWxj7iS2zLJXluDGVmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FahHean Lee <fahhean.lee@amd.com>,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Sairaj Arun Kodilkar <sairaj.arunkodilkar@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 105/222] iommu/amd: Invalidate cache before removing device from domain list
Date: Tue,  2 Jul 2024 19:02:23 +0200
Message-ID: <20240702170247.980874528@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit c362f32a59a84fe4453abecc6b53f5f70894a6d5 ]

Commit 87a6f1f22c97 ("iommu/amd: Introduce per-device domain ID to fix
potential TLB aliasing issue") introduced per device domain ID when
domain is configured with v2 page table. And in invalidation path, it
uses per device structure (dev_data->gcr3_info.domid) to get the domain ID.

In detach_device() path, current code tries to invalidate IOMMU cache
after removing dev_data from domain device list. This means when domain
is configured with v2 page table, amd_iommu_domain_flush_all() will not be
able to invalidate cache as device is already removed from domain device
list.

This is causing change domain tests (changing domain type from identity to DMA)
to fail with IO_PAGE_FAULT issue.

Hence invalidate cache and update DTE before updating data structures.

Reported-by: FahHean Lee <fahhean.lee@amd.com>
Reported-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Fixes: 87a6f1f22c97 ("iommu/amd: Introduce per-device domain ID to fix potential TLB aliasing issue")
Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Tested-by: Sairaj Arun Kodilkar <sairaj.arunkodilkar@amd.com>
Tested-by: FahHean Lee <fahhean.lee@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20240620060552.13984-1-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index d19a12a158085..e2b900ffbc158 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2061,6 +2061,12 @@ static void do_detach(struct iommu_dev_data *dev_data)
 	struct protection_domain *domain = dev_data->domain;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
 
+	/* Clear DTE and flush the entry */
+	amd_iommu_dev_update_dte(dev_data, false);
+
+	/* Flush IOTLB and wait for the flushes to finish */
+	amd_iommu_domain_flush_all(domain);
+
 	/* Clear GCR3 table */
 	if (domain->pd_mode == PD_MODE_V2) {
 		update_gcr3(dev_data, 0, 0, false);
@@ -2071,12 +2077,6 @@ static void do_detach(struct iommu_dev_data *dev_data)
 	dev_data->domain = NULL;
 	list_del(&dev_data->list);
 
-	/* Clear DTE and flush the entry */
-	amd_iommu_dev_update_dte(dev_data, false);
-
-	/* Flush IOTLB and wait for the flushes to finish */
-	amd_iommu_domain_flush_all(domain);
-
 	/* decrease reference counters - needs to happen after the flushes */
 	domain->dev_iommu[iommu->index] -= 1;
 	domain->dev_cnt                 -= 1;
-- 
2.43.0



