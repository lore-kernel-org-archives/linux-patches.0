Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E511028C037;
	Tue,  6 Jan 2026 17:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720853; cv=none; b=Rrq5RiLLfgmlDndE9eUOXlZY1g9xJkchKvlDPyFX3nCHI1T8i7Wivr+OvW5rsSyX99QtmApk694Z5lYH4JSuJksxpnq195FXeO/qZ50qErcih7Voy3D5ZlzZR+SNqZVkOj8H4K7jONYLj3stp/gRPfsIy1HP18qrD3x3oA6p72M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720853; c=relaxed/simple;
	bh=cndLYkuhgZwBsA7HJu1RCs1RbqCvsDXrssJY4I4GfmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dU0WgYQODb6AKcVm+95ReTN+jLSyyFaWUaOz6hjNFa/gP4g/Qbgb27NhRI2OsaFguS5EBXKmvLuxXwhfqTH+a0G1hteBCNoGf1cRikEi676kGoqvUiI5osxVBIat4+3HtSgVFluUAUbEqWnF5DB3gDsfdU3zUPjyloYlUtdv2Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTACbwzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTACbwzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B6CC116C6;
	Tue,  6 Jan 2026 17:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720852;
	bh=cndLYkuhgZwBsA7HJu1RCs1RbqCvsDXrssJY4I4GfmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTACbwzFmdTaEH76j6hbysK3aNLp3L1t9EPxpkYm/j3RkCjGoj1/BGwCyWHFZBCZq
	 1lnMzqNwILdnKeiw+Y9PrCKjfgJjKgPbTkhx3bgjahQGgb2LN33Yk3m2E0M7QXdXaK
	 +sjlYbvHfngYM//dLSBW5RdnQAXe8mjZXru/TPl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Anna <s-anna@ti.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 362/567] iommu/omap: fix device leaks on probe_device()
Date: Tue,  6 Jan 2026 18:02:24 +0100
Message-ID: <20260106170504.729468851@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1688,6 +1688,7 @@ static struct iommu_device *omap_iommu_p
 		}
 
 		oiommu = platform_get_drvdata(pdev);
+		put_device(&pdev->dev);
 		if (!oiommu) {
 			of_node_put(np);
 			kfree(arch_data);
@@ -1695,7 +1696,6 @@ static struct iommu_device *omap_iommu_p
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


