Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D8423F42D;
	Tue,  6 Jan 2026 17:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721938; cv=none; b=eMRR6pnrgXsh2lv/K7C2BvYYJBCiTYzhu8/B5MnlMYb6n/CcS5S6liYfaLZ6zq87ao8dfIbUKeMv3RJ55Hz4eu47tsDns0j94jH8uk5xWAnEFd2kx2dpBKsdAp++XZHErnOZujcRKcWFdBz8mtMCurjDhZJ1qjx9YNDcX9vrNo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721938; c=relaxed/simple;
	bh=Qrudp/nnsAmuGG7YkTfBL8oUWw4E6LIULzkmUF2zNsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/uJC2nfarnxLjyXnlmGvfX4YrMOwF6ht5MnpfBrxyb24NDg5zl5hc4ESf8uzZOSAYX9W4kLhtG1BLbfvziDc0ptktrtegmRojAo/EZ7il/WpMUifBE8pSOdxeNyiy8YSQKet4E4/4V6cJCrINowBgiL53ltJs5RF6yMehIgxrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hISnecKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hISnecKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE47DC16AAE;
	Tue,  6 Jan 2026 17:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721938;
	bh=Qrudp/nnsAmuGG7YkTfBL8oUWw4E6LIULzkmUF2zNsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hISnecKr5xdD/J4RZ0WmUrEiySoOzjxkmPPMFsqo/jsyWiMLCo3Kw7OcaQiYp9eZ/
	 hcEIc29Ndl1170Mh/0LjqB+9vfN96KpP3kLL5llG+Mae+t0rOmcKVX4r8S30+tsCTF
	 g4KDO6uXu5uq6DwN9oTBXogAee3Bhb54ngNsQMuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Anna <s-anna@ti.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 116/312] iommu/omap: fix device leaks on probe_device()
Date: Tue,  6 Jan 2026 18:03:10 +0100
Message-ID: <20260106170552.038096068@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit b5870691065e6bbe6ba0650c0412636c6a239c5a upstream.

Make sure to drop the references taken to the iommu platform devices
when looking up their driver data during probe_device().

Note that the arch data device pointer added by commit 604629bcb505
("iommu/omap: add support for late attachment of iommu devices") has
never been used. Remove it to underline that the references are not
needed.

Fixes: 9d5018deec86 ("iommu/omap: Add support to program multiple iommus")
Fixes: 7d6827748d54 ("iommu/omap: Fix iommu archdata name for DT-based devices")
Cc: stable@vger.kernel.org	# 3.18
Cc: Suman Anna <s-anna@ti.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/omap-iommu.c |    2 +-
 drivers/iommu/omap-iommu.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1675,6 +1675,7 @@ static struct iommu_device *omap_iommu_p
 		}
 
 		oiommu = platform_get_drvdata(pdev);
+		put_device(&pdev->dev);
 		if (!oiommu) {
 			of_node_put(np);
 			kfree(arch_data);
@@ -1682,7 +1683,6 @@ static struct iommu_device *omap_iommu_p
 		}
 
 		tmp->iommu_dev = oiommu;
-		tmp->dev = &pdev->dev;
 
 		of_node_put(np);
 	}
--- a/drivers/iommu/omap-iommu.h
+++ b/drivers/iommu/omap-iommu.h
@@ -88,7 +88,6 @@ struct omap_iommu {
 /**
  * struct omap_iommu_arch_data - omap iommu private data
  * @iommu_dev: handle of the OMAP iommu device
- * @dev: handle of the iommu device
  *
  * This is an omap iommu private data object, which binds an iommu user
  * to its iommu device. This object should be placed at the iommu user's
@@ -97,7 +96,6 @@ struct omap_iommu {
  */
 struct omap_iommu_arch_data {
 	struct omap_iommu *iommu_dev;
-	struct device *dev;
 };
 
 struct cr_regs {


