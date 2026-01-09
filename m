Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77554338911;
	Fri,  9 Jan 2026 12:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960874; cv=none; b=EivOK/h4P5h+HkAlGAew6p6gFEdIWz0tVWnkHt760RMU9DUuhzNAUDNhxScVYq5rIdMtS4oNjzTShWc+SxXSb2+a4ngaQiDU9uKS+WgUQNWVJ3Cvd4JrgQpsbq31ImD9UgmZxYIyuALmz3SlOPCYTr0rRb1bBp1BCA/Z4w38bb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960874; c=relaxed/simple;
	bh=n4M0drP9I7T18KfB0KSKMcL8jZNl5yUAzT/qbw5T9mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1kCsarsn4CJER3/N+Jm43qEh+YfMcfi7sOgc5Mc0nqJVRag2y1o814z2pK5o0y7TxHlF/FZpAIsQroXEinovFZbAKT2Uy1xIv1v8kvWBEzLQGhB4OZVBvsCLgH10z1ZVFQtLjbJOjIu0YF9vXlbnpwrQMfclZNywWs7I8fzObk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2buZNcJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2buZNcJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3DAC4CEF1;
	Fri,  9 Jan 2026 12:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960874;
	bh=n4M0drP9I7T18KfB0KSKMcL8jZNl5yUAzT/qbw5T9mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2buZNcJKeoteBKErXV6vqp+BiBqnCRLxEWI6iLzIfJahasac/OSKVn/D+Lr/yEgd9
	 la4K4/eNGY7FOAbTpuEUUUye0akZjdaLMvyT/wSWOD3AXEg/V6Y0RxD8ZBqeFtS4Xc
	 IiyDo8uAsCzKK7nLmElmvwkkx299qxqgKKVy4SZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 555/737] iommu/mediatek: fix device leak on of_xlate()
Date: Fri,  9 Jan 2026 12:41:34 +0100
Message-ID: <20260109112154.877301392@linuxfoundation.org>
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
@@ -959,6 +959,8 @@ static int mtk_iommu_of_xlate(struct dev
 			return -EINVAL;
 
 		dev_iommu_priv_set(dev, platform_get_drvdata(m4updev));
+
+		put_device(&m4updev->dev);
 	}
 
 	return iommu_fwspec_add_ids(dev, args->args, 1);


