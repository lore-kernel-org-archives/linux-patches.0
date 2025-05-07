Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D14114A4C7;
	Wed,  7 May 2025 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643327; cv=none; b=TfaAni9bQOGFLCkJher5VBBCx4F4aXYE0SppyMPptaGkI1aE0er6PofITZug6NueTtunCmXBIpxL5J0cEaWyVUa1nMHhq7wz+Nzi9KNygfoERK2PghPFjDYO/AA72wW+RWZgngziv4Ft6CmydVJMFRQgoVvV6RrgLRHwGxte9c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643327; c=relaxed/simple;
	bh=uHwELXeBMHPxYrlcRqM7Mok9nUIGufI7keaPn2FhCpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7sDzSCdGeYjb4Zyvp0gNZB35SyT6HdZI8D5TPm3W2j6NSBJTRJq4Wx6kaY6I4YU5Jd7FWc681fTFM12cgFoi0Idxg8FBvYqyK1HY9bIhlpi4Ghm0FU4D2unbI4xIstTFIIPghxIIrBi8q1PiQNz7RLFVpCy0zKLga4tgDQ00Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJkYyjsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJkYyjsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832F4C4CEE2;
	Wed,  7 May 2025 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643326;
	bh=uHwELXeBMHPxYrlcRqM7Mok9nUIGufI7keaPn2FhCpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJkYyjsB4KQW4NsE+ylRpsZZP3tTyierwLxnq8nOyXaHGA093G3A3LwPRVoW7JiPN
	 kMUjhXSyYgQq184XfDEXNpLHCuIID0DZ6Ev47wnYUGKxZPzTuiIqYXmkEkzncVXk11
	 lKW0gj4ehmJGDw8rnwAVOY1XnVqKXGH71afAfxOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 22/55] net: ethernet: mtk-star-emac: rearm interrupts in rx_poll only when advised
Date: Wed,  7 May 2025 20:39:23 +0200
Message-ID: <20250507183759.936288750@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c7155e0102232..639cf1c27dbd4 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1338,8 +1338,7 @@ static int mtk_star_rx_poll(struct napi_struct *napi, int budget)
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



