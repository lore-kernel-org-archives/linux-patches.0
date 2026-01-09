Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7E835A933;
	Fri,  9 Jan 2026 12:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960882; cv=none; b=rVzhZqMuGDXL246VkmL4xOhdLPQtV4QK30coECEgOOXnaIEr6L0i0TvvvNGXyBKshvBJSqpRPM/nBEuzknsFdfUaJeXZssSDLczVPD/GfC74uGNBCUAxnP5C2K2aea0n8LUDiN+UKllOR7nQlFJJlO27g87bIIOmIC9pq7xAfss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960882; c=relaxed/simple;
	bh=DAPlF/x/LF2tH8rvSOXdMhQArwriNwZ+LUmlz9Z9beU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=In9+zpMk0mNRbUThprmNyAZ8DVVTK48HuP7KsCrIDvLI/Uky8CYMfuBEaCfBfWyNeYTesxbn+LDvCJSH5jwC3Cva6QaxjNbECWpcTHEf64V1QpkhJEaRvChf/uiCcw9q+OfziA8cYoBmwNRvPfrmfpDJh6rnnCLZoI4v+TDHhc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUMWfOQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUMWfOQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA8FC16AAE;
	Fri,  9 Jan 2026 12:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960882;
	bh=DAPlF/x/LF2tH8rvSOXdMhQArwriNwZ+LUmlz9Z9beU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUMWfOQPvCIbVBcDU9DBdrKSsh7v03IKD5PIov2n0XagTJFmFHbuYe+PyymnjcQjp
	 G/tmFjfIQLJUbouysGmkKzFqxtTx4IKJdDiR9Hc6q1DPOXsyJuEBA6BTiPFWLQuPnG
	 eTUYUt1IzAuAaJdFRla4QEknCYHkfhVWq2yEBZfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 558/737] iommu/sun50i: fix device leak on of_xlate()
Date: Fri,  9 Jan 2026 12:41:37 +0100
Message-ID: <20260109112154.993521439@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit f916109bf53864605d10bf6f4215afa023a80406 upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Cc: stable@vger.kernel.org	# 5.8
Cc: Maxime Ripard <mripard@kernel.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/sun50i-iommu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -824,6 +824,8 @@ static int sun50i_iommu_of_xlate(struct
 
 	dev_iommu_priv_set(dev, platform_get_drvdata(iommu_pdev));
 
+	put_device(&iommu_pdev->dev);
+
 	return iommu_fwspec_add_ids(dev, &id, 1);
 }
 


