Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95511FF5EC;
	Wed,  7 May 2025 18:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644011; cv=none; b=oLfdYavv9OuIy9EHQ7gNUwsWltJhl5zwmgb2MqgIMCdj5lYzMXyAyNxJq1NLb0fIevx8xvEV09ZHDLbr3QuUcPng756TQCfA6Ggj2hM+KcGpi1tI/8r317brhofTPpJjJ1Cr7nf/QJjtwHWUv6LlnR4DO1qfeZiyW4mscJ0QjjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644011; c=relaxed/simple;
	bh=1edMPcRlKn0npp3DeVIe3jsxmqZfBwXFr0rcHo60wic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fU8kETv8qWabKh9muDwaLT0DLi8ysFcnl1B4Jx1r4mzJ7xAXjY9ElipimGvZvJcr0QKxwB2Hr+JjBWQB0t8zOesxbq4hDzehCgSaEdtHDz5dwaTPUzIqNeDTTEuQZ3Lu6XNevv9UXNPaC62G78nqApZIJeeMnOAdGy3hcSpNVK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egSVm1ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egSVm1ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6F8C4CEE9;
	Wed,  7 May 2025 18:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644010;
	bh=1edMPcRlKn0npp3DeVIe3jsxmqZfBwXFr0rcHo60wic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egSVm1ub+iQEvQJk7xzO/e2hgTQfYJ5ItXy1XLuksdi4FbnQBzx+e9GzLth3lZQPi
	 fWc3KrlcwapNjH5vovbAadIQDEVsJ7K1UB6F18t+S/qJ70tc5qInlIzOomdfhUMkw8
	 VYSzWvGrdhAZNe98htNFzcqtoW0hJlHnGHCBXAs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 091/183] net: ethernet: mtk-star-emac: rearm interrupts in rx_poll only when advised
Date: Wed,  7 May 2025 20:38:56 +0200
Message-ID: <20250507183828.511747358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



