Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D449268FEB;
	Tue,  8 Apr 2025 11:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112142; cv=none; b=sw5csKNgw/Nym0ff7BV6cW2YMpnxNqy2rvTijvdXrRNYbqEqzbqgY9q3NgVDIfR+8NNpxDwAg4lcBW6C70/Z5WQRAE/dH+O8N97tdkO72Ew5HJQbz63hSFhG94DVks4AX0qQjIXskif+HjXgRwwLlddO3i4yP2xRTwm9o+7ijGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112142; c=relaxed/simple;
	bh=Acll1SeXsFAqOaYOIrpTaekSMgUSt0TuIT3l2uPkc6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEjuWxDhMqu1yLYIQ7Idj+Qdl8FVx2GaA/q41IOuH/XCMjBE0ODKbiLmrgqltUNGPnuj7KyXfaxK+gittjgUEy7q0Hmp0BXEIY52eFgm3g1hBSBK0+qzhoTs+lq3cdR1s1Cyglklc767K64UzAS7CgDsjORUuTVyprOcaQ29kmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvKgHehR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvKgHehR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF1BC4CEE5;
	Tue,  8 Apr 2025 11:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112141;
	bh=Acll1SeXsFAqOaYOIrpTaekSMgUSt0TuIT3l2uPkc6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvKgHehRNILx+g8sTl9zBKDX7uKRisbwrRjLteXz7nrfXQYh0DWBs0ZoDj7oP+YLs
	 oWBqJy7o3XECRHlkvhGRNK+/rccwuEFoQH7rzA1687SFGzsBzI58YqQqWQDBSU41/X
	 GtFz0Sy3vwrxOUo8nzO8/kODzZvHX1WfF4osLEc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	"Sicelo A. Mhlongo" <absicsz@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 692/731] media: omap3isp: Handle ARM dma_iommu_mapping
Date: Tue,  8 Apr 2025 12:49:49 +0200
Message-ID: <20250408104930.363516989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 6bc076eec6f85f778f33a8242b438e1bd9fcdd59 upstream.

It's no longer practical for the OMAP IOMMU driver to trick
arm_setup_iommu_dma_ops() into ignoring its presence, so let's use the
same tactic as other IOMMU API users on 32-bit ARM and explicitly kick
the arch code's dma_iommu_mapping out of the way to avoid problems.

Fixes: 4720287c7bf7 ("iommu: Remove struct iommu_ops *iommu from arch_setup_dma_ops()")
Cc: stable@vger.kernel.org
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Sicelo A. Mhlongo <absicsz@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/omap3isp/isp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/platform/ti/omap3isp/isp.c
+++ b/drivers/media/platform/ti/omap3isp/isp.c
@@ -1961,6 +1961,13 @@ static int isp_attach_iommu(struct isp_d
 	struct dma_iommu_mapping *mapping;
 	int ret;
 
+	/* We always want to replace any default mapping from the arch code */
+	mapping = to_dma_iommu_mapping(isp->dev);
+	if (mapping) {
+		arm_iommu_detach_device(isp->dev);
+		arm_iommu_release_mapping(mapping);
+	}
+
 	/*
 	 * Create the ARM mapping, used by the ARM DMA mapping core to allocate
 	 * VAs. This will allocate a corresponding IOMMU domain.


