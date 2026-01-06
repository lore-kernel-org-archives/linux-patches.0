Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229632E62D9;
	Tue,  6 Jan 2026 17:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720850; cv=none; b=rJmxcnhK7aqT4CoAC3G8z/ZiCYR9rqX3agEWTj1RLjCePHKJWezz7bdhMfO+xzACY7PjJ8i5m0sE37FS3x4zKUoOo63/DKcqmrUBWqD1+1DY0KcRaPka1aG5PMAL5SYWcuRhWaeQgPV2qY6+bJFSvWOjpTaiFE9rAD6/unWqMY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720850; c=relaxed/simple;
	bh=El4RkmlspS/hYqUewbgiAXSEGXP8+dm9pHzw5ivzgXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgDhtvzg1nM3K47uo+9IHmdSijz03d0tf2Wwtd+9h5r00ly8WnIrAGnVDZhL1vH3MOygI4IsROnHSRnsDktgcno2mKYO0tK3xeZ0UTOhc4NMNjcIO2B2Pjq11u/PYfGWnAVWFL1WsOoJo+8sHYRFAMT5q/ujT/VBAybrZsIgaIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZG6nkqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZG6nkqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5BDC116C6;
	Tue,  6 Jan 2026 17:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720849;
	bh=El4RkmlspS/hYqUewbgiAXSEGXP8+dm9pHzw5ivzgXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZG6nkqtejnKQRziuFqQPXNdszv98bNqAaTYA3UCQY2uK5opiWiLH6WCnT7gTj6A3
	 /SnLLA+kBbFFFdENYMXKskZo50UgfUNqJ3IaEI/CVi7efwMDVGeLKSwBnKTuk/uafb
	 J9fO7zJFx+ydK299B1DQYzOg00ER9yh5XokFH540=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 361/567] iommu/mediatek: fix device leak on of_xlate()
Date: Tue,  6 Jan 2026 18:02:23 +0100
Message-ID: <20260106170504.691971955@linuxfoundation.org>
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
@@ -975,6 +975,8 @@ static int mtk_iommu_of_xlate(struct dev
 			return -EINVAL;
 
 		dev_iommu_priv_set(dev, platform_get_drvdata(m4updev));
+
+		put_device(&m4updev->dev);
 	}
 
 	return iommu_fwspec_add_ids(dev, args->args, 1);


