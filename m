Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA663612DC;
	Fri,  9 Jan 2026 12:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962741; cv=none; b=r5OFX4S87qN2u29ydOvPHfPIV8h6WS6pVXke6odlUOKft+LSn22LFFFuR9m8QZnEmyNrDKmDC0eHZw+PlN/3fdXQQ/L2Wm49w9vHxFvtk8N5xCzvd3AHY81GpuGZM3nCDrllWVCieDkU3jtE4cv81XNRE9TC7Vj9cyAJCdGTCHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962741; c=relaxed/simple;
	bh=OrpJ51227/QQfWFptBoVPZoPr6ReDSAOXUJKWkKk2mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czxy9SIPIkUAVZIuzo9XBwQFn702T2QmKD+xJXqOIgxdmy9/TVt6JORPu8WShzChxs908EiNwK3NoGurbdXBNoLXzLWL6kxi7YD/Y93pXWqHeXbAghcRPQhSawckF5A3/oRqu0IudG3UTq2h0Ft43sLex/XQ6dZQwAm5mQ/MXis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G632S5jA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G632S5jA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CA8C16AAE;
	Fri,  9 Jan 2026 12:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962741;
	bh=OrpJ51227/QQfWFptBoVPZoPr6ReDSAOXUJKWkKk2mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G632S5jAxnexmN0YYZY+5CoVB18lryEAM1BNAWiTsBubE44kPPsH9oH0tlVNiQn7C
	 w9BiMGFIuYDkBD8Z1YzoP1tJIdvKu/E8CEICx0eJF//dhpOhH1My4c2YU1ZiIOW9+J
	 b2H45d+KbAYO2EG13lc9Z30PdZuiJ9czOOetNfIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.1 454/634] iommu/mediatek: fix device leak on of_xlate()
Date: Fri,  9 Jan 2026 12:42:12 +0100
Message-ID: <20260109112134.627354880@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,6 +894,8 @@ static int mtk_iommu_of_xlate(struct dev
 			return -EINVAL;
 
 		dev_iommu_priv_set(dev, platform_get_drvdata(m4updev));
+
+		put_device(&m4updev->dev);
 	}
 
 	return iommu_fwspec_add_ids(dev, args->args, 1);


