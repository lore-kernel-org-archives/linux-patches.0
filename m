Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D123D1CD7;
	Thu, 15 Jan 2026 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499706; cv=none; b=YWU/LMafRHcJP1jyisnbD49LvWRHQOZuYanA70maK1uMNyaWSPdvpipMgrwMzsG8A+mKzvOIPAvxK0+9ei3TYX7YsIk8b4WeOQChZ45lF5+N7+M+4T3p1Kqwgy3U7Qkr0Opuwm5IvpjaijwV5KtDhJGTaYXhOl5Iie2GGfwl0jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499706; c=relaxed/simple;
	bh=GCaapQmXWZ4vHyV+fkfcfB+LsezbXzkDkvArVXkAOzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqmick7DP3F2G8sQps+nNmWhTV2df8iqT/rcgFh8utMMITvdmFhCiBdsEO6d1hnS31/llH6J/tGHRN4HrLJz9IwkyuCDx8iyT16ZqBoR6/h0UKU+AMhNzOUMJPBRVa3Q9f+rOArR5998x6r5vj2IDIpFIB88W4jcVcRKmBPjnqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs9scfX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs9scfX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63689C116D0;
	Thu, 15 Jan 2026 17:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499706;
	bh=GCaapQmXWZ4vHyV+fkfcfB+LsezbXzkDkvArVXkAOzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs9scfX3fqtyh+0ycxNT1W9PSkrEz7CgHUsBgdT3wfPhF/TAwZGDJ482MZNQVW3J6
	 Cg4eSjw/A66AprZ4KKQHFFRFNX0anpOMf+gZbPWwhgXJpTnXOYaeoI6DL3xCgFSICa
	 GEET1SIN8roSKl7JsnII170RWmlYGj0A8Rev9rpg=
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
Subject: [PATCH 5.10 304/451] iommu/mediatek-v1: fix device leak on probe_device()
Date: Thu, 15 Jan 2026 17:48:25 +0100
Message-ID: <20260115164241.892591415@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


