Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C373C1FF9;
	Thu, 15 Jan 2026 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498295; cv=none; b=hOsRJxdbPqQo/5mlxBDoaIvEXST3sHcrlMwFskM2BxcXaVour9KMa94nafF5845XcctdujKcNgip1PnTj25tIi71YXKbAh8OzrNKG544V3hvpX93NLVp9x/tiwIB71sDlV54+eueq+NWZemthXXCqvQyMzWX9QfddHh080CZWbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498295; c=relaxed/simple;
	bh=btSKtf+qUn5x9MhuOgsh0u1L1OprbAn8JsUd4W92vOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUEw3ZvaXR2D3MK7pmVITu06f0IsdSVuJgYiFdPhM0U8rpp+ulR3ZlxLMaaUuLNFlH18AJu3+ni2bxpy5F7TbOzeQbQATe1oF21d9GtkE9WFz+dKgocHD2N8qsbHyMQHbADKqNKLxHyYm2gR86TNoAen8gDwJyWkVprRSV2KLkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wD68tS+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wD68tS+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40CCC116D0;
	Thu, 15 Jan 2026 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498295;
	bh=btSKtf+qUn5x9MhuOgsh0u1L1OprbAn8JsUd4W92vOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wD68tS+uDMLpf4EK94B336fF18BmZgPXgZVgghCUmFXKs9LlXL1dbXl/+hcKpxvmm
	 nEO9EYEHNxTyzE8gQQ+uF81xRPcaLoKDr6MowbvYlPfKj2gkNZd44vxz3bJ5PTXhu6
	 7/eh74ryqh0frRogYxQ8VMK0JqmbOF9CJRGfr1w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <treding@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.15 380/554] iommu/tegra: fix device leak on probe_device()
Date: Thu, 15 Jan 2026 17:47:26 +0100
Message-ID: <20260115164259.990554758@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit c08934a61201db8f1d1c66fcc63fb2eb526b656d upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during probe_device().

Note that commit 9826e393e4a8 ("iommu/tegra-smmu: Fix missing
put_device() call in tegra_smmu_find") fixed the leak in an error path,
but the reference is still leaking on success.

Fixes: 891846516317 ("memory: Add NVIDIA Tegra memory controller support")
Cc: stable@vger.kernel.org	# 3.19: 9826e393e4a8
Cc: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/tegra-smmu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -808,10 +808,9 @@ static struct tegra_smmu *tegra_smmu_fin
 		return NULL;
 
 	mc = platform_get_drvdata(pdev);
-	if (!mc) {
-		put_device(&pdev->dev);
+	put_device(&pdev->dev);
+	if (!mc)
 		return NULL;
-	}
 
 	return mc->smmu;
 }


