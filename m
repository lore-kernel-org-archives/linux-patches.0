Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DF73A0E98;
	Thu, 15 Jan 2026 17:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498281; cv=none; b=lSxMHtX+8AsNWyOybZNfMf/zQHH9nLNcfOAL4drGnXmjXUKCliRdnG9toVunj9ONxki8LTaBB1SGuEwclpuYhoGIevTz3SzSR0sYHR/Lc7LOJzvYnzoQnB2CTR5DUip5ihCsdgOi7XUd114a+p6quYGs28RAQBnj6PL+SALWrrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498281; c=relaxed/simple;
	bh=9hHL4hll79qJVMpEQe8Rgg67EcCifAZKhwkOk+o83jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMXXfiqBOuo6H9RyZSFpeizKcJMwqpPTJjWLuxvRx+50TGGPiRKgwBRLVIL9sJVGGZA1we5vjWBZdQXQ4211Pi4mZHoPIBEa6UCdYcPdKUyNtUcSXvwXohmZ9rTRefsxgtJY8SCsuVI15CN4NQ7G+XBUcKx3dhlUVoe/FhlPdX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOrt1LFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOrt1LFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7303CC116D0;
	Thu, 15 Jan 2026 17:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498280;
	bh=9hHL4hll79qJVMpEQe8Rgg67EcCifAZKhwkOk+o83jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOrt1LFvfyjwXMV59OzPzkmoTLhkyUA5U+grYqSrBrrAwonKdCAEo20qmdO++iohM
	 GkfqWvDsuUx7IN2o7hAKGRCit7nim9gCal+Gmqt6IhdjaFn7MNcVAByPmHAbN12TEQ
	 2+dxD01tjnsmm6TLtA2UkSd5G1QjsLXOzjDmbxac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honghui Zhang <honghui.zhang@mediatek.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.15 376/554] iommu/mediatek-v1: fix device leak on probe_device()
Date: Thu, 15 Jan 2026 17:47:22 +0100
Message-ID: <20260115164259.843631901@linuxfoundation.org>
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

commit c77ad28bfee0df9cbc719eb5adc9864462cfb65b upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during probe_device().

Fixes: b17336c55d89 ("iommu/mediatek: add support for mtk iommu generation one HW")
Cc: stable@vger.kernel.org	# 4.8
Cc: Honghui Zhang <honghui.zhang@mediatek.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/mtk_iommu_v1.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -393,6 +393,8 @@ static int mtk_iommu_create_mapping(stru
 			return -EINVAL;
 
 		dev_iommu_priv_set(dev, platform_get_drvdata(m4updev));
+
+		put_device(&m4updev->dev);
 	}
 
 	ret = iommu_fwspec_add_ids(dev, args->args, 1);


