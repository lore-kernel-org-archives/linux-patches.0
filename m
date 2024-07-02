Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD14B1BD51B;
	Tue,  2 Jul 2024 17:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940272; cv=none; b=qxH+nknFb93OSQex7+S/qrII/uRnm/aHmpJuBebzMYJbmhglqBDMiNm3p/xKKbP9u54A3fJHCch9dym6/8grV5x8+mndd2cZatbm/ZPD51W68BA/qWYiHFJ7iJXe1ZlDW4BtwKOfS2zFf05ZTzWaNh0DUlrukqrGMqxFv2LkPrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940272; c=relaxed/simple;
	bh=tt9rOrT6n0nX24OgkVGJy7lBW1ueY1p05mBtzxbGxS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqsT4p7vwkCi7mqeoxJLHwhouwFWfGnzxam15X0GzfDSJW6wXEcj5GSExYGzUm3DL/+eqksm5E90inq3ziafWUP/SF19RXx37V7mzl+u4GlhltjaGHik3VYkWRLDwAQK4EJcPEEv4VQqS6V8pd5sZZMjxeZM2Bhscllws2b72mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnTffunS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnTffunS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A50AC116B1;
	Tue,  2 Jul 2024 17:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940272;
	bh=tt9rOrT6n0nX24OgkVGJy7lBW1ueY1p05mBtzxbGxS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnTffunSaIzJXk2HrciYbMbhfc/3pA/Aj7h2tpfZl7rMn6Qz/DZsm+PPgvg8IjD92
	 c3NeHu2GYxSYJ8+946Nk8t/2/5OpFbYtufUqJIti9wQAFiqLgTjkxcHlKqXeRoR3J/
	 UCVMzDfuHtbYAIKlgjl/NWVvNByvpwXrpsRxmxFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 104/222] iommu/amd: Introduce per device DTE update function
Date: Tue,  2 Jul 2024 19:02:22 +0200
Message-ID: <20240702170247.942517068@linuxfoundation.org>
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

[ Upstream commit c5ebd09625391000026b0860952e05d0f7fc4519 ]

Consolidate per device update and flush logic into separate function.
Also make it as global function as it will be used in subsequent series
to update the DTE.

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20240418103400.6229-3-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: c362f32a59a8 ("iommu/amd: Invalidate cache before removing device from domain list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h |  1 +
 drivers/iommu/amd/iommu.c     | 26 ++++++++++++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index f482aab420f78..95a161fdbae2c 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -56,6 +56,7 @@ int amd_iommu_clear_gcr3(struct iommu_dev_data *dev_data, ioasid_t pasid);
 void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_update_and_flush_device_table(struct protection_domain *domain);
 void amd_iommu_domain_update(struct protection_domain *domain);
+void amd_iommu_dev_update_dte(struct iommu_dev_data *dev_data, bool set);
 void amd_iommu_domain_flush_complete(struct protection_domain *domain);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 				  u64 address, size_t size);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index fb727f5b0b82d..d19a12a158085 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2002,6 +2002,21 @@ static void clear_dte_entry(struct amd_iommu *iommu, u16 devid)
 	amd_iommu_apply_erratum_63(iommu, devid);
 }
 
+/* Update and flush DTE for the given device */
+void amd_iommu_dev_update_dte(struct iommu_dev_data *dev_data, bool set)
+{
+	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
+
+	if (set)
+		set_dte_entry(iommu, dev_data);
+	else
+		clear_dte_entry(iommu, dev_data->devid);
+
+	clone_aliases(iommu, dev_data->dev);
+	device_flush_dte(dev_data);
+	iommu_completion_wait(iommu);
+}
+
 static int do_attach(struct iommu_dev_data *dev_data,
 		     struct protection_domain *domain)
 {
@@ -2036,10 +2051,7 @@ static int do_attach(struct iommu_dev_data *dev_data,
 	}
 
 	/* Update device table */
-	set_dte_entry(iommu, dev_data);
-	clone_aliases(iommu, dev_data->dev);
-
-	device_flush_dte(dev_data);
+	amd_iommu_dev_update_dte(dev_data, true);
 
 	return ret;
 }
@@ -2058,11 +2070,9 @@ static void do_detach(struct iommu_dev_data *dev_data)
 	/* Update data structures */
 	dev_data->domain = NULL;
 	list_del(&dev_data->list);
-	clear_dte_entry(iommu, dev_data->devid);
-	clone_aliases(iommu, dev_data->dev);
 
-	/* Flush the DTE entry */
-	device_flush_dte(dev_data);
+	/* Clear DTE and flush the entry */
+	amd_iommu_dev_update_dte(dev_data, false);
 
 	/* Flush IOTLB and wait for the flushes to finish */
 	amd_iommu_domain_flush_all(domain);
-- 
2.43.0



