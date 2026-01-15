Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1513A0E98;
	Thu, 15 Jan 2026 17:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498286; cv=none; b=iD/It9RLZcU0+V181qqqIOwMhKqGAZfTu+NHs2+hf1bFlV9fmlAxRZj9AxAV/pCoMQ1Ua4VHM4Bwt26WTlPWuqkm7hfzdGJWcoYpPXfvDQvH5HuSiRGKjdJQp9cTkzIwPi7/YZR+9eBW7L6AvqIGDGi938ly9iOaNWkRCmNpMWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498286; c=relaxed/simple;
	bh=7SFPS7+3qf7QMnjaHgafBNM3zKxJIoH8qqtxPGKvW4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Of/RhD555cs54tbCtDuHB2HpDDncG2U2Y8GlUWrocy8gkPudbN/hlitmlSSR4iiuQrY+tvU9WADf0jOBq9fzPK4yPfo9HOU+LNXo46U4ibZq3Iqz0kr9Y9gBo1dTh96QGFcUE/BLCDuSGtglLrTtlNihVstSqmqSZMi55ZME+IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fK4UJVnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fK4UJVnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF79C116D0;
	Thu, 15 Jan 2026 17:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498286;
	bh=7SFPS7+3qf7QMnjaHgafBNM3zKxJIoH8qqtxPGKvW4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fK4UJVnw7Is+jvdQ2cgU5Fp2n3QUrJieZi3D8cHOCC7MUXHsozbQh6XUNBIoYFRNc
	 3CZDbfHB3JA8MgFOc4H40f4J+jMk8oO2oqIoZ98PCJs7KVSie2ajxEE/viJ3dZKsAh
	 rHmZ7Xn0lMx3JA6tUsBFCdS6G93egVbXbVv4d//I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.15 377/554] iommu/mediatek: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:47:23 +0100
Message-ID: <20260115164259.880693050@linuxfoundation.org>
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

commit b3f1ee18280363ef17f82b564fc379ceba9ec86f upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Fixes: 0df4fabe208d ("iommu/mediatek: Add mt8173 IOMMU driver")
Cc: stable@vger.kernel.org	# 4.6
Acked-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/mtk_iommu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -669,6 +669,8 @@ static int mtk_iommu_of_xlate(struct dev
 			return -EINVAL;
 
 		dev_iommu_priv_set(dev, platform_get_drvdata(m4updev));
+
+		put_device(&m4updev->dev);
 	}
 
 	return iommu_fwspec_add_ids(dev, args->args, 1);


