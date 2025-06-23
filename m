Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C911E22E6;
	Mon, 23 Jun 2025 21:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715670; cv=none; b=mB16zY3jPmaETUj3X6nqexVmRPEeEL+kB7F3sdkol5WNkULOV6UG+6GfqpZ2hQGkInkkgjSuYuwEx6jbxhchllkDWSn+jM3Sbe980S+eLieU1JJWxV3+5ApwoQ2O9qf2vG2wISVdAhcX/VAy44VuSnHk6SYp3RhbtcZaIMQ3dek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715670; c=relaxed/simple;
	bh=DINxIrXFns8Hd3Ke7oEid+S0NaU6cX7J6myHbHbLi6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aW5Fxm4XG6SXqIA2JIwChVGiJEMKjVos1twYLW09LFfWJ1kUOXy7yhQ4jU5iYVHzfOS+Gymtfnsx3DbfkzURFLL5ZvqSlpx3Gk3fs/vMpsQIfSDMUkC/6VZfh7vHsthqA9mTpxNEmjKLr+GcEAkXf/MWnTEf/HtBrR20QUK0Q8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXqqUtht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXqqUtht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6B2C4CEEA;
	Mon, 23 Jun 2025 21:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715670;
	bh=DINxIrXFns8Hd3Ke7oEid+S0NaU6cX7J6myHbHbLi6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXqqUtht7LkHmE8W+YUSpCRnjhkbaCy89Ry3rTAHBAGe0b/A9DGDjNd8uR+7uyLhZ
	 w7AEB2THAr00tmpLOSNCCs7zEinNY3wm8EUYyEacDv4djqA4KRjq344cbVtu4w5RDv
	 QikC31C1lKs/t6cjd0x6XmFZIgGVwooewGIE1g/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergio Perez Gonzalez <sperezglz@gmail.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/414] net: macb: Check return value of dma_set_mask_and_coherent()
Date: Mon, 23 Jun 2025 15:05:28 +0200
Message-ID: <20250623130646.794236590@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sergio Perez Gonzalez <sperezglz@gmail.com>

[ Upstream commit 3920a758800762917177a6b5ab39707d8e376fe6 ]

Issue flagged by coverity. Add a safety check for the return value
of dma_set_mask_and_coherent, go to a safe exit if it returns error.

Link: https://scan7.scan.coverity.com/#/project-view/53936/11354?selectedIssue=1643754
Signed-off-by: Sergio Perez Gonzalez <sperezglz@gmail.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Link: https://patch.msgid.link/20250526032034.84900-1-sperezglz@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index ae100ed8ed6b9..3c2a7919b1289 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5117,7 +5117,11 @@ static int macb_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	if (GEM_BFEXT(DAW64, gem_readl(bp, DCFG6))) {
-		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
+		if (err) {
+			dev_err(&pdev->dev, "failed to set DMA mask\n");
+			goto err_out_free_netdev;
+		}
 		bp->hw_dma_cap |= HW_DMA_CAP_64B;
 	}
 #endif
-- 
2.39.5



