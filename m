Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5092AEE4;
	Mon, 23 Jun 2025 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715033; cv=none; b=hAi9vgPR/0B/u+ewz7+pipJdRVn3Hjh47htNUCarZnm9+n+v0l/28KaE1JfjJvpxJUlr/BpoYEsRDbPoJBWNsGcHT4oI3v+8fgOCRuwv1vd+hA554HpEW3NN1GiddPpYidfUB0oZDTu0gtwNZUyIkqEUCgCHxh9CEJvUwcMdpfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715033; c=relaxed/simple;
	bh=LWC5hipTMAYZkvYhIWm3i8FYr/iqV5UkqypO3jsVCRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdQh9a6/tyhnpJUJ+cs5PK9WGc0m0VNq8DLfc7TyR4UizWsa4pDqz6o4SCUHx5I+bJ1DK8umTIdRfwynCNshio8sVZOio0yj+v4DpR0iqfID5ipJCHXw2XptAjVCK70KxnRcXO2HFjy2M8p1MEFIXkjCh+hUvQIs0g48y91rSHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnwkWRHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnwkWRHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5413EC4CEEA;
	Mon, 23 Jun 2025 21:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715033;
	bh=LWC5hipTMAYZkvYhIWm3i8FYr/iqV5UkqypO3jsVCRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YnwkWRHqTQXuzeJonqU1+26uQlASvFMSzxhJmeZrlWJQxK2x0DMomqIHl3x5JY0M8
	 fjk/Adj3va3aRmGLuM6z7Q+ZG0hfVPGOJ+LzrGavTHkC01tCacFCCA3cuC/HLIPL2z
	 L0qL50wYTLDWB0/Y/+kgL5ul9dafP/uBCc5WEIhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergio Perez Gonzalez <sperezglz@gmail.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/355] net: macb: Check return value of dma_set_mask_and_coherent()
Date: Mon, 23 Jun 2025 15:07:29 +0200
Message-ID: <20250623130634.206977368@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 74f3cabf8ed64..2a103be1c9d8a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4571,7 +4571,11 @@ static int macb_probe(struct platform_device *pdev)
 
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



