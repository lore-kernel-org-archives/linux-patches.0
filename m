Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6213418E27;
	Sat,  3 Feb 2024 04:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933679; cv=none; b=ZXNP2Vy9i0u0lTPpGqtsCJ9xh02ktqEZuFh04ILf4bc7BmU436lDD8+qDBpzcWOmdbNA1rmM5B5JCbiVanWFbuVQDjoesLqTcxMMEIGwWazp6eHRoRj5dELi1gcEz9XupaNTNoSK/5eMzC1PbwjBbhX0UFhwtFI2eLI6Fk9hGCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933679; c=relaxed/simple;
	bh=yFJ/IBko9z3EeoYr3NqReTmAFFDOsHkfFrNlkGAd0Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaTKqrzCTKFQknm2cIUKqWPmAMNHLoaO0BUcbtKSo82+5Krbtvu+2URVQwlnwKaozlbGB2Pxc25GEj5LbOkA3LDW9UlFRGMPIKqU2xe/1E+jgXWdloeOS8pe+37I9sr1N7xZzdY08VkKoFmU8q7pjz/S037MX+vjTpkG68U3bac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pgr2azwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pgr2azwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29553C433F1;
	Sat,  3 Feb 2024 04:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933679;
	bh=yFJ/IBko9z3EeoYr3NqReTmAFFDOsHkfFrNlkGAd0Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pgr2azwY7WCCuxQ9dKVguTpPwocDQ8wnNNMb2+kUep4IiuC9XTZKCz3zZBfIAljLS
	 lg/Zwog1+J5SeO0CoKwp2LBTEED3qiVDeVC10NJhi5L7UwuRTYwExnMY7KCwwFZPX8
	 4iL0phOzISrHhNWlbJVz7xCd3q3/YqCvBbq8not8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elad Yifee <eladwf@users.github.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 272/322] net: ethernet: mtk_eth_soc: set DMA coherent mask to get PPE working
Date: Fri,  2 Feb 2024 20:06:09 -0800
Message-ID: <20240203035407.895399096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit cae1f1c36661f28c92a1db9113961a9ebd61dbaa ]

Set DMA coherent mask to 32-bit which makes PPE offloading engine start
working on BPi-R4 which got 4 GiB of RAM.

Fixes: 2d75891ebc09 ("net: ethernet: mtk_eth_soc: support 36-bit DMA addressing on MT7988")
Suggested-by: Elad Yifee <eladwf@users.github.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/97e90925368b405f0974b9b15f1b7377c4a329ad.1706113251.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 20afe79f380a..73ea1e22b1fa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4757,7 +4757,10 @@ static int mtk_probe(struct platform_device *pdev)
 	}
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_36BIT_DMA)) {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(36));
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(36));
+		if (!err)
+			err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+
 		if (err) {
 			dev_err(&pdev->dev, "Wrong DMA config\n");
 			return -EINVAL;
-- 
2.43.0



