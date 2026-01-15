Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3FC3D6482;
	Thu, 15 Jan 2026 17:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499737; cv=none; b=BkNfTFBSVPTQe5G3YidXNQE2VLAsPQ/KHSb2PFT0/mBWxBepxNtZKWgIKuTTmO4cURhoOvrib3CFr5yEIW8g2WTEgTpzdTzXFaLRv6NBrY0lMX2zrAwPKvg8M8BIXoFfg3n3cb2tldU5dWRChSdnqcKNcUhXFSAlmNH7iWiNsEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499737; c=relaxed/simple;
	bh=cWBfX6J8I1B6w6mTeJyo5nRl4O6gFJNtxqyImYS88P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ma1sud6IhwLlblX3Rjk08ivIXJGxRl8/KWgVPeJ/cbtUJoqtQL22ntIV6O06IuS1HCO9PGzHU4KthYnaVGAH26GbpnAGc9h+dOJke06cb7h1zd8Jx9+86Lfl2T0Z0a3a4pWjriM23OhZnvu8N8jOVTRfN6LVPLcTYEz05kNoxHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7IIhnI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7IIhnI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51139C116D0;
	Thu, 15 Jan 2026 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499737;
	bh=cWBfX6J8I1B6w6mTeJyo5nRl4O6gFJNtxqyImYS88P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7IIhnI+Ah0g/KTrbybTv3zYThqstyvCCZgPUKNThecMIhY2V5ZtczWskAxerw8Ul
	 /y6E3ZLeyIx00SXEFhNJhg2Gm7YMxPCS/8/GMOj/OxfXHsoIzwBSE5vEIfNRaxE6N1
	 fGtMTaTfYa6Cv6UKZq5W8GgRaSlgU7pGio8hDu8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.10 305/451] iommu/mediatek: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:48:26 +0100
Message-ID: <20260115164241.929567985@linuxfoundation.org>
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
@@ -526,6 +526,8 @@ static int mtk_iommu_of_xlate(struct dev
 			return -EINVAL;
 
 		dev_iommu_priv_set(dev, platform_get_drvdata(m4updev));
+
+		put_device(&m4updev->dev);
 	}
 
 	return iommu_fwspec_add_ids(dev, args->args, 1);


