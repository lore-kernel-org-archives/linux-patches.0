Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B62D21146F;
	Wed,  7 May 2025 19:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644576; cv=none; b=Ix70KhnVD5ii2XUQz+qzp415hnbBEULP+P/cHKf8k4xbKotCFHT/1Hv60G1EmgO+1XHSqSPr1RTqPlVlm1IaZog3AZgjM+rlKRFQGZh5NIyaX4eBDuWMqNC3kcZ5fwVz3v+DqPOkpr3NlmO8gkCELJr2fhlFxkt+liksIvJ/BME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644576; c=relaxed/simple;
	bh=QLspojp2eLMzYfp4njPAAjyLQsWk710CR5splNb9uec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhLzMvUgh70t/CvqZRwCGWmVH82WgTj0JBl27kxpA0oYZmixj5SQ0Cs5j+uawL0azBflYjmqBEWwfi9qOQXSBqW7GGocVapjeSCGP8eWQRPSphOmi+CUVYqvHIetYrCdSiAFmkBu/53uw8bOB5VfgvTuCGPyPFVWt+aqpXfCA4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxYZ3gPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxYZ3gPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30449C4CEE2;
	Wed,  7 May 2025 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644574;
	bh=QLspojp2eLMzYfp4njPAAjyLQsWk710CR5splNb9uec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxYZ3gPRAbGVCW5j2pZ0uWGWVEOlHMUcMC9XrHE0vKaxVjX7jNlGBTt4Sm3C/M2VR
	 WEaMreGlNMSXeI/p/qP5kIBbGsxqoHeIie6YO9JlvDJZTFubV+fhAeXeA/w90DdC9D
	 vqFyX/FSx2aWvBw/bQ1dbb5zbcyfnILTuaKtNJG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/164] net: ethernet: mtk-star-emac: rearm interrupts in rx_poll only when advised
Date: Wed,  7 May 2025 20:39:31 +0200
Message-ID: <20250507183824.446077487@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit e54b4db35e201a9173da9cb7abc8377e12abaf87 ]

In mtk_star_rx_poll function, on event processing completion, the
mtk_star_emac driver calls napi_complete_done but ignores its return
code and enable RX DMA interrupts inconditionally. This return code
gives the info if a device should avoid rearming its interrupts or not,
so fix this behaviour by taking it into account.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://patch.msgid.link/20250424-mtk_star_emac-fix-spinlock-recursion-issue-v2-2-f3fde2e529d8@collabora.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 47a00e02365a2..c2ab87828d858 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1348,8 +1348,7 @@ static int mtk_star_rx_poll(struct napi_struct *napi, int budget)
 	priv = container_of(napi, struct mtk_star_priv, rx_napi);
 
 	work_done = mtk_star_rx(priv, budget);
-	if (work_done < budget) {
-		napi_complete_done(napi, work_done);
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		spin_lock_irqsave(&priv->lock, flags);
 		mtk_star_enable_dma_irq(priv, true, false);
 		spin_unlock_irqrestore(&priv->lock, flags);
-- 
2.39.5



