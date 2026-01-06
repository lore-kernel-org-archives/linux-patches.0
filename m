Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B06623F42D;
	Tue,  6 Jan 2026 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721928; cv=none; b=qMKnU412452ivAT2NxJiZ2KdBQdUTRG2oIdjBqJQvMb6by1oIcLuviZpZ6A/28DUzaaN4liMdqRHhNxuSvqGfbStu9r4mbCBzwkeYfia5vbUjnSY21EHBIRAJ5LaP0I7Ntfei/vj63zpWIvuWdUDzhoX64xsWqC7rKgRYiF3Jtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721928; c=relaxed/simple;
	bh=ZiSdvhm0tU5BreDbqOAW1xiY+9mzUaa98PhkR3AuHZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wrdu6xSY6PzPZhqKFT7Aze+OjuYlqyqkRvPA/w8J5LOe0va8Vw/n6XaR+BPM4FyxcJ0em7au/sai9ev+no5XuNs0DeQq5F5PC58by7Hdj28QwaH8pG9uwWooHBy2Y+mUe1er8D20eYxCkrI0ojts1q/iVxDSAgp9J3HoGtuh6Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYVvnMN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYVvnMN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4109EC116C6;
	Tue,  6 Jan 2026 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721927;
	bh=ZiSdvhm0tU5BreDbqOAW1xiY+9mzUaa98PhkR3AuHZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYVvnMN9iA2uM//7bFtWcLR3ZaHTDegmdWsS8w+PEXKQqldGTtkPFvsIP9CjECF/b
	 ehs+tq4CDq5AHP2Ejq/RgE5qleQjUHDCTfTBLJHeHN4Hg/CJRbYdQPPJZ+roD4C9+4
	 NG6L5nstVxFhbunxV1Ic7J85wTBX3YvC6oAo74S0=
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
Subject: [PATCH 6.18 113/312] iommu/mediatek-v1: fix device leak on probe_device()
Date: Tue,  6 Jan 2026 18:03:07 +0100
Message-ID: <20260106170551.926293835@linuxfoundation.org>
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
@@ -435,6 +435,8 @@ static int mtk_iommu_v1_create_mapping(s
 			return -EINVAL;
 
 		dev_iommu_priv_set(dev, platform_get_drvdata(m4updev));
+
+		put_device(&m4updev->dev);
 	}
 
 	ret = iommu_fwspec_add_ids(dev, args->args, 1);


