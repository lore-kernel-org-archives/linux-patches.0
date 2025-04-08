Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1C0283688;
	Tue,  8 Apr 2025 12:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117157; cv=none; b=WCZAJ5i9PC35VFH/KEs8i1SLyOaaYVoHNr9wOKvueY5DUwNqkOn0V98eLHuQcjwluJE5vOGgkPGUnN+RIpDvFjkVBKiKeP4M8Fcb0QuwOEx4/MQbJkevWBM6UM8B3/Wa4gTQ92WmCsZ8oPkyvbExXvvGObZQcXWCGNKwMot5sS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117157; c=relaxed/simple;
	bh=ZcS7QY9z5rvP8VNmls7UHI/w6Gv3ijAQNPcPC7ZRf7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgLQTUQ8H1C1iyTQxJVC5SV/8Ih++AkZtBZzleHDfrvcYw5CweX6L2OeitxKQXEW3vDx5MbbLl3AturA51V4fhWyTX/rtNKIa5x7in8QRPoCvOnBIY+pUpg/XQ2U0C7yV+aacdfTTjwCaRF2rCC8bcr4zZyQvihhu6LP37fCiR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1O5FSQny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O5FSQny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56823C4CEE7;
	Tue,  8 Apr 2025 12:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117157;
	bh=ZcS7QY9z5rvP8VNmls7UHI/w6Gv3ijAQNPcPC7ZRf7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1O5FSQnyWbeEH28PdCVAQaf/za+nz36enGfIRap9sj8Mx1mamb5wlAbr5pT0hCVIU
	 i34yv5sUz4I0mPp6gRnuxsnFDDBNitUTwu0Exs9YEchA6y0gE5IYWpMXEbr15uAVYN
	 ShsZFCh3mkbiK+RZBUJ0wKUZEITzh9EUIA2+0U94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	"Sicelo A. Mhlongo" <absicsz@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 388/423] media: omap3isp: Handle ARM dma_iommu_mapping
Date: Tue,  8 Apr 2025 12:51:54 +0200
Message-ID: <20250408104854.927363138@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


