Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F621A0BFD;
	Sun,  7 Sep 2025 20:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277287; cv=none; b=bsXl33VRVWh90dn/sAYP+48ZokaUIpFF2cbhK1JNLt3lPIuluQxVdGhMe0oDa7tch95MGWALD97oNsGsiOcqU7wUjQy2TJuaAwTKDPG33PdJSfhvZXCBKDrcXgXmSsM9dzvh0f+7sl5SRnsA5+Yw7uaweRu8ho/7e7Rn+FT1wrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277287; c=relaxed/simple;
	bh=7LoeOI7rBEWC0rUquzaU+q091ZH8psnfoP0ajfKxOZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuLZUxu/iK48EwUiAb/UTTYng/NglQkjuCv5zQs3Ij0Wf0uYC3EorQE2SB1dILk42zAgDzZNkinbzprxbpYRFHehWmOCdFpcAKEkSm2Ekp+C/cdBRS+ge+MwA/NIUmnoVhEkel9PvmUXvXShZUHpSun9XkIa1wKfZ38Gev521ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYhji/v7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYhji/v7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286A6C4CEF0;
	Sun,  7 Sep 2025 20:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277287;
	bh=7LoeOI7rBEWC0rUquzaU+q091ZH8psnfoP0ajfKxOZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYhji/v7CPTzhVsUP2ESs+RIspP1uf8CXWfSrE4OmKH0bp4+ERr5aSYFIC3eQTHvf
	 EwRg0rq1FuYU8sm+4YBxbbGv8GdC4m9ybWKXn4UoWrPITb4iQCBbRwvazrX1wh3HqT
	 zaI3Db1bC2W19FpJ40y5iU2LAkNyMkXxqn6BQ9Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/175] dmaengine: mediatek: Fix a possible deadlock error in mtk_cqdma_tx_status()
Date: Sun,  7 Sep 2025 21:59:00 +0200
Message-ID: <20250907195618.288550989@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu-ji Chen <chenqiuji666@gmail.com>

[ Upstream commit 157ae5ffd76a2857ccb4b7ce40bc5a344ca00395 ]

Fix a potential deadlock bug. Observe that in the mtk-cqdma.c
file, functions like mtk_cqdma_issue_pending() and
mtk_cqdma_free_active_desc() properly acquire the pc lock before the vc
lock when handling pc and vc fields. However, mtk_cqdma_tx_status()
violates this order by first acquiring the vc lock before invoking
mtk_cqdma_find_active_desc(), which subsequently takes the pc lock. This
reversed locking sequence (vc → pc) contradicts the established
pc → vc order and creates deadlock risks.

Fix the issue by moving the vc lock acquisition code from
mtk_cqdma_find_active_desc() to mtk_cqdma_tx_status(). Ensure the pc lock
is acquired before the vc lock in the calling function to maintain correct
locking hierarchy. Note that since mtk_cqdma_find_active_desc() is a
static function with only one caller (mtk_cqdma_tx_status()), this
modification safely eliminates the deadlock possibility without affecting
other components.

This possible bug is found by an experimental static analysis tool
developed by our team. This tool analyzes the locking APIs to extract
function pairs that can be concurrently executed, and then analyzes the
instructions in the paired functions to identify possible concurrency bugs
including deadlocks, data races and atomicity violations.

Fixes: b1f01e48df5a ("dmaengine: mediatek: Add MediaTek Command-Queue DMA controller for MT6765 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250508073634.3719-1-chenqiuji666@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/mediatek/mtk-cqdma.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/dma/mediatek/mtk-cqdma.c
+++ b/drivers/dma/mediatek/mtk-cqdma.c
@@ -420,15 +420,11 @@ static struct virt_dma_desc *mtk_cqdma_f
 {
 	struct mtk_cqdma_vchan *cvc = to_cqdma_vchan(c);
 	struct virt_dma_desc *vd;
-	unsigned long flags;
 
-	spin_lock_irqsave(&cvc->pc->lock, flags);
 	list_for_each_entry(vd, &cvc->pc->queue, node)
 		if (vd->tx.cookie == cookie) {
-			spin_unlock_irqrestore(&cvc->pc->lock, flags);
 			return vd;
 		}
-	spin_unlock_irqrestore(&cvc->pc->lock, flags);
 
 	list_for_each_entry(vd, &cvc->vc.desc_issued, node)
 		if (vd->tx.cookie == cookie)
@@ -452,9 +448,11 @@ static enum dma_status mtk_cqdma_tx_stat
 	if (ret == DMA_COMPLETE || !txstate)
 		return ret;
 
+	spin_lock_irqsave(&cvc->pc->lock, flags);
 	spin_lock_irqsave(&cvc->vc.lock, flags);
 	vd = mtk_cqdma_find_active_desc(c, cookie);
 	spin_unlock_irqrestore(&cvc->vc.lock, flags);
+	spin_unlock_irqrestore(&cvc->pc->lock, flags);
 
 	if (vd) {
 		cvd = to_cqdma_vdesc(vd);


